From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] lsattr: return error values
Date: Thu, 18 Jun 2009 17:51:07 -0500
Message-ID: <4A3AC4DB.2030609@redhat.com>
References: <4A3AB8AD.6000100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbZFRWvG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jun 2009 18:51:06 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5IMp9X2011032
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2009 18:51:09 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5IMp8bI012310
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2009 18:51:08 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5IMp7HN026784
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2009 18:51:07 -0400
In-Reply-To: <4A3AB8AD.6000100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(hastily redone before I leave for a few days, hope this
is sane, review welcome) :)

lsattr doesn't return an error if you point it at a file that 
doesn't exist.

This is slightly trickier because it can take more than one
file as an arg, but ls seems to report an error if any occurred,
so this does the same, it'll report the last error that was 
encountered.

Addresses-RedHat-Bugzilla: #489841
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/misc/lsattr.c b/misc/lsattr.c

index 254ebb4..15b17ad 100644
--- a/misc/lsattr.c
+++ b/misc/lsattr.c
@@ -74,7 +74,7 @@ static void usage(void)
 	exit(1);
 }
 
-static void list_attributes (const char * name)
+static int list_attributes (const char * name)
 {
 	unsigned long flags;
 	unsigned long generation;
@@ -82,14 +82,14 @@ static void list_attributes (const char * name)
 	if (fgetflags (name, &flags) == -1) {
 		com_err (program_name, errno, _("While reading flags on %s"),
 			 name);
-		return;
+		return -1;
 	}
 	if (generation_opt) {
 		if (fgetversion (name, &generation) == -1) {
 			com_err (program_name, errno,
 				 _("While reading version on %s"),
 				 name);
-			return;
+			return -1;
 		}
 		printf ("%5lu ", generation);
 	}
@@ -101,23 +101,27 @@ static void list_attributes (const char * name)
 		print_flags(stdout, flags, pf_options);
 		printf(" %s\n", name);
 	}
+	return 0;
 }
 
 static int lsattr_dir_proc (const char *, struct dirent *, void *);
 
-static void lsattr_args (const char * name)
+static int lsattr_args (const char * name)
 {
 	STRUCT_STAT	st;
+	int retval = 0;
 
-	if (LSTAT (name, &st) == -1)
+	if (LSTAT (name, &st) == -1) {
 		com_err (program_name, errno, _("while trying to stat %s"),
 			 name);
-	else {
+		retval = -1;
+	} else {
 		if (S_ISDIR(st.st_mode) && !dirs_opt)
-			iterate_on_dir (name, lsattr_dir_proc, NULL);
+			retval = iterate_on_dir (name, lsattr_dir_proc, NULL);
 		else
-			list_attributes (name);
+			retval = list_attributes (name);
 	}
+	return retval;
 }
 
 static int lsattr_dir_proc (const char * dir_name, struct dirent * de,
@@ -155,6 +159,7 @@ int main (int argc, char ** argv)
 {
 	int c;
 	int i;
+	int err, retval = 0;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -192,10 +197,15 @@ int main (int argc, char ** argv)
 	if (verbose)
 		fprintf (stderr, "lsattr %s (%s)\n",
 			 E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	if (optind > argc - 1)
-		lsattr_args (".");
-	else
-		for (i = optind; i < argc; i++)
-			lsattr_args (argv[i]);
-	exit(0);
+	if (optind > argc - 1) {
+		if (lsattr_args (".") == -1)
+			retval = 1;
+	} else {
+		for (i = optind; i < argc; i++) {
+			err = lsattr_args (argv[i]);
+			if (err)
+				retval = 1;
+		}
+	}
+	exit(retval);
 }

