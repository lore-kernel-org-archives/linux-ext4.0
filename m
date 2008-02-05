From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] extra checking for in-inode EAs
Date: Tue, 05 Feb 2008 01:01:32 -0700
Message-ID: <20080205080132.GA29177@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:47520 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYBEIBs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 03:01:48 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1581l6c003747
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 00:01:48 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVR00F01A63G100@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 05 Feb 2008 00:01:47 -0800 (PST)
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When investigating the EA problem reported on this list, I noticed that some
of the checks for the in-inode EAs were removed (possibly when the unordered
EAs-in-inode patch was removed).  The following patch returns the checks for
the e_value_offs.  This passes "make check" with the Lustre EA test cases.

A more complete check (not implemented here) would be to ensure that
the EAs don't overlap as is done with the external EAs.  Some extra
whitespace is removed in the first hunk.

Signed-off-by: Andreas Dilger <adilger@sun.com>

--- e2fsck/pass1.c.orig	2008-02-04 10:41:50.000000000 -0700
+++ e2fsck/pass1.c	2008-02-04 17:36:34.000000000 -0700
@@ -268,14 +268,14 @@
 	/* scan all entry's headers first */
 
 	/* take finish entry 0UL into account */
-	remain = storage_size - sizeof(__u32); 
+	remain = storage_size - sizeof(__u32);
 
 	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
 		__u32 hash;
 
 		/* header eats this space */
 		remain -= sizeof(struct ext2_ext_attr_entry);
-		
+
 		/* is attribute name valid? */
 		if (EXT2_EXT_ATTR_SIZE(entry->e_name_len) > remain) {
 			pctx->num = entry->e_name_len;
@@ -293,6 +293,21 @@
 			goto fix;
 		}
 
+		/* check value placement */
+		if (start + entry->e_value_offs > end) {
+			pctx->num = entry->e_value_offset;
+			problem = PR_1_ATTR_VALUE_OFFSET;
+			goto fix;
+		}
+
+		/* check value offset + size */
+		if (start + entry->e_value_offs +
+		    EXT2_XATTR_SIZE(entry->e_value_size) > end) {
+			pctx->num = entry->e_value_size;
+			problem = PR_1_ATTR_VALUE_SIZE;
+			goto fix;
+		}
+
 		/* e_value_block must be 0 in inode's ea */
 		if (entry->e_value_block != 0) {
 			pctx->num = entry->e_value_block;
@@ -310,7 +325,7 @@
 			goto fix;
 		}
 
-		remain -= entry->e_value_size;
+		remain -= EXT2_XATTR_SIZE(entry->e_value_size);
 
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
