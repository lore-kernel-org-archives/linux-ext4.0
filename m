From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] tests: add new test to validate errno handling in the journal superblock
Date: Thu, 31 May 2012 20:14:57 -0400
Message-ID: <1338509698-24349-3-git-send-email-tytso@mit.edu>
References: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46855 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758723Ab2FAAPF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 20:15:05 -0400
In-Reply-To: <1338509698-24349-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a new regression test f_jnl_errno

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/f_jnl_errno/expect.0 |  48 +++++++++++++++++++++++++++++++++++++++++++++
 tests/f_jnl_errno/expect.1 |   9 +++++++++
 tests/f_jnl_errno/expect.2 |   7 +++++++
 tests/f_jnl_errno/image.gz | Bin 0 -> 8822 bytes
 tests/f_jnl_errno/name     |   1 +
 tests/f_jnl_errno/script   |   4 ++++
 6 files changed, 69 insertions(+)
 create mode 100644 tests/f_jnl_errno/expect.0
 create mode 100644 tests/f_jnl_errno/expect.1
 create mode 100644 tests/f_jnl_errno/expect.2
 create mode 100644 tests/f_jnl_errno/image.gz
 create mode 100644 tests/f_jnl_errno/name
 create mode 100644 tests/f_jnl_errno/script

diff --git a/tests/f_jnl_errno/expect.0 b/tests/f_jnl_errno/expect.0
new file mode 100644
index 0000000..7dae17d
--- /dev/null
+++ b/tests/f_jnl_errno/expect.0
@@ -0,0 +1,48 @@
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
+Default mount options:    user_xattr acl
+Filesystem state:         clean
+Errors behavior:          Remount read-only
+Filesystem OS type:       Linux
+Inode count:              2048
+Block count:              8192
+Reserved block count:     409
+Free blocks:              6862
+Free inodes:              2037
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      31
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Flex block group size:    16
+Mount count:              0
+Check interval:           0 (<none>)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          128
+Journal inode:            8
+Default directory hash:   half_md4
+Journal backup:           inode blocks
+Journal features:         (none)
+Journal size:             1024k
+Journal length:           1024
+Journal sequence:         0x00000005
+Journal start:            0
+
+
+Group 0: (Blocks 1-8191) [ITABLE_ZEROED]
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-33
+  Block bitmap at 34 (+33), Inode bitmap at 50 (+49)
+  Inode table at 66-321 (+65)
+  6862 free blocks, 2037 free inodes, 2 directories, 2037 unused inodes
+  Free blocks: 1330-8191
+  Free inodes: 12-2048
diff --git a/tests/f_jnl_errno/expect.1 b/tests/f_jnl_errno/expect.1
new file mode 100644
index 0000000..c572951
--- /dev/null
+++ b/tests/f_jnl_errno/expect.1
@@ -0,0 +1,9 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/2048 files (9.1% non-contiguous), 1330/8192 blocks
+Exit status is 1
diff --git a/tests/f_jnl_errno/expect.2 b/tests/f_jnl_errno/expect.2
new file mode 100644
index 0000000..db16a75
--- /dev/null
+++ b/tests/f_jnl_errno/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/2048 files (9.1% non-contiguous), 1330/8192 blocks
+Exit status is 0
diff --git a/tests/f_jnl_errno/image.gz b/tests/f_jnl_errno/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c55c775d165fe024592a33fe52e873fbab599459
GIT binary patch
literal 8822
zc-oWi=HNK_<+wi+b7pR0dMd-4JN7x!p)%|ro?Ejo_f+6q8gOWS+a=zWT~RAq4mr%_
zG)zf&`HVGqp-_;e-&MDcUC~ws&NFT#IC%7=ehNxmxvMlWEx}P%%Ae<1`He7Hp;aDB
zJyzPwzkF>y|NhUPw)fwcY<l9&DG~X2;?F7Dyfp95^<Ek5xzgm%uNwP{?|#pH`&3@(
z>6N#2CHDT2IdPrOo0m2JRa0JjqIzPM$u6<e+;5A`qoc2Wd$u=v`}>?VA@k29_`R{-
z(->bL_vh30`F0i0ci-H2^xd&``)QAu{lCU*A2a-@;Qw^tx1&GAew}`K;^v7Qm9}})
zyncVR-<*EB?rfKx+3|n1BChrE{AaTl-u&_9(b1~K*Ve2z&Hn0^yme#s{P?~lUvlf`
zYyUj__Ur1i+q0)%pS^YK*VA9y4$r;o=XOq{bXM1|_aU1Wa=i#y7jNXufFJZUy;~UY
z$@O6U`l&|`hiIiPPrey_e$(ZTDMr`o&#P}bA9j6Ke(k1R|9&1<<DO?W`TvUlbN7V*
zKhU8un<?Ob!!PzL_6z<oe&t_L@9>xTl{{F8uld`f-S=&5n5VF>J}Uq2Sl86N?Z2NF
z{6-I{-?@#4qyM||rvL4kEh@o#_f$u}yxWbFD;kX_K63i^E@t^8-oFwTR>tgq!o%tR
z_v`-$xBfd!+g`rUV%wL{vu_xYeQ{v&)=iuD+MM`*^S%7@%lEg-+`3(V@4s`>`!W?_
zey`nm!C`kcJn@Z}?q6A|EGKsA>E7e<ntT7xcps}PyWzjd<ZrL{m%rfe`(JbYWBiq4
zPW6_umeMnO@0<^gDso@PoIU@&?~{8!&tLlJKBs<}(sCbph7k;u75b+rCr?aQntGz*
ziARc(k>t!S8|g|tBiWgqXWZuX%k=IMuoSB_{1o)0;>pt!F;AwRSUvH&(t3A4muJfP
zGpZOy!6+C7qhJ(_f>AIEM!_f;1*2dTjDk@x3P!;w7zLwX6pVsVFbYP&C>RB!U=)l3
gJfLC!t!8H?5X<p@y!BxwBDEdRVimcV2h`300FAMMcmMzZ

literal 0
Hc-jL100001

diff --git a/tests/f_jnl_errno/name b/tests/f_jnl_errno/name
new file mode 100644
index 0000000..e5f64d6
--- /dev/null
+++ b/tests/f_jnl_errno/name
@@ -0,0 +1 @@
+journal s_errno handling
diff --git a/tests/f_jnl_errno/script b/tests/f_jnl_errno/script
new file mode 100644
index 0000000..dd1ffd6
--- /dev/null
+++ b/tests/f_jnl_errno/script
@@ -0,0 +1,4 @@
+AFTER_CMD='$DUMPE2FS $TMPFILE 2>&1 | sed -f $cmd_dir/filter_dumpe2fs > $test_name.0.log'
+PASS_ZERO=true
+
+. $cmd_dir/run_e2fsck
-- 
1.7.10.2.552.gaa3bb87

