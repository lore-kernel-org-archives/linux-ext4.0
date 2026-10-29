Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280523;
	b=PVLnZ1y9t5bgYme1K/RnJwOJBJ5o3gqVbwnUKyDt8ernHgrFhUv+hN6iw4Rc0yo+9QCu
	 5bP9zk6GNlZ/w7HhCBxLLsSAe8755/Nbf5GXfgd2iSP0owqztT0j4ArUw/Xebh83ryhpO
	 j2tfpAMuHbU9PunlNQShg5/qS5zpGdxOUlr+59w76wSJ5nkhWZPakm/Uf/WwNNAwkK0+q
	 Pio0MPDETCvqlrPUvtACXecwAYuSqZuClL1srREzJQYPt3h3RXss2IEodvVjDajvePedR
	 f7snGXsjEOPQ9cEacc+NvPrQOWVoMv/dCkyV2qlALDMvq97V4i4b49e9ng4M7aLPeGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280523;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=WOoNtfs12FclpM7unjXnVo//k9+tyhvumTm3nvy94pQ=;
	b=E0/IBZf44nyXZJgPTfwbHNBF+KNqF3dTNZkwf2BMYmGSRGyKOy3jkJA7n9hV72mVzxTT
	 I50d/9n0SWJI24cm5FYhOhh+77rsCxNOnUAOUswgh/w6L8/UTx45ETMnJ2/4SZ/dov2hj
	 H1F4pAGdLgKNSK+K9hef+p4ytKdolzhE6WOCD1/LYwC8znvCYJ/40hbYQLUay4eKbEIi/
	 M5lmiGCff1OHySdBG2j/+9rRHAaHI75KS4Azl+JJv8pbgJFem/nhoZifUwzdFSRL9TaJC
	 xlup1ubGYgmgAFoGaxmZvBTXve8fVxL6fWmiYyccsR7N74HGFvwyQZ5qtP2vw/gimrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JdLlY5WA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DAE606A31D;
	Thu, 29 Oct 2026 13:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JdLlY5WA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4281F01828;
	Thu, 29 Oct 2026 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280523;
	bh=WOoNtfs12FclpM7unjXnVo//k9+tyhvumTm3nvy94pQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JdLlY5WAkTCm4T42gYOxwvW2w97BoAOybrS5v39gARqVOm7x0RPtCCtTxVJfONwAT
	 n/pKeckaGGCtnb1oBvRaDImNugK6losDvIMt0Y8wxJy2SUjrRyWfofi/IIhtpgGhxV
	 kTnhmjMlr6GeUvc11zIBSvcqrR+u0zaniiz25Vm9xA1C/ffveoQ0gVUwwxft174hZB
	 DzrchVadDTdqlVpaJlyGI9a7fyzc6dzOQe/3AtOVmfgi0C+J93+7iwvqlhZ8ga8jUq
	 7UfJAaTj/54MOoXkN3sC3Q6moC1lZt5yPqixd2Kbw5n/m3h3k3mGTsnevOIkMsefY+
	 V2g7plNa8fvqg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:17 +0100
Subject: [PATCH RFC 2/9] ext2: don't read the inode block in
 ext2_sync_inode_metadata()
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-2-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2000; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TEwe0ScWQYuz39fTzFMWk4b/bOxR+/JrHkyp1Ux3qXI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vwnetJO3DqkxT3bUM26ZU8699Pf2x7c5F+z+unFG
 at9JMMndZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEiI3hF/PS558rD5Wcf8/m
 cK3nMFdO3rf+mUvcjrllfFkptCJj+l5Ghn8XNpVs8Gn67Fuw77K27qLFLzwad+k/vJ+ZJT9JKWm
 LMB8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext2_sync_inode_metadata() looks up the inode block with
ext2_get_inode() which reads it from disk if it isn't cached. But a
block that isn't in the buffer cache is neither dirty nor under
writeback. So there's nothing to write or to wait for and reading it in
is pointless.

It's also not something we can afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead, the same way
fat_sync_inode_metadata() already does.

Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 940f61a4dde3..efb50cb48da3 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1586,19 +1586,22 @@ int ext2_write_inode(struct inode *inode, struct writeback_control *wbc)
 int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh;
-	struct ext2_inode *raw_inode = ext2_get_inode(inode->i_sb, inode->i_ino,
-						      &bh);
+	unsigned long block, offset;
 	int err = 0;
 
-	if (IS_ERR(raw_inode))
+	if (ext2_inode_block(inode->i_sb, inode->i_ino, &block, &offset))
 		return -EIO;
 	err = mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
 	if (err) {
 		ext2_error(inode->i_sb, __func__,
 			"Error syncing inode metadata ino=%lu\n",
 			(unsigned long)inode->i_ino);
-		goto out;
+		return err;
 	}
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (!bh)
+		return 0;
 	sync_dirty_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		ext2_error(inode->i_sb, __func__,
@@ -1606,7 +1609,6 @@ int ext2_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 			(unsigned long)inode->i_ino);
 		err = -EIO;
 	}
-out:
 	brelse(bh);
 	return err;
 }

-- 
2.53.0

