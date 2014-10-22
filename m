From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] xfstests-bld: Split system images in two parts
Date: Wed, 22 Oct 2014 19:06:56 +0400
Message-ID: <1413990417-18285-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, root <root@deb7build (none) >
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:37003 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaJVPHI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 11:07:08 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: root <root@deb7build.(none)>

There are three different parts of the kvm-xfstests boundle
1) operation system itself
2) xfstests + xfstest-config
3) kernel

Currently (1) and (2) are combined together to root_fs.img, but
it is not always good because (1) is usually very stable, but
(2) is not especially in case of xfstests development.
This patch split root_fs image in two parts:
root_fs.img: contains debian distribution and generic xfstest startup scripts
test_fs.img: contains xfstests and xfstest-config  (mounted in /tests)

With that packaging scheme one can easily regenerate xfstests on non debian
enviroment.

Guest image rename scheme:
/root/xfstests -> /tests/xfstests
/root/conf  -> /tests/xfstests-conf
TEST_API: 1.0 -> 2.0 # because old-layout no longer compatible with new one.

Minor changes: Add various error checks to gen-image
---
 README                                             |    7 +-
 kvm-xfstests/README                                |    8 +-
 kvm-xfstests/config                                |    1 +
 kvm-xfstests/kvm-xfstests                          |    5 +-
 kvm-xfstests/test-appliance/.gitignore             |    2 +
 kvm-xfstests/test-appliance/files/etc/fstab        |   13 --
 kvm-xfstests/test-appliance/files/etc/hostname     |    1 -
 .../files/etc/network/interfaces.d/eth0            |    6 -
 .../files/etc/systemd/system/kvm-xfstests.service  |   13 --
 kvm-xfstests/test-appliance/files/root/.bashrc     |    1 -
 kvm-xfstests/test-appliance/files/root/conf/1k     |    6 -
 kvm-xfstests/test-appliance/files/root/conf/4k     |    6 -
 .../test-appliance/files/root/conf/bigalloc        |    9 --
 .../test-appliance/files/root/conf/bigalloc_1k     |    7 -
 .../test-appliance/files/root/conf/data_journal    |    6 -
 .../files/root/conf/data_journal.exclude           |    1 -
 .../test-appliance/files/root/conf/dioread_nolock  |    6 -
 .../test-appliance/files/root/conf/encrypt         |    6 -
 kvm-xfstests/test-appliance/files/root/conf/ext3   |    6 -
 .../test-appliance/files/root/conf/ext3conv        |    6 -
 kvm-xfstests/test-appliance/files/root/conf/inline |    7 -
 .../test-appliance/files/root/conf/inline.exclude  |    1 -
 .../test-appliance/files/root/conf/metacsum        |    7 -
 .../test-appliance/files/root/conf/nojournal       |    6 -
 kvm-xfstests/test-appliance/files/root/conf/xfs    |    4 -
 .../test-appliance/files/root/kvm-xfstests.boot    |   56 --------
 kvm-xfstests/test-appliance/files/root/runtests.sh |  136 --------------------
 kvm-xfstests/test-appliance/files/root/test-config |   29 -----
 kvm-xfstests/test-appliance/files/root/test-env    |    6 -
 kvm-xfstests/test-appliance/gen-image              |   81 +-----------
 kvm-xfstests/test-appliance/gen-root-image         |   91 +++++++++++++
 kvm-xfstests/test-appliance/gen-test-image         |   35 +++++
 kvm-xfstests/test-appliance/root_files/etc/fstab   |   14 ++
 .../test-appliance/root_files/etc/hostname         |    1 +
 .../root_files/etc/network/interfaces.d/eth0       |    6 +
 .../etc/systemd/system/kvm-xfstests.service        |   13 ++
 .../test-appliance/root_files/root/.bashrc         |    1 +
 .../root_files/root/kvm-xfstests.boot              |   56 ++++++++
 .../test-appliance/root_files/root/runtests.sh     |  136 ++++++++++++++++++++
 .../test-appliance/root_files/root/test-config     |   29 +++++
 .../test-appliance/root_files/root/test-env        |    6 +
 .../test-appliance/test_files/xfstests-conf/1k     |    6 +
 .../test-appliance/test_files/xfstests-conf/4k     |    6 +
 .../test_files/xfstests-conf/bigalloc              |    9 ++
 .../test_files/xfstests-conf/bigalloc_1k           |    7 +
 .../test_files/xfstests-conf/data_journal          |    6 +
 .../test_files/xfstests-conf/data_journal.exclude  |    1 +
 .../test_files/xfstests-conf/dioread_nolock        |    6 +
 .../test_files/xfstests-conf/encrypt               |    6 +
 .../test-appliance/test_files/xfstests-conf/ext3   |    6 +
 .../test_files/xfstests-conf/ext3conv              |    6 +
 .../test-appliance/test_files/xfstests-conf/inline |    7 +
 .../test_files/xfstests-conf/inline.exclude        |    1 +
 .../test_files/xfstests-conf/metacsum              |    7 +
 .../test_files/xfstests-conf/nojournal             |    6 +
 .../test-appliance/test_files/xfstests-conf/xfs    |    4 +
 56 files changed, 490 insertions(+), 431 deletions(-)
 delete mode 100644 kvm-xfstests/test-appliance/files/etc/fstab
 delete mode 100644 kvm-xfstests/test-appliance/files/etc/hostname
 delete mode 100644 kvm-xfstests/test-appliance/files/etc/network/interfaces.d/eth0
 delete mode 100644 kvm-xfstests/test-appliance/files/etc/systemd/system/kvm-xfstests.service
 delete mode 100644 kvm-xfstests/test-appliance/files/root/.bashrc
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/1k
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/4k
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/bigalloc
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/data_journal
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/dioread_nolock
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/encrypt
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/ext3
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/ext3conv
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/inline
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/inline.exclude
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/metacsum
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/nojournal
 delete mode 100644 kvm-xfstests/test-appliance/files/root/conf/xfs
 delete mode 100755 kvm-xfstests/test-appliance/files/root/kvm-xfstests.boot
 delete mode 100755 kvm-xfstests/test-appliance/files/root/runtests.sh
 delete mode 100644 kvm-xfstests/test-appliance/files/root/test-config
 delete mode 100644 kvm-xfstests/test-appliance/files/root/test-env
 create mode 100644 kvm-xfstests/test-appliance/gen-root-image
 create mode 100755 kvm-xfstests/test-appliance/gen-test-image
 create mode 100644 kvm-xfstests/test-appliance/root_files/etc/fstab
 create mode 100644 kvm-xfstests/test-appliance/root_files/etc/hostname
 create mode 100644 kvm-xfstests/test-appliance/root_files/etc/network/interfaces.d/eth0
 create mode 100644 kvm-xfstests/test-appliance/root_files/etc/systemd/system/kvm-xfstests.service
 create mode 100644 kvm-xfstests/test-appliance/root_files/root/.bashrc
 create mode 100755 kvm-xfstests/test-appliance/root_files/root/kvm-xfstests.boot
 create mode 100755 kvm-xfstests/test-appliance/root_files/root/runtests.sh
 create mode 100644 kvm-xfstests/test-appliance/root_files/root/test-config
 create mode 100644 kvm-xfstests/test-appliance/root_files/root/test-env
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/1k
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/4k
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc_1k
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal.exclude
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/dioread_nolock
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/encrypt
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3conv
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/inline
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/inline.exclude
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/metacsum
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/nojournal
 create mode 100644 kvm-xfstests/test-appliance/test_files/xfstests-conf/xfs

