Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280531;
	b=HuQFcJM+DKGWS/817cWFGxJbLYz3FJyGEjYUNkqmLEyTwHA4ZYx0BN10y2vnCZaPInSe
	 7sCn0X1EMtXucfk7G/KdCXI2qyJ5q7atu0RRufiUGsXCPCLxY0w+9hYXxfiO+ODE25YNc
	 LbtF7BnHf3hAPqSe2tcTfYRbKOI5fmE1burCPiEO6+eSgPzEmLIRI26xpuxlbLCVgZFK5
	 PkEz+9hyTN1PEwxUor61DD/ez7EL9MVdDOxGFGmc3IqTsRoBiv9R+n1FtZ84hpRa2U6xN
	 su/CmRRPEMrPS3Z2VbGgFGrN6jn9qN1xqZTeZ7Eq31NZ/5PIOHqFQj4KL7HwZuF7zLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280531;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=q3FoC8GG51fB6+9W6Cdx4y06bpbtOnaIjPkJ3YVf8mE=;
	b=TKfJ01WRbE71P5mk98sPVAK+lmg4ap6kK/rFJwd5BeEjP8Y2WrEAj7JUbFwdhlpPtob0
	 FV2NruIuyyKn6XTqy35WHEtGir7xNaVCV7k7iBrgEf1/s8OR2tvOYWnUi/Jcib/7Sdw3U
	 x5iNvMXhwH0jK+x8m4V0qkndF4GCIevXLRhrWeAh48MfA3oRFNgNSB0XP1nm3MCa5jQ4O
	 vb3F7zmXzrFEThG/Xf3xdfpDGMlDiAN/mMfNZPaYxCsbvHpXPvRnnMiHquV0dRXjo2ly9
	 srZEHS6wKNq5M1DUe7j8Se1M0nESB3MTJxhuntIeB+dEkA7dkSNOywL0LIKSFylbp9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXGsCAg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC6606A326;
	Thu, 29 Oct 2026 13:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EXGsCAg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F511F031E6;
	Thu, 29 Oct 2026 13:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280530;
	bh=q3FoC8GG51fB6+9W6Cdx4y06bpbtOnaIjPkJ3YVf8mE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EXGsCAg5PqVmkiS0fMxWDADDEBSh/VfI225MURNO7ZfuidrmcIxLY57L80wLhjwdf
	 YO99JEDZ21rJRGx0iibZbGZs3zUg3x1JNfMgMSeyzdWQzbbEq719eX991ARrbE0goI
	 Oo/GRcTUWXnssq64McT9Bsu3a8VQAOqpcAdh0ZdRDfe4H2VWEPfiyX7FKjHys9uL3M
	 91R+GCbgBuIH+2+rrTLXRnRjaL0qbbTi69cRgDWQj2SjPBL19xRyog7Tob5xR4GEnp
	 GeKjrbWaZsg3/345HQUpr6gWDNap3oli5YEjbt2rTV6bFrhATavWtUfjHNY9HgXPYO
	 GIskLvOrsbMug==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:19 +0100
Subject: [PATCH RFC 4/9] ext4: don't read the inode block in
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-4-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2130; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0yQq1C8tn/X5XVSK6w+21mZxyXdieU8fqIeLTqZdZJI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vx/ROXIgcO1PMdT7OU5cpp6bdjfJS6sL+adnbKvO
 PjwGebcjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIl0vGD4X3E9Yu//lZ/ylbdx
 X+a6dqg+fWZe9Mxv/KlNHy2cs57/tWb4p9+52myb446vM5UztW5V7NzSs/Ebr3NIb8aj2YGlgg+
 9mQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

In nojournal mode ext4_sync_inode_metadata() looks up the inode table
block with __ext4_get_inode_loc_noinmem() which reads it from disk, with
readahead of the inode table on top, if it isn't cached. But a block
that isn't in the buffer cache is neither dirty nor under writeback. So
there's nothing to write or to wait for and reading it in is pointless.

It's also not something we can afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Note that ext4_get_inode_loc_noio() isn't usable here. It uses the
atomic lookup and that one gives up on a folio that is being migrated.
That's fine for a best-effort fast commit snapshot but not for a data
integrity sync.

Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b34b99d15db6..cab26ec01aba 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6824,28 +6824,32 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct ext4_iloc iloc;
 	struct mapping_metadata_bhs *mmb;
+	ext4_fsblk_t block;
 	int err;
 
 	/* We should only get here in nojournal mode */
 	if (WARN_ON_ONCE(EXT4_SB(inode->i_sb)->s_journal))
 		return -EFSCORRUPTED;
 
-	err = __ext4_get_inode_loc_noinmem(inode, &iloc);
+	err = ext4_inode_loc_block(inode, &iloc, &block);
 	if (err)
 		return err;
 	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
 	if (mmb) {
 		err = mmb_sync(mmb);
 		if (err)
-			goto out;
+			return err;
 	}
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	iloc.bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (!iloc.bh)
+		return 0;
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

