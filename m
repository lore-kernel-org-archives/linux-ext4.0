Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243150;
	b=YzNReSh2BUdpX1vPze6LdU/4AGezzpkvkTSuQkym3LgIm4t1dD+VOjmPRd8ZfT6Ji+3Q
	 e3rYNemZeg0CMODNBl0+A56qD2YrOcEvoNzwRqfFbJQ4ZeP2SqRi78sfQDDA7pEQQA4mv
	 H81tm2gLohP2lkZG+mWmaNFhOdEM8+/rgdTh7rXsJNvDrH6gsZz40VYQSvFnwGdOLfvyH
	 OWaFcGx3pstFNp/2f7nJBoCDzIck/pwfgRmN9WeDiSpquQ7Kse6fW5rV92EdUW9SBVzdW
	 rUYLyAmEKG0oMFlJpKWaO5R/HWpEErqTZHTXBnp0R69Hf12r9amogL6FfPlGgi4o5sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243150;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=wvp7aEXKTRjkC0RMz3G+6B2RxEnBx0WTfNq1GTY9Xcc=;
	b=XhG8nlYjjdeg1Yynz9aF+PUSpqNuOc03dGQ+leud1FEL0+d1QFFVxVo6iFc557SkN5ak
	 i7ooIpG0zPcjqqxAnDcUtwnhhhqX99OBtcv45BaExb5EjrSMfMNRFfDiGmFcd0I4eZJv7
	 gWV0SUWm+RNq1gKtP+l4VL4ffaXkAWnGiqi9emnj36ksw6uXxz9YtuelUtb7PFM0gm/Di
	 i5tZqgl1k4ctI9rE+qP+XGJpLq8cL96CW6IZaCbK78gcqq7W7u18GGegzB/Yd4UD/+nQI
	 I5sKZqm9tc8j9A4W/5Ehb2cOPGVNH+L4XcAfoVKa8DCscqCKZLfTzr2/PGDwOKjQrHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAzJG8F1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAB660A5BCA;
	Mon,  9 Nov 2026 16:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAzJG8F1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6768B1F008A2;
	Mon,  9 Nov 2026 16:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243150;
	bh=wvp7aEXKTRjkC0RMz3G+6B2RxEnBx0WTfNq1GTY9Xcc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LAzJG8F13cj76Ntjy4rwTv1E5V5ZgnP5zrPDzNmrHPvA9G6tym+wOzEl6gr8Gf5U+
	 dOxxznf3Xyrx9oZOxOQgXQwDFXIHl5bAltP7NDfU/NmqaxpT3ckxRPx8LWRGO1/Ked
	 caFrHRaqrBxFajfT/38lZiMCOwHHT8S+bXiqraJpAjFOj54h5XKQg7oGQoAdNhdGxh
	 gPIDai996lotOYPCbqpIGGqth5TJRPEYWR5YJhNFPPVXvHvqwsOipmWW7bX2HfSGt9
	 +l1e15fpbPFF/43rOrvTnfVW96HL4DjJVLZn6e85mgq4yiUhccURNstimUNInw2Hj1
	 HCseNu4Pipumg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:25 +0100
Subject: [PATCH RFC v3 10/14] ext2: drop mmb_sync() from ext2_evict_inode()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-10-91ac6c024018@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=816; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jdLKZXVKo6M+tE/hsn07BEOSJbYTywSNk0lIiPZwPHY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/KVw8/vPzPutGeuPTF1+1uCBgE77uvSEqzuK12uuY
 F4WH3W8o6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAivwwZGd7VhjnveJy22OqW
 u02n2cWSGys32/x8drY5qWSWlVAvkx7DP9uGxXzJWlsqFkr3HjZUeXLi+RxDk+t1FxXfsOdl6kc
 t4wYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

evict() writes out what I_METADATA_WRITEBACK tracks before it calls
->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
includes the tracked metadata buffers. So there's nothing left for
ext2_evict_inode() to sync.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext2/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9261b666d043..4c38a3a8ea4d 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -91,8 +91,6 @@ void ext2_evict_inode(struct inode * inode)
 		if (inode->i_blocks)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
-	} else {
-		mmb_sync(&EXT2_I(inode)->i_metadata_bhs);
 	}
 	mmb_invalidate(&EXT2_I(inode)->i_metadata_bhs);
 	clear_inode(inode);

-- 
2.53.0

