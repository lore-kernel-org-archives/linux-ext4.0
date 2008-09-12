From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add extent conversion support to chattr
Date: Fri, 12 Sep 2008 15:01:53 +0530
Message-ID: <20080912093153.GD8405@skywalker>
References: <1221210249-26484-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080912091713.GY3086@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55448 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYILJdI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:33:08 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m8C9VA1g002861
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:31:11 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C9W7L91081404
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:32:07 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8C9W6Pd020523
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:32:06 +1000
Content-Disposition: inline
In-Reply-To: <20080912091713.GY3086@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Updated patch

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Add extent conversion support to chattr

This patch adds new option, +e to chattr. The +e option
is used to convert the ext3 format (non extent) file
to ext4 (extent) format. This can be used to migrate
the ext3 file system to ext4 file system.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 misc/chattr.1.in |    8 ++----
 misc/chattr.c    |   58 +++++++++++++++++++++++++++++++++++------------------
 2 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 960f058..c49f876 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -19,7 +19,7 @@ chattr \- change file attributes on a Linux second extended file system
 .B chattr
 changes the file attributes on a Linux second extended file system.
 .PP
-The format of a symbolic mode is +-=[ASacDdIijsTtu].
+The format of a symbolic mode is +-=[ASacDdeIijsTtu].
 .PP
 The operator `+' causes the selected attributes to be added to the
 existing attributes of the files; `-' causes them to be removed; and
@@ -74,10 +74,8 @@ although it can be displayed by
 .BR lsattr (1).
 .PP
 The 'e' attribute indicates that the file is using extents for mapping
-the blocks on disk.  It may not be set or reset using
-.BR chattr (1),
-although it can be displayed by
-.BR lsattr (1).
+the blocks on disk.  It may not be removed using
+.BR chattr (1).
 .PP
 The 'I' attribute is used by the htree code to indicate that a directory
 is being indexed using hashed trees.  It may not be set or reset using 
diff --git a/misc/chattr.c b/misc/chattr.c
index 3d67519..067d0b6 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -82,7 +82,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=AacDdeijsSu] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -99,6 +99,7 @@ static const struct flags_char flags_array[] = {
 	{ EXT2_APPEND_FL, 'a' },
 	{ EXT2_COMPR_FL, 'c' },
 	{ EXT2_NODUMP_FL, 'd' },
+	{ EXT4_EXTENTS_FL, 'e'},
 	{ EXT2_IMMUTABLE_FL, 'i' },
 	{ EXT3_JOURNAL_DATA_FL, 'j' },
 	{ EXT2_SECRM_FL, 's' },
@@ -191,6 +192,7 @@ static int change_attributes(const char * name)
 {
 	unsigned long flags;
 	STRUCT_STAT	st;
+	int extent_file = 0;
 
 	if (LSTAT (name, &st) == -1) {
 		if (!silent)
@@ -199,7 +201,22 @@ static int change_attributes(const char * name)
 		return -1;
 	}
 
+	if (fgetflags (name, &flags) == -1) {
+		if (!silent)
+			com_err (program_name, errno,
+					_("while reading flags on %s"), name);
+		return -1;
+	}
+	if (flags & EXT4_EXTENTS_FL)
+		extent_file = 1;
 	if (set) {
+		if (extent_file && !(sf & EXT4_EXTENTS_FL)) {
+			if (!silent)
+				com_err(program_name, 0,
+				_("Clearing extent flag not supported on %s"),
+					name);
+			return -1;
+		}
 		if (verbose) {
 			printf (_("Flags of %s set as "), name);
 			print_flags (stdout, sf, 0);
@@ -208,30 +225,31 @@ static int change_attributes(const char * name)
 		if (fsetflags (name, sf) == -1)
 			perror (name);
 	} else {
-		if (fgetflags (name, &flags) == -1) {
+		if (rem)
+			flags &= ~rf;
+		if (add)
+			flags |= af;
+		if (extent_file && !(flags & EXT4_EXTENTS_FL)) {
 			if (!silent)
-				com_err (program_name, errno,
-					 _("while reading flags on %s"), name);
+				com_err(program_name, 0,
+				_("Clearing extent flag not supported on %s"),
+					name);
 			return -1;
-		} else {
-			if (rem)
-				flags &= ~rf;
-			if (add)
-				flags |= af;
-			if (verbose) {
-				printf (_("Flags of %s set as "), name);
-				print_flags (stdout, flags, 0);
-				printf ("\n");
-			}
-			if (!S_ISDIR(st.st_mode))
-				flags &= ~EXT2_DIRSYNC_FL;
-			if (fsetflags (name, flags) == -1) {
-				if (!silent)
-					com_err(program_name, errno,
+		}
+		if (verbose) {
+			printf (_("Flags of %s set as "), name);
+			print_flags (stdout, flags, 0);
+			printf ("\n");
+		}
+		if (!S_ISDIR(st.st_mode))
+			flags &= ~EXT2_DIRSYNC_FL;
+		if (fsetflags (name, flags) == -1) {
+			if (!silent) {
+				com_err(program_name, errno,
 						_("while setting flags on %s"),
 						name);
-				return -1;
 			}
+			return -1;
 		}
 	}
 	if (set_version) {
-- 
tg: (5bf3f80..) an/chattr3 (depends on: master)
