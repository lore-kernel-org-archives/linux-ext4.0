From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] Improve ext4 feature descriptions in mke2fs and tune2fs man pages
Date: Mon, 31 Mar 2008 19:36:22 -0400
Message-ID: <1207006592-13980-1-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61503 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbYCaXjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:24 -0400
In-Reply-To: <20080325084039.GA10804@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/mke2fs.8.in  |   14 +++++++-------
 misc/tune2fs.8.in |   10 +++++++++-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 390874c..6cd10b1 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -427,13 +427,6 @@ Store file type information in directory entries.
 .TP
 .B has_journal
 Create an ext3 journal (as if using the
-.TP
-.B uninit_groups
-Create a filesystem without initializing all of the groups.  This speeds
-up filesystem creation time noticably, and can also reduce
-.BR e2fsck time
-dramatically.  This feature causes the filesystem to be read-only in
-older kernels is not supported in most Linux kernels, use with caution.
 .B \-j
 option).
 @JDEV@.TP
@@ -445,6 +438,13 @@ option).
 @JDEV@must be created with the same
 @JDEV@block size as the filesystems that will be using it.
 .TP
+.B uninit_groups
+Create a filesystem without initializing all of the groups.  This speeds
+up filesystem creation time noticably, and can also reduce
+.BR e2fsck time
+dramatically.  This feature is only supported by the ext4 filesystem in
+recent Linux kernels.
+.TP
 .B resize_inode
 Reserve space so the block group descriptor table may grow in the future.
 Useful for online resizing using 
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 69da5de..66d9d52 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -444,7 +444,9 @@ only supports clearing this filesystem feature.
 Allow the kernel to initialize bitmaps and inode tables and keep a high
 watermark for the unused inodes in a filesystem, to reduce
 .BR e2fsck (8)
-time.
+time.  This first e2fsck run after enabling this feature will take the
+full time, but subsequent e2fsck runs will take only a fraction of the
+original time, depending on how full the file system is.
 .RE
 .IP
 After setting or clearing 
@@ -464,6 +466,12 @@ if necessary.  After setting the
 feature, 
 .B e2fsck -D
 can be run to convert existing directories to the hashed B-tree format.
+Enabling certain filesystem features may prevent the filesystem from being
+mounted by kernels which do not support those features.  In particular the
+.BR uninit_groups
+and
+.BR flex_bg
+features are only supported by the ext4 filesystem.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
-- 
1.5.4.1.144.gdfee-dirty

