From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH RESEND] Add extent conversion support to chattr
Date: Tue,  6 Jan 2009 12:07:14 +0530
Message-ID: <1231223834-2785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57196 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZAFGhR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 01:37:17 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id n066bFMf026881
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 12:07:15 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n066Zc6x3674120
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 12:05:38 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id n066bEC8000438
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 17:37:15 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
tg: (8680b4e..) an/chattr3 (depends on: master)
