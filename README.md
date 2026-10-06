# eigene Skills einfügen:

### Skills die aufdem Host unter ~/.agents/skills liegen:
- mit 
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
- 
```powershell
sbx skills add https://github.com/example/my-agent-skills
```
- später aktualisieren:
```powershell
sbx skills update
```

# eigene MCP Server:
- in die .sbxenv.yaml

```yaml
mcp:
  servers:
    - name: openai-docs
      url: https://developers.openai.com/mcp

    - name: playwright
      command: npx
      args:
        - "-y"
        - "@playwright/mcp@latest"
```