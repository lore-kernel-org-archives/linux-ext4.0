Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882539;
	b=0oQr1mwjXrOiI80To8p7Jaejtz+s5ywzMWc8f8TeXKzvJ9bTmWlBaQVZQx6fufrXQiFm
	 IkyqSBp7umCdN5dcIquTUatW0FvfBrnMWyYwkHmwkAlpHw85TJ2yeW0imIB7On+ZvZGUR
	 VT3PkDVrg+X8tmLbfvUvZ2U3EGQNUL6wFpiwCvDoXl9G2LENAKR2pVZZW6doUZ4gTNkcg
	 qdSxwnKafMz4x0L8a/b2l4KvtYrBYRovrxO6w/fqJox5nMStnxike789IFUCsharWGbbM
	 +Xg1QxjHoBIKkaWPIJm4zgWw+50ld24HPV4b5PpOI7qnc5Vkgmrz4DrOEqFZp/sHieA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882539;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=2bJ6VrqB2zZhUNG+i8RcuajIdalPNNO6IGi4chnMNtg=;
	b=BrE7gsv7OTbZWV8uzBkLHww56UQinzapkFe2+H2Bp1DVbhqEgFyiwfY52cq9YrjY1sKw
	 uP2HzrEY3MbptCA+CEDqWpa8U0DkpbgOoCksnZ7MNxU5BGovY3M/ULQoeArT87qvAQoxD
	 gdr5Rdr8MbDA8rJhaE5wf9ErN9nn2aBSZZ/MFJ2nNu7hbLLbdAdYyaHQzhw5l65igMJFr
	 XlOWjqqRfM0yggXFUVstJC7lRaNuJvWl9ecMJOKJNuZJb3iscA1ShZQsXLHGXhOyTLh2R
	 jGpk6K4tE0yJ+ZS40EfSWQWCbOQC8u8+qlmBOL3mkRIJsgF3qqp+mLkCLQMMRQPucUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBnm6ePR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9CB606D81C;
	Thu,  5 Nov 2026 12:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBnm6ePR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99381F0093A;
	Thu,  5 Nov 2026 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882539;
	bh=2bJ6VrqB2zZhUNG+i8RcuajIdalPNNO6IGi4chnMNtg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KBnm6ePRAdQbnJN85eOHelUnB7/MsyCZHWn8kd04qcunWTPs0k+Tn9JoGtbdzQGz8
	 ybtyBBys4jVkY/ruN0TC8mWjz5tGMt15zypOHqrSZGpkMmK5rqd+MbOQyM6/+koLm0
	 dymKq8WyBJcgEUhnCZHYQWQLkGNuKik4s8GKAjoYH4xG28RcIpmIbqYNibWJh4F6Kw
	 GP/iAXqBbTfsM2kt+kC4iRrJwVf0nlLTemsUDzwI37T81AazkS/Rb+DhaCPNaA+JOw
	 DJNCkXgLAFNvegFv7rti8OWBM/HqIhEmhymLaBRh8btdVmv560/TUVb88vocVCokMV
	 OrMdGCtW4t/bA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:31 +0100
Subject: [PATCH RFC v2 02/13] ext2: don't read the inode block in
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-2-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
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
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZzU9e9qrmJZxs2+Z/1dskITZjqw/XHnmrI35PnKR
 OMZ07Zt6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIATuGfxYHd/y/onF/151J
 DpOOvF1Rn/1H/cFMh/uVGdkxz/kCU5IYGabz/C79kBpUV7u1/5PSD5tFHGGvV/vuenb+2L9dQTU
 cXJwA
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

