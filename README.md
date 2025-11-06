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

## ⚙️ Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
# Database
DATABASE_URL=sqlite3:storage/development.sqlite3

# Redis (para Action Cable em produção)
REDIS_URL=redis://localhost:6379/0

# Email (opcional, para funcionalidades do Devise)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password

# Segurança
SECRET_KEY_BASE=your-secret-key-base
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

### Service Layer

O projeto utiliza **Service Objects** para encapsular lógica de negócio:

```ruby
# Exemplo de uso
result = UserManagementService.create_user(user_params)
if result.success?
  redirect_to user_path(result.data)
else
  flash[:error] = result.error
end
```

### Background Jobs

Processamento assíncrono para operações pesadas:

```ruby
# Importação CSV
UserImportJob.perform_later(import_id, current_user_id)
```

### Real-time Updates

WebSockets para atualizações automáticas:

```javascript
// Dashboard em tempo real
import consumer from "./consumer"

consumer.subscriptions.create("DashboardChannel", {
  received(data) {
    updateDashboardMetrics(data)
  }
})
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

## 🧪 Testes

```bash
# Executar testes
bundle exec rspec

# Com coverage
bundle exec rspec --format documentation

# Testes específicos
bundle exec rspec spec/models/
bundle exec rspec spec/services/
```

## 🚀 Deploy

### Docker

```bash
# Build da imagem
docker build -t user-management .

# Executar container
docker run -p 3000:3000 -e RAILS_ENV=production user-management
```

### Deploy Manual

```bash
# Preparar assets
rails assets:precompile

# Executar migrations
rails db:migrate RAILS_ENV=production

# Iniciar servidor
rails server -e production
```

## 📈 Performance

### Otimizações Implementadas

- **Paginação** para grandes datasets
- **Background jobs** para operações pesadas
- **Caching** de consultas frequentes
- **Lazy loading** de relacionamentos
- **Asset pipeline** otimizado

### Monitoramento

- Logs estruturados com timestamps
- Métricas de performance no dashboard
- Alertas para operações demoradas

## 🤝 Contribuição

### Como Contribuir

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Crie um Pull Request

### Padrões de Código

- Siga as convenções do Ruby/Rails
- Use o Rubocop para linting
- Escreva testes para novas funcionalidades
- Documente APIs e métodos complexos

### Issues

Use as **issues** do GitHub para:
- Reportar bugs
- Sugerir funcionalidades
- Discutir melhorias

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Lucas Leandro**
- GitHub: [@lucasleandro1](https://github.com/lucasleandro1)
- LinkedIn: [Lucas Leandro](https://linkedin.com/in/lucasleandro)
- Email: lucas@example.com

---

⭐ **Se este projeto foi útil, considere dar uma estrela!**
