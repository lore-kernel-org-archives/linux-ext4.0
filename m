From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] common: Improve _link_output_file to be more versatile
Date: Tue, 24 Nov 2015 11:39:57 +0100
Message-ID: <1448361598-28438-3-git-send-email-jack@suse.cz>
References: <1448361598-28438-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbbKXKkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2015 05:40:04 -0500
In-Reply-To: <1448361598-28438-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.com>

Currently _link_output_file() selects output file suffix based on the
current operating system. Make it more versatile by allowing selection
of output file suffix based on any feature string. The idea is that
in config file ($seq.cfg) there are several lines like:

feat1,feat2: suffix

The function is passed a feature string (or uses os_name,MOUNT_OPTIONS
if no argument is passed) and selects output file with a suffix for
which all features are present in the feature string. If there is no
matching line, output with 'default' suffix is selected.

Update all tests using _link_out_file to the new calling convention.

Signed-off-by: Jan Kara <jack@suse.com>
---
 common/rc                   |  49 +++++++++--
 tests/generic/088           |   2 +-
 tests/generic/088.cfg       |   2 +
 tests/xfs/018               |   2 +-
 tests/xfs/018.cfg           |   2 +
 tests/xfs/022               |   2 +-
 tests/xfs/022.cfg           |   2 +
 tests/xfs/023               |   2 +-
 tests/xfs/023.cfg           |   2 +
 tests/xfs/030               |   2 +-
 tests/xfs/030.cfg           |   2 +
 tests/xfs/031               |   2 +-
 tests/xfs/031.cfg           |   2 +
 tests/xfs/033               |   6 +-
 tests/xfs/033.cfg           |   3 +
 tests/xfs/033.crc.out.linux | 197 --------------------------------------------
 tests/xfs/033.out.crc.linux | 197 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/035               |   2 +-
 tests/xfs/035.cfg           |   2 +
 tests/xfs/036               |   2 +-
 tests/xfs/036.cfg           |   2 +
 tests/xfs/039               |   2 +-
 tests/xfs/039.cfg           |   2 +
 tests/xfs/043               |   2 +-
 tests/xfs/043.cfg           |   2 +
 tests/xfs/055               |   2 +-
 tests/xfs/082               |   2 +-
 tests/xfs/082.cfg           |   2 +
 tests/xfs/146               |   2 +-
 tests/xfs/146.cfg           |   2 +
 30 files changed, 283 insertions(+), 219 deletions(-)
 create mode 100644 tests/generic/088.cfg
 create mode 100644 tests/xfs/018.cfg
 create mode 100644 tests/xfs/022.cfg
 create mode 100644 tests/xfs/023.cfg
 create mode 100644 tests/xfs/030.cfg
 create mode 100644 tests/xfs/031.cfg
 create mode 100644 tests/xfs/033.cfg
 delete mode 100644 tests/xfs/033.crc.out.linux
 create mode 100644 tests/xfs/033.out.crc.linux
 create mode 100644 tests/xfs/035.cfg
 create mode 100644 tests/xfs/036.cfg
 create mode 100644 tests/xfs/039.cfg
 create mode 100644 tests/xfs/043.cfg
 create mode 100644 tests/xfs/082.cfg
 create mode 100644 tests/xfs/146.cfg

diff --git a/common/rc b/common/rc
index 81418280f163..8256a15050dc 100644
--- a/common/rc
+++ b/common/rc
@@ -2200,15 +2200,52 @@ _get_os_name()
 	fi
 }
 
