Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243143;
	b=elIS2hqmtf2kk8pgzUzSZewWeAXKoqVrayFE6vXRZ/XpqnEhdJUR78TcTdX+KgskhuwM
	 qufhfODgtYZEfn4gIamZx9iurjDUvQuTY/YWIaaJcnlxsbp00s/sTEizpwmrTnYOxo0u9
	 9F9OnPFSu2VizcmutWJOKrb18kt5kYvSmuJ7wOenDJNa/9BmUNXY/QjoewfmjxSK5Gi6Z
	 LbSKscsZhcDjWgGEgZsqT1tbnAThexzlDjNvgLAD6wrPmnx+Sl6YwvU6ssUQnZBoDZA1j
	 E+v14MUOBexLdW5oC7C26pT8+fA/cZ+1XqfIc7A+TQpz4c+iY8tVlVY/rtKctr9S00g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243143;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uq51MUUAmNPFrZxx3InXgsTsHaGuIBJwf1HYCbIU0TQ=;
	b=Qct0OUKu19G5h0HPo2uKxEfoEwxX6TVTCeC7CoM2DbZkRw9EKUO8bpUdM/Y9XxPT5fhI
	 entVl9Xb0g++6G6d1mDxTONLge7E6Dtjihv6RQr2qoYG2ugSQDLrd3ZsJVVA4rtbTo2X8
	 vKVNbJAqf+fXhRajXNa0UQ0pTPjGlP282Uzl/JzJn9IXMbSoTbkWOkO/g11E3zVjzWBhg
	 wjicE2/hQiJ8K3uS/nGLWLX89rDOksVK3WhMQ6AOpqCIwuBA+LPFkCJCIlc+h7/f03DVW
	 6gun6alRGWS3wKSEf0enoAb3nCtZ3iSv7cRX1pvu4IO6qlRoL+7uqpmm58rAC9UdjNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSrdk0tV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73733606EE9D;
	Mon,  9 Nov 2026 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SSrdk0tV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725BA1F00904;
	Mon,  9 Nov 2026 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243143;
	bh=uq51MUUAmNPFrZxx3InXgsTsHaGuIBJwf1HYCbIU0TQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SSrdk0tV2OCAlfeTIVpYAeKa0hFIEq+wlRs1aX9VVEHRZEFCVauGcQOiaSsJ45rNi
	 uPxby3F8a/+gxCrn/69d+qka08xcUn9HGE5P3VyHuwqrvmucuNM00lpZDQBOkS/2cq
	 SDS5v+LLMKi/rdABWQEd7QfvF6L5VAFPiyyf3dRmQd01nrjn4bMvTTyf+08aA3Mnrj
	 6Z62ovmS2KummrnIoASRuhrSipzeqNpMv68FyMpVU2g17oMNFgZvfNwwxZNM8YY+1I
	 wLxsAqg/X6cudffaTkIAHna/ex2B0gK+ud7LuPOCxOl85S/o/X/B/qh5nFTGVuX5Nu
	 6yI9XPv/rBAfA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:23 +0100
Subject: [PATCH RFC v3 08/14] fs: set I_METADATA_WRITEBACK in
 mmb_mark_buffer_dirty()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-8-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2641; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ANLjFQZTu7eWBUSoA/NoDD8YeQ/elBxEjOpJYgsXPC4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CW3L3/Wh7jaF7OzIpunZehXarXVaH1PntAiv3WT3
 BshmcaCjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInIrWZkeG77tn5h1jzZ5Qu3
 neRh82Xe8KR0Z5jh/TMZ7fZmKa/0jRgZvtktzHyis+fy0eaiF30b7/V/PxAYHC14eMKhG7u6Zr1
 05AQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext2, ext4 without a journal, fat, udf and minix track the metadata
buffers of an inode in a mapping_metadata_bhs list and sync them from
->sync_inode_metadata() and ->evict_inode(). The inode block itself is
only tracked by I_METADATA_WRITEBACK which ->write_inode() sets after
copying the inode into its buffer.

Set the bit in mmb_mark_buffer_dirty() as well so that it covers all
the metadata an inode may still have to write out. Set it after the
buffer is on the list. An fsync() that sees the bit then also finds the
buffer when it walks the list, and one that cleared the bit before we
set it leaves it set for the next one.

The inode itself may never have been dirtied. fat for example tracks
the FAT buffers on a private inode that nothing marks dirty. So attach
the inode to a wb before setting the bit, the way ext4_mark_iloc_dirty()
does, or writeback_single_inode() has no wb to lock once evict() syncs
it.

That lets evict() write out everything the bit tracks in one place
instead of every ->evict_inode() calling mmb_sync() itself.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/buffer.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 5d3852b726d6..f951559e7d32 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -621,12 +621,15 @@ void write_boundary_block(struct block_device *bdev,
  * @bh: The buffer to mark dirty.
  * @mmb: The list of buffers to add the buffer to.
  *
- * Mark the buffer dirty and add it to the list if it is not already on
- * a list.
+ * Mark the buffer dirty, add it to the list if it is not already on a list
+ * and set I_METADATA_WRITEBACK on the inode so that fsync() and eviction
+ * write it out.
  */
 void mmb_mark_buffer_dirty(struct buffer_head *bh,
 			   struct mapping_metadata_bhs *mmb)
 {
+	struct inode *inode = mmb->mapping->host;
+
 	mark_buffer_dirty(bh);
 	if (!bh->b_mmb) {
 		spin_lock(&mmb->lock);
@@ -641,6 +644,15 @@ void mmb_mark_buffer_dirty(struct buffer_head *bh,
 		list_move_tail(&bh->b_assoc_buffers, &mmb->list);
 		spin_unlock(&mmb->lock);
 	}
+	/*
+	 * The inode itself may never have been dirtied, so attach it to a wb
+	 * before setting the bit or writeback_single_inode() has nothing to
+	 * lock when evict() syncs it.
+	 */
+	spin_lock(&inode->i_lock);
+	inode_attach_wb(inode, NULL);
+	inode_state_set(inode, I_METADATA_WRITEBACK);
+	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(mmb_mark_buffer_dirty);
 

-- 
2.53.0

