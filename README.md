# install
- Files wie folg ablegen:
- C:\Users\<DEIN-BENUTZERNAME>\.sbxenv.yaml
- C:\Users\<DEIN-BENUTZERNAME>\.config\codex-sbx\tui.toml

```powershell
cd D:\<DEIN-FOLDER>
sbx env run
```

# eigene Skills einfügen:

### Skills die aufdem Host unter ~/.agents/skills liegen:
- mit:
```powershell
sbx skills import --dry-run
sbx skills import
```
importieren

- dannach:
```powershell
sbx skills ls
```

### Skills aus einem Repo:
```powershell
sbx skills add https://github.com/example/my-agent-skills
```
- später aktualisieren:
```powershell
sbx skills update
```

# eigene MCP Server:
- in die .sbxenv.yaml
- Beispiel:
```powershell
sbx mcp add openai-docs --url https://developers.openai.com/mcp
```

```powershell
docker pull mcr.microsoft.com/playwright/mcp
```

```yaml
mcp:
  servers:
    - name: openai-docs
      url: https://developers.openai.com/mcp

    - name: playwright
      command: docker
      args:
        - run
        - -i
        - --rm
        - --init
        - --pull=always
        - mcr.microsoft.com/playwright/mcp
```