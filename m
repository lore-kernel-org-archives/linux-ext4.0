From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: mke2fs manpage updates
Date: Mon, 16 Dec 2013 01:26:39 -0500
Message-ID: <20131216062639.GM28536@thunk.org>
References: <CAO+X6OgDR91sa8eN9EqUFbyFeHDM4NcaYe3KDa19-KmJAC5P4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Uri Corin <uri.corin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40409 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3LPG0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Dec 2013 01:26:42 -0500
Content-Disposition: inline
In-Reply-To: <CAO+X6OgDR91sa8eN9EqUFbyFeHDM4NcaYe3KDa19-KmJAC5P4Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 09, 2013 at 09:10:21PM +0200, Uri Corin wrote:
> Hi,
> 
> I've added documentation for all available filesystem features
> settable by mke2fs.
> * Features now include the kernel constant attached to the function.
> * Some pre-existing feature explanations have been expanded based on
> ext4.wiki.kernel.org.
> 
> Regards,
> Uri Corin
> uri.corin@gmail.com

Thanks, I made a number of changes to correct some technical and
stylistic nits before applying.

						- Ted

commit baf89923facf3fd24635d999ab047864e5a81ea7
Author: Uri Corin <uri.corin@gmail.com>
Date:   Mon Dec 16 00:53:35 2013 -0500

    e2fsprogs: mke2fs manpage updates
    
    I've added documentation for all available filesystem features
    settable by mke2fs.
    * Features now include the kernel constant attached to the function.
    * Some pre-existing feature explanations have been expanded based on
    ext4.wiki.kernel.org.
    
    [ Edited by tytso for stylistic and correctness. ]
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 7b89296..df244de 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -293,11 +293,11 @@ as default.
 Do not attempt to discard blocks at mkfs time.
 @QUOTA_MAN_COMMENT@.TP
 @QUOTA_MAN_COMMENT@.BI quotatype
-@QUOTA_MAN_COMMENT@Specify which quota type ('usr' or 'grp') is to be initialized. This
-@QUOTA_MAN_COMMENT@option has any effect only if
+@QUOTA_MAN_COMMENT@Specify which quota type ('usr' or 'grp') is to be
+@QUOTA_MAN_COMMENT@initialized. This option has effect only if
 @QUOTA_MAN_COMMENT@.B quota
-@QUOTA_MAN_COMMENT@feature is set. Without this extended option, the default behavior is to
-@QUOTA_MAN_COMMENT@initialize both user and group quotas.
+@QUOTA_MAN_COMMENT@feature is set. Without this extended option, the default
+@QUOTA_MAN_COMMENT@behavior is to initialize both user and group quotas.
 .RE
 .TP
 .BI \-f " fragment-size"
@@ -532,11 +532,22 @@ section of the configuration file.
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
+Enables the file system to be larger than 2^32 blocks.  This feature is set
+automatically, as needed, but it can be useful to specify this feature
+explicitly if the file system might need to be resized larger than 2^32
+blocks, even if it was smaller than that threshold when it was
+originally created.  Note that some older kernels and older versions
+of e2fsprogs will not support file systems with this feature enabled.
+.TP
 .B bigalloc
+.br
 This feature enables clustered allocation, so that the unit of
 allocation is a power of two number of blocks.  That is, each bit in the
 what had traditionally been known as the block allocation bitmap now
@@ -550,21 +561,49 @@ for large files.  The size can be specified using the
 The bigalloc feature is still under development, and may not be fully
 supported with your kernel or may have various bugs.  Please see the web
 page http://ext4.wiki.kernel.org/index.php/Bigalloc for details.
+May clash with delayed allocation (see
+.BR nodelalloc mount option).
+.IP
+This feature requires that the
+.B extent
+features be enabled.
 .TP
 .B dir_index
+.br
 Use hashed b-trees to speed up lookups in large directories.
 .TP
-.B extents
+.B dir_nlink
+.br
+Allow more than 65000 subdirectories per directory.
+.TP
+.B extent
+.br
 Instead of using the indirect block scheme for storing the location of
 data blocks in an inode, use extents instead.  This is a much more
 efficient encoding which speeds up filesystem access, especially for
