Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243126;
	b=RlE4jDvbqOBcUiY/LrfrU2Jw8Z9dJHy4GQUKZMnfAbGcSOuNynPVoeMpa0fmDSKRuNkC
	 SL4JBzqfzejE5sJ/Ps6NZbPGA4mlnMJrRg7p5DWnyD6A927tTJ9t/6cWBcGaLEIKECIFP
	 5cXp41bX2lwX96ZlxU2bYFlJ20XqzfT5yX6N3TNTjetK43jckwqD6sio81t+FqtIJM7lG
	 p7ehjpRqHIqt2kNN9djCmEWxKS6qIjbetKEEJD+3whYESz7LNMHRM2IoOXyaZm8tMin2U
	 g0eQwM/pYUP94JD5QjCPiEqkm1gC4gkjLFXSSywwct5K9dbVgxDI4GTq6dVYYb8ANAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243126;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=EQm9jF9j8uBOJBb+Mm2IVK02ojVKWvwxTQhZotZkM+s=;
	b=dMdJkHtRt5MK6ELVyamHQv/O7U6lVIVJ+M9eIn4euoxLS5Yi06xNtAFOO+XUnUrmEAUw
	 yinChPSwe76qhsS+Vg+c4XZ7AVVzN89PTBttXLJ590YggEAz2nLhu5rnLlfG/Fb10M5FK
	 us0/marjsY0SdVxDN+M2LqsZKCNjB9NZO+OZhzQy44+57HmIzrX5QS672N2OGbD93UIZz
	 JREqU52gQXGCbRyvyLoNxqDtyQMRzjg7edXNEYUDOLPYRRKRIVtdams/NVGlayddYTU27
	 TxOA1c9WK9VSolAOMjZa7iS0dj0yvDOffhR1aFB0iQdyC565ZdKVhcXR7UmmGcFc9Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVbfwkJL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88939606EE9D;
	Mon,  9 Nov 2026 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVbfwkJL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2923C1F008A7;
	Mon,  9 Nov 2026 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243126;
	bh=EQm9jF9j8uBOJBb+Mm2IVK02ojVKWvwxTQhZotZkM+s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hVbfwkJLcZW2LEp2RCuYY0U8lQFqSX5fBAB0gczdUtQvFIVjLFiuIvgv4JTst0dg5
	 3ArrkluqTZc/+zzmwSrqpH4ZOJGrxb/sMaR1jTT8HuveaJcD+ZohbTPNEPoeWNna9T
	 VctHkSX6oW+Q7X0SqXUwGXZumAXY4DGibIFvODs1T0VP4dgTcVJNXq/y3wSxNAX7d8
	 gD3NBSTPxsDT6Eu1AnR7REfqASm1YYt+EbF0HxTxNnnadCvdhecRp4ckls99NaS4Xg
	 /w6fDfAdUPCnMhoyfLbtpEXK7qr9LXS7qEGjJkfenHbpewEQqc/ikyfBjQT1ddxn/h
	 9SyEm+ieF2s9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:18 +0100
Subject: [PATCH RFC v3 03/14] ext4: use sb_find_get_block_nonatomic() in
 ext4_get_inode_loc_noio()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-3-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2068; i=brauner@kernel.org;
 h=from:subject:message-id; bh=y/2bLv95o07NiM3dNbGx8CayQRph+jT7KBmU72dJI98=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CXhOfG2jEBxWGfV/L6U31lzVVwWvDXc/tk//YTkA
 uZOqzbHjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIncUWD4n/RrtlSqxOM9t6Nt
 m02y/QRn5/p9u8HJrrNdk/3rIvFlUgz/7M2MExV3MnO9frdx0ddz7yMUWTo/3Dyq9cQkUuHCk4P
 f+QA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext4_get_inode_loc_noio() looks the inode table block up with
sb_find_get_block(). That's the atomic lookup. It serializes against
try_to_free_buffers() with i_private_lock instead of the folio lock and
gives up if the folio is being migrated. So it can report the block as
not cached while it is.

For ext4_fc_snapshot_inode() that only means falling back to a full
commit. But ext4_sync_inode_metadata() is going to use
ext4_get_inode_loc_noio() to find the inode block that fsync() has to
write out and there a dirty block must not be skipped.

ext4_fc_snapshot_inode() is the only caller and it can sleep. It runs
under jbd2_journal_lock_updates() and allocates the snapshot with
GFP_NOFS. So use sb_find_get_block_nonatomic() which takes the folio
lock and waits for the migration instead.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4d581aa5ee1..4484c2383eaf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5876,7 +5876,8 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 /*
  * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
  * It looks up the inode table block in the buffer cache and returns -EAGAIN if
- * the block is not present or not uptodate, without starting any I/O.
+ * the block is not present or not uptodate, without starting any I/O. It may
+ * sleep on the folio lock of the block.
  */
 int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
 {
@@ -5912,7 +5913,7 @@ int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
 	}
 	block += inode_offset / inodes_per_block;
 
-	bh = sb_find_get_block(sb, block);
+	bh = sb_find_get_block_nonatomic(sb, block);
 	if (!bh)
 		return -EAGAIN;
 	if (!ext4_buffer_uptodate(bh)) {

-- 
2.53.0

