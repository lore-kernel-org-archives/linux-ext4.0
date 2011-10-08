From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 44/47] e2fsck: Check revoke block checksum during recovery
Date: Sat, 08 Oct 2011 00:37:57 -0700
Message-ID: <20111008073757.17888.62465.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53476 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1JHHjj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Oct 2011 03:39:39 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 01:39:38 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987c0W0094110
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:38:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987bwMP020700
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:59 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the revoke block checksum when recovering the journal.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/recovery.c       |   37 +++++++++++++++++++++++++++++++++++--
 lib/ext2fs/kernel-jbd.h |    4 ++++
 2 files changed, 39 insertions(+), 2 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index b669941..8979193 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -674,8 +674,17 @@ static int do_one_pass(journal_t *journal,
 			err = scan_revoke_records(journal, bh,
 						  next_commit_ID, info);
 			brelse(bh);
-			if (err)
-				goto failed;
+			if (err) {
+				if (err != -EINVAL)
+					goto failed;
+				/*
+				 * Ignoring corrupt revoke blocks is safe
+				 * because at worst it results in unnecessary
+				 * writes during recovery.
+				 */
+				jbd_debug(3, "Skipping corrupt revoke "
+					  "block.\n");
+			}
 			continue;
 
 		default:
@@ -715,6 +724,27 @@ static int do_one_pass(journal_t *journal,
 	return err;
 }
 
+static int jbd2_revoke_block_csum_verify(journal_t *j,
+					 void *buf)
+{
+	struct journal_revoke_tail *tail;
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	tail = (struct journal_revoke_tail *)(buf + j->j_blocksize -
+			sizeof(struct journal_revoke_tail));
+	provided = tail->r_checksum;
+	tail->r_checksum = 0;
+	calculated = ext2fs_crc32c_le(~0, j->j_superblock->s_uuid,
+				      sizeof(j->j_superblock->s_uuid));
+	calculated = ext2fs_crc32c_le(calculated, buf, j->j_blocksize);
+	tail->r_checksum = provided;
+
+	provided = ext2fs_be32_to_cpu(provided);
+	return provided == calculated;
+}
 
 /* Scan a revoke record, marking all blocks mentioned as revoked. */
 
@@ -729,6 +759,9 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	offset = sizeof(journal_revoke_header_t);
 	max = be32_to_cpu(header->r_count);
 
+	if (!jbd2_revoke_block_csum_verify(journal, header))
+		return -EINVAL;
+
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 08479d3..187cb38 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -157,6 +157,10 @@ typedef struct journal_revoke_header_s
 	int		 r_count;	/* Count of bytes used in the block */
 } journal_revoke_header_t;
 
+/* Tail of revoke block, for checksumming */
+struct journal_revoke_tail {
+	__u32		r_checksum;
+};
 
 /* Definitions for the journal tag flags word: */
 #define JFS_FLAG_ESCAPE		1	/* on-disk block is escaped */