diff --git a/README b/README
index 9558e99..d7b4e5a 100644
--- a/README
+++ b/README
@@ -17,7 +17,12 @@ know if create something which works well for other distributions.
 
 1.  "make ; make tarball" to generate the xfstests.tar.gz file.
 2.  cd to kvm-xfststs/test-appliance, and run as root the shell script
-    "gen-image".  This will create the root_fs.img file.
+    "gen-root-image && gen-test-image".  This will create the root_fs.img
+    and test_fs.img files accordingly. Usually user should not regenerate
+    root_fs.img because it contains only OS packages and generic hooks
+    for kvm-xfstests,  xfstests and it's configs are placed to test_fs.img
+    and may be regenerated with "gen-test-image" 
+    
 3.  build a kernel which does not use modules (at least for all of the
     device drivers required for running under kvm).  There are sample
     kernel configs found in the top-level kernel-configs directory.
diff --git a/kvm-xfstests/README b/kvm-xfstests/README
index 30c02e7..453d7c4 100644
--- a/kvm-xfstests/README
+++ b/kvm-xfstests/README
@@ -41,10 +41,10 @@ The kvm-xfstests script is used as follows:
 *) kvm-xfstests maint
 
 	Will drop you into a root shell and allows you to modify the
-	root file system.  KVM uses and modifies the root_fs.img file,
-	which is a compressed qcow2 image.  After doing a lot of
-	maintenance, the root_fs.img can get quite large.  If so, the
-	compress-rootfs shell script can be helpful.
+	root file system.  KVM uses and modifies the root_fs.img and
+	test_fs.img files, which is a compressed qcow2 image.  After
+	doing a lot of maintenance, the root_fs.img can get quite
+	large.  If so, the compress-rootfs shell script can be helpful.
 
 
 To extract the interesting results from the log file, run the command
diff --git a/kvm-xfstests/config b/kvm-xfstests/config
index 3ead580..c80d4d7 100644
--- a/kvm-xfstests/config
+++ b/kvm-xfstests/config
@@ -11,6 +11,7 @@ CONFIG_DIR=$HOME/.config
 PRIMARY_FSTYPE="ext4"
 ROOT_FS=$DIR/test-appliance/root_fs.img
 ROOT_DEV=/dev/vda
+TEST_FS=$DIR/test-appliance/test_fs.img
 VDB=$DIR/vdb
 VDC=$DIR/vdc
 VDD=$DIR/vdd
diff --git a/kvm-xfstests/kvm-xfstests b/kvm-xfstests/kvm-xfstests
index d77cc8b..66235b9 100755
--- a/kvm-xfstests/kvm-xfstests
+++ b/kvm-xfstests/kvm-xfstests
@@ -5,7 +5,7 @@ DIR=.
 
 . $DIR/util/parse_cli
 
-API="1.0"
+API="2.0"
 
 ARG="$ARG fstesttyp=$PRIMARY_FSTYPE fstestapi=$API"
 
@@ -34,7 +34,7 @@ then
 	$DIR/setup
 fi
 
-$QEMU -boot order=c $NET \
+$QEMU $QEMU_OPT -boot order=c $NET \
 	-drive file=$ROOT_FS,if=virtio$SNAPSHOT \
 	-drive file=$VDB,cache=none,if=virtio \
 	-drive file=$VDC,cache=none,if=virtio \
@@ -42,6 +42,7 @@ $QEMU -boot order=c $NET \
 	-drive file=$VDE,cache=none,if=virtio \
 	-drive file=$VDF,cache=none,if=virtio \
 	-drive file=$VDG,cache=none,if=virtio \
+	-drive file=$TEST_FS,if=virtio$SNAPSHOT \
 	-nographic -smp $NR_CPU -m $MEM \
         $CONSOLE \
         $MONITOR \
diff --git a/kvm-xfstests/test-appliance/.gitignore b/kvm-xfstests/test-appliance/.gitignore
index 6bd9cb8..53eaab5 100644
--- a/kvm-xfstests/test-appliance/.gitignore
+++ b/kvm-xfstests/test-appliance/.gitignore
@@ -1,5 +1,7 @@
 root_fs.img
 root_fs.raw
+test_fs.img
+test_fs.raw
 rootdir
 var.cache.apt.archives
 var.lib.apt.lists
