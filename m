From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] e2fsck: Recover revoke blocks on 64bit filesystems correctly
Date: Sat, 08 Oct 2011 00:29:09 -0700
Message-ID: <20111008072909.16622.37880.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34190 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1JHH3Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:29:16 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:29:15 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987TBri414276
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:29:11 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987TBrn005646
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:29:11 -0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the advent of 64bit filesystems, revoke blocks store 64-bit block numbers
instead of 32-bit block numbers.  Therefore we need to be able to handle that
case.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/jfs_user.h |    1 +
 e2fsck/recovery.c |   13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 2bb71c3..9e33306 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -62,6 +62,7 @@ typedef struct {
 #define cond_resched()	do { } while (0)
 
 typedef unsigned int __be32;
+typedef __u64 __be64;
 
 #define __init
 
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index a587bd7..b669941 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -723,17 +723,26 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 {
 	journal_revoke_header_t *header;
 	int offset, max;
+	int record_len = 4;
 
 	header = (journal_revoke_header_t *) bh->b_data;
 	offset = sizeof(journal_revoke_header_t);
 	max = be32_to_cpu(header->r_count);
 
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
+		record_len = 8;
+
 	while (offset < max) {
 		unsigned long blocknr;
 		int err;
 
-		blocknr = be32_to_cpu(* ((__be32 *) (bh->b_data+offset)));
-		offset += 4;
+		if (record_len == 4)
+			blocknr = ext2fs_be32_to_cpu(*((__be32 *)(bh->b_data +
+								  offset)));
+		else
+			blocknr = ext2fs_be64_to_cpu(*((__be64 *)(bh->b_data +
+								  offset)));
+		offset += record_len;
 		err = journal_set_revoke(journal, blocknr, sequence);
 		if (err)
 			return err;

