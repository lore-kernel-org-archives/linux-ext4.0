Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280538;
	b=V8Ncjt8a50cqOSCYCdwx/zBxICFiJyghmPAohQ2gOnmx5l/EGI6hsQkfFBYbCBuu1NOy
	 M0E71wjRhOnUdDkNaxy6LbTv+cFOCX/Jn4pBKHfu1q7LaX3VZrMrUbDOOR6aFg7L5Mi8T
	 H/0OZm42Tdi8rSKS3lo+WL3zm2jtpnQni9NNHDl66xduuEO4ildMsPv89X6oE3fwBTDK4
	 WuCe8Smxu+Xl2F/qW6XBWBYs1fkE8/3zFxsijVM5PuRdBYVmM7UwGrjNufxQXjbZm4SCR
	 iUknmrZBrBAxy91T3KpsAHnrdXgMHmplNvidQbb2cOIuktwAMn6M2KeH9W+dHo8r2jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280538;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uIjxvErSn7gYcZXIycV31zj49o/px0njZpaugYg/K64=;
	b=qg3ZLM9UMxRFhgvmyV7df/95FX6c9b+VgkRUOIigckjgwV0vP5d9orjKr/EXkXrHxIPN
	 e/yIIuskvKR/KPoviYgVhOGVmFmLRrt4s8DeLaU+LwbLIIVT+jaUDpvBqNv+K0vPZPRKX
	 ttzmuZ82DvYL/Y2VbkPstZnnfxozjstsAC+1pHQtthgLHHwtoZLPIkFMEpMRA+LJ2XLCF
	 IvF1Q+yLqurZEdtVD/zKueV8luD6PkFA0/2WOOj7Fu1SrEDb1xNch4hrgJipVA9N+HXi/
	 R7mHZqk2rGYXiWxN1eq3fzrR1RkME4mYwrbSuG/e8K12RQxjAXvVVJFioXEdA1Qu/oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmhY0haC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A0A606A31F;
	Thu, 29 Oct 2026 13:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmhY0haC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6475C1F031E2;
	Thu, 29 Oct 2026 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280537;
	bh=uIjxvErSn7gYcZXIycV31zj49o/px0njZpaugYg/K64=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kmhY0haCpxkSDar4xM6VjYMmcd8eEbgsv9QLVZXuew4kZQgOcXJtmwMiHCFIQie51
	 zsT819aCYjtqFue/FEUnugpikgiIJWy1/KndmVYcwod4Wz2/P/ck2Eh3wbjY+73ALJ
	 1Hohbsi1o6zt59u5oirYiUXBNgSglKl+S034KKYtMa+I0nzu8NBSzdln2Ca59vKYkk
	 MQ7Uy2kI829QpdIgKfOJ6xEHJSg4A7rbXLhxK53E7YP+0BKxeqZSBNTudLhYh3Qz/F
	 W6GoK4PxpCcyaMZ1j8GccmW92qF8ubtJknG8/tUOTaJ2uHP6PObIeM10bR2fkV4BTv
	 wOC6Ys+NdNvMA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 14:28:21 +0100
Subject: [PATCH RFC 6/9] minix: don't read the inode block in
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
Message-Id: <20261029-work-inode-metadata_writeback-v1-6-7d6c678a585d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1763; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ySz3ES2rOJw3m24TdiYhnj6oL3N384wZYJ1sKl94Ao4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ99vy/tDGr8dNLY9bw2d5Ggfn3Kx4dctX87ZanpSE1m
 eP4Ttn9HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPxt2Fk2PuqZh6nH+9Ny6ZH
 e7/UH9TMEaz5pjqzf5cBq50du7BBNsP/gjCu0PglSdsSfs+csoLvXnCAAJ/ChjP5fVz+qX3Vrly
 cAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

minix_sync_inode_metadata() looks up the inode block with
minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
it isn't cached. But a block that isn't in the buffer cache is neither
dirty nor under writeback. So there's nothing to write or to wait for
and reading it in is pointless.

It's also not something we can afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
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

