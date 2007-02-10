From: "Brian D. Behlendorf" <behlendorf1@llnl.gov>
Subject: e2fsprogs coverity patch <cid-9.diff>
Date: Fri, 9 Feb 2007 18:11:44 -0800
Message-ID: <200702100211.l1A2BiQE007552@igsi.llnl.gov>
Cc: linux-ext4@vger.kernel.org, adilger@clusterfs.com,
	behlendorf1@llnl.gov, wartens2@llnl.gov
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nspiron-2.llnl.gov ([128.115.41.82]:20101 "EHLO
	nspiron-2.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbXBJCOv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Feb 2007 21:14:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Lawrence Livermore National Labs recently ran the source code
analysis tool Coverity over the e2fsprogs-1.39 source to see 
if it would identify any significant bugs.  The analysis
turned up 38 mostly minor issues which are enumerated here
with patches.  We went through and resolved these issues
but would love to see these mostly minor changes reviewed
and commited upstream.

Thanks,
Brian Behlendorf <behlendorf1@llnl.gov>, and
Herb Wartens <wartens2@llnl.gov>

-----------------------------------------------------------------------------
Coverity ID: 9: Null Returns

dict_lookup() can potentially return a NULL dnode_t.  It is not
checked in two places in the clone_file() function.  Looks to be
safe to check if n is not NULL.  If n is NULL then point out the
error.

Index: e2fsprogs+chaos/e2fsck/pass1b.c
===================================================================
--- e2fsprogs+chaos.orig/e2fsck/pass1b.c
+++ e2fsprogs+chaos/e2fsck/pass1b.c
@@ -752,19 +752,33 @@ static int clone_file(e2fsck_t ctx, ext2
 		 * them to point to the new EA block.
 		 */
 		n = dict_lookup(&blk_dict, INT_TO_VOIDPTR(blk));
-		db = (struct dup_block *) dnode_get(n);
-		for (ino_el = db->inode_list; ino_el; ino_el = ino_el->next) {
-			if (ino_el->inode == ino)
-				continue;
-			n = dict_lookup(&ino_dict, INT_TO_VOIDPTR(ino_el->inode));
-			di = (struct dup_inode *) dnode_get(n);
-			if (di->inode.i_file_acl == blk) {
-				di->inode.i_file_acl = dp->inode.i_file_acl;
-				e2fsck_write_inode(ctx, ino_el->inode,
-					   &di->inode, "clone file EA");
-				decrement_badcount(ctx, blk, db);
+		if (n) {
+			db = (struct dup_block *) dnode_get(n);
+			for (ino_el = db->inode_list; ino_el; ino_el = ino_el->next) {
+				if (ino_el->inode == ino)
+					continue;
+				n = dict_lookup(&ino_dict, INT_TO_VOIDPTR(ino_el->inode));
+				if (n) {
+					di = (struct dup_inode *) dnode_get(n);
+					if (di->inode.i_file_acl == blk) {
+						di->inode.i_file_acl = dp->inode.i_file_acl;
+						e2fsck_write_inode(ctx, ino_el->inode,
+							&di->inode, "clone file EA");
+						decrement_badcount(ctx, blk, db);
+					}
+				}
+				else {
+					com_err("clone_file", 0,
+						_("internal error; can't find dup_blk for %u\n"),
+						ino_el->inode);
+				}
 			}
 		}
+		else {
+			com_err("clone_file", 0,
+				_("internal error; can't find dup_blk for %u\n"),
+				blk);
+		}
 	}
 	retval = 0;
 errout:
