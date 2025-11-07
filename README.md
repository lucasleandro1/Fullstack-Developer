# 🚀 Sistema de Gerenciamento de Usuários

Um sistema completo de gerenciamento de usuários em Ruby on Rails com funcionalidades avançadas de autenticação, autorização baseada em roles e importação de usuários via CSV com processamento em background e atualizações em tempo real.

## 📋 Índice

- [Funcionalidades](#-funcionalidades)
- [Tecnologias](#-tecnologias)
- [Instalação](#-instalação)
- [Configuração](#-configuração)
- [Como Usar](#-como-usar)
- [Arquitetura](#-arquitetura)
- [Segurança](#-segurança)
- [API](#-api)
- [Contribuição](#-contribuição)

## ✨ Funcionalidades

### 🔐 **Autenticação e Autorização**
- ✅ Sistema completo de autenticação com **Devise**
- ✅ **Roles** hierárquicos (Admin, Manager, User)
- ✅ Controle de acesso granular por funcionalidade
- ✅ Rastreamento de login para auditoria
- ✅ Proteção contra ataques comuns (CSRF, XSS)

### 👥 **Gerenciamento de Usuários**
- ✅ **CRUD completo** para administradores
- ✅ **Perfil editável** pelos próprios usuários
- ✅ **Busca avançada** (nome, email, role, status)
- ✅ **Filtros dinâmicos** com paginação
- ✅ **Validações robustas** e feedback de erros

### 📊 **Dashboard Administrativo**
- ✅ **Métricas em tempo real** via WebSockets
- ✅ **Estatísticas do sistema** (usuários, roles, atividade)
- ✅ **Interface responsiva** com Bootstrap 5
- ✅ **Atualizações automáticas** sem refresh

### 📁 **Importação CSV**
- ✅ **Upload de arquivos** com validação
- ✅ **Processamento assíncrono** em background
- ✅ **Progress tracking** em tempo real
- ✅ **Relatórios de erro** detalhados
- ✅ **Histórico de importações** com status

## 🛠️ Tecnologias

### Backend
- **Ruby 3.2.0**
- **Rails 7.x**
- **SQLite** (desenvolvimento) / **PostgreSQL** (produção)
- **Devise** (autenticação)
- **Active Job** (background processing)
- **Action Cable** (WebSockets)

### Frontend
- **Bootstrap 5** (UI Framework)
- **Stimulus** (JavaScript framework)
- **Turbo** (SPA-like experience)
- **Simple Form** (formulários)
- **Importmap** (ES6 modules)

### Ferramentas
- **Docker** (containerização)
- **Git** (controle de versão)
- **Rubocop** (linting)
- **Brakeman** (security scanning)

## 🚀 Instalação

### Pré-requisitos
- Ruby 3.2.0 ou superior
- Node.js 18+ e Yarn
- SQLite3 (desenvolvimento)
- Redis (para Action Cable em produção)

### Setup Local

1. **Clone o repositório:**
```bash
git clone https://github.com/lucasleandro1/Fullstack-Developer.git
cd Fullstack-Developer
```

2. **Instale as dependências:**
```bash
bundle install
yarn install
```

3. **Configure o banco de dados:**
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. **Inicie o servidor:**
```bash
./bin/dev
# ou separadamente:
rails server
yarn build --watch
```

5. **Acesse a aplicação:**
```
http://localhost:3000
```

### Usuários de Teste

Após rodar `rails db:seed`, você terá acesso a:

| Email | Senha | Role | Descrição |
|-------|--------|------|-----------|
| `admin@example.com` | `password123` | Admin | Acesso total ao sistema |
| `manager@example.com` | `password123` | Manager | Gerenciamento de usuários |
| `user@example.com` | `password123` | User | Acesso básico |

## 📖 Como Usar

### 1. **Login no Sistema**
- Acesse `/users/sign_in`
- Use um dos usuários de teste ou registre-se

### 2. **Dashboard (Admin/Manager)**
- Visualize métricas em tempo real
- Monitore atividade do sistema
- Acesse relatórios

### 3. **Gerenciamento de Usuários (Admin)**
- **Listar:** Veja todos os usuários com filtros
- **Criar:** Adicione novos usuários manualmente
- **Editar:** Modifique informações e roles
- **Excluir:** Remove usuários do sistema

### 4. **Importação CSV (Admin)**
- Acesse "Importações" no menu
- Faça upload de arquivo CSV
- Acompanhe o progresso em tempo real
- Veja relatório de resultados

**Formato do CSV:**
```csv
first_name,last_name,email,role
João,Silva,joao@example.com,user
Maria,Santos,maria@example.com,manager
```

### 5. **Perfil do Usuário**
- Edite suas informações pessoais
- Altere senha
- Visualize histórico de login

## 🏗️ Arquitetura

### Estrutura de Diretórios

```
app/
├── controllers/
│   ├── application_controller.rb
│   ├── home_controller.rb
│   ├── users_controller.rb
│   └── admin/
│       ├── dashboard_controller.rb
│       ├── users_controller.rb
│       └── imports_controller.rb
├── models/
│   ├── user.rb
│   ├── import.rb
│   └── concerns/
│       └── dashboard_broadcaster.rb
├── services/
│   ├── application_service.rb
│   ├── user_management_service.rb
│   ├── user_search_service.rb
│   └── dashboard_stats_service.rb
├── jobs/
│   └── user_import_job.rb
├── channels/
│   ├── dashboard_channel.rb
│   └── import_progress_channel.rb
└── views/
    ├── layouts/
    ├── shared/
    ├── home/
    ├── users/
    └── admin/
```

## 🛡️ Segurança

### Implementações de Segurança

- **Strong Parameters** para mass assignment protection
- **Authorization checks** em todos os controllers
- **Role-based access control** (RBAC)
- **File upload validation** com whitelist de tipos
- **CSRF protection** habilitada
- **SQL injection protection** via ActiveRecord
- **XSS protection** com sanitização automática

### Auditoria

- **Trackable fields** para monitoramento de login
- **Logs de atividade** para ações administrativas
- **Histórico de importações** com timestamps

## 📡 API

### Endpoints Principais

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| `GET` | `/` | Página inicial | - |
| `POST` | `/users/sign_in` | Login | - |
| `GET` | `/admin/dashboard` | Dashboard admin | Admin |
| `GET` | `/admin/users` | Lista usuários | Admin |
| `POST` | `/admin/imports` | Upload CSV | Admin |
| `GET` | `/users/profile` | Perfil do usuário | User |

### WebSocket Channels

- **DashboardChannel** - Métricas em tempo real
- **ImportProgressChannel** - Status de importação

⭐ **Se este projeto foi útil, considere dar uma estrela!**
