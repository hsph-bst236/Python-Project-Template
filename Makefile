# Github variables
REPO_NAME = your-repo-name
GITHUB_USER = your-github-username
BRANCH = main

# Virtual environment settings
VENV_NAME := venv
PYTHON := python
VENV_BIN := $(VENV_NAME)/bin
VENV_PIP := $(VENV_NAME)/bin/pip
CONFIG_DIR := config

# Colors for pretty output
GREEN := \033[0;32m
NC := \033[0m  # No Color
INFO := @echo "$(GREEN)➜$(NC)"

# Combine all PHONY targets
.PHONY: venv install update freeze activate deactivate list-packages clean dev-install format lint test help init_config init_project_structure

# Initialize a local Git repository and push to GitHub
init:
	git init
	git add .
	git commit -m "Initial commit"
	make init_repo

init_repo:
	gh repo create $(GITHUB_USER)/$(REPO_NAME) --private --source=. --remote=origin
	git push -u origin $(BRANCH)

# Sync with Github
sync:
	git pull origin $(BRANCH)
	$(INFO) "Updating packages in requirements.txt..."
	$(VENV_PIP) install --upgrade -r requirements.txt


# Push to GitHub
push:
	git pull origin $(BRANCH)
	$(INFO) "Freezing current packages to requirements.txt..."
	$(VENV_PIP) freeze > requirements.txt
	git add .
	git commit -m "Update analysis and data"
	git push origin $(BRANCH)

# Create and initialize virtual environment
venv:
	$(INFO) "Creating virtual environment..."
	$(PYTHON) -m venv $(VENV_NAME)
	$(INFO) "Upgrading pip..."
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) freeze > requirements.txt
	$(INFO) "Virtual environment created at $(VENV_NAME)/"

# Install data science packages
install:
	$(INFO) "Installing packages for data science..."
	$(VENV_PIP) install numpy pandas scikit-learn matplotlib seaborn yaml Box pathlib
	$(VENV_PIP) install python-box pyyaml
	$(VENV_PIP) freeze > requirements.txt

# Update existing packages
update_packages:
	$(INFO) "Updating packages in requirements.txt..."
	$(VENV_PIP) install --upgrade -r requirements.txt

# Save current package versions
freeze:
	$(INFO) "Freezing current packages to requirements.txt..."
	$(VENV_PIP) freeze > requirements.txt

# Show activation command
activate:
	$(INFO) "To activate the virtual environment, run:"
	@echo "source $(VENV_NAME)/bin/activate"

# Show deactivation command
deactivate:
	$(INFO) "To deactivate the virtual environment, simply run:"
	@echo "deactivate"

# Display installed packages
list-packages:
	$(INFO) "Currently installed packages:"
	$(VENV_PIP) list

# Remove virtual environment and cache
clean:
	$(INFO) "Cleaning up virtual environment..."
	rm -rf $(VENV_NAME)
	rm -rf __pycache__
	rm -rf *.pyc
	rm -rf .pytest_cache
	rm -rf .coverage
	rm -rf htmlcov
	$(INFO) "Clean complete"

# Initialize configuration structure
init_config:
	$(INFO) "Creating configuration structure..."
	mkdir -p $(CONFIG_DIR)
	@echo "Creating base config.yaml..."
	@echo "base:" > $(CONFIG_DIR)/config.yaml
	@echo "  path:" >> $(CONFIG_DIR)/config.yaml
	@echo "    data: data/" >> $(CONFIG_DIR)/config.yaml
	@echo "    models: models/" >> $(CONFIG_DIR)/config.yaml
	@echo "    output: output/" >> $(CONFIG_DIR)/config.yaml
	@echo "  params:" >> $(CONFIG_DIR)/config.yaml
	@echo "    random_seed: 42" >> $(CONFIG_DIR)/config.yaml
	@echo "Creating development config..."
	@echo "development:" > $(CONFIG_DIR)/development.yaml
	@echo "  debug: true" >> $(CONFIG_DIR)/development.yaml
	@echo "  log_level: DEBUG" >> $(CONFIG_DIR)/development.yaml
	@echo "Creating production config..."
	@echo "production:" > $(CONFIG_DIR)/production.yaml
	@echo "  debug: false" >> $(CONFIG_DIR)/production.yaml
	@echo "  log_level: INFO" >> $(CONFIG_DIR)/production.yaml
	$(INFO) "Installing python-box for config management..."
	$(VENV_PIP) install python-box pyyaml
	$(INFO) "Configuration structure created!"

# Install development tools
dev-install:
	$(INFO) "Installing development packages..."
	$(VENV_PIP) install pytest pytest-cov black flake8 mypy

# Format code using black
format:
	$(INFO) "Formatting code with black..."
	$(VENV_BIN)/black .

# Run code quality checks
lint:
	$(INFO) "Running flake8..."
	$(VENV_BIN)/flake8 .
	$(INFO) "Running mypy..."
	$(VENV_BIN)/mypy .

# Run tests with coverage
test:
	$(INFO) "Running tests with pytest..."
	$(VENV_BIN)/pytest --cov=.

# Display available commands
help:
	@echo "Available commands:"
	@echo "  make venv          - Create a new virtual environment"
	@echo "  make install       - Install data science packages"
	@echo "  make update        - Update packages from requirements.txt"
	@echo "  make freeze        - Update requirements.txt with current packages"
	@echo "  make activate      - Show command to activate virtual environment"
	@echo "  make deactivate    - Show command to deactivate virtual environment"
	@echo "  make list-packages - List all installed packages"
	@echo "  make clean         - Remove virtual environment and cache files"
	@echo "  make dev-install   - Install development packages"
	@echo "  make format        - Format code with black"
	@echo "  make lint          - Run linting tools"
	@echo "  make test          - Run tests with coverage"
	@echo "  make init_config   - Initialize configuration structure"

# Add sandbox directory to init_project_structure
init_project_structure:
	$(INFO) "Creating project directory structure..."
	mkdir -p data/{raw,processed,external}
	mkdir -p src/{data,features,models,visualization}
	mkdir -p notebooks
	mkdir -p reports/figures
	mkdir -p config
	mkdir -p sandbox
	touch data/raw/.gitkeep
	touch data/processed/.gitkeep
	touch data/external/.gitkeep
	touch src/data/.gitkeep
	touch src/features/.gitkeep
	touch src/models/.gitkeep
	touch src/visualization/.gitkeep
	touch notebooks/.gitkeep
	touch reports/figures/.gitkeep
	touch config/.gitkeep
	touch sandbox/.gitkeep

