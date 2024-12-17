ARG BASE_IMAGE=osrf/ros:jazzy-desktop-full
FROM ${BASE_IMAGE} AS base

LABEL maintainer="Kiki-Sarpong <kikisarpong05@gmail.com>"
ARG NEW_USER=multiagents
ARG WS_DIR=/home/${NEW_USER}/ros2_ws


USER root

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
  && apt-get install -y \
  ssh \
  # iproute2 \
  build-essential \
  # ca-certificates \
  gnupg \
  software-properties-common \
  gcc \
  g++ \
  gdb \
  # clang \
  # cmake \
#   rsync \
#   tar \
  python3 \
  wget \
#   ninja-build \
  python3-pip \
  # nano \
#   openssh-client \
  git \
  curl \
#   tmux \
#   xclip \
  tree \
  x11-xserver-utils \
  libopencv-dev \
#   libyaml-cpp-dev \
#   libunwind-dev \
  ros-${ROS_DISTRO}-rosbridge-server \
  ros-${ROS_DISTRO}-rosbridge-suite \
  ros-${ROS_DISTRO}-rviz2 \
  ros-${ROS_DISTRO}-tf2-geometry-msgs \
  ros-${ROS_DISTRO}-mavros* \
#   ros-${ROS_DISTRO}-navigation2 \
#   ros-${ROS_DISTRO}-depth-image-proc \
  ros-${ROS_DISTRO}-image-proc \
  ros-${ROS_DISTRO}-ros-gz \
#   ros-${ROS_DISTRO}-rqt-graph \
  ros-${ROS_DISTRO}-xacro \
  ros-${ROS_DISTRO}-joy \
  # ros-${ROS_DISTRO}-ros2-control \
  # ros-${ROS_DISTRO}-ros2-controllers \
  ros-${ROS_DISTRO}-teleop-twist-joy \
#   ros-${ROS_DISTRO}-joint-state-publisher \
#   ros-${ROS_DISTRO}-joint-state-publisher-gui \
#   ros-${ROS_DISTRO}-joint-state-broadcaster \
#   ros-${ROS_DISTRO}-controller-manager \
  ros-${ROS_DISTRO}-imu-tools \
  ros-${ROS_DISTRO}-ros-gz \
  # This remembers to clean the apt cache after a run for size reduction
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Add the new_user to listed groups. And remove need for password
RUN adduser --disabled-password --gecos '' ${NEW_USER} \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && adduser ${NEW_USER} sudo \
  && adduser ${NEW_USER} audio \
  && adduser ${NEW_USER} video

FROM base AS dev-ws

# Switch to multi-agents user
USER ${NEW_USER}
WORKDIR $WS_DIR
ENV XDG_RUNTIME_DIR=/home/${NEW_USER}/x11_dir/
ENV WS_DIR=$WS_DIR
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV LIBGL_ALWAYS_INDIRECT=0
ENV GAZEBO_IP=127.0.0.1
RUN mkdir -p /home/${NEW_USER}/x11_dir/ && chmod 700 /home/${NEW_USER}/x11_dir/


# Create workspace directory if it doesn't exist
RUN mkdir -p $WS_DIR

# Copy necessary files from the build stage
# COPY --from=build $WS_DIR $WS_DIR

# Setup ROS environment
RUN echo "source /opt/ros/jazzy/setup.bash" >> /home/${NEW_USER}/.bashrc

CMD ["/bin/bash"]
# CMD ["tail", "-f", "/dev/null"]   # Already used in docker-compose.yml
