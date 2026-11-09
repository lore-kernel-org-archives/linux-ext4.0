Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243134;
	b=35rdN59/rKFED9oD7MnBOAa5+UlVxJIo5VhmnITgIlKiSgGBWI+V44mNJcjJUflMdiCz
	 PVW6vlbHmqUpVsrz1qunNPTmVV7v/LiF1iwlgnrLqgatRz+T4Ftowi0Rueu4qDYua691y
	 vzjO6pDO5tWJPsb1OxYb+gyupszM7Km06D69cYh9D6cWJCpTPy2VNChzjEpyxGo4jy6id
	 1SIkNgQxS8xPwyMppfZ/Kw6vLtZvuJYAeV9cW29+ENxpA8WvrGRu1xTGshkHUty5z1XDS
	 XxiL6Eka8zbP58kvZRGx14naQuQYuo75gLrp+vBUOiiE3K2fXyc/+EP/THnPj4/gc7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243134;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=GrzNqira/q6xHj3RrsdinaJQRvF/Byboo3gR6uCrG+E=;
	b=hqVLNGgLR9/oYV6YpV2lT1KTy/3R1Bpu4cCkggiIa/izAi6HoV6Q3FQ9ee+mGbqdd3Nc
	 b4YzgujMj3Qs57WUqJ6IcaxeuBa9WQ/hTh5QPtJx2iTXvkDKo+FFo5izq3o3enqUc1iTZ
	 Atq76xYHfgEeFirk7ygcCAhPNTEhnN1PjoMBWby1PtEj/tKuu15tHjZqZUSLP5uM/iate
	 DqBgAqgnrVRJm4xXkGur8FBOFgyACxwaxgyvtHFWKsGXYZ8VYL93rzE4d+6EIcTdy1Th7
	 SHISZAGKB5yXKVx204XcRXrNK3TF2KK203Ttyu9oOatwEEHd+j8MWJ96ziEjWCAgZBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGjbOwfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8BD60A2627;
	Mon,  9 Nov 2026 16:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGjbOwfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423821F008A1;
	Mon,  9 Nov 2026 16:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243133;
	bh=GrzNqira/q6xHj3RrsdinaJQRvF/Byboo3gR6uCrG+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hGjbOwfcJyU+JMK4d7bG3ULOPmM7AEdoPlSbaeZVHBnUWSBzGMucbUY5ACrRkpDPa
	 3yX4P7oUCFwJdknCFD0UaAdHLNr2GDiHQ7+UP445jNlB2F9ysF5cxo8Kdo3n1cmMtp
	 jcH7wUhMGPiV4mgp6hLYBbUPBHiWerB/A9HrgyCwXMproOXwmgBVK4rnTDLQ6koxFM
	 jjKQA1ra12+8b/Cs4evgTwyq7br5BBbI5EEA0IEmt0i1+mW+LnR00dqigiBJBadped
	 YaaTqexZ1fT4hBdG1PUv5TBcEhApg8U1MJTwp4IMUuMz0Uoebudjz8L2TArW1mj9ZL
	 aaLxD2/2s+5fQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:20 +0100
Subject: [PATCH RFC v3 05/14] minix: add minix_inode_block() helper
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-5-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3386; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vP6nHnxbknUQxQ6VYZuCGgOUFmSvhp3UqRPap0CV+EU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CUVfGZt9TebeI23Oix3dJ6k7e9aJpXd/Mj79aYFD
 J9Pb6wP7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIkjbDf+97vuXsfu1vXxuV
 a9vpLnm3Q7vMK0/0td65Ges3GQSeXsrwh8Pg9AqZ958Cl2XVzsqvX/FfZYJfd5PpW733c3NS6+a
 78QIA
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

