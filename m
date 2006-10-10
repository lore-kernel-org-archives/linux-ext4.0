From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: [RFC] [PATCH] Documentation/filesystems/ext4.txt
Date: Tue, 10 Oct 2006 15:02:35 -0500
Message-ID: <1160510555.28923.15.camel@kleikamp.austin.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
	 <20061005173933.f54555fb.akpm@osdl.org>
	 <20061009232927.77b667c2.akpm@osdl.org> <20061010075402.GA23992@in.ibm.com>
	 <20061010011434.e8e2f76b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: suparna@in.ibm.com, ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:14570 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030239AbWJJUCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Oct 2006 16:02:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9AK2iuF017279
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 16:02:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9AK2drC135892
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 16:02:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9AK2cCj016749
	for <linux-ext4@vger.kernel.org>; Tue, 10 Oct 2006 16:02:39 -0400
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061010011434.e8e2f76b.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-10-10 at 01:14 -0700, Andrew Morton wrote:
> On Tue, 10 Oct 2006 13:24:02 +0530
> Suparna Bhattacharya <suparna@in.ibm.com> wrote:
> 
> > On Mon, Oct 09, 2006 at 11:29:27PM -0700, Andrew Morton wrote:
> > > On Thu, 5 Oct 2006 17:39:33 -0700
> > > Andrew Morton <akpm@osdl.org> wrote:
> > > 
> > > > Could we please have a few nice words about ext4 for the record?  Like,
> > > > what its features are, how one creates an instance, where to get the
> > > > correct userspace tools from, stability level, any known shortcomings,
> > > > issues, etc?
> > > 
> > > So I guess I get to write this.

Sorry I didn't get something written sooner.  This is based off of what
you put in the -mm1 announcement.

> > Hopefully not :) 
> > We should be able to put something together for a start. Where should this
> > reside ? Under Documentation/filesystems/ext4.txt ?

Suparna put this together and I updated it a bit.

> That sounds appropriate.  And in the patch changelog.

How do you want to handle the patch set?  I could resend it with more
comments, put it into git, or do you just want to plug the comments into
the patches you are carrying?  I can do whatever works best for you.

> > However, since this is still very clearly a "development" branch at the moment,
> > with lots of ongoing work both on the kernel and even more so on the
> > tools side, how much detail are you looking for ?
> 
> We should make it as easy as possible for our testers to get up and running
> and using all available features.  They're skilled, so a simple user guide
> which tells them what the features are and how to access them should
> suffice, thanks.

This file, ext4.txt, was put together with information from Andrew Morton,
Andreas Dilger, Suparna Bhattacharya, and Ted Ts'o.

I copied the mount options, with the exception of "extents", from ext3.txt,
so if anyone is aware of anything out-of-date, please let me know.

Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>

diff -Nurp linux-orig/Documentation/filesystems/00-INDEX linux/Documentation/filesystems/00-INDEX
--- linux-orig/Documentation/filesystems/00-INDEX	2006-10-05 07:22:05.000000000 -0500
+++ linux/Documentation/filesystems/00-INDEX	2006-10-06 17:30:59.000000000 -0500
@@ -34,6 +34,8 @@ ext2.txt
 	- info, mount options and specifications for the Ext2 filesystem.
 ext3.txt
 	- info, mount options and specifications for the Ext3 filesystem.
+ext4.txt
+	- info, mount options and specifications for the Ext4 filesystem.
 files.txt
 	- info on file management in the Linux kernel.
 fuse.txt
