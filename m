From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] return status from chattr
Date: Thu, 20 Sep 2007 12:57:14 -0500
Message-ID: <46F2B47A.1070902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbXITR5S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 13:57:18 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l8KHvG0B015742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2007 13:57:16 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8KHvGSt019188
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2007 13:57:16 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8KHvFYj001326
	for <linux-ext4@vger.kernel.org>; Thu, 20 Sep 2007 13:57:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is for RH bug #180596, Chattr command doesn't provide expected 
exit code in case of failure.

(trying to clear out an e2fsprogs bug backlog, can you tell?)  :)

This is a little funky as a result of the man page saying that
links encountered on recursive traversal are (silently?) ignored.

I changed this a bit so that if it's explicitly listed on the
commandline, the link itself gets chattr'd.  I'm not quite sure 
what is intended here; that the links are not *followed* or
that they are not chattr'd?  Seems a little odd to me.

I tried to follow the way other recursive commands work, for example
chmod -R, and carry on in the face of any errors.  If any error
was encountered, exit with an error.  If no errors, exit 0.

Also, if both flags and -v (version) are specified, and the flag 
set encounters an error, the version set is not attempted.  Is this 
ok or should both commands be tried?

Finally, I'm curious, the utility ignores anything that's not a link,
regular file, or dir, but the kernel code doesn't have these checks.
Should it?

Comments?

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>


Index: e2fsprogs-1.40.2/misc/chattr.c
===================================================================
--- e2fsprogs-1.40.2.orig/misc/chattr.c
+++ e2fsprogs-1.40.2/misc/chattr.c
@@ -182,7 +182,7 @@ static int decode_arg (int * i, int argc
 
 static int chattr_dir_proc (const char *, struct dirent *, void *);
 
-static void change_attributes (const char * name)
+static int change_attributes (const char * name, int cmdline)
 {
 	unsigned long flags;
 	STRUCT_STAT	st;
@@ -190,19 +190,20 @@ static void change_attributes (const cha
 	if (LSTAT (name, &st) == -1) {
 		com_err (program_name, errno, _("while trying to stat %s"), 
 			 name);
-		return;
+		return -1;
 	}
-	if (S_ISLNK(st.st_mode) && recursive)
-		return;
 
-	/* Don't try to open device files, fifos etc.  We probably
-           ought to display an error if the file was explicitly given
-           on the command line (whether or not recursive was
-           requested).  */
-	if (!S_ISREG(st.st_mode) && !S_ISLNK(st.st_mode) &&
-	    !S_ISDIR(st.st_mode))
-		return;
+	/* Just silently ignore links found by recursion;
+	   not an error according to the manpage */
+	if (S_ISLNK(st.st_mode) && !cmdline)
+		return 0;
 
+	/* Don't try to open device files, fifos etc. */
+	if (!S_ISREG(st.st_mode) && !S_ISLNK(st.st_mode) &&
+	    !S_ISDIR(st.st_mode)) {
+		com_err (program_name, EINVAL, _("for file %s"), name);
+		return -1;
+	}
 	if (set) {
 		if (verbose) {
 			printf (_("Flags of %s set as "), name);
@@ -212,10 +213,11 @@ static void change_attributes (const cha
 		if (fsetflags (name, sf) == -1)
 			perror (name);
 	} else {
-		if (fgetflags (name, &flags) == -1)
+		if (fgetflags (name, &flags) == -1) {
 			com_err (program_name, errno,
 			         _("while reading flags on %s"), name);
-		else {
+			return -1;
+		} else {
 			if (rem)
 				flags &= ~rf;
 			if (add)
@@ -227,25 +229,32 @@ static void change_attributes (const cha
 			}
 			if (!S_ISDIR(st.st_mode))
 				flags &= ~EXT2_DIRSYNC_FL;
-			if (fsetflags (name, flags) == -1)
+			if (fsetflags (name, flags) == -1) {
 				com_err (program_name, errno,
 				         _("while setting flags on %s"), name);
+				return -1;
+			}
+
 		}
 	}
 	if (set_version) {
 		if (verbose)
 			printf (_("Version of %s set as %lu\n"), name, version);
-		if (fsetversion (name, version) == -1)
+		if (fsetversion (name, version) == -1) {
 			com_err (program_name, errno,
 			         _("while setting version on %s"), name);
+			return -1;
+		}
 	}
 	if (S_ISDIR(st.st_mode) && recursive)
-		iterate_on_dir (name, chattr_dir_proc, NULL);
+		return iterate_on_dir (name, chattr_dir_proc, NULL);
 }
 
 static int chattr_dir_proc (const char * dir_name, struct dirent * de,
 			    void * private EXT2FS_ATTR((unused)))
 {
+	int err;
+
 	if (strcmp (de->d_name, ".") && strcmp (de->d_name, "..")) {
 	        char *path;
 
@@ -253,11 +262,13 @@ static int chattr_dir_proc (const char *
 		if (!path) {
 			fprintf(stderr, _("Couldn't allocate path variable "
 					  "in chattr_dir_proc"));
-			exit(1);
+			return -1;
 		}
 		sprintf (path, "%s/%s", dir_name, de->d_name);
-		change_attributes (path);
+		err = change_attributes (path, 0);
 		free(path);
+		if (err)
+			return -1;
 	}
 	return 0;
 }
@@ -266,6 +277,7 @@ int main (int argc, char ** argv)
 {
 	int i, j;
 	int end_arg = 0;
+	int err, retval = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -303,7 +315,10 @@ int main (int argc, char ** argv)
 	if (verbose)
 		fprintf (stderr, "chattr %s (%s)\n",
 			 E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	for (j = i; j < argc; j++)
-		change_attributes (argv[j]);
-	exit(0);
+	for (j = i; j < argc; j++) {
+		err = change_attributes (argv[j], 1);
+		if (err)
+			retval = 1;
+	}
+	exit(retval);
 }
