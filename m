From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] chattr manpage tidyups
Date: Wed, 27 May 2009 23:23:43 -0500
Message-ID: <4A1E11CF.1000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50965 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZE1EXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 00:23:44 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4S4Njxi014033
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 00:23:45 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4S4NjgG001610
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 00:23:45 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4S4NhvI015628
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2009 00:23:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was prompted by RH BZ#502971

Note that this goes after Aneesh's patch to add chattr +e

Tidy up the chattr(1) manpage to completely document all
available options, and differentiate those which are read-only
early in the manpage as well.

* Remove "I" from settable attribute list
* add "e" to 2nd list of settable attributes & descriptions
* Note that h/E/I/X/Z are readonly
* Correct "H" to "h" for huge file attribute description
* fix long_name for indexed directory in flags_array

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index 078b82c..4a61176 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -41,7 +41,7 @@ static struct flags_name flags_array[] = {
 	{ EXT2_ECOMPR_FL, "E", "Compression_Error" },
 #endif
 	{ EXT3_JOURNAL_DATA_FL, "j", "Journaled_Data" },
-	{ EXT2_INDEX_FL, "I", "Indexed_direcctory" },
+	{ EXT2_INDEX_FL, "I", "Indexed_directory" },
 	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
 	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index e1e6a85..ce6b33b 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -19,17 +19,23 @@ chattr \- change file attributes on a Linux second extended file system
 .B chattr
 changes the file attributes on a Linux second extended file system.
 .PP
-The format of a symbolic mode is +-=[ASacDdeIijsTtu].
+The format of a symbolic mode is +-=[acdeijstuADST].
 .PP
 The operator `+' causes the selected attributes to be added to the
 existing attributes of the files; `-' causes them to be removed; and
 `=' causes them to be the only attributes that the files have.
 .PP
-The letters `acdijsuADST' select the new attributes for the files: 
-append only (a), compressed (c), no dump (d), immutable (i),
+The letters `acdeijstuADST' select the new attributes for the files: 
+append only (a), compressed (c), no dump (d), extent format (e), immutable (i),
 data journalling (j), secure deletion (s), no tail-merging (t), 
 undeletable (u), no atime updates (A), synchronous directory updates (D), 
 synchronous updates (S), and top of directory hierarchy (T).
+.PP
+The following attributes are read-only, and may be listed by
+.BR lsattr (1)
+but not modified by chattr: huge file (h), compression error (E),
+indexed directory (I), compression raw access (X), and compressed dirty
+file (Z).
 .SH OPTIONS
 .TP
 .B \-R
@@ -83,7 +89,7 @@ is being indexed using hashed trees.  It may not be set or reset using
 although it can be displayed by
 .BR lsattr (1).
 .PP
-The 'H' attribute indicates the file is storing its blocks in units of the
+The 'h' attribute indicates the file is storing its blocks in units of the
 filesystem blocksize instead of in units of sectors, and means that the file
 is (or at one time was) larger than 2TB.  It may not be set or reset using
 .BR chattr (1),

