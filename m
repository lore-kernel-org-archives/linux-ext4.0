From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] e2fsprogs: added checking for in-inode xattrs
Date: Thu, 5 Aug 2010 17:02:21 -0600
Message-ID: <463F970D-D1D8-48B1-A020-A91334163041@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-85--53052256
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46872 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab0HEXIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 19:08:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-85--53052256
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Add check for in-inode xattr to make sure that it is not referencing an =
offset
that is beyond the end of the inode.

Signed-off-by: Andreas Dilger <andreas.dilger@oracle.com>

Cheers, Andreas



--Apple-Mail-85--53052256
Content-Disposition: attachment;
	filename=e2fsprogs-bad-ininode-ea.patch
Content-Type: application/octet-stream;
	name="e2fsprogs-bad-ininode-ea.patch"
Content-Transfer-Encoding: 7bit

Add check for in-inode xattr to make sure that it is not referencing an offset
that is beyond the end of the inode.

Index: e2fsprogs-1.41.12/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.41.12.orig/e2fsck/pass1.c
+++ e2fsprogs-1.41.12/e2fsck/pass1.c
@@ -319,6 +319,13 @@ static void check_ea_in_inode(e2fsck_t c
 			goto fix;
 		}
 
+		/* Value size cannot be larger than EA space in inode */
+		if (entry->e_value_offs > storage_size ||
+		    entry->e_value_offs + entry->e_value_size > storage_size) {
+			problem = PR_1_INODE_EA_BAD_VALUE;
+			goto fix;
+		}
+
 		hash = ext2fs_ext_attr_hash_entry(entry,
 						  start + entry->e_value_offs);
 
Index: e2fsprogs-1.41.12/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.12.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.12/e2fsck/problem.c
@@ -890,6 +890,11 @@ static struct e2fsck_problem problem_tab
 	     "(size %Is, lblk %r)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* Bad extended attribute value in inode */
+	{ PR_1_INODE_EA_BAD_VALUE,
+	  N_("@a in @i %i is corrupt (@n value)."),
+	  PROMPT_CLEAR, 0},
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
Index: e2fsprogs-1.41.12/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.41.12.orig/e2fsck/problem.h
+++ e2fsprogs-1.41.12/e2fsck/problem.h
@@ -520,6 +520,9 @@ struct problem_context {
 /* EOFBLOCKS flag set when not necessary */
 #define PR_1_EOFBLOCKS_FL_SET		0x010060
 
+/* Bad extended attribute value in inode */
+#define PR_1_INODE_EA_BAD_VALUE		0x010061
+
 /*
  * Pass 1b errors
  */

--Apple-Mail-85--53052256--
