From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: add mount options to ext4.5
Date: Wed, 11 Jun 2014 15:36:48 -0500
Message-ID: <5398BDE0.2040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFKUgr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2014 16:36:47 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5BKalUg032212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 16:36:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a straight cut and paste from the util-linux
mount manpage to ext4.5 (with commented-out lines
removed).

It's pretty much impossible for util-linux to keep up
with every filesystem out there, and Karel has more than
once expressed a wish that mount options move into fs-specific
manpages.

So, here we go.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index f08210e..7adfd52 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -254,10 +254,368 @@ and it also speeds up the time required for
 .BR mke2fs (8)
 to create the file system.
 .RE
+.SH MOUNT OPTIONS
+This section describes mount options which are specific to ext2, ext3,
+and ext4.  Other generic mount options may be used as well; see
+.BR mount (8)
+for details.
+.SH "Mount options for ext2"
+The `ext2' filesystem is the standard Linux filesystem.
+Since Linux 2.5.46, for most mount options the default
+is determined by the filesystem superblock. Set them with
+.BR tune2fs (8). 
+.TP 
+.BR acl | noacl
+Support POSIX Access Control Lists (or not).
+.TP
+.BR bsddf | minixdf
+Set the behavior for the
+.I statfs
+system call. The
+.B minixdf
+behavior is to return in the
+.I f_blocks 
+field the total number of blocks of the filesystem, while the
+.B bsddf
+behavior (which is the default) is to subtract the overhead blocks
+used by the ext2 filesystem and not available for file storage. Thus
+.sp 1
+% mount /k \-o minixdf; df /k; umount /k
+.TS
+tab(#);
+l2 l2 r2 l2 l2 l
+l c r c c l.
+Filesystem#1024-blocks#Used#Available#Capacity#Mounted on
+/dev/sda6#2630655#86954#2412169#3%#/k
+.TE
+.sp 1
+% mount /k \-o bsddf; df /k; umount /k
+.TS
+tab(#);
+l2 l2 r2 l2 l2 l
+l c r c c l.
+Filesystem#1024-blocks#Used#Available#Capacity#Mounted on
+/dev/sda6#2543714#13#2412169#0%#/k
+.TE
+.sp 1
+(Note that this example shows that one can add command line options
+to the options given in
+.IR /etc/fstab .)
+.TP
+.BR check=none " or " nocheck
+No checking is done at mount time. This is the default. This is fast.
+It is wise to invoke
+.BR e2fsck (8)
+every now and then, e.g.\& at boot time. The non-default behavior is unsupported
+(check=normal and check=strict options have been removed). Note that these mount options
+don't have to be supported if ext4 kernel driver is used for ext2 and ext3 filesystems.
+.TP
+.B debug
+Print debugging info upon each (re)mount.
+.TP
+.BR errors= { continue | remount-ro | panic }
+Define the behavior when an error is encountered.
+(Either ignore errors and just mark the filesystem erroneous and continue,
+or remount the filesystem read-only, or panic and halt the system.)
+The default is set in the filesystem superblock, and can be
+changed using
+.BR tune2fs (8).
+.TP
+.BR grpid | bsdgroups " and " nogrpid | sysvgroups
+These options define what group id a newly created file gets.
+When
+.B grpid
+is set, it takes the group id of the directory in which it is created;
+otherwise (the default) it takes the fsgid of the current process, unless
+the directory has the setgid bit set, in which case it takes the gid
+from the parent directory, and also gets the setgid bit set
+if it is a directory itself.
+.TP
+.BR grpquota | noquota | quota | usrquota
+The usrquota (same as quota) mount option enables user quota support on the
+filesystem. grpquota enables group quotas support. You need the quota utilities
+to actually enable and manage the quota system.
+.TP
+.B nouid32
+Disables 32-bit UIDs and GIDs.  This is for interoperability with older
+kernels which only store and expect 16-bit values.
+.TP
+.BR oldalloc " or " orlov
+Use old allocator or Orlov allocator for new inodes. Orlov is default.
+.TP
+\fBresgid=\fP\,\fIn\fP and \fBresuid=\fP\,\fIn\fP
+The ext2 filesystem reserves a certain percentage of the available
+space (by default 5%, see
+.BR mke2fs (8)
+and
+.BR tune2fs (8)).
+These options determine who can use the reserved blocks.
+(Roughly: whoever has the specified uid, or belongs to the specified group.)
+.TP
+.BI sb= n
+Instead of block 1, use block
+.I n
+as superblock. This could be useful when the filesystem has been damaged.
+(Earlier, copies of the superblock would be made every 8192 blocks: in
+block 1, 8193, 16385, \&...\& (and one got thousands of copies on
+a big filesystem). Since version 1.08,
+.B mke2fs
+has a \-s (sparse superblock) option to reduce the number of backup
+superblocks, and since version 1.15 this is the default. Note
+that this may mean that ext2 filesystems created by a recent
+.B mke2fs
+cannot be mounted r/w under Linux 2.0.*.)
+The block number here uses 1\ k units. Thus, if you want to use logical
+block 32768 on a filesystem with 4\ k blocks, use "sb=131072".
+.TP
+.BR user_xattr | nouser_xattr
+Support "user." extended attributes (or not).
+
+
+.SH "Mount options for ext3"
+The ext3 filesystem is a version of the ext2 filesystem which has been
+enhanced with journaling.  It supports the same options as ext2 as
+well as the following additions:
+.TP
+.B journal=update
+Update the ext3 filesystem's journal to the current format.
+.TP
+.B journal=inum
+When a journal already exists, this option is ignored. Otherwise, it
+specifies the number of the inode which will represent the ext3 filesystem's
+journal file; ext3 will create a new journal, overwriting the old contents
+of the file whose inode number is
+.IR inum .
+.TP
+.BR journal_dev=devnum / journal_path=path
+When the external journal device's major/minor numbers
+have changed, these options allow the user to specify
+the new journal location.  The journal device is
+identified either through its new major/minor numbers encoded
+in devnum, or via a path to the device.
+.TP
+.BR norecovery / noload
+Don't load the journal on mounting.  Note that
+if the filesystem was not unmounted cleanly,
+skipping the journal replay will lead to the
+filesystem containing inconsistencies that can
+lead to any number of problems.
+.TP
+.BR data= { journal | ordered | writeback }
+Specifies the journaling mode for file data.  Metadata is always journaled.
+To use modes other than
+.B ordered
+on the root filesystem, pass the mode to the kernel as boot parameter, e.g.\&
+.IR rootflags=data=journal .
+.RS
+.TP
+.B journal
+All data is committed into the journal prior to being written into the
+main filesystem.
+.TP
+.B ordered
+This is the default mode.  All data is forced directly out to the main file
+system prior to its metadata being committed to the journal.
+.TP
+.B writeback
+Data ordering is not preserved \(en data may be written into the main
+filesystem after its metadata has been committed to the journal.
+This is rumoured to be the highest-throughput option.  It guarantees
+internal filesystem integrity, however it can allow old data to appear
+in files after a crash and journal recovery.
+.RE
+.TP
+.B data_err=ignore
+Just print an error message if an error occurs in a file data buffer in
+ordered mode.
+.TP
+.B data_err=abort
+Abort the journal if an error occurs in a file data buffer in ordered mode.
+.TP
+.BR barrier=0 " / " barrier=1 "
+This disables / enables the use of write barriers in the jbd code.  barrier=0
+disables, barrier=1 enables (default). This also requires an IO stack which can
+support barriers, and if jbd gets an error on a barrier write, it will disable
+barriers again with a warning.  Write barriers enforce proper on-disk ordering
+of journal commits, making volatile disk write caches safe to use, at some
+performance penalty.  If your disks are battery-backed in one way or another,
+disabling barriers may safely improve performance.
+.TP
+.BI commit= nrsec
+Sync all data and metadata every
+.I nrsec
+seconds. The default value is 5 seconds. Zero means default.
+.TP
+.B user_xattr
+Enable Extended User Attributes. See the
+.BR attr (5)
+manual page.
+.TP
+.B acl
+Enable POSIX Access Control Lists. See the
+.BR acl (5)
+manual page.
+.TP
+.BR usrjquota=aquota.user | grpjquota=aquota.group | jqfmt=vfsv0
+Apart from the old quota system (as in ext2, jqfmt=vfsold aka version 1 quota)
+ext3 also supports journaled quotas (version 2 quota). jqfmt=vfsv0
+enables journaled quotas. For journaled quotas the mount options
+usrjquota=aquota.user and grpjquota=aquota.group are required to tell the
+quota system which quota database files to use. Journaled quotas have the
+advantage that even after a crash no quota check is required.
+
+.SH "Mount options for ext4"
+The ext4 filesystem is an advanced level of the ext3 filesystem which
+incorporates scalability and reliability enhancements for supporting large
+filesystem.
+
+The options
+.B journal_dev, norecovery, noload, data, commit, orlov, oldalloc, [no]user_xattr
+.B [no]acl, bsddf, minixdf, debug, errors, data_err, grpid, bsdgroups, nogrpid
+.B sysvgroups, resgid, resuid, sb, quota, noquota, grpquota, usrquota
+.B usrjquota, grpjquota and jqfmt
+are backwardly compatible with ext3 or ext2.
+.TP
+.B journal_checksum
+Enable checksumming of the journal transactions.  This will allow the recovery
+code in e2fsck and the kernel to detect corruption in the kernel.  It is a
+compatible change and will be ignored by older kernels.
+.TP
+.B journal_async_commit
+Commit block can be written to disk without waiting for descriptor blocks. If
+enabled older kernels cannot mount the device.
+This will enable 'journal_checksum' internally.
+.TP
+.BR barrier=0 " / " barrier=1 " / " barrier " / " nobarrier
+These mount options have the same effect as in ext3.  The mount options
+"barrier" and "nobarrier" are added for consistency with other ext4 mount
+options.
+
+The ext4 filesystem enables write barriers by default.
+.TP
+.BI inode_readahead_blks= n
+This tuning parameter controls the maximum number of inode table blocks that
+ext4's inode table readahead algorithm will pre-read into the buffer cache.
+The value must be a power of 2. The default value is 32 blocks.
+.TP
+.BI stripe= n
+Number of filesystem blocks that mballoc will try to use for allocation size
+and alignment. For RAID5/6 systems this should be the number of data disks *
+RAID chunk size in filesystem blocks.
+.TP
+.B delalloc
+Deferring block allocation until write-out time.
+.TP
+.B nodelalloc
+Disable delayed allocation. Blocks are allocated when data is copied from user
+to page cache.
+.TP
+.BI max_batch_time= usec
+Maximum amount of time ext4 should wait for additional filesystem operations to
+be batch together with a synchronous write operation. Since a synchronous
+write operation is going to force a commit and then a wait for the I/O
+complete, it doesn't cost much, and can be a huge throughput win, we wait for a
+small amount of time to see if any other transactions can piggyback on the
+synchronous write. The algorithm used is designed to automatically tune for
+the speed of the disk, by measuring the amount of time (on average) that it
+takes to finish committing a transaction. Call this time the "commit time".
+If the time that the transaction has been running is less than the commit time,
+ext4 will try sleeping for the commit time to see if other operations will join
+the transaction. The commit time is capped by the max_batch_time, which
+defaults to 15000\ \[mc]s (15\ ms). This optimization can be turned off entirely by
+setting max_batch_time to 0.
+.TP
+.BI min_batch_time= usec
+This parameter sets the commit time (as described above) to be at least
+min_batch_time. It defaults to zero microseconds. Increasing this parameter
+may improve the throughput of multi-threaded, synchronous workloads on very
+fast disks, at the cost of increasing latency.
+.TP
+.BI journal_ioprio= prio
+The I/O priority (from 0 to 7, where 0 is the highest priority) which should be
+used for I/O operations submitted by kjournald2 during a commit operation.
+This defaults to 3, which is a slightly higher priority than the default I/O
+priority.
+.TP
+.B abort
+Simulate the effects of calling ext4_abort() for
+debugging purposes.  This is normally used while
+remounting a filesystem which is already mounted.
+.TP
+.BR auto_da_alloc | noauto_da_alloc
+Many broken applications don't use fsync() when
+replacing existing files via patterns such as
+
+fd = open("foo.new")/write(fd,...)/close(fd)/ rename("foo.new", "foo")
+
+or worse yet
+
+fd = open("foo", O_TRUNC)/write(fd,...)/close(fd).
+
+If auto_da_alloc is enabled, ext4 will detect the replace-via-rename and
+replace-via-truncate patterns and force that any delayed allocation blocks are
+allocated such that at the next journal commit, in the default data=ordered
+mode, the data blocks of the new file are forced to disk before the rename()
+operation is committed.  This provides roughly the same level of guarantees as
+ext3, and avoids the "zero-length" problem that can happen when a system
+crashes before the delayed allocation blocks are forced to disk.
+.TP
+.B noinit_itable
+Do not initialize any uninitialized inode table blocks in the background. This
+feature may be used by installation CD's so that the install process can
+complete as quickly as possible; the inode table initialization process would
+then be deferred until the next time the filesystem is mounted.
+.TP
+.B init_itable=n
+The lazy itable init code will wait n times the number of milliseconds it took
+to zero out the previous block group's inode table. This minimizes the impact on
+system performance while the filesystem's inode table is being initialized.
+.TP
+.BR discard / nodiscard
+Controls whether ext4 should issue discard/TRIM commands to the underlying
+block device when blocks are freed.  This is useful for SSD devices and
+sparse/thinly-provisioned LUNs, but it is off by default until sufficient
+testing has been done.
+.TP
+.B nouid32
+Disables 32-bit UIDs and GIDs.  This is for
+interoperability  with  older kernels which only
+store and expect 16-bit values.
+.TP
+.BR block_validity / noblock_validity
+This options allows to enables/disables the in-kernel facility for tracking
+filesystem metadata blocks within internal data structures. This allows multi-\c
+block allocator and other routines to quickly locate extents which might
+overlap with filesystem metadata blocks. This option is intended for debugging
+purposes and since it negatively affects the performance, it is off by default.
+.TP
+.BR dioread_lock / dioread_nolock
+Controls whether or not ext4 should use the DIO read locking. If the
+dioread_nolock option is specified ext4 will allocate uninitialized extent
+before buffer write and convert the extent to initialized after IO completes.
+This approach allows ext4 code to avoid using inode mutex, which improves
+scalability on high speed storages. However this does not work with data
+journaling and dioread_nolock option will be ignored with kernel warning.
+Note that dioread_nolock code path is only used for extent-based files.
+Because of the restrictions this options comprises it is off by default
+(e.g.\& dioread_lock).
+.TP
+.B max_dir_size_kb=n
+This limits the size of the directories so that any attempt to expand them
+beyond the specified limit in kilobytes will cause an ENOSPC error. This is
+useful in memory-constrained environments, where a very large directory can
+cause severe performance problems or even provoke the Out Of Memory killer. (For
+example, if there is only 512\ MB memory available, a 176\ MB directory may
+seriously cramp the system's style.)
+.TP
+.B i_version
+Enable 64-bit inode version support. This option is off by default.
+
 .SH SEE ALSO
 .BR mke2fs (8),
 .BR mke2fs.conf (5),
 .BR e2fsck (8),
 .BR dumpe2fs (8),
 .BR tune2fs (8),
-.BR debugfs (8)
+.BR debugfs (8),
+.BR mount (8)

