From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: Fix dead URLs to ftp.kernel.org
Date: Sun, 26 Mar 2017 13:11:15 -0600
Message-ID: <20170326131115.1399a01c@lwn.net>
References: <20170326142550.29269-1-sj38.park@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        jeffrey.t.kirsher@intel.com, mchehab@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>
To: SeongJae Park <sj38.park@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170326142550.29269-1-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 26 Mar 2017 23:25:50 +0900
SeongJae Park <sj38.park@gmail.com> wrote:

CC += davem

If nobody objects, I'll just take this through the docs tree.

Thanks,

jon

> As ftp.kernel.org is closed [0], this commit fixes dead URLs in
> documents to use www.kernel.org instead.
> 
> [0] https://www.kernel.org/shutting-down-ftp-services.html
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
> ---
>  Documentation/early-userspace/README       |  2 +-
>  Documentation/filesystems/ext4.txt         |  2 +-
>  Documentation/filesystems/nfs/nfs-rdma.txt |  2 +-
>  Documentation/networking/e100.txt          |  2 +-
>  Documentation/networking/e1000.txt         |  2 +-
>  Documentation/networking/e1000e.txt        |  2 +-
>  Documentation/networking/igb.txt           |  2 +-
>  Documentation/networking/igbvf.txt         |  2 +-
>  Documentation/networking/ixgb.txt          |  2 +-
>  Documentation/networking/ixgbe.txt         |  2 +-
>  Documentation/process/applying-patches.rst | 12 +++---------
>  Documentation/process/changes.rst          | 10 +++++-----
>  12 files changed, 18 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/early-userspace/README b/Documentation/early-userspace/README
> index 93e63a9af30b..2c00b072a4c8 100644
> --- a/Documentation/early-userspace/README
> +++ b/Documentation/early-userspace/README
> @@ -86,7 +86,7 @@ early userspace useful.  The klibc distribution is currently
>  maintained separately from the kernel.
>  
>  You can obtain somewhat infrequent snapshots of klibc from
> -ftp://ftp.kernel.org/pub/linux/libs/klibc/
> +https://www.kernel.org/pub/linux/libs/klibc/
>  
>  For active users, you are better off using the klibc git
>  repository, at http://git.kernel.org/?p=libs/klibc/klibc.git
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 3698ed3146e3..5a8f7f4d2bca 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -25,7 +25,7 @@ Note: More extensive information for getting started with ext4 can be
>  	
>  	or
>  
> -    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/
> +    https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/
>  
>  	or grab the latest git repository from:
>  
> diff --git a/Documentation/filesystems/nfs/nfs-rdma.txt b/Documentation/filesystems/nfs/nfs-rdma.txt
> index 1e6564545edf..31b55fe434d3 100644
> --- a/Documentation/filesystems/nfs/nfs-rdma.txt
> +++ b/Documentation/filesystems/nfs/nfs-rdma.txt
> @@ -113,7 +113,7 @@ Installation
>      kernel version 2.6.25 and later. This and other versions of the 2.6 Linux
>      kernel can be found at:
>  
> -    ftp://ftp.kernel.org/pub/linux/kernel/v2.6/
> +    https://www.kernel.org/pub/linux/kernel/v2.6/
>  
>      Download the sources and place them in an appropriate location.
>  
> diff --git a/Documentation/networking/e100.txt b/Documentation/networking/e100.txt
> index 42ddbd4b52a9..54810b82c01a 100644
> --- a/Documentation/networking/e100.txt
> +++ b/Documentation/networking/e100.txt
> @@ -130,7 +130,7 @@ Additional Configurations
>    version 1.6 or later is required for this functionality.
>  
>    The latest release of ethtool can be found from
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://www.kernel.org/pub/software/network/ethtool/
>  
>    Enabling Wake on LAN* (WoL)
>    ---------------------------
> diff --git a/Documentation/networking/e1000.txt b/Documentation/networking/e1000.txt
> index 437b2099cced..1f6ed848363d 100644
> --- a/Documentation/networking/e1000.txt
> +++ b/Documentation/networking/e1000.txt
> @@ -435,7 +435,7 @@ Additional Configurations
>    version 1.6 or later is required for this functionality.
>  
>    The latest release of ethtool can be found from
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://www.kernel.org/pub/software/network/ethtool/
>  
>    Enabling Wake on LAN* (WoL)
>    ---------------------------
> diff --git a/Documentation/networking/e1000e.txt b/Documentation/networking/e1000e.txt
> index ad2d9f38ce14..12089547baed 100644
> --- a/Documentation/networking/e1000e.txt
> +++ b/Documentation/networking/e1000e.txt
> @@ -274,7 +274,7 @@ Additional Configurations
>    diagnostics, as well as displaying statistical information.  We
>    strongly recommend downloading the latest version of ethtool at:
>  
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://kernel.org/pub/software/network/ethtool/
>  
>    NOTE: When validating enable/disable tests on some parts (82578, for example)
>    you need to add a few seconds between tests when working with ethtool.
> diff --git a/Documentation/networking/igb.txt b/Documentation/networking/igb.txt
> index 15534fdd09a8..f90643ef39c9 100644
> --- a/Documentation/networking/igb.txt
> +++ b/Documentation/networking/igb.txt
> @@ -63,7 +63,7 @@ Additional Configurations
>    diagnostics, as well as displaying statistical information. The latest
>    version of ethtool can be found at:
>  
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://www.kernel.org/pub/software/network/ethtool/
>  
>    Enabling Wake on LAN* (WoL)
>    ---------------------------
> diff --git a/Documentation/networking/igbvf.txt b/Documentation/networking/igbvf.txt
> index 40db17a6665b..bd404735fb46 100644
> --- a/Documentation/networking/igbvf.txt
> +++ b/Documentation/networking/igbvf.txt
> @@ -62,7 +62,7 @@ Additional Configurations
>    version 3.0 or later is required for this functionality, although we
>    strongly recommend downloading the latest version at:
>  
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://www.kernel.org/pub/software/network/ethtool/
>  
>  Support
>  =======
> diff --git a/Documentation/networking/ixgb.txt b/Documentation/networking/ixgb.txt
> index 9b4a10a1cf50..09f71d71920a 100644
> --- a/Documentation/networking/ixgb.txt
> +++ b/Documentation/networking/ixgb.txt
> @@ -313,7 +313,7 @@ Additional Configurations
>    version 1.6 or later is required for this functionality.
>  
>    The latest release of ethtool can be found from
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://www.kernel.org/pub/software/network/ethtool/
>  
>    NOTE: The ethtool version 1.6 only supports a limited set of ethtool options.
>          Support for a more complete ethtool feature set can be enabled by
> diff --git a/Documentation/networking/ixgbe.txt b/Documentation/networking/ixgbe.txt
> index 6f0cb57b59c6..687835415707 100644
> --- a/Documentation/networking/ixgbe.txt
> +++ b/Documentation/networking/ixgbe.txt
> @@ -272,7 +272,7 @@ Additional Configurations
>    ethtool version is required for this functionality.
>  
>    The latest release of ethtool can be found from
> -  http://ftp.kernel.org/pub/software/network/ethtool/
> +  https://www.kernel.org/pub/software/network/ethtool/
>  
>    FCoE
>    ----
> diff --git a/Documentation/process/applying-patches.rst b/Documentation/process/applying-patches.rst
> index 87825cf96f33..a0d058cc6d25 100644
> --- a/Documentation/process/applying-patches.rst
> +++ b/Documentation/process/applying-patches.rst
> @@ -250,17 +250,11 @@ specific homes.
>  
>  The 4.x.y (-stable) and 4.x patches live at
>  
> -	ftp://ftp.kernel.org/pub/linux/kernel/v4.x/
> +	https://www.kernel.org/pub/linux/kernel/v4.x/
>  
>  The -rc patches live at
>  
> -	ftp://ftp.kernel.org/pub/linux/kernel/v4.x/testing/
> -
> -In place of ``ftp.kernel.org`` you can use ``ftp.cc.kernel.org``, where cc is a
> -country code. This way you'll be downloading from a mirror site that's most
> -likely geographically closer to you, resulting in faster downloads for you,
> -less bandwidth used globally and less load on the main kernel.org servers --
> -these are good things, so do use mirrors when possible.
> +	https://www.kernel.org/pub/linux/kernel/v4.x/testing/
>  
>  
>  The 4.x kernels
> @@ -317,7 +311,7 @@ the current stable kernel.
>   The -stable team usually do make incremental patches available as well
>   as patches against the latest mainline release, but I only cover the
>   non-incremental ones below. The incremental ones can be found at
> - ftp://ftp.kernel.org/pub/linux/kernel/v4.x/incr/
> + https://www.kernel.org/pub/linux/kernel/v4.x/incr/
>  
>  These patches are not incremental, meaning that for example the 4.7.3
>  patch does not apply on top of the 4.7.2 kernel source, but rather on top
> diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
> index e4f25038ef65..01c5dbcd0f84 100644
> --- a/Documentation/process/changes.rst
> +++ b/Documentation/process/changes.rst
> @@ -349,7 +349,7 @@ Make
>  Binutils
>  --------
>  
> -- <ftp://ftp.kernel.org/pub/linux/devel/binutils/>
> +- <https://www.kernel.org/pub/linux/devel/binutils/>
>  
>  OpenSSL
>  -------
> @@ -362,17 +362,17 @@ System utilities
>  Util-linux
>  ----------
>  
> -- <ftp://ftp.kernel.org/pub/linux/utils/util-linux/>
> +- <https://www.kernel.org/pub/linux/utils/util-linux/>
>  
>  Ksymoops
>  --------
>  
> -- <ftp://ftp.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
> +- <https://www.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
>  
>  Module-Init-Tools
>  -----------------
>  
> -- <ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/modules/>
> +- <https://www.kernel.org/pub/linux/utils/kernel/module-init-tools/>
>  
>  Mkinitrd
>  --------
> @@ -402,7 +402,7 @@ Xfsprogs
>  Pcmciautils
>  -----------
>  
> -- <ftp://ftp.kernel.org/pub/linux/utils/kernel/pcmcia/>
> +- <https://www.kernel.org/pub/linux/utils/kernel/pcmcia/>
>  
>  Quota-tools
>  -----------
