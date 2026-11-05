Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882549;
	b=hRNn1T4voWxY5DQoUfl5ZMqcSqEtgVJM47y3dK+zog7ji4HWwTXU5M7PkqnzHI9hr+O+
	 Ema8+Ezd6oN7V89W92JjP2wuthhS2NV69sIMkkTIyajRqZyifTIIxgS8ZXtYZQrBsRGXF
	 ZoEj1XvmvzkLZ75GJa4KNQZ7uoXkWb0C7W52vigAyUTkZdGWU9QxoBqaqs8HfINJ5vr2I
	 O1D2zu2HJL0zaLsoyiRloOekIIti4NHWk8clK8ZCYchkWZIXv936/mePOBDYM8QkrgRr1
	 J4R41nPSLBw2uC/y0+U2hFLMj0C8B1yCzr/a+SGa0MSFWZNv+NHteAlE8RB8QiDBkkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882549;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=zW6GMG4oYoeEjnu+kiOgo/V+0XYeqQHkQ89IjZ5LcGw=;
	b=1WK0+Dd6z6iWA6G/voawioLnE2O/wxf5VGB6/vlr1xt+Qda+WTaC0g5esQ1HgDc1/Nmw
	 fqJG8QfGbQD0yJyx+Bla9mTlQjQqaDavHTb3C8lKyDEHK7FoKFoLdoMGP/M1SQublenuP
	 6gnAjUvoPAHO7wPZSbVjxbvcmMvUEoClMg9O9jp7iFWmunk5ZlJS8pCViIvmQ8KBcqXvZ
	 onWRuBUeTCp9nkGVPlDWBGTy9UJQTzL2/PQd5MiR6fNjQU6tqd9OoQBFFJxGnQobvqxLi
	 EWHx/s+z4CAI4x+5thIQZ/JyeJBpTwaqmIQ/C/FcxLu1zwZgP4ZYb8+BNI9ttzfxr/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RG+j9CW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E37606A32C;
	Thu,  5 Nov 2026 12:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RG+j9CW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371281F00A02;
	Thu,  5 Nov 2026 12:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882548;
	bh=zW6GMG4oYoeEjnu+kiOgo/V+0XYeqQHkQ89IjZ5LcGw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RG+j9CW8v5VaUmRHbthenA/uchemR/mMjlozjFiiWnfFT2aR01nDgQbQqDWvBQsBy
	 WdlRSaN1YP7jdghVrDqyps1AKve5T+Mk6NhatxbOVL2zKc62BK/g1CMN+dNuKVr6Zu
	 SWgRwlrCxVNGsy+AxWzVJGIPCsQO3JN3NpRuH2PNpDzfg5NcYruVaYbjLwkJSBLui7
	 Zg5qpyXIv8X6PzFprecXLmYQ8mWPYIhO/RscgqiFsFyW0/9NQOZZKjrB8J/kGWFCYG
	 7PZuoREOZNuVsBh5Bygd7ZTHcgah2SnO5CZlPZyDZyP7jxMgSjSjoce/a0dun3iFEO
	 iMl6SukwvyCjw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:34 +0100
Subject: [PATCH RFC v2 05/13] ext4: don't read the inode block in
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-5-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2036; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BsJmMmqy0/bUJi3XQROckrierDSD8ACgz0DdyyuLj4I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZzWkNKToFjd/fLU4w1LVB+rBP7Lm74gtZ3vZONfe
 TvGtVe2dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkTgMjw4uw/lz2BTLMdxq7
 +RcFHOzbr7vv+Ne7ojqyPBF+DxhevWFkOL71CcvrSxd2no2bYbdth8bprDgezzWRM46lMdfW37F
 +wQoA
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

