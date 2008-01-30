From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] print "mostly-printable" xattr strings in debugfs
Date: Tue, 29 Jan 2008 21:30:46 -0600
Message-ID: <479FEF66.6040308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbYA3Das (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2008 22:30:48 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m0U3Ulo1013331
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2008 22:30:47 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0U3UlBc003255
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2008 22:30:47 -0500
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m0U3Ukpu020232
	for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2008 22:30:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Taking a cue from getfattr... if a string is "mostly"
printable characters, go ahead & print as a string,
and escape what's left over.

so we get:

Extended attributes stored in inode body: 
  selinux = "system_u:object_r:root_t:s0\000" (28)

instead of:

Extended attributes stored in inode body: 
  selinux = "73 79 73 74 65 6d 5f 75 3a 6f 62 6a 65 63 74 5f 72 3a 72 6f 6f 74 5f 74 3a 73 30 00 " (28)

(selinux includes the trailing null in "len" so it
never prints as a string today)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 
Index: e2fsprogs-1.40.5/debugfs/debugfs.c
===================================================================
--- e2fsprogs-1.40.5.orig/debugfs/debugfs.c
+++ e2fsprogs-1.40.5/debugfs/debugfs.c
@@ -434,19 +434,21 @@ static int list_blocks_proc(ext2_filsys 
 
 static void dump_xattr_string(FILE *out, const char *str, int len)
 {
-	int printable = 1;
+	int printable = 0;
 	int i;
 	
-	/* check is string printable? */
+	/* check: is string "printable enough?" */
 	for (i = 0; i < len; i++)
-		if (!isprint(str[i])) {
-			printable = 0;
-			break;
-		}
+		if (isprint(str[i]))
+			printable++;
+
+	if (printable <= len*7/8)
+		printable = 0;
 
 	for (i = 0; i < len; i++)
 		if (printable)
-			fprintf(out, "%c", (unsigned char)str[i]);
+			fprintf(out, isprint(str[i]) ? "%c" : "\\%03o",
+				(unsigned char)str[i]);
 		else
 			fprintf(out, "%02x ", (unsigned char)str[i]);
 }
