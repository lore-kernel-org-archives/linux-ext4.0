From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] Documentation: Fix dead URLs to ftp.kernel.org
Date: Mon, 27 Mar 2017 22:05:34 +0900
Message-ID: <20170327130534.7487-1-sj38.park@gmail.com>
References: <CAEjAshpG7XXZgjuvau6v_hCNBJRqX7C2ODBqWQbZyCHegu9=Xg@mail.gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-wired-lan@lists.osuosl.org,
        SeongJae Park <sj38.park@gmail.com>
To: corbet@lwn.net, tytso@mit.edu, adilger.kernel@dilger.ca,
        jeffrey.t.kirsher@intel.com, mchehab@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAEjAshpG7XXZgjuvau6v_hCNBJRqX7C2ODBqWQbZyCHegu9=Xg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As ftp.kernel.org is closed [0], this commit fixes dead URLs in
documents to use www.kernel.org instead.

[0] https://www.kernel.org/shutting-down-ftp-services.html

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/early-userspace/README       |  2 +-
 Documentation/filesystems/ext4.txt         |  2 +-
 Documentation/filesystems/nfs/nfs-rdma.txt |  4 ++--
 Documentation/networking/e100.txt          |  2 +-
 Documentation/networking/e1000.txt         |  2 +-
 Documentation/networking/e1000e.txt        |  2 +-
 Documentation/networking/igb.txt           |  2 +-
 Documentation/networking/igbvf.txt         |  2 +-
 Documentation/networking/ixgb.txt          |  2 +-
 Documentation/networking/ixgbe.txt         |  2 +-
 Documentation/process/applying-patches.rst | 12 +++---------
 Documentation/process/changes.rst          | 10 +++++-----
 12 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/Documentation/early-userspace/README b/Documentation/early-userspace/README
index 93e63a9af30b..2c00b072a4c8 100644
--- a/Documentation/early-userspace/README
+++ b/Documentation/early-userspace/README
@@ -86,7 +86,7 @@ early userspace useful.  The klibc distribution is currently
 maintained separately from the kernel.
 
 You can obtain somewhat infrequent snapshots of klibc from
-ftp://ftp.kernel.org/pub/linux/libs/klibc/
+https://www.kernel.org/pub/linux/libs/klibc/
 
 For active users, you are better off using the klibc git
 repository, at http://git.kernel.org/?p=libs/klibc/klibc.git
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 3698ed3146e3..5a8f7f4d2bca 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -25,7 +25,7 @@ Note: More extensive information for getting started with ext4 can be
 	
 	or
 
-    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/
+    https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/
 
 	or grab the latest git repository from:
 
diff --git a/Documentation/filesystems/nfs/nfs-rdma.txt b/Documentation/filesystems/nfs/nfs-rdma.txt
index 1e6564545edf..22dc0dd6889c 100644
--- a/Documentation/filesystems/nfs/nfs-rdma.txt
+++ b/Documentation/filesystems/nfs/nfs-rdma.txt
@@ -110,10 +110,10 @@ Installation
   - Install a Linux kernel with NFS/RDMA
 
     The NFS/RDMA client and server are both included in the mainline Linux
-    kernel version 2.6.25 and later. This and other versions of the 2.6 Linux
+    kernel version 2.6.25 and later. This and other versions of the Linux
     kernel can be found at:
 
-    ftp://ftp.kernel.org/pub/linux/kernel/v2.6/
+    https://www.kernel.org/pub/linux/kernel/
 
     Download the sources and place them in an appropriate location.
 
diff --git a/Documentation/networking/e100.txt b/Documentation/networking/e100.txt
index 42ddbd4b52a9..54810b82c01a 100644
--- a/Documentation/networking/e100.txt
+++ b/Documentation/networking/e100.txt
@@ -130,7 +130,7 @@ Additional Configurations
   version 1.6 or later is required for this functionality.
 
   The latest release of ethtool can be found from
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://www.kernel.org/pub/software/network/ethtool/
 
   Enabling Wake on LAN* (WoL)
   ---------------------------
diff --git a/Documentation/networking/e1000.txt b/Documentation/networking/e1000.txt
index 437b2099cced..1f6ed848363d 100644
--- a/Documentation/networking/e1000.txt
+++ b/Documentation/networking/e1000.txt
@@ -435,7 +435,7 @@ Additional Configurations
   version 1.6 or later is required for this functionality.
 
   The latest release of ethtool can be found from
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://www.kernel.org/pub/software/network/ethtool/
 
   Enabling Wake on LAN* (WoL)
   ---------------------------
diff --git a/Documentation/networking/e1000e.txt b/Documentation/networking/e1000e.txt
index ad2d9f38ce14..12089547baed 100644
--- a/Documentation/networking/e1000e.txt
+++ b/Documentation/networking/e1000e.txt
@@ -274,7 +274,7 @@ Additional Configurations
   diagnostics, as well as displaying statistical information.  We
   strongly recommend downloading the latest version of ethtool at:
 
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://kernel.org/pub/software/network/ethtool/
 
   NOTE: When validating enable/disable tests on some parts (82578, for example)
   you need to add a few seconds between tests when working with ethtool.
