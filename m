Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882556;
	b=zJWBd5B5ikJ64u3LmCmrOCQtIxd7wGO9GGaK1Ah51ZcCUosur0jWuzD/GK9DAro9jLPU
	 fW1UC8Rvz83BqICMg1QjblKr29jhBZTxGvZxlphV/ioo6uOsynyzHafOxM6PKpxCbLP29
	 R36o3UapuyyjAO5RsqvZHNxKJIdukkrF8rg7vlKdsjogD6rtftq3ZXdwj/clCVMiy1LRg
	 8pB59SgPq2+4h80nE9d6o2Im1MSDu03m5ynN6MBs3Pg8QIQVziHdSu2WkMl4dk3fJML3x
	 zNT0QDPUPsFwwhB/BMLj4nzqBHfxK7fxIiGq3+WtDz+SSHVgiMaQBHJ63Pe3LVrPgLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882556;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=GrzNqira/q6xHj3RrsdinaJQRvF/Byboo3gR6uCrG+E=;
	b=nnR0e9ArQkzUF2AUm3wnRHV++52PeaGsn2hYTDJ02cw9ABnBV8lyuVDtqPf4e2H1GGsF
	 2k/fIhexJsqkrI1HhAO4jr4rk2Wl969Zt9xcbEW+g+HfiwGD4xdNmZlI2fOmt92tFU1AK
	 /FRGnxjAVG45Jd/By3Mxt6Bs650BBKiAEal96mkR64EYJHCJDCvV1FtTi0wbnuxraqQ9h
	 7pvNx5WWTTmOQhXo1CmsePu6sCtNvf6DgeD9s6+4LpZXyzyPBceXcwOOcgRiE2gNkqjGN
	 jN16PViUP2xbNg+oNKI9yfOwGy+ClIzIIsP/Uafiyq9nNGU/rAY2vyn+RrEPQ1XTFJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=el6gG2CF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E5606A330;
	Thu,  5 Nov 2026 12:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=el6gG2CF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6D31F00919;
	Thu,  5 Nov 2026 12:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882555;
	bh=GrzNqira/q6xHj3RrsdinaJQRvF/Byboo3gR6uCrG+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=el6gG2CFcdrXCAeDx2IPQk0/AVofFq09Lvu48SEjZ2RbvD5uoJIPaGhAOxGU/x50t
	 P4zFlWJzPFDTDyDCXfE8vX1o6oA7HmmriHey5gm4Ixy0oHuYIrHLxH9R08mLAqAW68
	 FVMn/nbS6cVb32KJMA4x5jlmi+Q1VxGPYiJA9lNlnAHJT0BQ3IKHu4CgJxc8faR/CV
	 dG/bRKYO5GhlCLfbci7opxY2+vmKqVSj/NAy1pgSV5OeG0kfugL3a82t5H8R++7QAt
	 8mDW9FYSP1uiQYI1lzKoOJ4PJcCJLG4ZN5PTimOUtyPebGYNBLO/FusGDlq2TdLfhu
	 UETPO0TvB89ZQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:36 +0100
Subject: [PATCH RFC v2 07/13] minix: add minix_inode_block() helper
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-work-inode-metadata_writeback-v2-7-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
 linux-ext4@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Namjae Jeon <namjae.jeon@samsung.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3386; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vP6nHnxbknUQxQ6VYZuCGgOUFmSvhp3UqRPap0CV+EU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZxxOba+LrlCOl6FJe/PBI2Pat/ELGREF74WkpbW2
 cnqu3FbRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERuzGb4n/Uz288nXmfDecef
 EZ4RteqFO1MsHrVr7ciPkZd8MqWZl+GfovFJnTOTDO+psEy8XMI2P+3Cs1mZs6y4XpvrC2re41N
 gBwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Move the lookup of the block that holds an inode out of
minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
minix_sync_inode_metadata() is going to use it to find the block
without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/minix/bitmap.c | 37 +++++++++++++++++++++++--------------
 fs/minix/minix.h  |  1 +
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index abec438330a7..deac05472bef 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -103,21 +103,35 @@ unsigned long minix_count_free_blocks(struct super_block *sb)
 		<< sbi->s_log_zone_size);
 }
 
-struct minix_inode *
-minix_V1_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
+/* Return the block that holds inode @ino or 0 if @ino is out of range. */
+int minix_inode_block(struct super_block *sb, ino_t ino)
 {
-	int block;
 	struct minix_sb_info *sbi = minix_sb(sb);
-	struct minix_inode *p;
+	int inodes_per_block;
 
 	if (!ino || ino > sbi->s_ninodes) {
 		printk("Bad inode number on dev %s: %ld is out of range\n",
 		       sb->s_id, (long)ino);
-		return NULL;
+		return 0;
 	}
+	if (sbi->s_version == MINIX_V1)
+		inodes_per_block = MINIX_INODES_PER_BLOCK;
+	else
+		inodes_per_block = sb->s_blocksize / sizeof(struct minix2_inode);
+	return 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
+		 (ino - 1) / inodes_per_block;
+}
+
+struct minix_inode *
+minix_V1_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
+{
+	int block;
+	struct minix_inode *p;
+
+	block = minix_inode_block(sb, ino);
+	if (!block)
+		return NULL;
 	ino--;
-	block = 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
-		 ino / MINIX_INODES_PER_BLOCK;
 	*bh = sb_bread(sb, block);
 	if (!*bh) {
 		printk("Unable to read inode block\n");
@@ -131,19 +145,14 @@ struct minix2_inode *
 minix_V2_raw_inode(struct super_block *sb, ino_t ino, struct buffer_head **bh)
 {
 	int block;
-	struct minix_sb_info *sbi = minix_sb(sb);
 	struct minix2_inode *p;
 	int minix2_inodes_per_block = sb->s_blocksize / sizeof(struct minix2_inode);
 
 	*bh = NULL;
-	if (!ino || ino > sbi->s_ninodes) {
-		printk("Bad inode number on dev %s: %ld is out of range\n",
-		       sb->s_id, (long)ino);
+	block = minix_inode_block(sb, ino);
+	if (!block)
 		return NULL;
-	}
 	ino--;
-	block = 2 + sbi->s_imap_blocks + sbi->s_zmap_blocks +
-		 ino / minix2_inodes_per_block;
 	*bh = sb_bread(sb, block);
 	if (!*bh) {
 		printk("Unable to read inode block\n");
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index db92cf9e0e1b..67d8e2a7dc06 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -47,6 +47,7 @@ void __minix_error_inode(struct inode *inode, const char *function,
 			 unsigned int line, const char *fmt, ...);
 
 struct inode *minix_iget(struct super_block *, unsigned long);
+int minix_inode_block(struct super_block *sb, ino_t ino);
 struct minix_inode *minix_V1_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 struct minix2_inode *minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 struct inode *minix_new_inode(const struct inode *, umode_t);

-- 
2.53.0

