From: Tyson Nottingham <tgnottingham@gmail.com>
Subject: [PATCH 1/5] Add missing features and mount options to ext4 man page.
Date: Wed, 13 Dec 2017 23:13:09 -0800
Message-ID: <66ae08c8ad25285fff38e65b0da40e14c28fa9c8.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Cc: linux-ext4@vger.kernel.org,
        Tyson Nottingham <tgnottingham@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:43973 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdLNHOf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Dec 2017 02:14:35 -0500
Received: by mail-pg0-f44.google.com with SMTP id b18so2863682pgv.10
        for <linux-ext4@vger.kernel.org>; Wed, 13 Dec 2017 23:14:35 -0800 (PST)
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
In-Reply-To: <cover.1513233071.git.tgnottingham@gmail.com>
References: <cover.1513233071.git.tgnottingham@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add descriptions for ea_inode, large_dir, metadata_csum, and
metadata_csum_seed features, as well as nombcache and prjquota
mount options. Also, update a couple of descriptions.

Signed-off-by: Tyson Nottingham <tgnottingham@gmail.com>
---
 misc/ext4.5.in | 146 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 102 insertions(+), 44 deletions(-)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 45aceb2..8f4c4f5 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -78,6 +78,14 @@ lifts this limit by causing ext4 to use a link count of 1 to indicate
 that the number of hard links to a directory is not known when the link
 count might exceed the maximum count limit.
 .TP
+.B ea_inode
+.br
+Normally, a file's extended attributes and associated metadata must fit within
+the inode or the inode's associated extended attribute block. This feature
+allows the value of each extended attribute to be placed in the data blocks of a
+separate inode if necessary, increasing the limit on the size and number of
+extended attributes per file.
+.TP
 .B encrypt
 .br
 This ext4 feature provides file-system level encryption of data blocks
@@ -175,27 +183,40 @@ option to
 or
 .BR tune2fs(8).
 .TP
+.B large_dir
+.br
+This feature increases the limit on the number of files per directory by
+raising the maximum size of directories and, for hashed b-tree directories (see
+.BR dir_index ),
+the maximum height of the hashed b-tree used to store the directory entries.
+.TP
 .B large_file
 .br
 This feature flag is set automatically by modern kernels when a file
 larger than 2 gigabytes is created.  Very old kernels could not
 handle large files, so this feature flag was used to prohibit those
 kernels from mounting file systems that they could not understand.
-.\" .TP
-.\" .B metadata_csum
-.\" .br
-.\" This ext4 feature enables metadata checksumming.  This feature stores
-.\" checksums for all of the filesystem metadata (superblock, group
-.\" descriptor blocks, inode and block bitmaps, directories, and
-.\" extent tree blocks).  The checksum algorithm used for the metadata
-.\" blocks is different than the one used for group descriptors with the
-.\" .B uninit_bg
-.\" feature, these two features are incompatible and
-.\" .B metadata_csum
-.\" will be used preferentially instead of
-.\" .BR uninit_bg .
-.\" .br
-.\" .B Future feature, available in e2fsprogs 1.43-WIP
+.TP
+.B metadata_csum
+.br
+This ext4 feature enables metadata checksumming.  This feature stores
+checksums for all of the filesystem metadata (superblock, group
+descriptor blocks, inode and block bitmaps, directories, and
+extent tree blocks).  The checksum algorithm used for the metadata
+blocks is different than the one used for group descriptors with the
+.B uninit_bg
+feature.  These two features are incompatible and
+.B metadata_csum
+will be used preferentially instead of
+.BR uninit_bg .
+.TP
+.B metadata_csum_seed
+.br
+This feature allows the filesystem to store the metadata checksum seed in the
+superblock, which allows the administrator to change the UUID of a filesystem
+using the
+.B metadata_csum
+feature while it is mounted.
 .TP
 .B meta_bg
 .br
@@ -214,10 +235,6 @@ available in the resize inode.
 This ext4 feature provides multiple mount protection (MMP).  MMP helps to
 protect the filesystem from being multiply mounted and is useful in
 shared storage environments.
-.IP
-Causes the quota files (i.e., user.quota and
-group.quota which existed
-in the older quota design) to be hidden inodes.
 .TP
 .B project
 .br
