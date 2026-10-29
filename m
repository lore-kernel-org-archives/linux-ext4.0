Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280520;
	b=uAbFm5a/1Ph7rptB94Jhh0E8fNZoVA066U30V1DlxRcciqm8soIj8EO0/wb1PK8VDvlt
	 3svBa/JWzaIMYIOcLN2DtSg9cEIS6eXX7xjQcl4pX9zGqq5m/vwF+MMUPOm1kam4W01AX
	 83okEXfk58xOw9romJ91AomgC52x8E7G6g7j3zy6hQlXGjYOfAL5Woif75P2bKhVL9uix
	 9HPp2Dv3CZca2jmzOCnOxRshZdMBJFRhnU+bO+lH6ogJeyjxJDN4VbDGZRB/JI8LoImQI
	 RIdZZfZlQgYxAVynVOwpyVEvVJOZJpqTsOKNvKfT+7UiYAJS8aZdrwlpPFiNHIbqF/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280520;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=PpNiB5GVoHjObhV2fxgsOVdBov9kV3j8cE5XymCx/GU=;
	b=nwRI6bt8jedS6pje6ovUJ0wTkGK9JGOOGqXTfP1SAQDvVmwFQBctehnWaKn4WBCXwb7F
	 wYpRq5Avo6hzKKQtSb7pajRcwIfB4kzXbOmvm4hLk0qChtfXo2sxx+yctLdxOqGnzSq40
	 zsi1CKUqhKeGmjndHcMRMmPoaA5rWm0f3rdylYFa0XsHKuYgynWJ37ZXi6oEjkxWZMivO
	 Wc1dHunqMTnBDdFEqBt/GQpjRCt80wkEHUhy7hFhNgFvz5CuoCMpWhXvqGwB8mGV13p0u
	 cmsZ7h/Q3bHuYVeZ20V51pne+D3/kPmoRjIpNWKZIZh51G7CSn51X64SfQcv/KsMxAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIdELRhw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A51606A332;
	Thu, 29 Oct 2026 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oIdELRhw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D2F1F031E0;
	Thu, 29 Oct 2026 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280520;
	bh=PpNiB5GVoHjObhV2fxgsOVdBov9kV3j8cE5XymCx/GU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oIdELRhw+g7HrAIAByJpSc3KjtXrOAHkrQ5faHvKT2GWuCH1OfJvbng3UlK4ZC3wN
	 5i5OhL3VHty7hRHKMZHrRx5aZT+59QcJFvYzim9bzksgpoPTTGy8YP2sj9ayF17VYD
	 lRWXu7kHGmSW7UlfQeDlB3qNpJ3B0bZuOw0KqFh39FCRwXwDJMjrGVxJzyLuW4xH2N
	 njEhBN+npiWJsh8gtTKb+3sGqvh8dIhJo6bCcLCezhspY82PLGBruNIk29hcMkYmlj
	 NLJ4F8O3TnVOEtA5WHNQuyTxQORcguxSA13c8IXbYHB+s3973w/9RYapgTzCQ4bad9
	 K5pHC7bZt6c/w==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:16 +0100
Subject: [PATCH RFC 1/9] ext2: add ext2_inode_block() helper
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-1-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2936; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iA6Fno0655/czrhu3JkMVD7dXaj1s+qyRhNXfR8xLAw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vy3cjbb1XsFm1e/le7O9++LO+Sw7PSZW95GMzTr5
 ThvGwcKd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEagXDH/4/8yqtXq+tnunN
 nF/LW7bId2pP6bSlMV/KNjlMv/X6jxYjw6MgqTc9Xz7umsJ2aYlX0bI366Wuv3C6pHmA0SWy76X
 3DTYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Move the lookup of the inode table block that holds an inode out of
ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
use it to find the block without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/inode.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 12ac4cfe1500..940f61a4dde3 100644
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
+		ext2_error(sb, "ext2_get_inode", "bad inode number: %lu",
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

