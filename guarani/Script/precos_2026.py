from __future__ import annotations

from pathlib import Path
from typing import Any

import pandas as pd


SHEET_NAME = "2026"


def _to_text(value: Any) -> str:
    if pd.isna(value):
        return ""
    text = str(value).strip()
    return text


def _to_number(value: Any) -> float | None:
    if pd.isna(value):
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def carregar_precos_2026(planilha: Path) -> dict[str, Any]:
    if not planilha.exists():
        raise FileNotFoundError(f"Planilha nao encontrada: {planilha}")

    df = pd.read_excel(planilha, sheet_name=SHEET_NAME, header=None)

    secoes: list[dict[str, Any]] = []
    secao_atual: dict[str, Any] | None = None
    linha_cabecalho_esperada = {
        "PRODUTOS",
        "ADICIONAIS DIRETO ERP",
        "ADICIONAIS INDIRETO ERP",
        "ADICIONAIS DIRETO AFV (PLUGIN)",
    }

    for _, row in df.iterrows():
        col_1 = _to_text(row.iloc[1] if len(row) > 1 else "")
        col_2 = _to_text(row.iloc[2] if len(row) > 2 else "")
        col_3 = _to_text(row.iloc[3] if len(row) > 3 else "")
        col_4 = _to_text(row.iloc[4] if len(row) > 4 else "")
        col_5 = _to_text(row.iloc[5] if len(row) > 5 else "")
        col_6 = _to_text(row.iloc[6] if len(row) > 6 else "")

        if not col_1:
            continue

        upper = col_1.upper()

        if upper in linha_cabecalho_esperada:
            secao_atual = {"titulo": col_1, "itens": []}
            secoes.append(secao_atual)
            continue

        if upper.startswith("OBSERVA") or upper.startswith("INFORMATIVO GERAL"):
            secao_atual = None
            continue

        if secao_atual is None:
            continue

        qtd_num = _to_number(row.iloc[2] if len(row) > 2 else None)
        cdu_num = _to_number(row.iloc[3] if len(row) > 3 else None)
        mensalidade_num = _to_number(row.iloc[5] if len(row) > 5 else None)
        horas_tem_valor = bool(col_4)
        tem_numerico = qtd_num is not None or cdu_num is not None or mensalidade_num is not None

        item = {
            "produto": col_1,
            "qtde": col_2,
            "cdu_setup": col_3,
            "horas": col_4,
            "mensalidade": col_5,
            "informativo": col_6,
            "tipo": "item" if (tem_numerico or horas_tem_valor) else "subtitulo",
        }
        secao_atual["itens"].append(item)

    total_itens = sum(len(secao["itens"]) for secao in secoes)
    return {"secoes": secoes, "total_itens": total_itens}
