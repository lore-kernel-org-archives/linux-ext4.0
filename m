From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] tests: add f_first_meta_bg_too_big test
Date: Sat,  9 Aug 2014 13:10:19 -0400
Message-ID: <1407604220-2620-5-git-send-email-tytso@mit.edu>
References: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Cc: antymat+debian@chelmska.waw.pl, 756922@bugs.debian.org,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52423 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbaHIRK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 13:10:27 -0400
In-Reply-To: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The test verifies that e2fsck can properly fix a file system where the
value of s_first_meta_bg in the superblock is larger than the number
of block group descriptors in the file system.  E2fsck will fix this
by clearing the meta_bg feature.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/f_first_meta_bg_too_big/expect.1 |  20 ++++++++++++++++++++
 tests/f_first_meta_bg_too_big/expect.2 |   7 +++++++
 tests/f_first_meta_bg_too_big/image.gz | Bin 0 -> 533 bytes
 tests/f_first_meta_bg_too_big/name     |   1 +
 4 files changed, 28 insertions(+)
 create mode 100644 tests/f_first_meta_bg_too_big/expect.1
 create mode 100644 tests/f_first_meta_bg_too_big/expect.2
 create mode 100644 tests/f_first_meta_bg_too_big/image.gz
 create mode 100644 tests/f_first_meta_bg_too_big/name

diff --git a/tests/f_first_meta_bg_too_big/expect.1 b/tests/f_first_meta_bg_too_big/expect.1
new file mode 100644
index 0000000..85786bd
--- /dev/null
+++ b/tests/f_first_meta_bg_too_big/expect.1
@@ -0,0 +1,20 @@
+First_meta_bg is too big.  (2, max value 1).  Clear? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -3
+Fix? yes
+
+Free blocks count wrong for group #0 (79, counted=80).
+Fix? yes
+
+Free blocks count wrong (79, counted=80).
+Fix? yes
+
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/16 files (0.0% non-contiguous), 20/100 blocks
+Exit status is 1
diff --git a/tests/f_first_meta_bg_too_big/expect.2 b/tests/f_first_meta_bg_too_big/expect.2
new file mode 100644
index 0000000..44bff62
--- /dev/null
+++ b/tests/f_first_meta_bg_too_big/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16 files (0.0% non-contiguous), 20/100 blocks
+Exit status is 0
diff --git a/tests/f_first_meta_bg_too_big/image.gz b/tests/f_first_meta_bg_too_big/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..527937040de93a57428e73c8aee9181212b5efc4
GIT binary patch
literal 533
zc-oWi=HNKx`z)A=IWspgJ(c0@-Tm3Zfiesq%BLTb_idY2_ClrAs>5kT^Xe-*MGpFu
z3A8^_NNQiD!NJBV{_;V}+`q;xmyW9L_#wVSR6H=?qU*WozZt7~tu&-2ooC<ov*_gR
z??uyp@AGEb*}~wnYNmv=;Vi>*(=C7QJD4PB{4}XPcfYjLw9@;kmAjL62CTi_b+Nlp
z=~$~ti?yNst95qu-%_4_KHPnL+xfWI|G(_Fea+jp`|rz-r~X{N`Bj`hE;dTa=6+ev
zmTj{2!A4K^t&~WYsp@GsxY0uXaYfw!vwOs}&ThE6y*=U2T)pD_@1^s~^XAr6{=avy
z?DW<-f0o@3Tl;_2{i8*5Za*!WT7T{T?@fQ7#!Y;l)gS)%{nWRwrk#p8o4+|Y@x_l)
z$)2r?6BpWC+kZpSAn?*3<AO<Lr;3xUmt-yvp0oYF$+FAYv!l)ZVsGxLtUX+<B4NHZ
z>Ti9H$X9-!3)34Kez9M%U+|CdEB}gmhri6P<OBYLg%}tNiZ&gtW9FTFiid*%1uR~^
zf7|`FkK+4&e~US>-oC8hkK4ccBZ@L7^OxJJ*vBl>>Ad)56JvcszQKPT{@L}HHhk#*
axm@<~guCnvlz^Uv`G<RLRx?asWB>r>%kgsn

literal 0
Hc-jL100001

diff --git a/tests/f_first_meta_bg_too_big/name b/tests/f_first_meta_bg_too_big/name
new file mode 100644
index 0000000..47ec96d
--- /dev/null
+++ b/tests/f_first_meta_bg_too_big/name
@@ -0,0 +1 @@
+s_first_meta_bg is too large
-- 
2.0.0

