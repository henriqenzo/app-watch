## 1. GitFlow

### 1.1 Estrutura de Branches

| Branch | Finalidade | Regra |
|---|---|---|
| `main` | Código em produção | Nunca commitar diretamente |
| `develop` | Base de integração contínua; sempre estável | Nunca commitar diretamente |
| `feature/nome-da-feature` | Novas funcionalidades | Criada a partir de `develop`; merge via PR |
| `fix/nome-do-bug` | Correção de bugs encontrados em desenvolvimento | Criada a partir de `develop`; merge via PR |

### 1.2 Fluxo de Trabalho — Feature

```bash
# 1. Atualizar o repositório local
git pull origin develop

# 2. Criar a branch da feature
git checkout -b feature/nome-da-feature

# 3. Desenvolver e commitar seguindo os padrões de commit

# 4. Abrir Pull Request para develop com descrição clara

# 5. Aguardar revisão (mínimo 1 aprovação)

# 6. Realizar merge após aprovação e pipeline verde
```

### 1.3 Regras de Branch Protection

| Regra | `main` | `develop` |
|---|---|---|
| Push direto bloqueado | ✅ | ✅ |
| PR obrigatória | ✅ | ✅ |
| Mínimo de aprovações | 2 | 1 |
| Pipeline verde obrigatório | ✅ | ✅ |
| Estratégia de merge | Squash | Merge commit |

---

## 2. Padrões de Commit

### 2.1 Formato

```
<tipo>(escopo): <descrição curta no imperativo>

[corpo opcional — o quê e por quê, não o como]

[rodapé opcional — referências de issue/PR]
```

**Exemplos:**

```
feat(focus-mode): adiciona ativação por atalho de teclado
fix(app-manager): corrige crash ao fechar app sem janela ativa
refactor(wallpaper): extrai lógica de troca para WallpaperService
docs(readme): atualiza instruções de configuração
test(timer): adiciona testes de UsageTimeTracker
chore(ci): adiciona job de lint ao pipeline
```

### 2.2 Tipos Permitidos

| Tipo | Quando usar |
|---|---|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `refactor` | Refatoração sem mudança de comportamento |
| `test` | Adição ou correção de testes |
| `docs` | Documentação |
| `style` | Formatação, espaçamento (sem impacto lógico) |
| `chore` | Tarefas de manutenção (CI, dependências, scripts) |
| `perf` | Melhoria de performance |
| `revert` | Reversão de commit anterior |

### 2.3 Regras Gerais

- Mensagem em **inglês**.
- Descrição curta
- Nunca misturar múltiplas mudanças não relacionadas em um único commit.

---
