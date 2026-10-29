Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280527;
	b=xvDoVkYj8aMytr5B1/AYF28h6PUC2D5XU8IEfpFhoxC2Ze6o/HjqnY1E1djA8pqCM/r5
	 tJcIdzh9G+qoVS0Sgya9LtrVmF7DPEzQXkfJXJ2atjjJ5duOLNcDeJuLCwus8FnfnewUN
	 nvLTMlkMYyezQk63TDO9lcUoQAwOU2qMPPOqvF9UWHesuKBlsI5e4wI5oE5CMfnAOZ0Ba
	 pObA9momElJGoQupAWdtIphz+2730ScUn+wgmgXUz6ZgLQgfH84qpiLe0wA0xoe0fbZ3G
	 4TkQa+oeZO0E14YxktbbBmsukm9sKwmLkVqRQ8TG40WBQRZDhu0cJw0IKXkEBwedEfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280527;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=YA+SkQvjjPE6Af+G+8rzq4qym6m5ueAK5A8kZ+nJ7ts=;
	b=r/NT64y74wIsOcFroIQYCJCX0Uzsvfw/NQtXl9Yh98Ci3DoHfxIkoktyNEoQNHhviTvr
	 tAvSg7sU2yXVh54x2gs/kgSlgFAOcWQc74YJ5qmbk1uLd8T9uSKoMdTEEIv4VrgnBXqyI
	 i8OCPIArmgm4I2L3d1JDJFO02VcRASjjfb+oC2xu3svERhphtOAbznQ1IgMXaQS8lYuuB
	 pq6hoMR/C8z0ovekDqRgSmciQHMuUnTemxU/gDv8zvHM9Mwlw4yxJkfIhD7XyIaYZSnK0
	 t7l7J177JskOjtCNzQ8x536ZrQgt+daCdUPYaRWX4stOEtoyKD6QHazwQpMSCEBdk1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rhzwp0FV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF9606A31A;
	Thu, 29 Oct 2026 13:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rhzwp0FV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4B41F031E0;
	Thu, 29 Oct 2026 13:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280527;
	bh=YA+SkQvjjPE6Af+G+8rzq4qym6m5ueAK5A8kZ+nJ7ts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rhzwp0FVw0EAxpZpWn4k2F8bmPpgL0UpEcpL4H6y4YCoxm87SY3URbcWDJbxPDfY5
	 IBCzhcalBIEhE33LXUXnzguekq3rbnbqvu+LERv7CR8LPQqqTCAl9WRhkRzFCOQyLq
	 6jvmE7Aowbk0ws/RQh1Ov0/Mqs66KiFJXoK2KIPZiVBUXwDvVv3FlgPxGC5PXrVgV2
	 4xOwv+aNbQzeSKm3I77Cw+aajmFeLgspwIGacbP55kPrWWS9duwi6RGWWvjD7c3bq7
	 /Umm7YvDLgCUYLz1IWBuRPgm4GEhAZZWTlv1xXRd6dvuvjLTRqIajUuxhQdbXw6Xzt
	 PUXW8lAm9bZ2A==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:18 +0100
Subject: [PATCH RFC 3/9] ext4: add ext4_inode_loc_block() helper
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-3-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2880; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eaL92h59HRVy3sZA+HQXm1SW4UJJjp4vVmaiFDCfXpI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vx38yhTd+XN6yc1v79W1l2oNd2ZLXDTx+MnrPQ/X
 OPYfzRGvqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAii+0Z/mfoZO05oOB/4wOb
 gu6Jkg2KE4WvhU1k+6exI6v/clZZ5CNGhqs6rQ31JXYFMpPE2Vz86zL150u0LCtcvWjBi77vdsl
 1zAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Move the lookup of the inode table block out of
ext4_get_inode_loc_noio() into a helper. ext4_sync_inode_metadata() is
going to use it to find the block without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4d581aa5ee1..b34b99d15db6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5874,16 +5874,14 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 }
 
 /*
- * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
- * It looks up the inode table block in the buffer cache and returns -EAGAIN if
- * the block is not present or not uptodate, without starting any I/O.
+ * Find the inode table block that holds @inode without looking at the block
+ * itself. Fills in iloc->block_group and iloc->offset.
  */
-int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
+static int ext4_inode_loc_block(struct inode *inode, struct ext4_iloc *iloc,
+				ext4_fsblk_t *block)
 {
 	struct super_block *sb = inode->i_sb;
 	struct ext4_group_desc *gdp;
-	struct buffer_head *bh;
-	ext4_fsblk_t block;
 	int inodes_per_block, inode_offset;
 	unsigned long ino = inode->i_ino;
 
@@ -5902,15 +5900,33 @@ int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
 	inode_offset = ((ino - 1) % EXT4_INODES_PER_GROUP(sb));
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
-	block = ext4_inode_table(sb, gdp);
-	if (block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) ||
-	    block >= ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+	*block = ext4_inode_table(sb, gdp);
+	if (*block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) ||
+	    *block >= ext4_blocks_count(EXT4_SB(sb)->s_es)) {
 		ext4_error(sb,
 			   "Invalid inode table block %llu in block_group %u",
-			   block, iloc->block_group);
+			   *block, iloc->block_group);
 		return -EFSCORRUPTED;
 	}
-	block += inode_offset / inodes_per_block;
+	*block += inode_offset / inodes_per_block;
+	return 0;
+}
+
+/*
+ * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
+ * It looks up the inode table block in the buffer cache and returns -EAGAIN if
+ * the block is not present or not uptodate, without starting any I/O.
+ */
+int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
+{
+	struct super_block *sb = inode->i_sb;
+	struct buffer_head *bh;
+	ext4_fsblk_t block;
+	int err;
+
+	err = ext4_inode_loc_block(inode, iloc, &block);
+	if (err)
+		return err;
 
 	bh = sb_find_get_block(sb, block);
 	if (!bh)

-- 
2.53.0

