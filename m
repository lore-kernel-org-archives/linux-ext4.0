Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243137;
	b=CcHwGCmILCagMg9q64Pl7fj44ptzBpO5XhuH+865u56opQvfjbDirBEe5k4L/BP5+/A1
	 d8Qzr5j6xq+Vd8cusfXjEm/JmtWgM139jkeSWofFjL4aMsAbc/0rjXRURVndLl+YEd8I1
	 8L7aUlmktk4st070AbwONxFwHdHOl5KheiOOPJU0cb8vz7h1LdE8W674h4dw46kLTbJlA
	 ri4ihgZzQ4hZuppKVTbi2/VaDFlQazVUn8Uy6LA2rZwikiMt7wzEqNjH3onocgs+YqYJo
	 PK6QZe9RrVydGdOBPTQadGzz0guQD/Hys+vdq8KJBLHGH2Ddeh3k7Xt9KFPi9AKwZaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243137;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=aVQosNCaKSj9sGFZm3OzSLAh+WDNR5REm0O9s4BZk4Y=;
	b=de45JfjsnMkqXDka1+l0ufF79/WC/A0BUfjPRkh0wwkMsIrRaUptPhQyWTfEsXrKzBlm
	 bCH/rzCwRFqVwdsgY3v3z3B8goK136zXM7XOv69OboU6Vvdd5hYlB1hwoT1lWbtNAxHFg
	 l1BXGFHML000qP/buudcef12JGSxkjyxXvuOM6/elWV8KPAC/9Hr0xtAStAhbvhJk1kic
	 hrof1KWMZ6z1UKm79rxCfYVcMd7icIwMg5y5qA9BWo51lWKcq/DpkohFTMqzwqK0fy/nX
	 jXmTdGEWTGWJbQXJfIJ+mgVowpNB7pcs7+VR4nmqb2S+5cpiL3ykghfXK2kj/0pI5WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nzOE4hov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F2A606EE84;
	Mon,  9 Nov 2026 16:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nzOE4hov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9911F008A2;
	Mon,  9 Nov 2026 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243136;
	bh=aVQosNCaKSj9sGFZm3OzSLAh+WDNR5REm0O9s4BZk4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nzOE4hovffUMFgT4RJ0tXlOkENNLdti+iPp941+F8RHY/U6kd46i3/BaPMyB/CVpr
	 lapUmjIVHd9NHmKN7uj6tfEaWfOM81dd7SqIPHWO+wIZdiG+7MkQ0yC+ahl7CDrrz8
	 ToVh3lxCLhBEd+wJTigX1JgRXgi0lXs3iclhvoV1yr9uojMxSo8CFW5wa8a/PosFxh
	 aDBoI1iIgLmORWl3mduc0sHIxnI2OfnuVs/LmKlbzL/bmeaaDkW8aPcuZ6XrTRvyLe
	 FyJAzXi+m8DvmirmnPZgXoqVw8ugNXtxmtkdHuAkqxc7xAmiQNdQwLhTzvEvokq5Ez
	 4bBqXvpAyKE4g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:21 +0100
Subject: [PATCH RFC v3 06/14] minix: don't read the inode block in
 minix_sync_inode_metadata()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-6-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1762; i=brauner@kernel.org;
 h=from:subject:message-id; bh=i0iFIRlfPbgkN3WC6uE5i+bRrUzqXZsZa3h0C0TGQr4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CXtWDZT7J7+1Uiz8/1XVjMrCSu41mzy/rF48cP0E
 xX7285IdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEykaA/DX4nDqe5hJ+WZ7gmH
 7BeJY1Jkd7pZaip4YcrvOS9DK/gj3BgZOutnLWdbq2La0Rk063vVhRVXjnQZ9ClFt0muiLHY1dr
 GBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

minix_sync_inode_metadata() looks the inode block up with
minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
it isn't cached. But a block that isn't cached is neither dirty nor
under writeback, so there's nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/minix/inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 670179173645..756bef4dc832 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -702,24 +702,24 @@ static int minix_sync_inode_metadata(struct inode *inode,
 {
 	int err = 0;
 	struct buffer_head *bh;
-	void *raw_inode;
+	int block;
 
-	if (INODE_VERSION(inode) == MINIX_V1)
-		raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
-	else
-		raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
-	if (!raw_inode)
+	block = minix_inode_block(inode->i_sb, inode->i_ino);
+	if (!block)
 		return -EIO;
 	err = mmb_sync(&minix_i(inode)->i_metadata_bhs);
 	if (err)
-		goto out;
+		return err;
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (!bh)
+		return 0;
 	sync_dirty_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		printk("IO error syncing minix inode [%s:%08llx]\n",
 			inode->i_sb->s_id, inode->i_ino);
 		err = -EIO;
 	}
-out:
 	brelse(bh);
 	return err;
 }

-- 
2.53.0

