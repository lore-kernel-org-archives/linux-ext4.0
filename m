From: Uri Corin <uri.corin@gmail.com>
Subject: [PATCH] e2fsprogs: dumpe2fs manpage updates
Date: Tue, 17 Dec 2013 16:49:49 +0200
Message-ID: <CAO+X6Oiq5PLxjcGkjNi=D3qr=hB_zaCkgQfNcNjBQJaVjsNKBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:53725 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3LQOtw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Dec 2013 09:49:52 -0500
Received: by mail-qc0-f178.google.com with SMTP id i17so4946291qcy.37
        for <linux-ext4@vger.kernel.org>; Tue, 17 Dec 2013 06:49:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added documentation for all defined features, including legacy
and work in progress.
* Some pre-existing feature explanations have been expanded based on
ext4.wiki.kernel.org.
* Future features (dirdata, ea_inode and metadata_csum) are commented out

Regards,
Uri Corin
uri.corin@gmail.com
---

diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
index a493789..2cae930 100644
--- a/misc/dumpe2fs.8.in
+++ b/misc/dumpe2fs.8.in
@@ -68,7 +68,224 @@ print the detailed group information block numbers
in hexadecimal format
 print the version number of
 .B dumpe2fs
 and exit.
-.SH BUGS
+.SH Features
+Filesystem features as marked by
+.B dumpe2fs.
+.PP
+.TP
+.B 64bit
+.br
+Enables the file system to be larger than 2^32 blocks.  This feature may be set
+automatically, as needed.
+.TP
+.B bigalloc
+.br
+This feature enables clustered allocation, so that the unit of
+allocation is a power of two number of blocks.  That is, each bit in the
+what had traditionally been known as the block allocation bitmap now
+indicates whether a cluster is in use or not, where a cluster is by
+default composed of 16 blocks.  This feature can decrease the time
+spent on doing block allocation and brings smaller fragmentation, especially
+for large files.
+.TP
+.B compression
+.br
+Legacy feature, not settable by
+.BR mke2fs (8)
+and
+.BR tune2fs (8)
+.\" .TP
+.\" .B dirdata
+.\" .br
+.\" Data in directory entry.
+.\" .br
+.\" Not implemented.
+.TP
+.B dir_index
+.br
+Filesystem Uses hashed b-trees to speed up lookups in large directories.
+.TP
+.B dir_nlink
+.br
+Allows more than 65000 subdirectories per directory.
+.TP
+.B dir_prealloc
+.br
+Block pre-allocation for new directories is enabled.
+.\" .TP
+.\" .B ea_inode
+.\" .br
+.\" Inodes can be used for large extended attributes.
+.\" .br
+.\" Not implemented.
+.TP
+.B extent
+.br
+Instead of using the indirect block scheme for storing the location of
+data blocks in an inode, use extents instead.  This is a much more
+efficient encoding which speeds up filesystem access, especially for
+large files.  (Note: both
+.B extent
+and
+.B extents
+are accepted as valid names for this feature for
+historical/backwards compatibility reasons.)
+.TP
+.B extra_isize
+.br
+This feature enables storage of nanosecond timestamps and creation
+time, if the inode size is larger than 256 bytes or larger.
+.TP
+.B ext_attr
+.br
+This feature enables the use of extended attributes.
+.TP
+.B filetype
+.br
+This feature enables the storage file type information in directory
+entries.  It is normally enabled by default for all file system types.
+.TP
+.B flex_bg
+.br
+Allow the per-block group metadata (allocation bitmaps and inode tables)
+to be placed anywhere on the storage media.  In addition,
+.B mke2fs
+will place the per-block group metadata together starting at the first
+block group of each "flex_bg group".   The size of the flex_bg group
+.TP
+.B inline_data
+.br
+Allows small files or directories to be stored within the in-inode
extended attribute area.
+.TP
+.B has_journal
+.br
+Uses a journal to ensure filesystem consistency even across unclean shutdowns.
+.TP
+.B huge_file
+.br
+Allows files larger than 2TiB in size.
+.TP
+.B imagic_inodes
+.br
+Legacy feature, not settable by
+.BR mke2fs (8)
+and
+.BR tune2fs (8)
+.TP
+.B journal_dev
+.br
+This is a journal device
+(see journal-options in
+.BR tune2fs (8)
+or
+.BR mke2fs (8)).
+.TP
+.B large_dir
+Supports large directory >2GiB or 3-level htree.
+.TP
+.B large_file
+.br
+Filesystem can contain files that are greater than 2GiB.  (Modern kernels
+set this feature automatically when a file > 2GiB is created.)
+.TP
+.B lazy_bg
+.br
+Legacy parameter for testing purposes, no longer supported by kernel.
+.br
+Allows an ext2/ext3 developer to create very large filesystems using
sparse files where most of the block groups are not initialized and so
do not require much disk space.
+.TP
+.B meta_bg
+.br
+This feature allows file systems to be resized on-line without explicitly
+needing to reserve space for growth in the size of the block group
+descriptors.  This scheme is also used to resize file systems which are
+larger than 2^32 blocks.  It is not recommended that this feature be set
+when a file system is created, since this alternate method of storing
+the block group descriptor will slow down the time needed to mount the
+file system, and newer kernels can automatically set this feature as
+necessary when doing an online resize and no more reserved space is
+available in the resize inode.
+.\" .TP
+.\" .B metadata_csum
+.\" .br
+.\" Filesystem supports metadata checksumming.  This feature enables a
+.\" superset of the functionality of the
+.\" .B uninit_bg
+.\" feature.
+.\" .br
+.\" .B Future feature, available in e2fsprogs 1.43-WIP
+.TP
+.B mmp
+.br
+Multiple mount protection (MMP) helps to protect the filesystem from
being multiply mounted and is useful in shared storage environments.
+.TP
+.B needs_recovery
+.br
+This flag is set by the kernel to indicate either a mounted filesystem with
+.B has_journal
+is write enabled or, an unmounted filesystem is in an unclean state.
+@QUOTA_MAN_COMMENT@.TP
+@QUOTA_MAN_COMMENT@.B quota
+@QUOTA_MAN_COMMENT@.br
+@QUOTA_MAN_COMMENT@Create quota inodes (inode #3 for userquota and inode
+@QUOTA_MAN_COMMENT@#4 for group quota) and set them in the superblock.
+@QUOTA_MAN_COMMENT@With this feature, the quotas will be enabled
+@QUOTA_MAN_COMMENT@automatically when the filesystem is mounted.
+@QUOTA_MAN_COMMENT@.IP
+@QUOTA_MAN_COMMENT@Causes the quota files (i.e., user.quota and
+@QUOTA_MAN_COMMENT@group.quota which existed
+@QUOTA_MAN_COMMENT@in the older quota design) to be hidden inodes.
+@QUOTA_MAN_COMMENT@.IP
+@QUOTA_MAN_COMMENT@.B Not defined by default,
+@QUOTA_MAN_COMMENT@see https://ext4.wiki.kernel.org/index.php/Quota
+.TP
+.B replica
+.br
+Non-upstream feature.
+.TP
+.B resize_inode
+.br
+Reserves space so the block group descriptor table may grow in the future.
+Useful for online resizing using
+.BR resize2fs .
+.TP
+.B snapshot_bitmap
+.br
+Legacy parameter, no longer supported by kernel.
+.TP
+
+.B sparse_super
+.br
+Filesystem has fewer superblock backup copies
+(saves space on large filesystems).  This feature is normally enabled by
+default for all file systems.
+.TP
+.B uninit_bg
+.br
+Not all of the block groups are initialized.
+This feature allows the kernel to initialize bitmaps and inode tables
+and keep a high watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.  The result is that it can speed up filesystem creation time noticeably
+(if lazy_itable_init is enabled).
+.IP
+This first e2fsck run after enabling this feature will take the
+full time, but subsequent e2fsck runs will take only a fraction of the
+original time, depending on how full the file system is.
+It is only supported by the ext4 filesystem in recent Linux kernels.
+.B sparse_super
+.br
+Limits the number of backup superblocks to save space on large filesystems.
+.TP
+.B uninit_bg, uninit_groups
+.br
+Allows the kernel to initialize bitmaps and inode tables and keep a high
+watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.
+.br
+The first e2fsck run after enabling this feature will take the full
time, but subsequent e2fsck runs will take only a fraction of the
original time, depending on how full the file system is.
+SH BUGS
 You need to know the physical filesystem structure to understand the
 output.
 .SH AUTHOR