@@ -230,6 +247,10 @@ Create quota inodes (inode #3 for userquota and inode
 #4 for group quota) and set them in the superblock.
 With this feature, the quotas will be enabled
 automatically when the filesystem is mounted.
+.IP
+Causes the quota files (i.e., user.quota and
+group.quota which existed
+in the older quota design) to be hidden inodes.
 .TP
 .B resize_inode
 .br
@@ -248,6 +269,8 @@ extended option.
 .IP
 This feature requires that the
 .B sparse_super
+or
+.B sparse_super2
 feature be enabled.
 .TP
 .B sparse_super
@@ -382,18 +405,26 @@ These options determine who can use the reserved blocks.
 (Roughly: whoever has the specified uid, or belongs to the specified group.)
 .TP
 .BI sb= n
-Instead of block 1, use block
-.I n
-as superblock. This could be useful when the filesystem has been damaged.
-(Earlier, copies of the superblock would be made every 8192 blocks: in
-block 1, 8193, 16385, \&...\& (and one got thousands of copies on
-a big filesystem). Since version 1.08,
+Instead of using the normal superblock, use an alternative superblock
+specified by
+.IR n .
+This option is normally used when the primary superblock has been
+corrupted.  The location of backup superblocks is dependent on the
+filesystem's blocksize, the number of blocks per group, and features
+such as
+.BR sparse_super .
+.IP
+Additional backup superblocks can be determined by using the
 .B mke2fs
-has a \-s (sparse superblock) option to reduce the number of backup
-superblocks, and since version 1.15 this is the default. Note
-that this may mean that ext2 filesystems created by a recent
+program using the
+.B \-n
+option to print out where the superblocks exist, supposing
 .B mke2fs
-cannot be mounted r/w under Linux 2.0.*.)
+is supplied with arguments that are consistent with the filesystem's layout
+(e.g. blocksize, blocks per group,
+.BR sparse_super ,
+etc.).
+.IP
 The block number here uses 1\ k units. Thus, if you want to use logical
 block 32768 on a filesystem with 4\ k blocks, use "sb=131072".
 .TP
@@ -470,13 +501,22 @@ Enable Extended User Attributes. See the
 .BR attr (5)
 manual page.
 .TP
-.BR usrjquota=aquota.user | grpjquota=aquota.group | jqfmt=vfsv0
+.BR jqfmt= { vfsold | vfsv0 | vfsv1 }
 Apart from the old quota system (as in ext2, jqfmt=vfsold aka version 1 quota)
-ext3 also supports journaled quotas (version 2 quota). jqfmt=vfsv0
-enables journaled quotas. For journaled quotas the mount options
+ext3 also supports journaled quotas (version 2 quota). jqfmt=vfsv0 or
+jqfmt=vfsv1 enables journaled quotas. Journaled quotas have the advantage that
+even after a crash no quota check is required. When the
+.B quota
+filesystem feature is enabled, journaled quotas are used automatically, and
+this mount option is ignored.
+.TP
+.BR usrjquota=aquota.user | grpjquota=aquota.group
+For journaled quotas (jqfmt=vfsv0 or jqfmt=vfsv1), the mount options
 usrjquota=aquota.user and grpjquota=aquota.group are required to tell the
-quota system which quota database files to use. Journaled quotas have the
-advantage that even after a crash no quota check is required.
+quota system which quota database files to use. When the
+.B quota
+filesystem feature is enabled, journaled quotas are used automatically, and
+this mount option is ignored.
 
 .SH "Mount options for ext4"
 The ext4 filesystem is an advanced level of the ext3 filesystem which
@@ -484,16 +524,16 @@ incorporates scalability and reliability enhancements for supporting large
 filesystem.
 
 The options
-.B journal_dev, norecovery, noload, data, commit, orlov, oldalloc, [no]user_xattr
-.B [no]acl, bsddf, minixdf, debug, errors, data_err, grpid, bsdgroups, nogrpid
-.B sysvgroups, resgid, resuid, sb, quota, noquota, nouid32, grpquota, usrquota
-.B usrjquota, grpjquota and jqfmt
-are backwardly compatible with ext3 or ext2.
+.B journal_dev, journal_path, norecovery, noload, data, commit, orlov,
+.B oldalloc, [no]user_xattr, [no]acl, bsddf, minixdf, debug, errors,
+.B data_err, grpid, bsdgroups, nogrpid, sysvgroups, resgid, resuid, sb,
+.B quota, noquota, nouid32, grpquota, usrquota, usrjquota, grpjquota,
+.B and jqfmt are backwardly compatible with ext3 or ext2.
 .TP
-.B journal_checksum
-Enable checksumming of the journal transactions.  This will allow the recovery
-code in e2fsck and the kernel to detect corruption in the kernel.  It is a
-compatible change and will be ignored by older kernels.
+.B journal_checksum | nojournal_checksum
+The journal_checksum option enables checksumming of the journal transactions.
+This will allow the recovery code in e2fsck and the kernel to detect corruption
+in the kernel. It is a compatible change and will be ignored by older kernels.
 .TP
 .B journal_async_commit
 Commit block can be written to disk without waiting for descriptor blocks. If
@@ -592,7 +632,7 @@ sparse/thinly-provisioned LUNs, but it is off by default until sufficient
 testing has been done.
 .TP
 .BR block_validity / noblock_validity
-This options enables/disables the in-kernel facility for tracking
+This option enables/disables the in-kernel facility for tracking
 filesystem metadata blocks within internal data structures. This allows multi-\c
 block allocator and other routines to quickly locate extents which might
 overlap with filesystem metadata blocks. This option is intended for debugging
@@ -619,6 +659,18 @@ seriously cramp the system's style.)
 .TP
 .B i_version
 Enable 64-bit inode version support. This option is off by default.
+.TP
+.B nombcache
+This option disables use of mbcache for extended attribute deduplication. On
+systems where extended attributes are rarely or never shared between files,
+use of mbcache for deduplication adds unnecessary computational overhead.
+.TP
+.B prjquota
+The prjquota mount option enables project quota support on the filesystem.
+You need the quota utilities to actually enable and manage the quota system.
+This mount option requires the
+.B project
+filesystem feature.
 
 .SH FILE ATTRIBUTES
 The ext2, ext3, and ext4 filesystems support setting the following file
@@ -704,8 +756,14 @@ ext4, 3.16
 ext4, 3.18
 .IP "\fBencrypt\fR" 2in
 ext4, 4.1
+.IP "\fBmetadata_csum_seed\fR" 2in
+ext4, 4.4
 .IP "\fBproject\fR" 2in
 ext4, 4.5
+.IP "\fBea_inode\fR" 2in
+ext4, 4.13
+.IP "\fBlarge_dir\fR" 2in
+ext4, 4.13
 .SH SEE ALSO
 .BR mke2fs (8),
 .BR mke2fs.conf (5),
-- 
2.7.4