diff -Nurp linux-orig/Documentation/filesystems/ext4.txt linux/Documentation/filesystems/ext4.txt
--- linux-orig/Documentation/filesystems/ext4.txt	1969-12-31 18:00:00.000000000 -0600
+++ linux/Documentation/filesystems/ext4.txt	2006-10-10 14:25:38.000000000 -0500
@@ -0,0 +1,236 @@
+
+Ext4 Filesystem
+===============
+
+This is a development version of the ext4 filesystem, an advanced level
+of the ext3 filesystem which incorporates scalability and reliability
+enhancements for supporting large filesystems (64 bit) in keeping with
+increasing disk capacities and state-of-the-art feature requirements.
+
+Mailing list: linux-ext4@vger.kernel.org
+
+
+1. Quick usage instructions:
+===========================
+
+  - Grab updated e2fsprogs from
+    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/
+    This is a patchset on top of e2fsprogs-1.39, which can be found at
+    ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/
+
+  - It's still mke2fs -j /dev/hda1
+
+  - mount /dev/hda1 /wherever -t ext4dev
+
+  - To enable extents,
+
+	mount /dev/hda1 /wherever -t ext4dev -o extents
+
+  - The filesystem is compatible with the ext3 driver until you add a file
+    which has extents (ie: `mount -o extents', then create a file).
+
+    NOTE: The "extents" mount flag is temporary.  It will soon go away and
+    extents will be enabled by the "-o extents" flag to mke2fs or tune2fs
+
+  - When comparing performance with other filesystems, remember that
+    ext3/4 by default offers higher data integrity guarantees than most.  So
+    when comparing with a metadata-only journalling filesystem, use `mount -o
+    data=writeback'.  And you might as well use `mount -o nobh' too along
+    with it.  Making the journal larger than the mke2fs default often helps
+    performance with metadata-intensive workloads.
+
+2. Features
+===========
+
+2.1 Currently available
+
+* ability to use filesystems > 16TB
+* extent format reduces metadata overhead (RAM, IO for access, transactions)
+* extent format more robust in face of on-disk corruption due to magics,
+* internal redunancy in tree
+
+2.1 Previously available, soon to be enabled by default by "mkefs.ext4":
+
+* dir_index and resize inode will be on by default
+* large inodes will be used by default for fast EAs, nsec timestamps, etc
+
+2.2 Candidate features for future inclusion
+
+There are several under discussion, whether they all make it in is
+partly a function of how much time everyone has to work on them:
+
+* improved file allocation (multi-block alloc, delayed alloc; basically done)
+* fix 32000 subdirectory limit (patch exists, needs some e2fsck work)
+* nsec timestamps for mtime, atime, ctime, create time (patch exists,
+  needs some e2fsck work)
+* inode version field on disk (NFSv4, Lustre; prototype exists)
+* reduced mke2fs/e2fsck time via uninitialized groups (prototype exists)
+* journal checksumming for robustness, performance (prototype exists)
+* persistent file preallocation (e.g for streaming media, databases)
+
+Features like metadata checksumming have been discussed and planned for
+a bit but no patches exist yet so I'm not sure they're in the near-term
+roadmap.
+
+The big performance win will come with mballoc and delalloc.  CFS has
+been using mballoc for a few years already with Lustre, and IBM + Bull
+did a lot of benchmarking on it.  The reason it isn't in the first set of
+patches is partly a manageability issue, and partly because it doesn't
+directly affect the on-disk format (outside of much better allocation)
+so it isn't critical to get into the first round of changes.  I believe
+Alex is working on a new set of patches right now.
+
+3. Options
+==========
+
+When mounting an ext4 filesystem, the following option are accepted:
+(*) == default
+
+extents			ext4 will use extents to address file data.  The
+			file system will no longer be mountable by ext3.
+
+journal=update		Update the ext4 file system's journal to the current
+			format.
+
+journal=inum		When a journal already exists, this option is ignored.
+			Otherwise, it specifies the number of the inode which
+			will represent the ext4 file system's journal file.
+
+journal_dev=devnum	When the external journal device's major/minor numbers
+			have changed, this option allows the user to specify
+			the new journal location.  The journal device is
+			identified through its new major/minor numbers encoded
+			in devnum.
+
+noload			Don't load the journal on mounting.
+
+data=journal		All data are committed into the journal prior to being
+			written into the main file system.
+
+data=ordered	(*)	All data are forced directly out to the main file
+			system prior to its metadata being committed to the
+			journal.
+
+data=writeback		Data ordering is not preserved, data may be written
+			into the main file system after its metadata has been
+			committed to the journal.
+
+commit=nrsec	(*)	Ext4 can be told to sync all its data and metadata
+			every 'nrsec' seconds. The default value is 5 seconds.
+			This means that if you lose your power, you will lose
+			as much as the latest 5 seconds of work (your
+			filesystem will not be damaged though, thanks to the
+			journaling).  This default value (or any low value)
+			will hurt performance, but it's good for data-safety.
+			Setting it to 0 will have the same effect as leaving
+			it at the default (5 seconds).
+			Setting it to very large values will improve
+			performance.
+
+barrier=1		This enables/disables barriers.  barrier=0 disables
+			it, barrier=1 enables it.
+
+orlov		(*)	This enables the new Orlov block allocator. It is
+			enabled by default.
+
+oldalloc		This disables the Orlov block allocator and enables
+			the old block allocator.  Orlov should have better
+			performance - we'd like to get some feedback if it's
+			the contrary for you.
+
+user_xattr		Enables Extended User Attributes.  Additionally, you
+			need to have extended attribute support enabled in the
+			kernel configuration (CONFIG_EXT4_FS_XATTR).  See the
+			attr(5) manual page and http://acl.bestbits.at/ to
+			learn more about extended attributes.
+
+nouser_xattr		Disables Extended User Attributes.
+
+acl			Enables POSIX Access Control Lists support.
+			Additionally, you need to have ACL support enabled in
+			the kernel configuration (CONFIG_EXT4_FS_POSIX_ACL).
+			See the acl(5) manual page and http://acl.bestbits.at/
+			for more information.
+
+noacl			This option disables POSIX Access Control List
+			support.
+
+reservation
+
+noreservation
+
+bsddf		(*)	Make 'df' act like BSD.
+minixdf			Make 'df' act like Minix.
+
+check=none		Don't do extra checking of bitmaps on mount.
+nocheck
+
+debug			Extra debugging information is sent to syslog.
+
+errors=remount-ro(*)	Remount the filesystem read-only on an error.
+errors=continue		Keep going on a filesystem error.
+errors=panic		Panic and halt the machine if an error occurs.
+
+grpid			Give objects the same group ID as their creator.
+bsdgroups
+
+nogrpid		(*)	New objects have the group ID of their creator.
+sysvgroups
+
+resgid=n		The group ID which may use the reserved blocks.
+
+resuid=n		The user ID which may use the reserved blocks.
+
+sb=n			Use alternate superblock at this location.
+
+quota
+noquota
+grpquota
+usrquota
+
+bh		(*)	ext4 associates buffer heads to data pages to
+nobh			(a) cache disk block mapping information
+			(b) link pages into transaction to provide
+			    ordering guarantees.
+			"bh" option forces use of buffer heads.
+			"nobh" option tries to avoid associating buffer
+			heads (supported only for "writeback" mode).
+
+
+Data Mode
+---------
+There are 3 different data modes:
+
+* writeback mode
+In data=writeback mode, ext4 does not journal data at all.  This mode provides
+a similar level of journaling as that of XFS, JFS, and ReiserFS in its default
+mode - metadata journaling.  A crash+recovery can cause incorrect data to
+appear in files which were written shortly before the crash.  This mode will
+typically provide the best ext4 performance.
+
+* ordered mode
+In data=ordered mode, ext4 only officially journals metadata, but it logically
+groups metadata and data blocks into a single unit called a transaction.  When
+it's time to write the new metadata out to disk, the associated data blocks
+are written first.  In general, this mode performs slightly slower than
+writeback but significantly faster than journal mode.
+
+* journal mode
+data=journal mode provides full data and metadata journaling.  All new data is
+written to the journal first, and then to its final location.
+In the event of a crash, the journal can be replayed, bringing both data and
+metadata into a consistent state.  This mode is the slowest except when data
+needs to be read from and written to disk at the same time where it
+outperforms all others modes.
+
+References
+==========
+
+kernel source:	<file:fs/ext4/>
+		<file:fs/jbd2/>
+
+programs:	http://e2fsprogs.sourceforge.net/
+		http://ext2resize.sourceforge.net
+
+useful links:	http://fedoraproject.org/wiki/ext3-devel
+		http://www.bullopensource.org/ext4/

-- 
David Kleikamp
IBM Linux Technology Center

