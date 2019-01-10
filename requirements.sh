# The requirements.sh is an advanced mechanism and should rarely be needed.
# Be aware that it won't run with root permissions and 'sudo' won't work
# in most cases.  Py msm handles invokes the script with sudo internally if the platform allows it

#detect distribution using lsb_release (may be replaced parsing /etc/*release)
dist=$(lsb_release -d |awk '{print$2}')
echo $dist
dependencies=( build-essential cmake libgtk-3-dev libboost-all-dev libfreetype6-dev python-opencv)

# default pm
pm="sudo apt-get install -y"

#setting dependencies and package manager in relation to the distribution
if [ "$dist"  == "Arch"  ]; then
    pm="sudo pacman -S"
elif [ "$dist" ==  "Ubuntu" ] || [ "$dist" == "KDE" ] || [ "$dist" == "Debian" ] || [ "$dist" == "antiX" ] || [ "$dist"  == "Raspbian"  ]; then
    pm="sudo apt-get install -y"
elif [ "$dist"  == "Fedora" ] || [ "$dist" == "RedHat" ] || [ "$dist" == "CentOS" ]; then
    dependencies=( build-essential cmake libgtk-3-dev libboost-all-dev libfreetype6-dev opencv-python)
    pm="sudo yum -y install"
fi


# installing dependencies
for dep in "${dependencies[@]}"
do
    echo "installing: $dep"
    $pm $dep
done


# do extra stuff, like compiling from source`
# exit 1 # indicate failure with any non 0 error code`

# open cv https://medium.com/@manuganji/installation-of-opencv-numpy-scipy-inside-a-virtualenv-bf4d82220313

user=$(sh -c 'echo $SUDO_USER')

# install mycroft
DIRECTORY=/home/$user/.virtualenvs/mycroft

if [ -d "$DIRECTORY" ]; then
  # mycroft venv exists.
  cp /usr/lib/python2.7/dist-packages/cv* /home/$user/.virtualenvs/mycroft/lib/python2.7/site-packages/
  # try to install py_msm as a failsafe, the skill will try to use it to install itself if imports fail

  if [ -z "$WORKON_HOME" ]; then
      VIRTUALENV_ROOT=${VIRTUALENV_ROOT:-"${HOME}/.virtualenvs/mycroft"}
  else
      VIRTUALENV_ROOT="$WORKON_HOME/mycroft"
  fi

  source "${VIRTUALENV_ROOT}/bin/activate"

  pip install py_msm

  deactivate

fi

# install jarbas
DIRECTORY=/home/$user/.virtualenvs/jarbas

if [ -d "$DIRECTORY" ]; then
  # jarbas venv exists.
  cp /usr/lib/python2.7/dist-packages/cv* /home/$user/.virtualenvs/jarbas/lib/python2.7/site-packages/

  if [ -z "$WORKON_HOME" ]; then
      VIRTUALENV_ROOT=${VIRTUALENV_ROOT:-"${HOME}/.virtualenvs/jarbas"}
  else
      VIRTUALENV_ROOT="$WORKON_HOME/jarbas"
  fi

  source "${VIRTUALENV_ROOT}/bin/activate"

  pip install py_msm

  deactivate

fi

sudo pip install py_msm

# compile dlib
# installed in pip for now
#rundir=$(pwd)
#if ! git clone https://github.com/davisking/dlib ; then
#  echo "Unable to clone Dlib!"
#  exit 1
#fi
#cd dlib
#if grep -q avx /proc/cpuinfo ; then
#  mkdir build; cd build; cmake .. -DDLIB_USE_CUDA=0 -DUSE_AVX_INSTRUCTIONS=1; cmake --build .
#else
#  mkdir build; cd build; cmake .. -DDLIB_USE_CUDA=0 ; cmake --build .
#fi

#if ! python ${rundir}/dlib/setup.py install --no USE_AVX_INSTRUCTIONS --no DLIB_USE_CUDA ; then
#  echo "Unable to install python Dlib!"
#  exit 1
#fi

# exit with 0 to indicate success`

exit 0
