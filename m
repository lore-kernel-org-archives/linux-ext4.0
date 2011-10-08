From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 43/47] e2fsck: Check journal superblock checksum prior to
	recovery
Date: Sat, 08 Oct 2011 00:37:51 -0700
Message-ID: <20111008073751.17888.85896.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34510 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1JHHk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:40:29 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:40:28 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987bsuG171182
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:37:54 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987bqLs018614
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:37:53 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ensure that the journal superblock passes checksum before recovering the
filesystem.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/journal.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)


diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 915b8bb..2ac2e54 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -40,6 +40,53 @@ static int bh_count = 0;
  */
 #undef USE_INODE_IO
 
+/* Checksumming functions */
+int e2fsck_journal_verify_csum_type(journal_t *j, journal_superblock_t *jsb)
+{
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	return jsb->s_checksum_type == JBD2_CRC32C_CHKSUM;
+}
+
+static __u32 e2fsck_journal_sb_csum(journal_t *j, journal_superblock_t *jsb)
+{
+	__u32 crc, old_crc;
+
+	old_crc = jsb->s_checksum;
+	jsb->s_checksum = 0;
+	crc = ext2fs_crc32c_le(~0, (unsigned char *)jsb,
+			       sizeof(journal_superblock_t));
+	jsb->s_checksum = old_crc;
+
+	return crc;
+}
+
+int e2fsck_journal_sb_csum_verify(journal_t *j, journal_superblock_t *jsb)
+{
+	__u32 provided, calculated;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	provided = ext2fs_be32_to_cpu(jsb->s_checksum);
+	calculated = e2fsck_journal_sb_csum(j, jsb);
+
+	return provided == calculated;
+}
+
+errcode_t e2fsck_journal_sb_csum_set(journal_t *j, journal_superblock_t *jsb)
+{
+	__u32 crc;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return 0;
+
+	crc = e2fsck_journal_sb_csum(j, jsb);
+	jsb->s_checksum = ext2fs_cpu_to_be32(crc);
+	return 0;
+}
+
 /* Kernel compatibility functions for handling the journal.  These allow us
  * to use the recovery.c file virtually unchanged from the kernel, so we
  * don't have to do much to keep kernel and user recovery in sync.
@@ -560,6 +607,15 @@ static errcode_t e2fsck_journal_load(journal_t *journal)
 	if (JFS_HAS_RO_COMPAT_FEATURE(journal, ~JFS_KNOWN_ROCOMPAT_FEATURES))
 		return EXT2_ET_RO_UNSUPP_FEATURE;
 
+	/* Checksum v1 and v2 are mutually exclusive features. */
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2) &&
+	    JFS_HAS_COMPAT_FEATURE(journal, JFS_FEATURE_COMPAT_CHECKSUM))
+		return EXT2_ET_CORRUPT_SUPERBLOCK;
+
+	if (!e2fsck_journal_verify_csum_type(journal, jsb) ||
+	    !e2fsck_journal_sb_csum_verify(journal, jsb))
+		return EXT2_ET_CORRUPT_SUPERBLOCK;
+
 	/* We have now checked whether we know enough about the journal
 	 * format to be able to proceed safely, so any other checks that
 	 * fail we should attempt to recover from. */
@@ -627,6 +683,7 @@ static void e2fsck_journal_reset_super(e2fsck_t ctx, journal_superblock_t *jsb,
 	for (i = 0; i < 4; i ++)
 		new_seq ^= u.val[i];
 	jsb->s_sequence = htonl(new_seq);
+	e2fsck_journal_sb_csum_set(journal, jsb);
 
 	mark_buffer_dirty(journal->j_sb_buffer);
 	ll_rw_block(WRITE, 1, &journal->j_sb_buffer);
@@ -667,6 +724,7 @@ static void e2fsck_journal_release(e2fsck_t ctx, journal_t *journal,
 		jsb->s_sequence = htonl(journal->j_transaction_sequence);
 		if (reset)
 			jsb->s_start = 0; /* this marks the journal as empty */
+		e2fsck_journal_sb_csum_set(journal, jsb);
 		mark_buffer_dirty(journal->j_sb_buffer);
 	}
 	brelse(journal->j_sb_buffer);
@@ -843,6 +901,7 @@ static errcode_t recover_ext3_journal(e2fsck_t ctx)
 		ctx->fs->super->s_state |= EXT2_ERROR_FS;
 		ext2fs_mark_super_dirty(ctx->fs);
 		journal->j_superblock->s_errno = 0;
+		e2fsck_journal_sb_csum_set(journal, journal->j_superblock);
 		mark_buffer_dirty(journal->j_sb_buffer);
 	}
 

