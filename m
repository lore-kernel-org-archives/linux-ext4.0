Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243119;
	b=A7WiwvChtxeB3GIpUxTIGzWmYZR7VfKVnlS6873Yh/Zyp9dkNI0pPgKVbKbwlIhIrEXn
	 d6Q7mOhx01UCSLUW08gJq1EX3kHz8X+k996bRqrZBxxvDb4RYQAQ+Am6D75kE20YKTkaq
	 ErHyn0YYSycqEiA+C+cUrEuJfejSL4IlzVUzDMgD+tWEzRVlMj0BJaQLUJboKZ/gybhLW
	 SKHhnmyxuNG1fozOS+KqxgF9dwh4B3j1YOys+VFc7VQk1lOZ5iYJzBXogib+Kdh4vMlkP
	 4WRoTu2ifqZTTRYpKr1KVR+KjHnApVxPUCqIs5zH2tbgWEduzlyJoaSJyy/NRw3sBOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243119;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=pA4I5pMv7eSOxUKCvZwuj5uEQIIVeQMZP51qCWZFIPo=;
	b=BQEhlB7SITvFuu86prh+f2kY5jMcMqbLwZSffYSCwvTwWHMF793E9KzBhl5NvbPFqXpb
	 nKxCw/QwMLScC/RiWd5enhmqOTPmVhzlSimvy9gpKpOJ2Py7bFpkUSqIN9C1lwc3lpTcH
	 dxYe3ZsRCX+uhUy7oi9WDLF+JxA2DwbwIgipcR2+wou8bBNmr2hPSulHoyDB8oX57sHDG
	 Z0kK5CHhJ6t/TJA347dcavZXs0Lj33HvUeeZ31fuun1UjsuOviCtr6rWOuxA6fCx9SOCz
	 1Bu/fNWRxEyG/fUdaw0mcWrB7pxaP7OMh2iiIWXOI5R8QZY5CWC3g/r72N4ORG+V13g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jlzwtRRR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872B3606EE9D;
	Mon,  9 Nov 2026 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jlzwtRRR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8C71F008A5;
	Mon,  9 Nov 2026 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243119;
	bh=pA4I5pMv7eSOxUKCvZwuj5uEQIIVeQMZP51qCWZFIPo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jlzwtRRR3q9okEX+mwcPlcKYjg4j9tqdJCHP+7hL9CtPEHmgeSWnfWEsMiLShPvt7
	 qwHSx0YuBQKd4ZxBOi2B3inF0RFLJURqife0xT3N+HjDxBGucx8IwjAPjjO0skBaVE
	 /XlpiGG9EakjCM0vjlm4I//glNk9y6UgUo8rtPhYw/bAfVqHToeTdoEXE4JNwrjxrr
	 of5wIE93QEZthEDEKFdoZ3A/xejlIEW+Py8JXHZZ1KNtKVxfcIU2MgLJ31W14Qi+G5
	 Biuq9kciXEHehj2J8JowlWrf8REno2e7CoDrnjRTbcrzR0d7LyqLon7feLnyqEWILV
	 tMUNJFLykDnMA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:16 +0100
Subject: [PATCH RFC v3 01/14] ext2: add ext2_inode_block() helper
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-1-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
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
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CWqHrh21Z/3bDq+CmsFzGb2t716qvV46aRqjuPHU
 qdIxHEIdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEuJLhv+eGyC/nz5h9v6ya
 yX+Yb6PO2bjpd776lxV/uTHhYbjBxWhGho62TeZay/asvf5zynVB9Z1r+F5+d1vD5HGpln93CH+
 8DDMA
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

