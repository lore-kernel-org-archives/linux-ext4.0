From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Tue, 9 Sep 2008 21:58:14 +0530
Message-ID: <20080909162814.GB5335@skywalker>
References: <1220951542-1451-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080909114647.GA14052@infradead.org> <20080909134347.GB21071@mit.edu> <20080909140929.GA5335@skywalker> <20080909143915.GG21071@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:42905 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbYIIQbS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 12:31:18 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m89GT8l9024513
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 02:29:08 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m89GUAU9136668
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 02:30:10 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m89GUAIP023560
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2008 02:30:10 +1000
Content-Disposition: inline
In-Reply-To: <20080909143915.GG21071@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 10:39:15AM -0400, Theodore Tso wrote:
> On Tue, Sep 09, 2008 at 07:39:29PM +0530, Aneesh Kumar K.V wrote:
> > 
> > Shouldn't other file system give error when we call an ioctl with
> > EXT4_IOC_MIGRATE on the fd ?
> 
> Only if by some incredible bad luck the ioctl number (which is after
> all only at 16 bit number) doesn't happen to do something else random,
> like security erase the entire filesystem.  :-)
> 
> > On ext3 I get the below error
> > [an/chattr@e2fsprogs-upstream-build]$ ./misc/chattr -E ./misc/e2undo
> > ./misc/chattr: Inappropriate ioctl for device while converting ./misc/e2undo to extent format
> > 
> 
> #1, it really should be +e, since we are turning on the extent flag,
> and #2, we should give a much more user-understandable error message
> in that case.

something like 

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Add extent conversion support to chattr

This patch adds new option, +e to chattr. The +e option
is used to convert the ext3 format (non extent) file
to ext4 (extent) format. This can be used to migrate
the ext3 file system to ext4 file system.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 lib/e2p/e2p.h        |    1 +
 lib/e2p/fsetflags.c  |   10 ++++++++++
 lib/ext2fs/ext2_fs.h |    1 +
 misc/chattr.1.in     |    9 ++++-----
 misc/chattr.c        |   17 ++++++++++++++++-
 5 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index 98c97db..8cbf360 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -60,3 +60,4 @@ char *e2p_os2string(int os_type);
 int e2p_string2os(char *str);
 
 unsigned int e2p_percent(int percent, unsigned int base);
+int ext4_migrate(const char * name);
diff --git a/lib/e2p/fsetflags.c b/lib/e2p/fsetflags.c
index 62189c9..d1bb9d9 100644
--- a/lib/e2p/fsetflags.c
+++ b/lib/e2p/fsetflags.c
@@ -80,9 +80,19 @@ int fsetflags (const char * name, unsigned long flags)
 	if (fd == -1)
 		return -1;
 	f = (int) flags;
+	if (f & EXT4_EXTENTS_FL) {
+		/* extent flags is set using  migrate ioctl */
+		r = ioctl (fd, EXT4_IOC_MIGRATE, NULL);
+		if (r == -1) {
+			save_errno = errno;
+			goto err_out;
+		}
+		f = (int)flags & ~EXT4_EXTENTS_FL;
+	}
 	r = ioctl (fd, EXT2_IOC_SETFLAGS, &f);
 	if (r == -1)
 		save_errno = errno;
+err_out:
 	close (fd);
 	if (save_errno)
 		errno = save_errno;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index d7d7bdb..2fe6691 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -316,6 +316,7 @@ struct ext4_new_group_input {
 #define EXT2_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT2_IOC_GROUP_ADD		_IOW('f', 8,struct ext2_new_group_input)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
+#define EXT4_IOC_MIGRATE                _IO('f', 7)
 
 /*
  * Structure of an inode on the disk
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 960f058..1247090 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -19,7 +19,7 @@ chattr \- change file attributes on a Linux second extended file system
 .B chattr
 changes the file attributes on a Linux second extended file system.
 .PP
-The format of a symbolic mode is +-=[ASacDdIijsTtu].
+The format of a symbolic mode is +-=[ASacDdIijsTtue].
 .PP
 The operator `+' causes the selected attributes to be added to the
 existing attributes of the files; `-' causes them to be removed; and
@@ -74,10 +74,9 @@ although it can be displayed by
 .BR lsattr (1).
 .PP
 The 'e' attribute indicates that the file is using extents for mapping
-the blocks on disk.  It may not be set or reset using
-.BR chattr (1),
-although it can be displayed by
-.BR lsattr (1).
+the blocks on disk.  Setting extent flag cause the file to be converted
+to extent format. It may not be unset using
+.BR chattr (1).
 .PP
 The 'I' attribute is used by the htree code to indicate that a directory
 is being indexed using hashed trees.  It may not be set or reset using 
diff --git a/misc/chattr.c b/misc/chattr.c
index 3d67519..c9d6d1e 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -82,7 +82,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=AacDdijsSu] [+e] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -105,6 +105,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT2_UNRM_FL, 'u' },
 	{ EXT2_NOTAIL_FL, 't' },
 	{ EXT2_TOPDIR_FL, 'T' },
+	{ EXT4_EXTENTS_FL, 'e'},
 	{ 0, 0 }
 };
 
@@ -199,6 +200,20 @@ static int change_attributes(const char * name)
 		return -1;
 	}
 
+	if (rf & EXT4_EXTENTS_FL) {
+		/* only allowed format is +e */
+		com_err (program_name, errno,
+				_("Cannot remove the extent flag on %s"), name);
+		return -1;
+	}
+
+	if (sf & EXT4_EXTENTS_FL) {
+		/* only allowed format is +e */
+		com_err (program_name, errno,
+			_("Extent flag cannot be the only attribute on %s"), name);
+		return -1;
+	}
+
 	if (set) {
 		if (verbose) {
 			printf (_("Flags of %s set as "), name);
-- 
tg: (5bf3f80..) an/chattr (depends on: master)
