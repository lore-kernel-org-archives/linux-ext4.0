From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Add extent conversion support to chattr
Date: Fri, 12 Sep 2008 14:34:09 +0530
Message-ID: <1221210249-26484-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35755 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYILJEb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2008 05:04:31 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m8C936Qo014938
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:03:06 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8C94Ges4485338
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:04:16 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8C94FRb003483
	for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2008 19:04:16 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds new option, +e to chattr. The +e option
is used to convert the ext3 format (non extent) file
to ext4 (extent) format. This can be used to migrate
the ext3 file system to ext4 file system.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 misc/chattr.c |   58 +++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/misc/chattr.c b/misc/chattr.c
index 3d67519..7807b9e 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -82,7 +82,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=AacDdijsSue] [-v version] files...\n"),
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
