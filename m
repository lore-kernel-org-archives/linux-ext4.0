From: Uri Corin <uri.corin@gmail.com>
Subject: [PATCH] e2fsprogs: mke2fs manpage updates
Date: Mon, 9 Dec 2013 21:10:21 +0200
Message-ID: <CAO+X6OgDR91sa8eN9EqUFbyFeHDM4NcaYe3KDa19-KmJAC5P4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:41843 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761399Ab3LITKY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Dec 2013 14:10:24 -0500
Received: by mail-vc0-f170.google.com with SMTP id la4so701642vcb.29
        for <linux-ext4@vger.kernel.org>; Mon, 09 Dec 2013 11:10:22 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've added documentation for all available filesystem features
settable by mke2fs.
* Features now include the kernel constant attached to the function.
* Some pre-existing feature explanations have been expanded based on
ext4.wiki.kernel.org.

Regards,
Uri Corin
uri.corin@gmail.com

---

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 7b89296..dc76936 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -532,11 +532,24 @@ section of the configuration file.
 .sp
 The filesystem feature set is comprised of a list of features, separated
 by commas, that are to be enabled.  To disable a feature, simply
-prefix the feature name with a  caret ('^') character.  The
-pseudo-filesystem feature "none" will clear all filesystem features.
+prefix the feature name with a  caret ('^') or a minus ('-') character.
+Features with dependents will not be removed successfully.
+The pseudo-filesystem feature "none" will clear all filesystem features.
 .RS 1.2i
 .TP
+.B 64bit
+.br
+Constant EXT4_FEATURE_INCOMPAT_64BIT.
+.br
+Enable a filesystem size of 2^64 blocks.
+.TP
 .B bigalloc
+.br
+Constant EXT4_FEATURE_RO_COMPAT_BIGALLOC.
+.br
+Requires
+.B extents
+.br
 This feature enables clustered allocation, so that the unit of
 allocation is a power of two number of blocks.  That is, each bit in the
 what had traditionally been known as the block allocation bitmap now
@@ -550,21 +563,53 @@ for large files.  The size can be specified using the
 The bigalloc feature is still under development, and may not be fully
 supported with your kernel or may have various bugs.  Please see the web
 page http://ext4.wiki.kernel.org/index.php/Bigalloc for details.
+May clash with delayed allocation (see
+.BR nodelalloc mount option).
 .TP
 .B dir_index
+.br
+Constant EXT2_FEATURE_COMPAT_DIR_INDEX.
+.br
 Use hashed b-trees to speed up lookups in large directories.
 .TP
-.B extents
+.B dir_nlink
+.br
+Constant EXT4_FEATURE_RO_COMPAT_DIR_NLINK.
+.br
+Allow more than 65000 subdirectories per directory.
+.TP
+.B extent, extents
+.br
+Constant EXT3_FEATURE_INCOMPAT_EXTENTS.
+.br
 Instead of using the indirect block scheme for storing the location of
 data blocks in an inode, use extents instead.  This is a much more
 efficient encoding which speeds up filesystem access, especially for
 large files.  (Note: both extent and extents are accepted for
 historical/backwards compatibility reasons.)
 .TP
+.B extra_isize
+.br
+Constant EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE.
+.br
+Nanosecond timestamps and creation time.
+.TP
+.B ext_attr
+.br
+Constant EXT2_FEATURE_COMPAT_EXT_ATTR.
+.br
+Extended attribute blocks.
+.TP
 .B filetype
+.br
+Constant EXT2_FEATURE_INCOMPAT_FILETYPE.
+.br
 Store file type information in directory entries.
 .TP
 .B flex_bg
+.br
+Constant EXT4_FEATURE_INCOMPAT_FLEX_BG.
+.br
 Allow the per-block group metadata (allocation bitmaps and inode tables)
 to be placed anywhere on the storage media.  In addition,
 .B mke2fs
@@ -575,28 +620,98 @@ can be specified using the
 option.
 .TP
 .B has_journal