diff --git a/kvm-xfstests/test-appliance/files/etc/fstab b/kvm-xfstests/test-appliance/files/etc/fstab
deleted file mode 100644
index 20859fc..0000000
--- a/kvm-xfstests/test-appliance/files/etc/fstab
+++ /dev/null
@@ -1,13 +0,0 @@
-# /etc/fstab: static file system information.
-
-# <file system> <mount point>   <type>  <options>       <dump>  <pass>
-proc            /proc           proc    defaults        0       0
-tmpfs		/tmp		tmpfs	mode=1777	0	0
-debugfs		/sys/kernel/debug debugfs defaults	0	0
-/dev/rootfs	/	ext4    noatime 0 1
-/dev/vdb	/vdb	ext4	defaults,noauto	0	0
-/dev/vdc	/vdc ext4	defaults,noauto,usrquota,grpquota	0	0
-/dev/vdd	/vdd ext4	defaults,noauto	0	0
-/dev/vde	/vde ext4	defaults,noauto 0	0
-/dev/vdf	/vdf ext4	defaults,noauto 0	0
-/dev/vdg	/results ext4	defaults 0 2
diff --git a/kvm-xfstests/test-appliance/files/etc/hostname b/kvm-xfstests/test-appliance/files/etc/hostname
deleted file mode 100644
index 69fc9da..0000000
--- a/kvm-xfstests/test-appliance/files/etc/hostname
+++ /dev/null
@@ -1 +0,0 @@
-kvm-xfstests
diff --git a/kvm-xfstests/test-appliance/files/etc/network/interfaces.d/eth0 b/kvm-xfstests/test-appliance/files/etc/network/interfaces.d/eth0
deleted file mode 100644
index 699f499..0000000
--- a/kvm-xfstests/test-appliance/files/etc/network/interfaces.d/eth0
+++ /dev/null
@@ -1,6 +0,0 @@
-auto eth0
-
-iface eth0 inet static
-	address 172.20.0.10
-	netmask 255.255.0.0
-	gateway 172.20.0.2
diff --git a/kvm-xfstests/test-appliance/files/etc/systemd/system/kvm-xfstests.service b/kvm-xfstests/test-appliance/files/etc/systemd/system/kvm-xfstests.service
deleted file mode 100644
index 1196440..0000000
--- a/kvm-xfstests/test-appliance/files/etc/systemd/system/kvm-xfstests.service
+++ /dev/null
@@ -1,13 +0,0 @@
-[Unit]
-Description=KVM-xfstests
-After=network.target
-
-[Service]
-Type=forking
-ExecStart=/root/kvm-xfstests.boot
-TimeoutSec=0
-StandardInput=tty
-RemainAfterExit=yes
-
-[Install]
-WantedBy=multi-user.target
diff --git a/kvm-xfstests/test-appliance/files/root/.bashrc b/kvm-xfstests/test-appliance/files/root/.bashrc
deleted file mode 100644
index befce74..0000000
--- a/kvm-xfstests/test-appliance/files/root/.bashrc
+++ /dev/null
@@ -1 +0,0 @@
-PATH=/root/xfstests/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
diff --git a/kvm-xfstests/test-appliance/files/root/conf/1k b/kvm-xfstests/test-appliance/files/root/conf/1k
deleted file mode 100644
index dcfb152..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/1k
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -b 1024"
-export EXT_MOUNT_OPTIONS="-o block_validity"
-TESTNAME="Ext4 1k block"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/4k b/kvm-xfstests/test-appliance/files/root/conf/4k
deleted file mode 100644
index 5649d7e..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/4k
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDB
-export TEST_DIR=/vdb
-export MKFS_OPTIONS="-q"
-export EXT_MOUNT_OPTIONS="-o block_validity"
-TESTNAME="Ext4 4k block"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/bigalloc b/kvm-xfstests/test-appliance/files/root/conf/bigalloc
deleted file mode 100644
index c5509d2..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/bigalloc
+++ /dev/null
@@ -1,9 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDE
-export TEST_DIR=/vde
-export SCRATCH_DEV=$VDF
-export SCRATCH_MNT=/vdf
-export MKFS_OPTIONS="-q -O bigalloc"
-export EXT_MOUNT_OPTIONS="-o block_validity"
-TESTNAME="Ext4 4k block w/bigalloc"
-
diff --git a/kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k b/kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k
deleted file mode 100644
index 62a0c61..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/bigalloc_1k
+++ /dev/null
@@ -1,7 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -b 1024 -O bigalloc"
-export EXT_MOUNT_OPTIONS="-o block_validity"
-TESTNAME="Ext4 1k block w/bigalloc"
-
diff --git a/kvm-xfstests/test-appliance/files/root/conf/data_journal b/kvm-xfstests/test-appliance/files/root/conf/data_journal
deleted file mode 100644
index f8ad09b..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/data_journal
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDB
-export TEST_DIR=/vdb
-export MKFS_OPTIONS="-q"
-export EXT_MOUNT_OPTIONS="-o block_validity,data=journal"
-TESTNAME="Ext4 4k block w/data=journal"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude b/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
deleted file mode 100644
index e2bcac3..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/data_journal.exclude
+++ /dev/null
@@ -1 +0,0 @@
-generic/068
diff --git a/kvm-xfstests/test-appliance/files/root/conf/dioread_nolock b/kvm-xfstests/test-appliance/files/root/conf/dioread_nolock
deleted file mode 100644
index dd80e52..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/dioread_nolock
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDB
-export TEST_DIR=/vdb
-export MKFS_OPTIONS="-q"
-export EXT_MOUNT_OPTIONS="-o block_validity,dioread_nolock"
-TESTNAME="Ext4 4k block w/dioread_nolock"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/encrypt b/kvm-xfstests/test-appliance/files/root/conf/encrypt
deleted file mode 100644
index 0cac763..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/encrypt
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q"
-export EXT_MOUNT_OPTIONS="-o block_validity,dummy_encryption"
-TESTNAME="Ext4 encryption"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/ext3 b/kvm-xfstests/test-appliance/files/root/conf/ext3
deleted file mode 100644
index a24b91e..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/ext3
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -O ^extents,^flex_bg,^uninit_bg"
-export EXT_MOUNT_OPTIONS="-o block_validity,nodelalloc"
-TESTNAME="Ext4 4k block w/nodelalloc, no flex_bg, and no extents"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/ext3conv b/kvm-xfstests/test-appliance/files/root/conf/ext3conv
deleted file mode 100644
index ae17de5..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/ext3conv
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -O ^flex_bg"
-export EXT_MOUNT_OPTIONS="-o block_validity,nodelalloc"
-TESTNAME="Ext4 4k block w/nodelalloc and no flex_bg"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/inline b/kvm-xfstests/test-appliance/files/root/conf/inline
deleted file mode 100644
index 52b0609..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/inline
+++ /dev/null
@@ -1,7 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -O inline_data,metadata_csum,64bit"
-export EXT_MOUNT_OPTIONS="-o block_validity"
-TESTNAME="Ext4 4k block w/inline"
-
diff --git a/kvm-xfstests/test-appliance/files/root/conf/inline.exclude b/kvm-xfstests/test-appliance/files/root/conf/inline.exclude
deleted file mode 100644
index 9a059f8..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/inline.exclude
+++ /dev/null
@@ -1 +0,0 @@
-generic/027
diff --git a/kvm-xfstests/test-appliance/files/root/conf/metacsum b/kvm-xfstests/test-appliance/files/root/conf/metacsum
deleted file mode 100644
index 684b86d..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/metacsum
+++ /dev/null
@@ -1,7 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-export MKFS_OPTIONS="-q -O metadata_csum,64bit"
-export EXT_MOUNT_OPTIONS="-o block_validity"
-TESTNAME="Ext4 4k block w/metadata_csum"
-
diff --git a/kvm-xfstests/test-appliance/files/root/conf/nojournal b/kvm-xfstests/test-appliance/files/root/conf/nojournal
deleted file mode 100644
index f8219b6..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/nojournal
+++ /dev/null
@@ -1,6 +0,0 @@
-export FS=ext4
-export TEST_DEV=$VDB
-export TEST_DIR=/vdb
-export MKFS_OPTIONS="-q -O ^has_journal"
-export EXT_MOUNT_OPTIONS="-o block_validity,noload"
-TESTNAME="Ext4 4k block w/ no journal"
diff --git a/kvm-xfstests/test-appliance/files/root/conf/xfs b/kvm-xfstests/test-appliance/files/root/conf/xfs
deleted file mode 100644
index 0006dd8..0000000
--- a/kvm-xfstests/test-appliance/files/root/conf/xfs
+++ /dev/null
@@ -1,4 +0,0 @@
-export FS=xfs
-export TEST_DEV=$VDD
-export TEST_DIR=/vdd
-TESTNAME="XFS"
diff --git a/kvm-xfstests/test-appliance/files/root/kvm-xfstests.boot b/kvm-xfstests/test-appliance/files/root/kvm-xfstests.boot
deleted file mode 100755
index 3a2e06c..0000000
--- a/kvm-xfstests/test-appliance/files/root/kvm-xfstests.boot
+++ /dev/null
@@ -1,56 +0,0 @@
-#!/bin/bash -e
-#
-# rc.local
-#
-# This script is executed at the end of each multiuser runlevel.
-# Make sure that the script will "exit 0" on success or any other
-# value on error.
-#
-# In order to enable or disable this script just change the execution
-# bits.
-#
-# By default this script does nothing.
-
-parse() {
-if grep -q " $1=" /proc/cmdline; then
-   cat /proc/cmdline | sed -e "s/.* $1=//" | sed -e 's/ .*//'
-else
-   echo ""
-fi
-}
-
-PATH="/root/xfstests/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
-
-FSTESTCFG=$(parse fstestcfg | sed -e 's/,/ /g')
-FSTESTSET=$(parse fstestset | sed -e 's/,/ /g')
-FSTESTOPT=$(parse fstestopt | sed -e 's/,/ /g')
-FSTESTTYP=$(parse fstesttyp)
-FSTESTAPI=$(parse fstestapi | sed -e 's/\./ /g')
-timezone=$(parse fstesttz)
-MNTOPTS=$(parse mount_opts)
-CMD=$(parse cmd)
-
-export FSTESTCFG
-export FSTESTSET
-export FSTESTOPT
-export FSTESTTYP
-export FSTESTAPI
-export MNTOPTS
-
-if test -n "$timezone" -a -f /usr/share/zoneinfo/$timezone
-then
-    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
-    echo $timezone > /etc/timezone
-fi
-
-if test -n "$FSTESTCFG" -a -n "$FSTESTSET"
-then
-	sed -e 's/^/FSTESTVER: /g' /root/xfstests/git-versions
-	echo -e "FSTESTVER: kernel\t$(uname -r -v -m)"
-
-	echo FSTESTCFG: \"$FSTESTCFG\"
-	echo FSTESTSET: \"$FSTESTSET\"
-	echo FSTESTOPT: \"$FSTESTOPT\"
-	/root/runtests.sh
-	/sbin/poweroff
-fi
diff --git a/kvm-xfstests/test-appliance/files/root/runtests.sh b/kvm-xfstests/test-appliance/files/root/runtests.sh
deleted file mode 100755
index f20d237..0000000
--- a/kvm-xfstests/test-appliance/files/root/runtests.sh
+++ /dev/null
@@ -1,136 +0,0 @@
-#!/bin/bash
-
-API_MAJOR=1
-API_MINOR=0
-. /root/test-config
-
-if test -z "$FSTESTAPI" ; then
-    echo "Missing TEST API!"
-    umount /results
-    poweroff -f
-fi
-
-set $FSTESTAPI
-
-if test "$1" -ne "$API_MAJOR" ; then
-    echo " "
-    echo "API version of kvm-xfstests is $1.$2"
-    echo "Major version number must be $API_MAJOR"
-    echo " "
-    umount /results
-    poweroff -f
-fi
-
-if test "$2" -gt "$API_MINOR" ; then
-    echo " "
-    echo "API version of kvm-xfstests is $1.$2"
-    echo "Minor version number is greater than $API_MINOR"
-    echo "Some kvm-xfstests options may not work correctly."
-    echo "please update or rebuild your root_fs.img"
-    echo " "
-    sleep 5
-fi
-
-if test -n "$FSTESTOPT" ; then
-   set $FSTESTOPT
-else
-   set ""
-fi
-
-RPT_COUNT=1
-
-while [ "$1" != "" ]; do
-  case $1 in
-    aex)
-	echo "Enabling auto exclude"
-	DO_AEX=t
-	;;
-    count) shift
-	RPT_COUNT=$1
-	echo "Repeat each test $RPT_COUNT times"
-	;;
-    *)
-	echo " "
-	echo "Unrecognized option $i"
-	echo " "
-  esac
-  shift
-done
-
-umount $VDB >& /dev/null
-umount $VDD >& /dev/null
-/sbin/e2fsck -fy $VDB
-if test $? -ge 8 ; then
-	mke2fs -F -q -t ext4 $VDB
-fi
-dmesg -n 5
-cd /root/xfstests
-
-if test "$FSTESTCFG" = all
-then
-	FSTESTCFG="4k 1k ext3 nojournal ext3conv metacsum dioread_nolock data_journal bigalloc bigalloc_1k inline"
-fi
-
-SLAB_GREP="ext4\|jbd2\|xfs"
-
-grep $SLAB_GREP /proc/slabinfo
-free -m
-
-for i in $FSTESTCFG
-do
-	export SCRATCH_DEV=$VDC
-	export SCRATCH_MNT=/vdc
-	export RESULT_BASE=/results/results-$i
-	mkdir -p $RESULT_BASE
-	if test -e "/root/conf/$i"; then
-		. /root/conf/$i
-	else
-		echo "Unknown configuration $i!"
-		continue
-	fi
-	if test -n "$MNTOPTS" ; then
-		EXT_MOUNT_OPTIONS="$EXT_MOUNT_OPTIONS,$MNTOPTS"
-	fi
-	if test "$TEST_DEV" != "$VDB" ; then
-		if test "$FS" = "ext4" ; then
-		    mke2fs -F -q -t ext4 $MKFS_OPTIONS $TEST_DEV
-		elif test "$FS" = "xfs" ; then
-		    mkfs.xfs -f $MKFS_OPTIONS $TEST_DEV
-		else
-		    /sbin/mkfs.$FS $TEST_DEV
-		fi
-	fi
-	echo -n "BEGIN TEST: $TESTNAME " ; date
-	echo Device: $TEST_DEV
-	echo mk2fs options: $MKFS_OPTIONS
-	echo mount options: $EXT_MOUNT_OPTIONS
-	export FSTYP=$FS
-	AEX=""
-	if test -n "$DO_AEX" -a -f "/root/conf/$i.exclude"; then
-	    AEX="-E /root/conf/$i.exclude"
-        fi
-	for j in $(seq 1 $RPT_COUNT) ; do
-	   bash ./check -T $AEX $FSTESTSET
-	   umount $TEST_DEV >& /dev/null
-	   if test "$FS" = "ext4" ; then
-		/sbin/e2fsck -fy $TEST_DEV >& $RESULT_BASE/fsck.out
-		if test $? -gt 0 ; then
-		   cat $RESULT_BASE/fsck.out
-		fi
-	   elif test "$FS" = "xfs" ; then
-		if ! xfs_repair -n $TEST_DEV >& /dev/null ; then
-		   xfs_repair $TEST_DEV
-		fi
-	   else
-		/sbin/fsck.$FS $TEST_DEV
-	   fi
-	done
-	free -m
-	if test "$FS" = "ext4" ; then
-	   SLAB_GREP="ext4\|jbd2"
-	else
-	   SLAB_GREP=$FS
-	fi
-	grep $SLAB_GREP /proc/slabinfo
-	echo -n "END TEST: $TESTNAME " ; date
-done
diff --git a/kvm-xfstests/test-appliance/files/root/test-config b/kvm-xfstests/test-appliance/files/root/test-config
deleted file mode 100644
index ce4104f..0000000
--- a/kvm-xfstests/test-appliance/files/root/test-config
+++ /dev/null
@@ -1,29 +0,0 @@
-#
-# The test appliance uses five file systems
-#
-# VDB:  The primary file system's (small) persistent test device
-# VDC:  A small scratch device
-# VDD:  A small test device
-# VDE:  A large test device
-# VDF:  A large scratch device
-
-# legacy names
-export VDB=/dev/vdb
-export VDC=/dev/vdc
-export VDD=/dev/vdd
-export VDE=/dev/vde
-export VDF=/dev/vdf
-
-export PRI_TEST_DEV=/dev/vdb
-export SM_SCR_DEV=/dev/vdc
-export SM_TST_DEV=/dev/vdd
-export LG_TST_DEV=/dev/vde
-export LG_SCR_DEV=/dev/vdf
-
-export PRI_TEST_MNT=/$(basename $PRI_TEST_DEV)
-export SM_SCR_MNT=/$(basename SM_SCR_DEV)
-export SM_TST_MNT=/$(basename SM_TST_DEV)
-export LG_TST_MNT=/$(basename LG_TST_DEV)
-export LG_SCR_MNT=/$(basename LG_SCR_DEV)
-
-PATH="/root/xfstests/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
diff --git a/kvm-xfstests/test-appliance/files/root/test-env b/kvm-xfstests/test-appliance/files/root/test-env
deleted file mode 100644
index d5f45b4..0000000
--- a/kvm-xfstests/test-appliance/files/root/test-env
+++ /dev/null
@@ -1,6 +0,0 @@
-# For people who need to run tests by hand
-export FSTESTAPI="1 0"
-export FSTESTCFG=4k
-export FSTESTSET=generic/001
-export FSTESTOPT=aex
-export FSTESTTYP=ext4
diff --git a/kvm-xfstests/test-appliance/gen-image b/kvm-xfstests/test-appliance/gen-image
index a45f9b9..c89174a 100755
--- a/kvm-xfstests/test-appliance/gen-image
+++ b/kvm-xfstests/test-appliance/gen-image
@@ -2,84 +2,7 @@
 #
 # This shell script must be run as root
 
