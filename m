From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 14/23] ext4: Add checksums to the MMP block
Date: Tue, 13 Dec 2011 16:47:51 -0800
Message-ID: <20111214004751.28243.14984.stgit@elm3c44.beaverton.ibm.com>
References: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37026 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab1LNAs5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 19:48:57 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 17:48:55 -0700
In-Reply-To: <20111214004613.28243.54122.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Compute and verify a checksum for the MMP block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/ext4/ext4.h |    3 +++
 fs/ext4/mmp.c  |   44 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 42 insertions(+), 5 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ae71af3..f6bf9d0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2378,6 +2378,9 @@ extern int ext4_bio_write_page(struct ext4_io_submit *io,
 
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
+extern void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp);
+extern int ext4_mmp_csum_verify(struct super_block *sb,
+				struct mmp_struct *mmp);
 
 /* BH_Uninit flag: blocks are allocated but uninitialized on disk */
 enum ext4_state_bits {
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 7ea4ba4..142e9d7 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -6,12 +6,45 @@
 
 #include "ext4.h"
 
+/* Checksumming functions */
+static __u32 ext4_mmp_csum(struct super_block *sb, struct mmp_struct *mmp)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int offset = offsetof(struct mmp_struct, mmp_checksum);
+	__u32 csum;
+
+	csum = ext4_chksum(sbi, sbi->s_csum_seed, (char *)mmp, offset);
+
+	return cpu_to_le32(csum);
+}
+
+int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	return mmp->mmp_checksum == ext4_mmp_csum(sb, mmp);
+}
+
+void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
+{
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	mmp->mmp_checksum = ext4_mmp_csum(sb, mmp);
+}
+
 /*
  * Write the MMP block using WRITE_SYNC to try to get the block on-disk
  * faster.
  */
-static int write_mmp_block(struct buffer_head *bh)
+static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
 {
+	struct mmp_struct *mmp = (struct mmp_struct *)(bh->b_data);
+
+	ext4_mmp_csum_set(sb, mmp);
 	mark_buffer_dirty(bh);
 	lock_buffer(bh);
 	bh->b_end_io = end_buffer_write_sync;
@@ -59,7 +92,8 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	}
 
 	mmp = (struct mmp_struct *)((*bh)->b_data);
-	if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC)
+	if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC ||
+	    !ext4_mmp_csum_verify(sb, mmp))
 		return -EINVAL;
 
 	return 0;
@@ -120,7 +154,7 @@ static int kmmpd(void *data)
 		mmp->mmp_time = cpu_to_le64(get_seconds());
 		last_update_time = jiffies;
 
-		retval = write_mmp_block(bh);
+		retval = write_mmp_block(sb, bh);
 		/*
 		 * Don't spew too many error messages. Print one every
 		 * (s_mmp_update_interval * 60) seconds.
@@ -200,7 +234,7 @@ static int kmmpd(void *data)
 	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
 	mmp->mmp_time = cpu_to_le64(get_seconds());
 
-	retval = write_mmp_block(bh);
+	retval = write_mmp_block(sb, bh);
 
 failed:
 	kfree(data);
@@ -299,7 +333,7 @@ skip:
 	seq = mmp_new_seq();
 	mmp->mmp_seq = cpu_to_le32(seq);
 
-	retval = write_mmp_block(bh);
+	retval = write_mmp_block(sb, bh);
 	if (retval)
 		goto failed;
 