diff --git a/Documentation/networking/igb.txt b/Documentation/networking/igb.txt
index 15534fdd09a8..f90643ef39c9 100644
--- a/Documentation/networking/igb.txt
+++ b/Documentation/networking/igb.txt
@@ -63,7 +63,7 @@ Additional Configurations
   diagnostics, as well as displaying statistical information. The latest
   version of ethtool can be found at:
 
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://www.kernel.org/pub/software/network/ethtool/
 
   Enabling Wake on LAN* (WoL)
   ---------------------------
diff --git a/Documentation/networking/igbvf.txt b/Documentation/networking/igbvf.txt
index 40db17a6665b..bd404735fb46 100644
--- a/Documentation/networking/igbvf.txt
+++ b/Documentation/networking/igbvf.txt
@@ -62,7 +62,7 @@ Additional Configurations
   version 3.0 or later is required for this functionality, although we
   strongly recommend downloading the latest version at:
 
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://www.kernel.org/pub/software/network/ethtool/
 
 Support
 =======
diff --git a/Documentation/networking/ixgb.txt b/Documentation/networking/ixgb.txt
index 9b4a10a1cf50..09f71d71920a 100644
--- a/Documentation/networking/ixgb.txt
+++ b/Documentation/networking/ixgb.txt
@@ -313,7 +313,7 @@ Additional Configurations
   version 1.6 or later is required for this functionality.
 
   The latest release of ethtool can be found from
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://www.kernel.org/pub/software/network/ethtool/
 
   NOTE: The ethtool version 1.6 only supports a limited set of ethtool options.
         Support for a more complete ethtool feature set can be enabled by
diff --git a/Documentation/networking/ixgbe.txt b/Documentation/networking/ixgbe.txt
index 6f0cb57b59c6..687835415707 100644
--- a/Documentation/networking/ixgbe.txt
+++ b/Documentation/networking/ixgbe.txt
@@ -272,7 +272,7 @@ Additional Configurations
   ethtool version is required for this functionality.
 
   The latest release of ethtool can be found from
-  http://ftp.kernel.org/pub/software/network/ethtool/
+  https://www.kernel.org/pub/software/network/ethtool/
 
   FCoE
   ----
diff --git a/Documentation/process/applying-patches.rst b/Documentation/process/applying-patches.rst
index 87825cf96f33..a0d058cc6d25 100644
--- a/Documentation/process/applying-patches.rst
+++ b/Documentation/process/applying-patches.rst
@@ -250,17 +250,11 @@ specific homes.
 
 The 4.x.y (-stable) and 4.x patches live at
 
-	ftp://ftp.kernel.org/pub/linux/kernel/v4.x/
+	https://www.kernel.org/pub/linux/kernel/v4.x/
 
 The -rc patches live at
 
-	ftp://ftp.kernel.org/pub/linux/kernel/v4.x/testing/
-
-In place of ``ftp.kernel.org`` you can use ``ftp.cc.kernel.org``, where cc is a
-country code. This way you'll be downloading from a mirror site that's most
-likely geographically closer to you, resulting in faster downloads for you,
-less bandwidth used globally and less load on the main kernel.org servers --
-these are good things, so do use mirrors when possible.
+	https://www.kernel.org/pub/linux/kernel/v4.x/testing/
 
 
 The 4.x kernels
@@ -317,7 +311,7 @@ the current stable kernel.
  The -stable team usually do make incremental patches available as well
  as patches against the latest mainline release, but I only cover the
  non-incremental ones below. The incremental ones can be found at
- ftp://ftp.kernel.org/pub/linux/kernel/v4.x/incr/
+ https://www.kernel.org/pub/linux/kernel/v4.x/incr/
 
 These patches are not incremental, meaning that for example the 4.7.3
 patch does not apply on top of the 4.7.2 kernel source, but rather on top
diff --git a/Documentation/process/changes.rst b/Documentation/process/changes.rst
index 56ce66114665..60df34ada8a1 100644
--- a/Documentation/process/changes.rst
+++ b/Documentation/process/changes.rst
@@ -348,7 +348,7 @@ Make
 Binutils
 --------
 
-- <ftp://ftp.kernel.org/pub/linux/devel/binutils/>
+- <https://www.kernel.org/pub/linux/devel/binutils/>
 
 OpenSSL
 -------
@@ -361,17 +361,17 @@ System utilities
 Util-linux
 ----------
 
-- <ftp://ftp.kernel.org/pub/linux/utils/util-linux/>
+- <https://www.kernel.org/pub/linux/utils/util-linux/>
 
 Ksymoops
 --------
 
-- <ftp://ftp.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
+- <https://www.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/>
 
 Module-Init-Tools
 -----------------
 
-- <ftp://ftp.kernel.org/pub/linux/kernel/people/rusty/modules/>
+- <https://www.kernel.org/pub/linux/utils/kernel/module-init-tools/>
 
 Mkinitrd
 --------
@@ -401,7 +401,7 @@ Xfsprogs
 Pcmciautils
 -----------
 
-- <ftp://ftp.kernel.org/pub/linux/utils/kernel/pcmcia/>
+- <https://www.kernel.org/pub/linux/utils/kernel/pcmcia/>
 
 Quota-tools
 -----------
-- 
2.10.0
