From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] mke2fs: further updates for mke2fs(8) man page
Date: Tue, 17 Dec 2013 01:17:51 -0700
Message-ID: <1387268271-8285-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.br.shawcable.net ([64.59.134.9]:49347 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3LQIRx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 03:17:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The mke2fs(8) man page was updated in 4727c67dc2, but needs some
more clear descriptions for extra_isize and metadta_csum features.
The uninit_bg feature is supported by all ext4-capable kernels,
and does have a slow e2fsck pass for newly-formatted filesystems,
so remove the caveat.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 misc/mke2fs.8.in |   36 ++++++++++++++++++++++--------------
 1 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index df244de..4486014 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -210,8 +210,8 @@ in earlier versions of
 .BR mke2fs .
 The
 .B \-R
-option is still accepted for backwards compatibility.   The
-following extended options are supported:
+option is still accepted for backwards compatibility, but is deprecated.
+The following extended options are supported:
 .RS 1.2i
 .TP
 .BI mmp_update_interval= interval
@@ -548,7 +548,7 @@ of e2fsprogs will not support file systems with this feature enabled.
 .TP
 .B bigalloc
 .br
-This feature enables clustered allocation, so that the unit of
+This feature enables clustered block allocation, so that the unit of
 allocation is a power of two number of blocks.  That is, each bit in the
 what had traditionally been known as the block allocation bitmap now
 indicates whether a cluster is in use or not, where a cluster is by
@@ -570,7 +570,7 @@ features be enabled.
 .TP
 .B dir_index
 .br
-Use hashed b-trees to speed up lookups in large directories.
+Use hashed b-trees to speed up name lookups in large directories.
 .TP
 .B dir_nlink
 .br
@@ -590,8 +590,15 @@ historical/backwards compatibility reasons.)
 .TP
 .B extra_isize
 .br
-This feature enables storage of nanosecond timestamps and creation
-time, if the inode size is larger than 256 bytes or larger.
+This feature reserves a specific amount of space in each inode for
+extended metadata such as nanosecond timestamps and file creation time,
+even if the current kernel does not current need to reserve this much
+space.  Without this feature, the kernel will reserve the amount of
+space for features currently it currently needs, and the rest may be
+consumed by extended attributes.
+
+For this feature to be useful the inode size must be 256 bytes in size
+or larger.
 .TP
 .B ext_attr
 .br
@@ -649,10 +656,16 @@ set this feature automatically when a file > 2GiB is created.)
 .\" .TP
 .\" .B metadata_csum
 .\" .br
-.\" Filesystem supports metadata checksumming.  This feature enables a
-.\" superset of the functionality of the
+.\" Filesystem supports metadata checksumming.  This feature stores
+.\" checksums for all of the filesystem metadata (superblock, group
+.\" descriptor blocks, inode and block bitmaps, directories, and
+.\" extent tree blocks).  The checksum algorithm used for the metadata
+.\" blocks is different than the one used for group descriptors with the
 .\" .B uninit_bg
-.\" feature.
+.\" feature, these two features are incompatible and
+.\" .B metadata_csum
+.\" will be used preferentially instead of
+.\" .BR uninit_bg .
 .\" .br
 .\" .B Future feature, available in e2fsprogs 1.43-WIP
 .TP
@@ -719,11 +732,6 @@ and keep a high watermark for the unused inodes in a filesystem, to reduce
 .BR e2fsck (8)
 time.  The result is that it can speed up filesystem creation time noticeably
 (if lazy_itable_init is enabled).
-.IP
-This first e2fsck run after enabling this feature will take the
-full time, but subsequent e2fsck runs will take only a fraction of the
-original time, depending on how full the file system is.
-It is only supported by the ext4 filesystem in recent Linux kernels.
 .RE
 .TP
 .B \-q
-- 
1.7.3.4

