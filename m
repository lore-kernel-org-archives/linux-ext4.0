Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243123;
	b=l+u9hvU+UjGqC7CZ/2WkZUExkt6ZJEpRcC1JS6zyiviCxbCQL38HHy01u6s5g7BquRx8
	 K7ahsrwXHbc36EcP3cPMtfOLc8lsQr63yqb5+rgBAMKTm/jexZi3bnYuRvrHLJZwJlcGV
	 R9N51GA/XlBhVfFRnvxfbgK8Yd6pZ2c62HosvhFwpoeBfCVvyysvfmtTSHwoEU96FNcij
	 6JdCEiGa7s/w4/uPtKKdhvL5CSa8gO9eo+m6IQ7bcI/mOHDTfuJ2L2lY1432T8GUlC3SY
	 7u57302uxdqfu9FBQ8y356O4qVmkx1Hzy09JA2fnZSs8e1PFhjmzw6htC+vxkDYKHyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243123;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=2bJ6VrqB2zZhUNG+i8RcuajIdalPNNO6IGi4chnMNtg=;
	b=I9lFJ/Ds5S0L2dzPNMLpjsIbaUXP5oHWswK8O3xWg1x9L4VTR3D/gzuPx2s7KkIgmWxp
	 viIp2pQUIcSSbhXvHeUx8+/qhiUaZ06fpGLIBSU0AGMoRJ3f4SPP4S+YogO4+GYrBwlqA
	 LtFF8MHAXkitpQivFAM5dQvfm/crpxjm9aTgbkPNeSr+gn5UjD8OpgIysxh4iOu8WPKUQ
	 VwjfDoz2WTP23+oEH9fhGjZDT6v4ruVOT8hsNEL2WX/lgQ/bQQkfRmvtmvbLrrpIoPRW6
	 2mLitbu62GBZ6yX0cr8JPSbwaJtlTSWwi8OwAmqjU3N9vscA6tK4RNyYpmpGKI99h2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIkBZAr9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68757606EEA7;
	Mon,  9 Nov 2026 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIkBZAr9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A116D1F0089F;
	Mon,  9 Nov 2026 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243122;
	bh=2bJ6VrqB2zZhUNG+i8RcuajIdalPNNO6IGi4chnMNtg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mIkBZAr9LVw3IVGmyQVm8N07rbxmh6YrYcp+QupJrHuOk8gGFn97YlFaqeLbo5kBe
	 EZdwK1F5aMlwCuAxV4CHjk6inGK4tDa/VmRtXKGCY4F/QXSD3j3Vb1BPoIeqjFmEI5
	 FQzoe519+/9UCf8J76HGTRo/fN4ofmuY88nMpyxB5diWf7m4RquPfJYBD+FrbkeO+4
	 rb0u9jzmZLYSiQxxBD99nlY1+Yd38c6kwqWIvp8Ow74lS+99EjLminTG2NotIs6y7e
	 qnTxmB3DPA0rgumJx1siY/SioHf2FF+qv+YEDVRHf6Jmf+Vx5fuCl8Jhsm41ahAzqy
	 4x5FaR5uclSZw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:17 +0100
Subject: [PATCH RFC v3 02/14] ext2: don't read the inode block in
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-2-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1994; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Vm+qBT4Sj7DybZDPAhHwJuIQpPIcVpgGWxNSIBV/EpU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CV+9a2aauKBDJuJN9tLE3PzZtz4mGX2Z6H1H2aje
 YyeXFpfO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbycx8jw7Vuz6TXJ+yE1y+L
 fPNecI7Q6jNPDBdqCX/zP2tUtcHqoQLDPxvO7eop721ypbvVNtbtLLvLltgiZ2qq8CrstVez/LU
 oBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext2_sync_inode_metadata() looks the inode block up with
ext2_get_inode() which reads it from disk if it isn't cached. But a
block that isn't cached is neither dirty nor under writeback, so there's
nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead, the way fat_sync_inode_metadata()
already does.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index aecd8528ea36..9261b666d043 100644
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

