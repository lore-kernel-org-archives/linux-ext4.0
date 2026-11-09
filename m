Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243130;
	b=OcLm9xkfE7TLKizce9nPtXDTKHO/mhB8C4xdsxSMZUlV/VcbYlj8B5Q6N8bNtdGSc5gc
	 WciyA/arne5/GIyWHc3WqxLEJqMMzXTjg1MxhCy+z9zynfCQPQTHHHU0ql/eGu8clAiDi
	 K3YYrD0fZYhUQv6oAPbo4jLBHF2I+YUAbFodOtbzvxOn+JGf/eawkLpzxDRDb7jmAXgNy
	 0dO9aUCZq5nLe36RZtnBEw/RER3V/8u23s4DvoXiIwk11zqm/QfrkhY5D+pr6e8KiqBDm
	 +JnBCd8VB0yPodNjao6eUdnCX6q8O60OgzvZxpobxqdI7EgABF0Zigz4+kEWBeafieA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243130;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=zjmjqgnhrQ1nM2FGB6XLNsobkoIJu9RULbL+RBVp8No=;
	b=ZupDpvCEUGnjYEuw3cxynCysGeOvR/GmEohAqM9zZndhKX5Hfysi8hvx+4gC5uDA5inB
	 PZTqIWjFIsPG8t0NrJg7kjLPj8E3oqF4jym66TpsZgAF22T9KYmcuA0b00ou1D4K255T8
	 iDj6nqtDKfWeY9w46gA9B6SbGEfqiOL2AbdauPE630H805E6TyDz38DC0fOwVuX2jTKQE
	 ZTPUQoLgrVZpI4nnWYB3xaGrOJCV0Y7ZjKGnvGUdAHcgCKPqN3Q33Eh+/iKfqcUyc1e1y
	 zW4Vd/MGj1F74vnF1Q57RpNy116geaKZrrCPMOIxn3X6jVfdI14OIQerjyZN7hOC8Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z9nqD1lw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFB606EEA3;
	Mon,  9 Nov 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z9nqD1lw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC06A1F008AB;
	Mon,  9 Nov 2026 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243129;
	bh=zjmjqgnhrQ1nM2FGB6XLNsobkoIJu9RULbL+RBVp8No=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z9nqD1lwlr7mMO86ZAQOIcdEoAuGbiaYdQcgrFGDe+ngS+FTuYWQHG8M5bWH5kldW
	 GjvsfXuz6dGX79OJ5ZFsjEPAZy77xJsNIQ6qjouBf2jE9+lwdDhisoCiUbIVMXPqoB
	 8D99t4aC1M4mA3JVEyc5q4RDadbNfVvE1setcdA4qYAOJ51wIrctZox7Um3tBpJQ1C
	 H7+49dG9pz/xfXxtyhMXidWWJjtUrFPGI5P5ddFoPI8m8Mwdb1sEPgaei/iwoSfEQk
	 DFiHjjbbnHSSqXZ530mD6KZsvKSUDUZ3spfkrN0bJjPDPp6MDL9C7+TcNnvD9nIGTK
	 PRCnO6rL/loQA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:19 +0100
Subject: [PATCH RFC v3 04/14] ext4: don't read the inode block in
 ext4_sync_inode_metadata()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-4-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2074; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CHLrxlFDox4N6kEH+6Y+f6NwdyPQT2N0tNtxSBNc6CY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CU574jOh6KDPpYFk36uTQmVZ/At2K/cesyHiyWoI
 uyk4LTUjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlsPsPwz/C2j/Yc2yRjv3V9
 PDnJM5pybcw9rx/SvjLl4P2ju43OP2NkmPZyUW3DOrGsN8q7lXlU3v+OdVop0WC9gGX5J6FP+zf
 1MgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Without a journal ext4_sync_inode_metadata() looks the inode table
block up with __ext4_get_inode_loc_noinmem() which reads it from disk,
with readahead of the inode table on top, if it isn't cached. But a
block that isn't cached is neither dirty nor under writeback, so there's
nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
ext4_get_inode_loc_noio() instead and treat -EAGAIN as nothing to do.

Note that ext4_get_inode_loc_noio() also returns -EAGAIN for a block
that isn't uptodate. Such a block is being read or failed to be read
and can't be dirty either. A block whose write failed still counts as
uptodate for ext4_buffer_uptodate() so the write error still gets
reported.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4484c2383eaf..18362580097f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6815,22 +6815,24 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 	if (WARN_ON_ONCE(EXT4_SB(inode->i_sb)->s_journal))
 		return -EFSCORRUPTED;
 
-	err = __ext4_get_inode_loc_noinmem(inode, &iloc);
-	if (err)
-		return err;
 	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
 	if (mmb) {
 		err = mmb_sync(mmb);
 		if (err)
-			goto out;
+			return err;
 	}
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	err = ext4_get_inode_loc_noio(inode, &iloc);
+	if (err == -EAGAIN)
+		return 0;
+	if (err)
+		return err;
 	sync_dirty_buffer(iloc.bh);
 	if (buffer_write_io_error(iloc.bh)) {
 		ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
 				       "IO error syncing inode");
 		err = -EIO;
 	}
-out:
 	brelse(iloc.bh);
 	return err;
 }

-- 
2.53.0

