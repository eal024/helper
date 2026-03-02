# Fremdriftslogg — helper

Kronologisk logg over utvikling og beslutninger. Nyeste øverst.
Leses ved starten av hver økt for å gjenopprette kontekst.

---

## 2026-03-02 — Dokumentasjon av grunnbelop_long

**Hva ble gjort:**
- Hentet informasjon fra nav.no/grunnbelopet
- Utvidet roxygen2-dokumentasjonen i `R/grunnbelop_long.R` betydelig med:
  - Forklaring av hva G er og hvordan det brukes i NAVs ytelser
  - Eksempler på ytelser som bruker G (sykepenger, dagpenger, uføretrygd, pensjon)
  - Historiske milepæler (1967–2025)
  - Utdypet beskrivelse av alle kolonner, inkl. `omregnings_faktor`
- Oppdatert `man/grunnbelop_long.Rd` manuelt (devtools/roxygen2 ikke installert)

**Filer påvirket:**
- `R/grunnbelop_long.R` — utvidet dokumentasjon
- `man/grunnbelop_long.Rd` — manuelt oppdatert

**Merknad:** `devtools` og `roxygen2` er ikke installert i R-miljøet. `.Rd`-filer må oppdateres manuelt inntil videre, eller pakkes installeres med `install.packages(c("devtools", "roxygen2"))`.

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisens
- Vurder om `log/` skal legges til `.Rbuildignore`
- Begynn å bygge ut funksjoner

---

## 2026-03-02 — Oppsett og grunnstruktur

**Hva ble gjort:**
- Undersøkte pakken fra bunnen av (struktur, filer, git-historikk)
- Opprettet `CLAUDE.md` med regler, konvensjoner og arbeidsflyt
- Opprettet `README.md` med pakkebeskrivelse og datasett-dokumentasjon
- Opprettet `./log/progress.md` (denne filen) som kontekstlogg på tvers av økter
- Lagt inn logg-instruksjoner og fremdriftslogg-workflow i `CLAUDE.md`

**Filer påvirket:**
- `CLAUDE.md` — opprettet
- `README.md` — overskrevet (var nesten tom fra før)
- `log/progress.md` — opprettet

**Pakketilstand:**
- Versjon: 0.0.0.9000
- Eksporterte funksjoner: ingen
- Datasett: `grunnbelop_long`

**Neste steg:**
- Oppdater `DESCRIPTION` med riktig tittel, forfatter og lisensinformasjon
- Vurder om `log/` skal legges til `.Rbuildignore`
- Begynn å bygge ut funksjoner

---

<!-- Legg til nye oppføringer øverst, over denne linjen -->