-large files.  (Note: both extent and extents are accepted for
+large files.  (Note: both
+.B extent
+and
+.B extents
+are accepted as valid names for this feature for
 historical/backwards compatibility reasons.)
 .TP
+.B extra_isize
+.br
+This feature enables storage of nanosecond timestamps and creation
+time, if the inode size is larger than 256 bytes or larger.
+.TP
+.B ext_attr
+.br
+This feature enables the use of extended attributes.
+.TP
 .B filetype
-Store file type information in directory entries.
+.br
+This feature enables the storage file type information in directory
+entries.  It is normally enabled by default for all file system types.
 .TP
 .B flex_bg
+.br
 Allow the per-block group metadata (allocation bitmaps and inode tables)
 to be placed anywhere on the storage media.  In addition,
 .B mke2fs
@@ -575,28 +614,82 @@ can be specified using the
 option.
 .TP
 .B has_journal
-Create an ext3 journal (as if using the
+.br
+Create a journal to ensure filesystem consistency even across unclean
+shutdowns.  Setting the filesystem feature is equivalent to using the
 .B \-j
-option).
-@JDEV@.TP
-@JDEV@.B journal_dev
-@JDEV@Create an external ext3 journal on the given device
-@JDEV@instead of a regular ext2 filesystem.
-@JDEV@Note that
-@JDEV@.I external-journal
-@JDEV@must be created with the same
-@JDEV@block size as the filesystems that will be using it.
+option.
+.TP
+.B huge_file
+.br
+Allows files larger than 2TiB in size.
+.TP
+.B journal_dev
+.br
+Creates an external ext3 journal on the given device
+instead of a regular ext2 filesystem.
+Note that
+.I external-journal
+must be created with the same
+block size as the filesystems that will be using it.
+.IP
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
+.br
+Filesystem can contain files that are greater than 2GiB.  (Modern kernels
+set this feature automatically when a file > 2GiB is created.)
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
+.TP
+.B mmp
+.br
+Multiple mount protection (MMP) feature.  MMP helps to
+protect the filesystem from being multiply mounted and is useful in
+shared storage environments.
 @QUOTA_MAN_COMMENT@.TP
 @QUOTA_MAN_COMMENT@.B quota
-@QUOTA_MAN_COMMENT@Create quota inodes (inode# 3 for userquota and inode# 4 for group quota) and
-@QUOTA_MAN_COMMENT@set them in the superblock.  With this feature, the quotas will be enabled
+@QUOTA_MAN_COMMENT@.br
+@QUOTA_MAN_COMMENT@Create quota inodes (inode #3 for userquota and inode
+@QUOTA_MAN_COMMENT@#4 for group quota) and set them in the superblock.
+@QUOTA_MAN_COMMENT@With this feature, the quotas will be enabled
 @QUOTA_MAN_COMMENT@automatically when the filesystem is mounted.
+@QUOTA_MAN_COMMENT@.IP
+@QUOTA_MAN_COMMENT@Causes the quota files (i.e., user.quota and
+@QUOTA_MAN_COMMENT@group.quota which existed
+@QUOTA_MAN_COMMENT@in the older quota design) to be hidden inodes.
+@QUOTA_MAN_COMMENT@.IP
+@QUOTA_MAN_COMMENT@.B Not defined by default,
+@QUOTA_MAN_COMMENT@see https://ext4.wiki.kernel.org/index.php/Quota
 .TP
 .B resize_inode
+.br
 Reserve space so the block group descriptor table may grow in the future.
 Useful for online resizing using
 .BR resize2fs .
@@ -607,20 +700,30 @@ filesystem may grow to 1024 times its initial size.  This can be changed
 using the
 .B resize
 extended option.
+.IP
+ This feature requires that the
+.B sparse_super
+feature be enabled.
 .TP
 .B sparse_super
+.br
 Create a filesystem with fewer superblock backup copies
-(saves space on large filesystems).
+(saves space on large filesystems).  This feature is normally enabled by
+default for all file systems.
 .TP
 .B uninit_bg
+.br
 Create a filesystem without initializing all of the block groups.  This
-feature also enables checksums and highest-inode-used statistics in each
-blockgroup.  This feature can
-speed up filesystem creation time noticeably (if lazy_itable_init is
-enabled), and can also reduce
-.BR e2fsck
-time dramatically.  It is only supported by the ext4 filesystem in
-recent Linux kernels.
+feature allows the kernel to initialize bitmaps and inode tables
+and keep a high watermark for the unused inodes in a filesystem, to reduce
+.BR e2fsck (8)
+time.  The result is that it can speed up filesystem creation time noticeably
+(if lazy_itable_init is enabled).
+.IP
+This first e2fsck run after enabling this feature will take the
+full time, but subsequent e2fsck runs will take only a fraction of the
+original time, depending on how full the file system is.
+It is only supported by the ext4 filesystem in recent Linux kernels.
 .RE
 .TP
 .B \-q
@@ -652,7 +755,8 @@ or there is no chance of recovery.
 .\" using the specified test.
 .TP
 .BI \-t " fs-type"
-Specify the filesystem type (i.e., ext2, ext3, ext4, etc.) that is to be created.
+Specify the filesystem type (i.e., ext2, ext3, ext4, etc.) that is
+to be created.
 If this option is not specified,
 .B mke2fs
 will pick a default either via how