-Create an ext3 journal (as if using the
+.br
+Constant EXT3_FEATURE_COMPAT_HAS_JOURNAL.
+.br
+Create a journal to ensure filesystem consistency even across unclean
shutdowns.
+Setting the filesystem feature is equivalent to using the
 .B \-j
-option).
-@JDEV@.TP
-@JDEV@.B journal_dev
-@JDEV@Create an external ext3 journal on the given device
+option.
+.TP
+.B huge_file
+.br
+Constant EXT4_FEATURE_RO_COMPAT_HUGE_FILE.
+.br
+Allows files larger than 2TiB in size.
+.TP
+.B journal_dev
+.br
+Constant EXT3_FEATURE_INCOMPAT_JOURNAL_DEV.
+.br
+Device is to be used as an external journal by other filesystems.
+.br
+@JDEV@Creates an external ext3 journal on the given device
 @JDEV@instead of a regular ext2 filesystem.
 @JDEV@Note that
 @JDEV@.I external-journal
 @JDEV@must be created with the same
 @JDEV@block size as the filesystems that will be using it.
+.br
+Once ready, use
+.BR mke2fs (8)
+or
+.BR tune2fs(8)
+with
+.B \-J
+.BR device= <external-device>
+to direct a filesystem to the journaling device (see journal-options).
 .TP
 .B large_file
-Filesystem can contain files that are greater than 2GB.  (Modern kernels
-set this feature automatically when a file > 2GB is created.)
-@QUOTA_MAN_COMMENT@.TP
-@QUOTA_MAN_COMMENT@.B quota
+.br
+Constant EXT2_FEATURE_RO_COMPAT_LARGE_FILE.
+.br
+Filesystem can contain files that are greater than 2GiB.  (Modern kernels
+set this feature automatically when a file > 2GiB is created.)
+.TP
+.B metadata_csum
+.br
+Constant EXT4_FEATURE_RO_COMPAT_METADATA_CSUM.
+.br
+Filesystem supports metadata checksumming.
+.br
+Implies
+.B uninit_bg
+though it must be omitted.
+.br
+.B Future feature, available in e2fsprogs 1.43-WIP
+.TP
+.B meta_bg
+.br
+Constant EXT2_FEATURE_INCOMPAT_META_BG.
+.br
+Reduced block group backups.
+.TP
+.B mmp
+.br
+Constant EXT4_FEATURE_INCOMPAT_MMP.
+.br
+Multiple mount protection (MMP) feature.  MMP helps to
+protect the filesystem from being multiply mounted and is useful in
+shared storage environments.
+.TP
+.B quota
+.br
+Constant EXT4_FEATURE_RO_COMPAT_QUOTA.
+.br
 @QUOTA_MAN_COMMENT@Create quota inodes (inode# 3 for userquota and
inode# 4 for group quota) and
 @QUOTA_MAN_COMMENT@set them in the superblock.  With this feature,
the quotas will be enabled
 @QUOTA_MAN_COMMENT@automatically when the filesystem is mounted.
+.br
+Causes the quota files (i.e., user.quota and group.quota which
existed in the older quota design) to be hidden inodes.
+.br
+.B Not defined by default,
+see https://ext4.wiki.kernel.org/index.php/Quota
 .TP
 .B resize_inode
+.br
+Constant EXT2_FEATURE_COMPAT_RESIZE_INODE
+.br
+Requires
+.B sparse_super
+.br
+Sets
+.B large_file
+.br
 Reserve space so the block group descriptor table may grow in the future.
 Useful for online resizing using
 .BR resize2fs .
@@ -609,18 +724,27 @@ using the
 extended option.
 .TP
 .B sparse_super
+.br
+Constant EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER.
+.br
 Create a filesystem with fewer superblock backup copies
 (saves space on large filesystems).
 .TP
-.B uninit_bg
-Create a filesystem without initializing all of the block groups.  This
-feature also enables checksums and highest-inode-used statistics in each
-blockgroup.  This feature can
-speed up filesystem creation time noticeably (if lazy_itable_init is
-enabled), and can also reduce
-.BR e2fsck
-time dramatically.  It is only supported by the ext4 filesystem in
-recent Linux kernels.
+.B uninit_bg, uninit_groups
+.br
+Constant EXT4_FEATURE_RO_COMPAT_GDT_CSUM.
+.br
+Create a filesystem without initializing all of the block groups.
+.br
+Allows the kernel to initialize bitmaps and inode tables and keep a high
+watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.  Can speed up filesystem creation time noticeably (if
lazy_itable_init is enabled).
+.br
+This first e2fsck run after enabling this feature will take the
+full time, but subsequent e2fsck runs will take only a fraction of the
+original time, depending on how full the file system is.
+It is only supported by the ext4 filesystem in recent Linux kernels.
 .RE
 .TP
 .B \-q