-SUITE=jessie
-MIRROR=http://mirrors.kernel.org/debian
-DIR=$(pwd)
-ROOTDIR=$DIR/rootdir
-#ARCH="--arch=i386"
-RAW_ROOT_FS=$DIR/root_fs.raw
-ROOT_FS=$DIR/root_fs.img
-COMPAT="-o compat=0.10"
 
-if test $(df -k /tmp | tail -1 | awk '{print $4}') -gt 350000
-then
-    RAW_ROOT_FS=/tmp/root_fs.raw.$$
-fi
 
-mkdir -p $ROOTDIR
-mkdir -p var.cache.apt.archives
-mkdir -p var.lib.apt.lists
-mkdir -p debs
-cp /dev/null $RAW_ROOT_FS
-mke2fs -t ext4 -O ^has_journal -Fq $RAW_ROOT_FS 1g
-mount -t ext4 -o loop $RAW_ROOT_FS $ROOTDIR
-mkdir -p $ROOTDIR/var/cache/apt/archives
-mount --bind var.cache.apt.archives $ROOTDIR/var/cache/apt/archives
-mkdir -p $ROOTDIR/var/lib/apt/lists
-mount --bind var.lib.apt.lists $ROOTDIR/var/lib/apt/lists
-mkdir -p $ROOTDIR/debs
-mount --bind debs $ROOTDIR/debs
-debootstrap --variant=xfstests $ARCH $SUITE $ROOTDIR $MIRROR $DIR/kvm-xfstest.script
-cp -r files/* rootdir
-echo "untaring xfstests"
-tar -C rootdir/root -xf ../../xfstests.tar.gz
-for i in vda vdb vdc vdd vde vdf results
-do
-	mkdir $ROOTDIR/$i
-done
-
-echo "fsgqa:x:31415:31415:fsgqa user:/home/fsgqa:/bin/sh" >> $ROOTDIR/etc/passwd
-echo "fsgqa:*:31415:0:99999:7:::" >> $ROOTDIR/etc/shadow
-echo "fsgqa:x:31415:" >> $ROOTDIR/etc/group
-mkdir $ROOTDIR/home/fsgqa
-chown 31415:31415 $ROOTDIR/home/fsgqa
-chmod 755 $ROOTDIR/root
-
-DEBS=$(find debs -name \*.deb)
-if test -n "$DEBS"
-then
-    chroot $ROOTDIR dpkg --ignore-depends=e2fsprogs -i $DEBS
-fi
-
-
-cp $ROOTDIR/lib/systemd/system/serial-getty@.service \
-	$ROOTDIR/etc/systemd/system/telnet-getty@.service
-sed -i -e '/ExecStart/s/agetty/agetty -a root/' \
-    -e 's/After=rc.local.service/After=kvm-xfstests.service/' \
-	$ROOTDIR/lib/systemd/system/serial-getty@.service
-sed -i -e '/ExecStart/s/agetty/agetty -a root/' \
-    -e 's/After=rc.local.service/After=network.target/' \
-	$ROOTDIR/etc/systemd/system/telnet-getty@.service
-chroot $ROOTDIR dpkg --purge gcc-4.7-base gcc-4.8-base
-chroot $ROOTDIR systemctl enable kvm-xfstests.service
-chroot $ROOTDIR systemctl enable telnet-getty@ttyS1.service
-chroot $ROOTDIR systemctl enable telnet-getty@ttyS2.service
-chroot $ROOTDIR systemctl enable telnet-getty@ttyS3.service
-find $ROOTDIR/usr/share/doc -type f | grep -v copyright | xargs rm
-find $ROOTDIR/usr/share/doc -mindepth 2 -type l | xargs rm
-find $ROOTDIR/usr/share/doc -type d | xargs rmdir --ignore-fail-on-non-empty -p
-rm -rf $ROOTDIR/usr/share/man
-find $ROOTDIR/var/log -type f | xargs rm
-
-umount $ROOTDIR/var/cache/apt/archives
-umount $ROOTDIR/var/lib/apt/lists
-umount $ROOTDIR/debs
-rmdir $ROOTDIR/debs
-umount $ROOTDIR
-rmdir $ROOTDIR
-
-tune2fs -O has_journal $RAW_ROOT_FS
-e2fsck -fyD $RAW_ROOT_FS
-e2fsck -fy -E discard $RAW_ROOT_FS
-qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_ROOT_FS $ROOT_FS
-rm -f $RAW_ROOT_FS
+./gen-root-image || exit 1
+./gen-test-image || exit 1
diff --git a/kvm-xfstests/test-appliance/gen-root-image b/kvm-xfstests/test-appliance/gen-root-image
new file mode 100644
index 0000000..977c4c2
--- /dev/null
+++ b/kvm-xfstests/test-appliance/gen-root-image
@@ -0,0 +1,91 @@
+#!/bin/sh
+#
+# This shell script must be run as root
+
+SUITE=jessie
+
+MIRROR=http://mirrors.kernel.org/debian
+DIR=$(pwd)
+ROOTDIR=$DIR/rootdir
+#ARCH="--arch=i386"
+RAW_ROOT_FS=$DIR/root_fs.raw
+ROOT_FS=$DIR/root_fs.img
+COMPAT="-o compat=0.10"
+
+
+if test $(df -k /tmp | tail -1 | awk '{print $4}') -gt 350000
+then
+    RAW_ROOT_FS=/tmp/root_fs.raw.$$
+fi
+
+mkdir -p $ROOTDIR || exit 1
+mkdir -p var.cache.apt.archives || exit 1
+mkdir -p var.lib.apt.lists || exit 1
+mkdir -p debs || exit 1
+cp /dev/null $RAW_ROOT_FS
+mke2fs -t ext4 -O ^has_journal -Fq $RAW_ROOT_FS 1g || exit 1
+mount -t ext4 -o loop $RAW_ROOT_FS $ROOTDIR || exit 1
+mkdir -p $ROOTDIR/tests || exit 1
+mkdir -p $ROOTDIR/var/cache/apt/archives || exit 1
+mount --bind var.cache.apt.archives $ROOTDIR/var/cache/apt/archives || exit 1
+mkdir -p $ROOTDIR/var/lib/apt/lists || exit 1
+mount --bind var.lib.apt.lists $ROOTDIR/var/lib/apt/lists || exit 1
+mkdir -p $ROOTDIR/debs
+mount --bind debs $ROOTDIR/debs
+debootstrap --variant=xfstests $ARCH $SUITE $ROOTDIR $MIRROR $DIR/kvm-xfstest.script || exit 1
+cp -r root_files/* $ROOTDIR || exit 1
+
+# Add symlink for backward compatibility with 1.x
+ln -s /tests/xfstests $ROOTDIR/root/xfstests
+ln -s /tests/xfstests-conf $ROOTDIR/root/conf
+
+for i in vda vdb vdc vdd vde vdf results
+do
+	mkdir $ROOTDIR/$i || exit1
+done
+
+echo "fsgqa:x:31415:31415:fsgqa user:/home/fsgqa:/bin/sh" >> $ROOTDIR/etc/passwd
+echo "fsgqa:*:31415:0:99999:7:::" >> $ROOTDIR/etc/shadow
+echo "fsgqa:x:31415:" >> $ROOTDIR/etc/group
+mkdir $ROOTDIR/home/fsgqa
+chown 31415:31415 $ROOTDIR/home/fsgqa
+chmod 755 $ROOTDIR/root
+
+DEBS=$(find debs -name \*.deb)
+if test -n "$DEBS"
+then
+    chroot $ROOTDIR dpkg --ignore-depends=e2fsprogs -i $DEBS || exit 1
+fi
+
+
+cp $ROOTDIR/lib/systemd/system/serial-getty@.service \
+	$ROOTDIR/etc/systemd/system/telnet-getty@.service
+sed -i -e '/ExecStart/s/agetty/agetty -a root/' \
+    -e 's/After=rc.local.service/After=kvm-xfstests.service/' \
+	$ROOTDIR/lib/systemd/system/serial-getty@.service
+sed -i -e '/ExecStart/s/agetty/agetty -a root/' \
+    -e 's/After=rc.local.service/After=network.target/' \
+	$ROOTDIR/etc/systemd/system/telnet-getty@.service
+chroot $ROOTDIR dpkg --purge gcc-4.7-base gcc-4.8-base
+chroot $ROOTDIR systemctl enable kvm-xfstests.service
+chroot $ROOTDIR systemctl enable telnet-getty@ttyS1.service
+chroot $ROOTDIR systemctl enable telnet-getty@ttyS2.service
+chroot $ROOTDIR systemctl enable telnet-getty@ttyS3.service
+find $ROOTDIR/usr/share/doc -type f | grep -v copyright | xargs rm
+find $ROOTDIR/usr/share/doc -mindepth 2 -type l | xargs rm
+find $ROOTDIR/usr/share/doc -type d | xargs rmdir --ignore-fail-on-non-empty -p
+rm -rf $ROOTDIR/usr/share/man
+find $ROOTDIR/var/log -type f | xargs rm
+
+umount $ROOTDIR/var/cache/apt/archives || exit 1
+umount $ROOTDIR/var/lib/apt/lists || exit 1
+umount $ROOTDIR/debs || exit 1
+rmdir $ROOTDIR/debs || exit 1
+umount $ROOTDIR || exit 1
+rmdir $ROOTDIR || exit 1
+
+tune2fs -O has_journal $RAW_ROOT_FS || exit 1
+e2fsck -fyD $RAW_ROOT_FS
+e2fsck -fy -E discard $RAW_ROOT_FS || exit 1
+qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_ROOT_FS $ROOT_FS || exit 1
+rm -f $RAW_ROOT_FS
diff --git a/kvm-xfstests/test-appliance/gen-test-image b/kvm-xfstests/test-appliance/gen-test-image
new file mode 100755
index 0000000..ab02592
--- /dev/null
+++ b/kvm-xfstests/test-appliance/gen-test-image
@@ -0,0 +1,35 @@
+#!/bin/sh
+#
+# This shell script must be run as root
+
+DIR=$(pwd)
+RAW_TEST_FS=$DIR/test_fs.raw
+TEST_FS=$DIR/test_fs.img
+TESTDIR=$DIR/testdir
+COMPAT="-o compat=0.10"
+
+
+if test $(df -k /tmp | tail -1 | awk '{print $4}') -gt 350000
+then
+    RAW_TEST_FS=/tmp/test_fs.raw.$$
+else
+    exit 1
+fi
+
+mkdir -p $TESTDIR || exit 1
+cp /dev/null $RAW_TEST_FS || exit 1
+
+mke2fs -t ext4 -O ^has_journal -Fq $RAW_TEST_FS 1g || exit 1
+mount -t ext4 -o loop $RAW_TEST_FS $TESTDIR || exit 1
+
+echo "untaring xfstests"
+cp -r test_files/* $TESTDIR || exit 1
+tar -C $TESTDIR -xf ../../xfstests.tar.gz || exit 1
+umount $TESTDIR || exit 1
+rmdir $TESTDIR || exit 1
+
+tune2fs -O has_journal $RAW_TEST_FS || exit 1
+e2fsck -fyD $RAW_TEST_FS
+e2fsck -fy -E discard $RAW_TEST_FS || exit 1
+qemu-img convert -f raw -O qcow2 $COMPAT -c $RAW_TEST_FS $TEST_FS || exit 1
+rm -f $RAW_TEST_FS || exit 1
diff --git a/kvm-xfstests/test-appliance/root_files/etc/fstab b/kvm-xfstests/test-appliance/root_files/etc/fstab
new file mode 100644
index 0000000..6118c25
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/etc/fstab
@@ -0,0 +1,14 @@
+# /etc/fstab: static file system information.
+
+# <file system> <mount point>   <type>  <options>       <dump>  <pass>
+proc            /proc           proc    defaults        0       0
+tmpfs		/tmp		tmpfs	mode=1777	0	0
+debugfs		/sys/kernel/debug debugfs defaults	0	0
+/dev/rootfs	/	ext4    noatime 0 1
+/dev/vdb	/vdb	ext4	defaults,noauto	0	0
+/dev/vdc	/vdc ext4	defaults,noauto,usrquota,grpquota	0	0
+/dev/vdd	/vdd ext4	defaults,noauto	0	0
+/dev/vde	/vde ext4	defaults,noauto 0	0
+/dev/vdf	/vdf ext4	defaults,noauto 0	0
+/dev/vdg	/results ext4	defaults 0 2
+/dev/vdh	/tests ext4	defaults 0 2
diff --git a/kvm-xfstests/test-appliance/root_files/etc/hostname b/kvm-xfstests/test-appliance/root_files/etc/hostname
new file mode 100644
index 0000000..69fc9da
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/etc/hostname
@@ -0,0 +1 @@
+kvm-xfstests
diff --git a/kvm-xfstests/test-appliance/root_files/etc/network/interfaces.d/eth0 b/kvm-xfstests/test-appliance/root_files/etc/network/interfaces.d/eth0
new file mode 100644
index 0000000..699f499
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/etc/network/interfaces.d/eth0
@@ -0,0 +1,6 @@
+auto eth0
+
+iface eth0 inet static
+	address 172.20.0.10
+	netmask 255.255.0.0
+	gateway 172.20.0.2
diff --git a/kvm-xfstests/test-appliance/root_files/etc/systemd/system/kvm-xfstests.service b/kvm-xfstests/test-appliance/root_files/etc/systemd/system/kvm-xfstests.service
new file mode 100644
index 0000000..1196440
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/etc/systemd/system/kvm-xfstests.service
@@ -0,0 +1,13 @@
+[Unit]
+Description=KVM-xfstests
+After=network.target
+
+[Service]
+Type=forking
+ExecStart=/root/kvm-xfstests.boot
+TimeoutSec=0
+StandardInput=tty
+RemainAfterExit=yes
+
+[Install]
+WantedBy=multi-user.target
diff --git a/kvm-xfstests/test-appliance/root_files/root/.bashrc b/kvm-xfstests/test-appliance/root_files/root/.bashrc
new file mode 100644
index 0000000..befce74
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/root/.bashrc
@@ -0,0 +1 @@
+PATH=/root/xfstests/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
diff --git a/kvm-xfstests/test-appliance/root_files/root/kvm-xfstests.boot b/kvm-xfstests/test-appliance/root_files/root/kvm-xfstests.boot
new file mode 100755
index 0000000..3a2e06c
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/root/kvm-xfstests.boot
@@ -0,0 +1,56 @@
+#!/bin/bash -e
+#
+# rc.local
+#
+# This script is executed at the end of each multiuser runlevel.
+# Make sure that the script will "exit 0" on success or any other
+# value on error.
+#
+# In order to enable or disable this script just change the execution
+# bits.
+#
+# By default this script does nothing.
+
+parse() {
+if grep -q " $1=" /proc/cmdline; then
+   cat /proc/cmdline | sed -e "s/.* $1=//" | sed -e 's/ .*//'
+else
+   echo ""
+fi
+}
+
+PATH="/root/xfstests/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
+
+FSTESTCFG=$(parse fstestcfg | sed -e 's/,/ /g')
+FSTESTSET=$(parse fstestset | sed -e 's/,/ /g')
+FSTESTOPT=$(parse fstestopt | sed -e 's/,/ /g')
+FSTESTTYP=$(parse fstesttyp)
+FSTESTAPI=$(parse fstestapi | sed -e 's/\./ /g')
+timezone=$(parse fstesttz)
+MNTOPTS=$(parse mount_opts)
+CMD=$(parse cmd)
+
+export FSTESTCFG
+export FSTESTSET
+export FSTESTOPT
+export FSTESTTYP
+export FSTESTAPI
+export MNTOPTS
+
+if test -n "$timezone" -a -f /usr/share/zoneinfo/$timezone
+then
+    ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
+    echo $timezone > /etc/timezone
+fi
+
+if test -n "$FSTESTCFG" -a -n "$FSTESTSET"
+then
+	sed -e 's/^/FSTESTVER: /g' /root/xfstests/git-versions
+	echo -e "FSTESTVER: kernel\t$(uname -r -v -m)"
+
+	echo FSTESTCFG: \"$FSTESTCFG\"
+	echo FSTESTSET: \"$FSTESTSET\"
+	echo FSTESTOPT: \"$FSTESTOPT\"
+	/root/runtests.sh
+	/sbin/poweroff
+fi
diff --git a/kvm-xfstests/test-appliance/root_files/root/runtests.sh b/kvm-xfstests/test-appliance/root_files/root/runtests.sh
new file mode 100755
index 0000000..0ef5764
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/root/runtests.sh
@@ -0,0 +1,136 @@
+#!/bin/bash
+
+API_MAJOR=2
+API_MINOR=0
+. /root/test-config
+
+if test -z "$FSTESTAPI" ; then
+    echo "Missing TEST API!"
+    umount /results
+    poweroff -f
+fi
+
+set $FSTESTAPI
+
+if test "$1" -ne "$API_MAJOR" ; then
+    echo " "
+    echo "API version of kvm-xfstests is $1.$2"
+    echo "Major version number must be $API_MAJOR"
+    echo " "
+    umount /results
+    poweroff -f
+fi
+
+if test "$2" -gt "$API_MINOR" ; then
+    echo " "
+    echo "API version of kvm-xfstests is $1.$2"
+    echo "Minor version number is greater than $API_MINOR"
+    echo "Some kvm-xfstests options may not work correctly."
+    echo "please update or rebuild your root_fs.img"
+    echo " "
+    sleep 5
+fi
+
+if test -n "$FSTESTOPT" ; then
+   set $FSTESTOPT
+else
+   set ""
+fi
+
+RPT_COUNT=1
+
+while [ "$1" != "" ]; do
+  case $1 in
+    aex)
+	echo "Enabling auto exclude"
+	DO_AEX=t
+	;;
+    count) shift
+	RPT_COUNT=$1
+	echo "Repeat each test $RPT_COUNT times"
+	;;
+    *)
+	echo " "
+	echo "Unrecognized option $i"
+	echo " "
+  esac
+  shift
+done
+
+umount $VDB >& /dev/null
+umount $VDD >& /dev/null
+/sbin/e2fsck -fy $VDB
+if test $? -ge 8 ; then
+	mke2fs -F -q -t ext4 $VDB
+fi
+dmesg -n 5
+cd /tests/xfstests
+
+if test "$FSTESTCFG" = all
+then
+	FSTESTCFG="4k 1k ext3 nojournal ext3conv metacsum dioread_nolock data_journal bigalloc bigalloc_1k inline"
+fi
+
+SLAB_GREP="ext4\|jbd2\|xfs"
+
+grep $SLAB_GREP /proc/slabinfo
+free -m
+
+for i in $FSTESTCFG
+do
+	export SCRATCH_DEV=$VDC
+	export SCRATCH_MNT=/vdc
+	export RESULT_BASE=/results/results-$i
+	mkdir -p $RESULT_BASE
+	if test -e "/tests/xfstests-conf/$i"; then
+		. /tests/xfstests-conf/$i
+	else
+		echo "Unknown configuration $i!"
+		continue
+	fi
+	if test -n "$MNTOPTS" ; then
+		EXT_MOUNT_OPTIONS="$EXT_MOUNT_OPTIONS,$MNTOPTS"
+	fi
+	if test "$TEST_DEV" != "$VDB" ; then
+		if test "$FS" = "ext4" ; then
+		    mke2fs -F -q -t ext4 $MKFS_OPTIONS $TEST_DEV
+		elif test "$FS" = "xfs" ; then
+		    mkfs.xfs -f $MKFS_OPTIONS $TEST_DEV
+		else
+		    /sbin/mkfs.$FS $TEST_DEV
+		fi
+	fi
+	echo -n "BEGIN TEST: $TESTNAME " ; date
+	echo Device: $TEST_DEV
+	echo mk2fs options: $MKFS_OPTIONS
+	echo mount options: $EXT_MOUNT_OPTIONS
+	export FSTYP=$FS
+	AEX=""
+	if test -n "$DO_AEX" -a -f "/tests/xfstests-conf/$i.exclude"; then
+	    AEX="-E /tests/xfstests-conf/$i.exclude"
+        fi
+	for j in $(seq 1 $RPT_COUNT) ; do
+	   bash ./check -T $AEX $FSTESTSET
+	   umount $TEST_DEV >& /dev/null
+	   if test "$FS" = "ext4" ; then
+		/sbin/e2fsck -fy $TEST_DEV >& $RESULT_BASE/fsck.out
+		if test $? -gt 0 ; then
+		   cat $RESULT_BASE/fsck.out
+		fi
+	   elif test "$FS" = "xfs" ; then
+		if ! xfs_repair -n $TEST_DEV >& /dev/null ; then
+		   xfs_repair $TEST_DEV
+		fi
+	   else
+		/sbin/fsck.$FS $TEST_DEV
+	   fi
+	done
+	free -m
+	if test "$FS" = "ext4" ; then
+	   SLAB_GREP="ext4\|jbd2"
+	else
+	   SLAB_GREP=$FS
+	fi
+	grep $SLAB_GREP /proc/slabinfo
+	echo -n "END TEST: $TESTNAME " ; date
+done
diff --git a/kvm-xfstests/test-appliance/root_files/root/test-config b/kvm-xfstests/test-appliance/root_files/root/test-config
new file mode 100644
index 0000000..ce4104f
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/root/test-config
@@ -0,0 +1,29 @@
+#
+# The test appliance uses five file systems
+#
+# VDB:  The primary file system's (small) persistent test device
+# VDC:  A small scratch device
+# VDD:  A small test device
+# VDE:  A large test device
+# VDF:  A large scratch device
+
+# legacy names
+export VDB=/dev/vdb
+export VDC=/dev/vdc
+export VDD=/dev/vdd
+export VDE=/dev/vde
+export VDF=/dev/vdf
+
+export PRI_TEST_DEV=/dev/vdb
+export SM_SCR_DEV=/dev/vdc
+export SM_TST_DEV=/dev/vdd
+export LG_TST_DEV=/dev/vde
+export LG_SCR_DEV=/dev/vdf
+
+export PRI_TEST_MNT=/$(basename $PRI_TEST_DEV)
+export SM_SCR_MNT=/$(basename SM_SCR_DEV)
+export SM_TST_MNT=/$(basename SM_TST_DEV)
+export LG_TST_MNT=/$(basename LG_TST_DEV)
+export LG_SCR_MNT=/$(basename LG_SCR_DEV)
+
+PATH="/root/xfstests/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
diff --git a/kvm-xfstests/test-appliance/root_files/root/test-env b/kvm-xfstests/test-appliance/root_files/root/test-env
new file mode 100644
index 0000000..9a829a1
--- /dev/null
+++ b/kvm-xfstests/test-appliance/root_files/root/test-env
@@ -0,0 +1,6 @@
+# For people who need to run tests by hand
+export FSTESTAPI="2 0"
+export FSTESTCFG=4k
+export FSTESTSET=generic/001
+export FSTESTOPT=aex
+export FSTESTTYP=ext4
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/1k b/kvm-xfstests/test-appliance/test_files/xfstests-conf/1k
new file mode 100644
index 0000000..dcfb152
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/1k
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q -b 1024"
+export EXT_MOUNT_OPTIONS="-o block_validity"
+TESTNAME="Ext4 1k block"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/4k b/kvm-xfstests/test-appliance/test_files/xfstests-conf/4k
new file mode 100644
index 0000000..5649d7e
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/4k
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDB
+export TEST_DIR=/vdb
+export MKFS_OPTIONS="-q"
+export EXT_MOUNT_OPTIONS="-o block_validity"
+TESTNAME="Ext4 4k block"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc b/kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc
new file mode 100644
index 0000000..c5509d2
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc
@@ -0,0 +1,9 @@
+export FS=ext4
+export TEST_DEV=$VDE
+export TEST_DIR=/vde
+export SCRATCH_DEV=$VDF
+export SCRATCH_MNT=/vdf
+export MKFS_OPTIONS="-q -O bigalloc"
+export EXT_MOUNT_OPTIONS="-o block_validity"
+TESTNAME="Ext4 4k block w/bigalloc"
+
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc_1k b/kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc_1k
new file mode 100644
index 0000000..62a0c61
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/bigalloc_1k
@@ -0,0 +1,7 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q -b 1024 -O bigalloc"
+export EXT_MOUNT_OPTIONS="-o block_validity"
+TESTNAME="Ext4 1k block w/bigalloc"
+
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal b/kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal
new file mode 100644
index 0000000..f8ad09b
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDB
+export TEST_DIR=/vdb
+export MKFS_OPTIONS="-q"
+export EXT_MOUNT_OPTIONS="-o block_validity,data=journal"
+TESTNAME="Ext4 4k block w/data=journal"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal.exclude b/kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal.exclude
new file mode 100644
index 0000000..e2bcac3
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/data_journal.exclude
@@ -0,0 +1 @@
+generic/068
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/dioread_nolock b/kvm-xfstests/test-appliance/test_files/xfstests-conf/dioread_nolock
new file mode 100644
index 0000000..dd80e52
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/dioread_nolock
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDB
+export TEST_DIR=/vdb
+export MKFS_OPTIONS="-q"
+export EXT_MOUNT_OPTIONS="-o block_validity,dioread_nolock"
+TESTNAME="Ext4 4k block w/dioread_nolock"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/encrypt b/kvm-xfstests/test-appliance/test_files/xfstests-conf/encrypt
new file mode 100644
index 0000000..0cac763
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/encrypt
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q"
+export EXT_MOUNT_OPTIONS="-o block_validity,dummy_encryption"
+TESTNAME="Ext4 encryption"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3 b/kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3
new file mode 100644
index 0000000..a24b91e
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q -O ^extents,^flex_bg,^uninit_bg"
+export EXT_MOUNT_OPTIONS="-o block_validity,nodelalloc"
+TESTNAME="Ext4 4k block w/nodelalloc, no flex_bg, and no extents"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3conv b/kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3conv
new file mode 100644
index 0000000..ae17de5
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/ext3conv
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q -O ^flex_bg"
+export EXT_MOUNT_OPTIONS="-o block_validity,nodelalloc"
+TESTNAME="Ext4 4k block w/nodelalloc and no flex_bg"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/inline b/kvm-xfstests/test-appliance/test_files/xfstests-conf/inline
new file mode 100644
index 0000000..52b0609
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/inline
@@ -0,0 +1,7 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q -O inline_data,metadata_csum,64bit"
+export EXT_MOUNT_OPTIONS="-o block_validity"
+TESTNAME="Ext4 4k block w/inline"
+
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/inline.exclude b/kvm-xfstests/test-appliance/test_files/xfstests-conf/inline.exclude
new file mode 100644
index 0000000..9a059f8
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/inline.exclude
@@ -0,0 +1 @@
+generic/027
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/metacsum b/kvm-xfstests/test-appliance/test_files/xfstests-conf/metacsum
new file mode 100644
index 0000000..684b86d
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/metacsum
@@ -0,0 +1,7 @@
+export FS=ext4
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+export MKFS_OPTIONS="-q -O metadata_csum,64bit"
+export EXT_MOUNT_OPTIONS="-o block_validity"
+TESTNAME="Ext4 4k block w/metadata_csum"
+
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/nojournal b/kvm-xfstests/test-appliance/test_files/xfstests-conf/nojournal
new file mode 100644
index 0000000..f8219b6
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/nojournal
@@ -0,0 +1,6 @@
+export FS=ext4
+export TEST_DEV=$VDB
+export TEST_DIR=/vdb
+export MKFS_OPTIONS="-q -O ^has_journal"
+export EXT_MOUNT_OPTIONS="-o block_validity,noload"
+TESTNAME="Ext4 4k block w/ no journal"
diff --git a/kvm-xfstests/test-appliance/test_files/xfstests-conf/xfs b/kvm-xfstests/test-appliance/test_files/xfstests-conf/xfs
new file mode 100644
index 0000000..0006dd8
--- /dev/null
+++ b/kvm-xfstests/test-appliance/test_files/xfstests-conf/xfs
@@ -0,0 +1,4 @@
+export FS=xfs
+export TEST_DEV=$VDD
+export TEST_DIR=/vdd
+TESTNAME="XFS"
-- 
1.7.10.4