+_link_out_file_named()
+{
+	export FEATURES=$2
+	SUFFIX=$(perl -e '
+		my %feathash;
+		my $feature, $result, $suffix, $opts;
+
+		foreach $feature (split(/,/, $ENV{"FEATURES"})) {
+			$feathash{$feature} = 1;
+		}
+		$result = "default";
+		while (<>) {
+			my $found = 1;
+
+			chomp;
+			($opts, $suffix) = split(/ *: */);
+			foreach my $opt (split(/,/, $opts)) {
+				if (!exists($feathash{$opt})) {
+					$found = 0;
+					last;
+				}
+			}
+			if ($found == 1) {
+				$result = $suffix;
+				last;
+			}
+		}
+		print $result
+		' <$seqfull.cfg)
+	rm -f $1
+	SRC=$(basename $1)
+	ln -fs $SRC.$SUFFIX $1
+}
+
 _link_out_file()
 {
-	if [ -z "$1" -o -z "$2" ]; then
-		echo Error must pass src and dst.
-		exit
+	if [ $# -eq 0 ]; then
+		FEATURES="$(_get_os_name)"
+		if [ -n "$MOUNT_OPTIONS" ]; then
+			FEATURES=$FEATURES,${MOUNT_OPTIONS##"-o "}
+		fi
+	else
+		FEATURES=$1
 	fi
-	rm -f $2
-	SUFFIX=$(_get_os_name())
-	ln -s $1.$SUFFIX $2
+
+	_link_out_file_named $seqfull.out "$FEATURES"
 }
 
 _die()
diff --git a/tests/generic/088 b/tests/generic/088
index 983de983c059..46ce6ae4e25d 100755
--- a/tests/generic/088
+++ b/tests/generic/088
@@ -43,7 +43,7 @@ _filter()
 }
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs generic
diff --git a/tests/generic/088.cfg b/tests/generic/088.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/generic/088.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/018 b/tests/xfs/018
index f097b283207e..848981f87ff4 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -54,7 +54,7 @@ _require_scratch
 _require_v2log
 
 # link correct .out file
-_link_out_file $seq.op $seqfull.op
+_link_out_file_named $seqfull.op $(_get_os_name)
 
 echo "*** init FS"
 umount $SCRATCH_DEV >/dev/null 2>&1
diff --git a/tests/xfs/018.cfg b/tests/xfs/018.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/018.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/022 b/tests/xfs/022
index cd9b9ec18c5e..b2b6142cb285 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -39,7 +39,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/022.cfg b/tests/xfs/022.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/022.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/023 b/tests/xfs/023
index 120be64e432d..9a899a86268d 100755
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -38,7 +38,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/023.cfg b/tests/xfs/023.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/023.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/030 b/tests/xfs/030
index a43455f595ba..d2f5ed1917db 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -46,7 +46,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/repair
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # nuke the superblock, AGI, AGF, AGFL; then try repair the damage
 #
diff --git a/tests/xfs/030.cfg b/tests/xfs/030.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/030.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/031 b/tests/xfs/031
index 48a97e1d5f4f..59d68c31f9a1 100755
--- a/tests/xfs/031
+++ b/tests/xfs/031
@@ -39,7 +39,7 @@ rm -f $seqres.full
 . ./common/filter
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 _check_repair()
 {
diff --git a/tests/xfs/031.cfg b/tests/xfs/031.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/031.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/033 b/tests/xfs/033
index 576d437e33ff..dab111aa00f4 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -84,11 +84,11 @@ _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
 	_scratch_mkfs_xfs -isize=512 | _filter_mkfs >/dev/null 2>&1
 
 # link correct .out file
+FEATURES=$(_get_os_name)
 if [ $_fs_has_crcs -eq 1 ]; then
-	_link_out_file $seq.crc.out $seqfull.out
-else
-	_link_out_file $seq.out $seqfull.out
+	FEATURES=$FEATURES,crc
 fi
+_link_out_file_named $seqfull.out "$FEATURES"
 
 `xfs_db -r -c sb -c p $SCRATCH_DEV | grep 'ino = ' | \
 	sed -e 's/ //g' -e 's/^/export /'`
diff --git a/tests/xfs/033.cfg b/tests/xfs/033.cfg
new file mode 100644
index 000000000000..88e90e575804
--- /dev/null
+++ b/tests/xfs/033.cfg
@@ -0,0 +1,3 @@
+irix: irix
+linux,crc: crc.linux
+linux: linux
diff --git a/tests/xfs/033.crc.out.linux b/tests/xfs/033.crc.out.linux
deleted file mode 100644
index a6e86b9c8a28..000000000000
--- a/tests/xfs/033.crc.out.linux
+++ /dev/null
@@ -1,197 +0,0 @@
-QA output created by 033
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Corrupting root inode - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0x0 on inode INO
-bad version number 0x0 on inode INO
-inode identifier 0 mismatch on inode INO
-bad magic number 0x0 on inode INO, resetting magic number
-bad version number 0x0 on inode INO, resetting version number
-inode identifier 0 mismatch on inode INO
-cleared root inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-root inode lost
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing root directory
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
-done
-Corrupting rt bitmap inode - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0x0 on inode INO
-bad version number 0x0 on inode INO
-inode identifier 0 mismatch on inode INO
-bad magic number 0x0 on inode INO, resetting magic number
-bad version number 0x0 on inode INO, resetting version number
-inode identifier 0 mismatch on inode INO
-cleared realtime bitmap inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime bitmap inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-Corrupting rt summary inode - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0x0 on inode INO
-bad version number 0x0 on inode INO
-inode identifier 0 mismatch on inode INO
-bad magic number 0x0 on inode INO, resetting magic number
-bad version number 0x0 on inode INO, resetting version number
-inode identifier 0 mismatch on inode INO
-cleared realtime summary inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime summary inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-Corrupting root inode - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0xffff on inode INO
-bad version number 0xffffffff on inode INO
-inode identifier 18446744073709551615 mismatch on inode INO
-bad magic number 0xffff on inode INO, resetting magic number
-bad version number 0xffffffff on inode INO, resetting version number
-inode identifier 18446744073709551615 mismatch on inode INO
-cleared root inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-root inode lost
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing root directory
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
-done
-Corrupting rt bitmap inode - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0xffff on inode INO
-bad version number 0xffffffff on inode INO
-inode identifier 18446744073709551615 mismatch on inode INO
-bad magic number 0xffff on inode INO, resetting magic number
-bad version number 0xffffffff on inode INO, resetting version number
-inode identifier 18446744073709551615 mismatch on inode INO
-cleared realtime bitmap inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime bitmap inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
-Corrupting rt summary inode - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-bad magic number 0xffff on inode INO
-bad version number 0xffffffff on inode INO
-inode identifier 18446744073709551615 mismatch on inode INO
-bad magic number 0xffff on inode INO, resetting magic number
-bad version number 0xffffffff on inode INO, resetting version number
-inode identifier 18446744073709551615 mismatch on inode INO
-cleared realtime summary inode INO
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-reinitializing realtime summary inode
-        - resetting contents of realtime bitmap and summary inodes
-        - traversing filesystem ...
-        - traversal finished ...
-        - moving disconnected inodes to lost+found ...
-Phase 7 - verify and correct link counts...
-done
diff --git a/tests/xfs/033.out.crc.linux b/tests/xfs/033.out.crc.linux
new file mode 100644
index 000000000000..a6e86b9c8a28
--- /dev/null
+++ b/tests/xfs/033.out.crc.linux
@@ -0,0 +1,197 @@
+QA output created by 033
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
+Corrupting root inode - setting bits to 0
+Wrote X.XXKb (value 0x0)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0x0 on inode INO
+bad version number 0x0 on inode INO
+inode identifier 0 mismatch on inode INO
+bad magic number 0x0 on inode INO, resetting magic number
+bad version number 0x0 on inode INO, resetting version number
+inode identifier 0 mismatch on inode INO
+cleared root inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+root inode lost
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing root directory
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 1 to 2
+done
+Corrupting rt bitmap inode - setting bits to 0
+Wrote X.XXKb (value 0x0)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0x0 on inode INO
+bad version number 0x0 on inode INO
+inode identifier 0 mismatch on inode INO
+bad magic number 0x0 on inode INO, resetting magic number
+bad version number 0x0 on inode INO, resetting version number
+inode identifier 0 mismatch on inode INO
+cleared realtime bitmap inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime bitmap inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+Corrupting rt summary inode - setting bits to 0
+Wrote X.XXKb (value 0x0)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0x0 on inode INO
+bad version number 0x0 on inode INO
+inode identifier 0 mismatch on inode INO
+bad magic number 0x0 on inode INO, resetting magic number
+bad version number 0x0 on inode INO, resetting version number
+inode identifier 0 mismatch on inode INO
+cleared realtime summary inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime summary inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+Corrupting root inode - setting bits to -1
+Wrote X.XXKb (value 0xffffffff)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0xffff on inode INO
+bad version number 0xffffffff on inode INO
+inode identifier 18446744073709551615 mismatch on inode INO
+bad magic number 0xffff on inode INO, resetting magic number
+bad version number 0xffffffff on inode INO, resetting version number
+inode identifier 18446744073709551615 mismatch on inode INO
+cleared root inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+root inode lost
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing root directory
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+resetting inode INO nlinks from 1 to 2
+done
+Corrupting rt bitmap inode - setting bits to -1
+Wrote X.XXKb (value 0xffffffff)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0xffff on inode INO
+bad version number 0xffffffff on inode INO
+inode identifier 18446744073709551615 mismatch on inode INO
+bad magic number 0xffff on inode INO, resetting magic number
+bad version number 0xffffffff on inode INO, resetting version number
+inode identifier 18446744073709551615 mismatch on inode INO
+cleared realtime bitmap inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime bitmap inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
+Corrupting rt summary inode - setting bits to -1
+Wrote X.XXKb (value 0xffffffff)
+Phase 1 - find and verify superblock...
+Phase 2 - using <TYPEOF> log
+        - zero log...
+        - scan filesystem freespace and inode maps...
+        - found root inode chunk
+Phase 3 - for each AG...
+        - scan and clear agi unlinked lists...
+        - process known inodes and perform inode discovery...
+bad magic number 0xffff on inode INO
+bad version number 0xffffffff on inode INO
+inode identifier 18446744073709551615 mismatch on inode INO
+bad magic number 0xffff on inode INO, resetting magic number
+bad version number 0xffffffff on inode INO, resetting version number
+inode identifier 18446744073709551615 mismatch on inode INO
+cleared realtime summary inode INO
+        - process newly discovered inodes...
+Phase 4 - check for duplicate blocks...
+        - setting up duplicate extent list...
+        - check for inodes claiming duplicate blocks...
+Phase 5 - rebuild AG headers and trees...
+        - reset superblock...
+Phase 6 - check inode connectivity...
+reinitializing realtime summary inode
+        - resetting contents of realtime bitmap and summary inodes
+        - traversing filesystem ...
+        - traversal finished ...
+        - moving disconnected inodes to lost+found ...
+Phase 7 - verify and correct link counts...
+done
diff --git a/tests/xfs/035 b/tests/xfs/035
index 70eac93eff29..25f2f6972f9a 100755
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/035.cfg b/tests/xfs/035.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/035.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/036 b/tests/xfs/036
index 32b8c87c175f..280d03665ba9 100755
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/036.cfg b/tests/xfs/036.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/036.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/039 b/tests/xfs/039
index 974792300e8b..2f765b825b9d 100755
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/039.cfg b/tests/xfs/039.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/039.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/043 b/tests/xfs/043
index 55a52257a7d8..59eeff6e7777 100755
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -39,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/043.cfg b/tests/xfs/043.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/043.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/055 b/tests/xfs/055
index cc747d3018a1..920ba2886cc0 100755
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -37,7 +37,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/dump
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 # real QA test starts here
 _supported_fs xfs
diff --git a/tests/xfs/082 b/tests/xfs/082
index fff1d6b48dc2..f1178fdc9311 100755
--- a/tests/xfs/082
+++ b/tests/xfs/082
@@ -55,7 +55,7 @@ _require_scratch
 _require_v2log 
 
 # link correct .out file
-_link_out_file $seq.op $seqfull.op
+_link_out_file_named $seqfull.op $(_get_os_name)
 
 echo "*** init FS"
 umount $SCRATCH_DEV >/dev/null 2>&1
diff --git a/tests/xfs/082.cfg b/tests/xfs/082.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/082.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
diff --git a/tests/xfs/146 b/tests/xfs/146
index c6343f86f73a..f6cd3f30215a 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -48,7 +48,7 @@ _supported_fs xfs
 _supported_os Linux IRIX
 
 # link correct .out file
-_link_out_file $seq.out $seqfull.out
+_link_out_file
 
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
diff --git a/tests/xfs/146.cfg b/tests/xfs/146.cfg
new file mode 100644
index 000000000000..7ffdfc078230
--- /dev/null
+++ b/tests/xfs/146.cfg
@@ -0,0 +1,2 @@
+irix: irix
+linux: linux
-- 
2.1.4

