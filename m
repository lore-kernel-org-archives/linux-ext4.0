From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] add HUGE_FILE_FL to lsattr
Date: Fri, 25 Jul 2008 03:03:34 -0400
Message-ID: <20080725070334.GT5346@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:50172 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYGYHDi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2008 03:03:38 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6P73bYM008505
	for <linux-ext4@vger.kernel.org>; Fri, 25 Jul 2008 00:03:37 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4J00401VIOH300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 25 Jul 2008 00:03:37 -0700 (PDT)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add flags to lsattr for HUGE_FILE_FL.
Document both the extent and huge file flags for chattr.1.in.

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-cfs/lib/e2p/pf.c
===================================================================
--- e2fsprogs-cfs.orig/lib/e2p/pf.c
+++ e2fsprogs-cfs/lib/e2p/pf.c
@@ -28,7 +28,6 @@ static struct flags_name flags_array[] =
 	{ EXT2_SECRM_FL, "s", "Secure_Deletion" },
 	{ EXT2_UNRM_FL, "u" , "Undelete" },
 	{ EXT2_SYNC_FL, "S", "Synchronous_Updates" },
-	{ EXT2_DIRSYNC_FL, "D", "Synchronous_Directory_Updates" },
 	{ EXT2_IMMUTABLE_FL, "i", "Immutable" },
 	{ EXT2_APPEND_FL, "a", "Append_Only" },
 	{ EXT2_NODUMP_FL, "d", "No_Dump" },
@@ -40,10 +39,12 @@ static struct flags_name flags_array[] =
 	{ EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
 	{ EXT2_ECOMPR_FL, "E", "Compression_Error" },
 #endif
+	{ EXT2_INDEX_FL, "I", "Indexed_direcctory" },
 	{ EXT3_JOURNAL_DATA_FL, "j", "Journaled_Data" },
-	{ EXT2_INDEX_FL, "I", "Indexed_direcctory" }, 
 	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
+	{ EXT2_DIRSYNC_FL, "D", "Synchronous_Directory_Updates" },
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
+	{ EXT4_HUGE_FILE_FL, "H", "Huge_File" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
 	{ 0, NULL, NULL }
 };
Index: e2fsprogs-cfs/misc/chattr.1.in
===================================================================
--- e2fsprogs-cfs.orig/misc/chattr.1.in
+++ e2fsprogs-cfs/misc/chattr.1.in
@@ -72,6 +72,19 @@ set or reset using 
 although it can be displayed by
 .BR lsattr (1).
 .PP
+The 'e' attribute indicates that the file is using extents for mapping
+the blocks on disk.  It may not be set or reset using
+.BR chattr (1),
+although it can be displayed by
+.BR lsattr (1).
+.PP
+The 'H' attribute indicates the file is storing its blocks in units of the
+filesystem blocksize instead of in units of sectors, and means that the file
+is (or at one time was) larger than 2TB.  It may not be set or reset using
+.BR chattr (1),
+although it can be displayed by
+.BR lsattr (1).
+.PP
 The 'I' attribute is used by the htree code to indicate that a directory
 is being indexed using hashed trees.  It may not be set or reset using 
 .BR chattr (1),

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

