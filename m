From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 45/51] e2fsck: Check revoke block checksum during recovery
Date: Sat, 07 Jan 2012 00:37:44 -0800
Message-ID: <20120107083744.25788.21481.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:34279 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2AGIiB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2012 03:38:01 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 01:38:01 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078bkTO119494
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:37:46 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078biBH026255
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:37:46 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the revoke block checksum when recovering the journal.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/recovery.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)


diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index b669941..60c8ceb 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -715,6 +715,27 @@ static int do_one_pass(journal_t *journal,
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
 
@@ -729,6 +750,9 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	offset = sizeof(journal_revoke_header_t);
 	max = be32_to_cpu(header->r_count);
 
+	if (!jbd2_revoke_block_csum_verify(journal, header))
+		return -EINVAL;
+
 	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
 		record_len = 8;
 

