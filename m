Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280534;
	b=1P+PRUv1Eo4qOz9/zZaKGu4X6whHvE7L4lI/48mQ7XUIaiqVx4Hs2EQMdoqo3LIYh5Fk
	 gg+3DCfw4ycqpLC1HazsukyPGufBrCBonaxpSuVv+fsg4IvaUhKQilXfLy6R7VoLAQ7A/
	 shfQ8Ux7bfGQUhh+UutqXPkJaCTpzf+Zls65h22QlbBw2CJCYWqFM5tudXmuU0czM/ZfN
	 D2EVzuxY+E4stPliByr9NkagP4sRAoV9pmASH6OMTFGrAAsQuPV1bbM30GIy6nRyf5aa2
	 /xKr5Du+MqWAYsw7hno0ke/VlWFFlLUD0ormOVQqnjzcnRcEDtYO436p0O/LhCfMa8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280534;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=XRpoDV8EGxtykVJ9uEFBsO+MiASiz3bOI80p3A3K8Xg=;
	b=qNVgO/tYOoX6/O6tn+0nKR+LwEOc+cMVUv1xShKpbJ7H4W/3oZAEv9vYtel7c/FENoBH
	 FJMGnnC/UCZxkevrqeTLkRFGIzqLuBhj2uk1CDYPrQW8MT8JsZyDvJdfMWxH+kt1YfTNp
	 uUUPKrDMVP6VqXzSHSTrhsj80GoyMVAuwCPvQFQqbIsgDVDBj+hYg6LolcqPoEdMJgVMv
	 6VUIhpE5X/yEkn3fhPm+3n9DUamIdWq8taesWwtayYTOgN9Ee+HR76ATKGKSTN7qlcAE+
	 85NIV9h4vBSHPYuOO77qE6OnfdX3S/d9Z4v01d0qoG50Z86VU2BubQMT8jAlhechOhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dGnZk7zj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEF7606A31A;
	Thu, 29 Oct 2026 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dGnZk7zj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149DA1F01825;
	Thu, 29 Oct 2026 13:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280533;
	bh=XRpoDV8EGxtykVJ9uEFBsO+MiASiz3bOI80p3A3K8Xg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dGnZk7zjYZf0q4+iD8P3Jaofw3KJKEBoE3nvZZNHperoZz3yIm4+viDpKrtyjcJTu
	 ONccwwMtpYjdSY1LDXnT/733IxnxA1L/GHljmmAj4JmfV0tkTYV0rRv8phYynX4z5c
	 0XskEA61bcTF2LUe6tb76v7kAJFcDmCjX7PTF9deo/M8g/lilQAsxTmBBy4PnVdv2g
	 FYdsWO0eV1FER/uh3RaV0VcJgN1xUtVC1qTnfpPfAxbVPZu28iPazK13bWXGREBo8q
	 7A364B5i8EJVzbUTGKz1jcbKsgiyrLnb60IvU6XNAb3rTBnTt4ZDqinzYEWOPg/fLu
	 SSEdufPA69atg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:20 +0100
Subject: [PATCH RFC 5/9] minix: add minix_inode_block() helper
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-5-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3348; i=brauner@kernel.org;
 h=from:subject:message-id; bh=S67wcWhcYbeMtBR8hAoxyvBTIt8tn+5zEM5Zq3xI5D4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vxftvXAyrMT/y373PTmJ08Z94SrN+p5X7+509nOm
 8vlyTaNu6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiidaMDC1M98z5J1++NXfO
 BMFTTSUXnws17Dc6/NbjcGPp7BnKs2cxMnxO2Bp7wiNAbnpsgujdjvwn2U8nfnm6e8/xsppo1pm
 JuvwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Move the lookup of the block that holds an inode out of
minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
minix_sync_inode_metadata() is going to use it to find the block
without reading it from disk.

No functional changes.

Cc: stable@vger.kernel.org # v7.3
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

