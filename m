From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/6] debugfs: don't swap htree nodes in-place
Date: Thu, 23 Oct 2014 16:28:44 -0500
Message-ID: <5449730C.90907@redhat.com>
References: <54497296.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaJWV2p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 17:28:45 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLSjCX026560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:28:45 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com [10.11.146.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s9NLSi75006841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2014 17:28:45 -0400
In-Reply-To: <54497296.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

htree_dump_int_node() was swapping htree nodes in-place,
something not done elsewhere, so it made the sparse checker
unhappy.  Just use dedicated variables to hold the 2 needed
(endian-swapped) values.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 debugfs/htree.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4f0118d..866d1c6 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -138,21 +138,20 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 				struct ext2_dx_entry *ent,
 				char *buf, int level)
 {
-	struct ext2_dx_countlimit	limit;
-	struct ext2_dx_entry		e;
+	struct ext2_dx_countlimit	dx_countlimit;
 	struct ext2_dx_tail		*tail;
 	int				hash, i;
+	int				limit, count;
 	int				remainder;
 
-	limit = *((struct ext2_dx_countlimit *) ent);
-	limit.count = ext2fs_le16_to_cpu(limit.count);
-	limit.limit = ext2fs_le16_to_cpu(limit.limit);
+	dx_countlimit = *((struct ext2_dx_countlimit *) ent);
+	count = ext2fs_le16_to_cpu(dx_countlimit.count);
+	limit = ext2fs_le16_to_cpu(dx_countlimit.limit);
 
-	fprintf(pager, "Number of entries (count): %d\n", limit.count);
-	fprintf(pager, "Number of entries (limit): %d\n", limit.limit);
+	fprintf(pager, "Number of entries (count): %d\n", count);
+	fprintf(pager, "Number of entries (limit): %d\n", limit);
 
-	remainder = fs->blocksize - (limit.limit *
-				     sizeof(struct ext2_dx_entry));
+	remainder = fs->blocksize - (limit * sizeof(struct ext2_dx_entry));
 	if (ent == (struct ext2_dx_entry *)(rootnode + 1))
 		remainder -= sizeof(struct ext2_dx_root_info) + 24;
 	else
@@ -160,12 +159,12 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 	    remainder == sizeof(struct ext2_dx_tail)) {
-		tail = (struct ext2_dx_tail *)(ent + limit.limit);
+		tail = (struct ext2_dx_tail *)(ent + limit);
 		fprintf(pager, "Checksum: 0x%08x\n",
 			ext2fs_le32_to_cpu(tail->dt_checksum));
 	}
 
-	for (i=0; i < limit.count; i++) {
+	for (i=0; i < count; i++) {
 		hash = i ? ext2fs_le32_to_cpu(ent[i].hash) : 0;
 		fprintf(pager, "Entry #%d: Hash 0x%08x%s, block %u\n", i,
 			hash, (hash & 1) ? " (**)" : "",
@@ -174,17 +173,19 @@ static void htree_dump_int_node(ext2_filsys fs, ext2_ino_t ino,
 
 	fprintf(pager, "\n");
 
-	for (i=0; i < limit.count; i++) {
-		e.hash = ext2fs_le32_to_cpu(ent[i].hash);
-		e.block = ext2fs_le32_to_cpu(ent[i].block);
+	for (i=0; i < count; i++) {
+		int hash, block;
+
+		hash = ext2fs_le32_to_cpu(ent[i].hash);
+		block = ext2fs_le32_to_cpu(ent[i].block);
 		fprintf(pager, "Entry #%d: Hash 0x%08x, block %u\n", i,
-		       i ? e.hash : 0, e.block);
+		       i ? hash : 0, block);
 		if (level)
 			htree_dump_int_block(fs, ino, inode, rootnode,
-					     e.block, buf, level-1);
+					     block, buf, level-1);
 		else
 			htree_dump_leaf_node(fs, ino, inode, rootnode,
-					     e.block, buf);
+					     block, buf);
 	}
 
 	fprintf(pager, "---------------------\n");
-- 1.7.1

