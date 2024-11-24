#!/bin/bash

# Función para mostrar mensajes con colores
function print_message() {
    local color=$1
    shift
    echo -e "\e[${color}m$@\e[0m"
}

# Actualizar repositorios y paquetes del sistema
print_message "34" "1. Actualizando los repositorios y paquetes del sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependencias necesarias
print_message "34" "2. Instalando dependencias necesarias para compilar Python..."
sudo apt install -y build-essential zlib1g-dev libffi-dev libssl-dev \
    libsqlite3-dev libreadline-dev libbz2-dev liblzma-dev libncurses5-dev \
    libgdbm-dev libnss3-dev libxml2-dev libxmlsec1-dev wget curl git tar

# Intentar instalar Python 3.13 desde APT (por si acaso está disponible)
print_message "34" "3. Buscando Python 3.13 en los repositorios..."
if apt search python3.13 | grep -q "python3.13"; then
    print_message "32" "Python 3.13 encontrado en los repositorios. Instalando..."
    sudo apt install -y python3.13
    python3.13 --version
    exit 0
else
    print_message "33" "Python 3.13 no está disponible en los repositorios. Procediendo con pyenv..."
fi

# Instalar pyenv si no está instalado
if ! command -v pyenv &> /dev/null; then
    print_message "34" "4. pyenv no está instalado. Procediendo con la instalación de pyenv..."
    curl https://pyenv.run | bash
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    source ~/.bashrc
else
    print_message "32" "pyenv ya está instalado."
fi

# Instalar Python 3.13.0 con pyenv
print_message "34" "5. Instalando Python 3.13.0 con pyenv..."
pyenv install 3.13.0
pyenv global 3.13.0

# Verificar instalación de Python 3.13.0
print_message "34" "6. Verificando la instalación de Python 3.13.0..."
if python3 --version | grep -q "3.13.0"; then
    print_message "32" "Python 3.13.0 instalado correctamente."
else
    print_message "31" "Algo salió mal. Python 3.13.0 no está instalado."
fi
