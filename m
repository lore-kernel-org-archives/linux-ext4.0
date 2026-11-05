Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882536;
	b=wZVfttYbigN1fZodtPdmgaR2xNH7ws55AUTumzhRMcPyR6b+5DbftUsJ5CjmesKH9xX1
	 rKKEHZiT8kP+8mhRlcxoFWC4mKeFgRAZ3Xkw1x6S+t0uU/nMd18GjB/k1n0xF/8re4JKR
	 SA3C1v+den76C/mewqawY4eM41NCtrGF0cxBGzeHLZVwS2YS4h5NuJK05SlzWmFXBDs9H
	 BnRkaJMAVfcfu9qCjCs/Mp3Fiqssq8PCKCc263AZetCynIcdV5Fq0ZB5q/6imFQ3HO0J+
	 mpmKwzDgGvBVPUzAnQ/UNWBM77GBsmjp0m05kydizpVA8Eiv/RaTCnVSA+YwTPs44Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882536;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=pA4I5pMv7eSOxUKCvZwuj5uEQIIVeQMZP51qCWZFIPo=;
	b=C7SYfhH1R0UV8oPQocLubdOpcc0Bg+gMTjzdJosD8gzv9EgMMlyY+4YETopPKWzYdvSl
	 kvXfloeKeKhalZK4kir3gPXkbtH9fuFMMRMvB8w7ubktKjsFOh0H6EJchQpTVeKOLKnwg
	 SDQidb/0atJPcQz5Amu5Ch1IrhWkYULWpIYy5W6GVw5Ct9RBS9pwToVTgWo+OkPxE85mF
	 Bnn7mfkiWJvQVNXWWl/xOlADedz3VaVfAvbEI/WK8bHKg16Gs88FKlItvhtd6l2jlvOa5
	 Cw3UfS3no7Wrd5uCGoQlHOPC2z+46l8luIqdYRJ7smQCJQ3d6XyxrstAvdfZnWchGKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQfRgnIt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA11606A334;
	Thu,  5 Nov 2026 12:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZQfRgnIt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E7B1F000C1;
	Thu,  5 Nov 2026 12:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882536;
	bh=pA4I5pMv7eSOxUKCvZwuj5uEQIIVeQMZP51qCWZFIPo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZQfRgnItUTClzEGVSJlonANfbJQWJdB5hool1Xaem2HSk5lHFwfNBt7pJ+YWlbDdI
	 nuwRhRBB8YjtXV7HM2WGpzUiJ4kr7Gt3Bd7ULcv94UM2e8+Hzd8CSRMryBL3ak2uu1
	 tF+Xsu6C7uxiZwfaRsvib1G2h07s7Ji+djphrHg04iwy4ezVMWMvRhfDJqaEOa3dG8
	 nV/gN6sr83qf9HjR7svA6OkWpg83c4379Mhc3FnUqTsjgNiYTsNH/Y4fT9Jxe9TdJe
	 gkHo4dnfxs/YbNsnpjcK4RNmJWvuAqC9MLiuI0HirNNYs7TvDkNN2FXR6yU/dKaUmS
	 vTkKyryjv++XQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:30 +0100
Subject: [PATCH RFC v2 01/13] ext2: add ext2_inode_block() helper
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-1-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2966; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FaUtNYsNGfaVeZJNL7kraN6zpRBiQuc2GYklaVAxQfY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZwYlil7Xfh9wKFDTXP69wmyRs79e7W5m+Hlnvmb/
 p+6HflGsqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAihm8Z/se5WLu9beqrnL/x
 Vl95hcSTf79qL9ySNbkqqObhJcTpoc7IMEWpkc15pUFJRMby38rB8j/FQ1ncUh/7LK/05FHZfi6
 TBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Move the lookup of the inode table block that holds an inode out of
ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
use it to find the block without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/inode.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..aecd8528ea36 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1272,46 +1272,59 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	return 0;
 }
 
-static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
-					struct buffer_head **p)
+/*
+ * Find the inode table block that holds inode @ino and the offset of the
+ * inode in that block.
+ */
+static int ext2_inode_block(struct super_block *sb, ino_t ino,
+			    unsigned long *block, unsigned long *offset)
 {
-	struct buffer_head * bh;
 	unsigned long block_group;
-	unsigned long block;
-	unsigned long offset;
 	struct ext2_group_desc * gdp;
 
-	*p = NULL;
 	if ((ino != EXT2_ROOT_INO && ino < EXT2_FIRST_INO(sb)) ||
-	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count))
-		goto Einval;
+	    ino > le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count)) {
+		ext2_error(sb, __func__, "bad inode number: %lu",
+			   (unsigned long) ino);
+		return -EINVAL;
+	}
 
 	block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
 	gdp = ext2_get_group_desc(sb, block_group, NULL);
 	if (!gdp)
-		goto Egdp;
+		return -EIO;
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
-	offset = ((ino - 1) % EXT2_INODES_PER_GROUP(sb)) * EXT2_INODE_SIZE(sb);
-	block = le32_to_cpu(gdp->bg_inode_table) +
-		(offset >> EXT2_BLOCK_SIZE_BITS(sb));
+	*offset = ((ino - 1) % EXT2_INODES_PER_GROUP(sb)) * EXT2_INODE_SIZE(sb);
+	*block = le32_to_cpu(gdp->bg_inode_table) +
+		(*offset >> EXT2_BLOCK_SIZE_BITS(sb));
+	*offset &= (EXT2_BLOCK_SIZE(sb) - 1);
+	return 0;
+}
+
+static struct ext2_inode *ext2_get_inode(struct super_block *sb, ino_t ino,
+					struct buffer_head **p)
+{
+	struct buffer_head *bh;
+	unsigned long block;
+	unsigned long offset;
+	int err;
+
+	*p = NULL;
+	err = ext2_inode_block(sb, ino, &block, &offset);
+	if (err)
+		return ERR_PTR(err);
 	if (!(bh = sb_bread(sb, block)))
 		goto Eio;
 
 	*p = bh;
-	offset &= (EXT2_BLOCK_SIZE(sb) - 1);
 	return (struct ext2_inode *) (bh->b_data + offset);
 
-Einval:
-	ext2_error(sb, "ext2_get_inode", "bad inode number: %lu",
-		   (unsigned long) ino);
-	return ERR_PTR(-EINVAL);
 Eio:
 	ext2_error(sb, "ext2_get_inode",
 		   "unable to read inode block - inode=%lu, block=%lu",
 		   (unsigned long) ino, block);
-Egdp:
 	return ERR_PTR(-EIO);
 }
 

-- 
2.53.0

