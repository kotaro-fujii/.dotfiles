import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from dataclasses import dataclass
from datetime import date, datetime
from pathlib import Path
from typing import Any, Final


SAPPORO_LAT: Final[float] = 43.0618
SAPPORO_LON: Final[float] = 141.3545
TZ: Final[str] = "Asia/Tokyo"

CACHE_DIR: Final[Path] = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "shell-weather"
STAMP_FILE: Final[Path] = CACHE_DIR / "last_shown.json"
FORECAST_CACHE_FILE: Final[Path] = CACHE_DIR / "forecast_cache.json"

# 失敗してもシェル起動に影響しにくいよう短め
HTTP_TIMEOUT_SEC: Final[float] = 1.5
# 予報キャッシュの有効期間（秒）。同日中の複数端末等での無駄呼び出しを抑制
FORECAST_TTL_SEC: Final[int] = 60 * 60  # 1 hour


WMO_JA: dict[int, str] = {
    0: "快晴",
    1: "晴れ",
    2: "晴れ時々くもり",
    3: "くもり",
    45: "霧",
    48: "着氷性の霧",
    51: "霧雨（弱）",
    53: "霧雨（中）",
    55: "霧雨（強）",
    56: "着氷性の霧雨（弱）",
    57: "着氷性の霧雨（強）",
    61: "雨（弱）",
    63: "雨（中）",
    65: "雨（強）",
    66: "着氷性の雨（弱）",
    67: "着氷性の雨（強）",
    71: "雪（弱）",
    73: "雪（中）",
    75: "雪（強）",
    77: "霧雪",
    80: "にわか雨（弱）",
    81: "にわか雨（中）",
    82: "にわか雨（強）",
    85: "にわか雪（弱）",
    86: "にわか雪（強）",
    95: "雷雨",
    96: "雷雨（ひょうの可能性）",
    99: "激しい雷雨（ひょうの可能性）",
}


@dataclass(frozen=True)
class TodayWeather:
    summary: str
    tmin: float | None
    tmax: float | None
    pop: int | None  # precipitation probability max (%)


def _today_yyyymmdd(tz: str = TZ) -> str:
    # 端末のローカルTZがJSTでない可能性もあるので、APIにはtimezone=Asia/Tokyoを指定する。
    # スタンプ用はローカル日付でも良いが、混乱を避けてJST基準に寄せる。
    # ここでは「今のUTC時刻 + JSTオフセット概算」ではなく、単純にローカル日付を使う（WSLなら通常JST）。
    # 厳密にしたいなら zoneinfo を使うが依存を増やしたくないので割り切る。
    return date.today().isoformat()


def _read_json(path: Path) -> dict[str, Any] | None:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        return None
    except Exception:
        return None


def _write_json_atomic(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
    tmp.replace(path)


def _http_get_json(url: str, timeout_sec: float = HTTP_TIMEOUT_SEC) -> dict[str, Any]:
    req = urllib.request.Request(url, headers={"User-Agent": "shell-weather/1.0"})
    with urllib.request.urlopen(req, timeout=timeout_sec) as resp:
        charset = resp.headers.get_content_charset() or "utf-8"
        body = resp.read().decode(charset)
    return json.loads(body)


def _build_open_meteo_url() -> str:
    # Open-Meteo: APIキー不要。dailyのweathercode/最高最低/降水確率を取得。timezone=Asia/Tokyo。 :contentReference[oaicite:1]{index=1}
    base = "https://api.open-meteo.com/v1/forecast"
    params = {
        "latitude": str(SAPPORO_LAT),
        "longitude": str(SAPPORO_LON),
        "timezone": TZ,
        "daily": ",".join(
            [
                "weather_code",
                "temperature_2m_max",
                "temperature_2m_min",
                "precipitation_probability_max",
            ]
        ),
        "forecast_days": "1",
    }
    return base + "?" + urllib.parse.urlencode(params)


def _parse_today_weather(payload: dict[str, Any]) -> TodayWeather:
    daily = payload.get("daily") or {}
    codes = daily.get("weather_code") or []
    tmaxs = daily.get("temperature_2m_max") or []
    tmins = daily.get("temperature_2m_min") or []
    pops = daily.get("precipitation_probability_max") or []

    code = int(codes[0]) if codes else None
    summary = WMO_JA.get(code, f"天気コード:{code}") if code is not None else "不明"

    tmax = float(tmaxs[0]) if tmaxs else None
    tmin = float(tmins[0]) if tmins else None
    pop = int(pops[0]) if pops else None

    return TodayWeather(summary=summary, tmin=tmin, tmax=tmax, pop=pop)


def _get_today_weather_cached() -> TodayWeather | None:
    now = time.time()
    cached = _read_json(FORECAST_CACHE_FILE)
    if cached and isinstance(cached.get("fetched_at"), (int, float)) and (now - float(cached["fetched_at"]) < FORECAST_TTL_SEC):
        try:
            return _parse_today_weather(cached["payload"])
        except Exception:
            pass

    url = _build_open_meteo_url()
    try:
        payload = _http_get_json(url)
    except (urllib.error.URLError, TimeoutError, json.JSONDecodeError):
        return None

    _write_json_atomic(FORECAST_CACHE_FILE, {"fetched_at": now, "payload": payload})
    try:
        return _parse_today_weather(payload)
    except Exception:
        return None


def should_print_today() -> bool:
    today = _today_yyyymmdd()
    stamp = _read_json(STAMP_FILE) or {}
    if stamp.get("date") == today:
        return False
    return True


def mark_printed() -> None:
    _write_json_atomic(STAMP_FILE, {"date": _today_yyyymmdd(), "marked_at": datetime.now().isoformat(timespec="seconds")})


def format_message(w: TodayWeather) -> str:
    parts: list[str] = [f"札幌 今日の天気: {w.summary}"]
    if w.tmin is not None and w.tmax is not None:
        parts.append(f"{w.tmin:.0f}〜{w.tmax:.0f}℃")
    elif w.tmax is not None:
        parts.append(f"最高 {w.tmax:.0f}℃")
    if w.pop is not None:
        parts.append(f"降水確率 {w.pop}%")
    return " / ".join(parts)


def main(argv: list[str]) -> int:
    if not should_print_today():
        return 0

    w = _get_today_weather_cached()
    if w is None:
        # 失敗時は「何も出さない」方がログインがうるさくならない
        return 0

    print(format_message(w))
    mark_printed()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

