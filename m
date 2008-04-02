From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH][TRIVIAL][e2fsprogs] Rename uninit_groups to uninit_bg.
Date: Wed, 02 Apr 2008 09:03:14 -0500
Message-ID: <20080402140221.30632.62083.stgit@gara.konoha.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44998 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYDBODW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2008 10:03:22 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m32E3LBb018503
	for <linux-ext4@vger.kernel.org>; Wed, 2 Apr 2008 10:03:21 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m32E3LRR237694
	for <linux-ext4@vger.kernel.org>; Wed, 2 Apr 2008 10:03:21 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m32E3KF9009178
	for <linux-ext4@vger.kernel.org>; Wed, 2 Apr 2008 10:03:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Rename uninit_groups to uninit_bg.

<meta_bg> <flex_bg> <uninit_groups> <lazy_bg>

One of these things is not like the others,
One of these things just doesn't belong,
Can you tell which thing is not like the others
By the time I finish my song?
       	    by Joe Raposo

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 e2fsck/unix.c     |    2 +-
 lib/e2p/feature.c |    2 +-
 misc/mke2fs.8.in  |    2 +-
 misc/tune2fs.8.in |    4 ++--
 resize/main.c     |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 7b662e4..a868d87 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -559,7 +559,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		       "is set off by an equals ('=') sign.  "
 			"Valid extended options are:\n"
 			"\tea_ver=<ea_version (1 or 2)>\n"
-			"\tuninit_groups\n"
+			"\tuninit_bg\n"
 			"\tinit_groups\n\n"), stderr);
 		exit(1);
 	}
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index cf37447..3fc4f91 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -45,7 +45,7 @@ static struct feature feature_list[] = {
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HUGE_FILE,
 			"huge_file" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
-			"uninit_groups" },
+			"uninit_bg" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_DIR_NLINK,
 			"dir_nlink" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE,
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 9cc3895..7eebe40 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -443,7 +443,7 @@ to create a large virtual block group).
 .B has_journal
 Create an ext3 journal (as if using the
 .TP
-.B uninit_groups
+.B uninit_bg
 Create a filesystem without initializing all of the groups.  This speeds
 up filesystem creation time noticably, and can also reduce
 .BR e2fsck time
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index b5af4d0..3215808 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -440,7 +440,7 @@ future.
 .B Tune2fs 
 only supports clearing this filesystem feature.
 .TP
-.B uninit_groups
+.B uninit_bg
 Allow the kernel to initialize bitmaps and inode tables and keep a high
 watermark for the unused inodes in a filesystem, to reduce
 .BR e2fsck (8)
@@ -449,7 +449,7 @@ time.
 .IP
 After setting or clearing 
 .BR sparse_super ,
-.BR uninit_groups ,
+.BR uninit_bg ,
 .BR filetype ,
 or
 .B resize_inode
diff --git a/resize/main.c b/resize/main.c
index 2e5c89c..8b90e96 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -309,7 +309,7 @@ int main (int argc, char ** argv)
 
 	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
 		com_err(program_name, EXT2_ET_RO_UNSUPP_FEATURE,
-			":- uninit_groups");
+			":- uninit_bg");
 		exit(1);
 	}
 

