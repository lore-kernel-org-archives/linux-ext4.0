Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882571;
	b=JvhcQIGMrayvQUXh6Q6ttfQ3g0hPUbx3Ps11aaINEUKvWXt4yEenzBxGv+Q0qeJiCRVO
	 cqmqupfE4fc+ZuRd61jnb5VC3+0huyLpskOAcaZyT3naOZpYpJ07HE3rRzUB7OqGP1QGl
	 MztxpGkepRDyKtzSyMsxJEANj9y4cnAGmkZr88PAs0oFUTo+kwNMHB2sr8lsx7ikrAeEJ
	 buJ95rXpzokJVljSfpoVxBn88/xyJT0GXrFky4dVKlnhjU8e6G+mya+lluXW1j1e43Xys
	 5TpQcs5y+6la8KrVFAsVWqmjWEBJ7Yj4UBDvV0Y49T1fn5ayzkNrnwm30SEjxCy09BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882571;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=17n60/t2P67mde7UFdTZTcEcl1DYU83c2e3eW9XUAxg=;
	b=dQTIckBGBC2fz9ijKxERGbMVRFszAN6XXCPgbZJeZSCpj3pATA08ISbEhAnjp5gKaSMU
	 5FL6DPgBiGY7+opukBi3LHB1+I1F/MY7mQ4bc/dERkYMa+zSrSmxyyCJbSc/OdylPg5W/
	 Oz2NRzshlV8kgl1BW/32mauJ3E5tCMpBxy+Cm1YP2hsu367ptROGvv3jbOkjEhckHXdNa
	 ytAGy4h3n4c5Z0z1iQnxv2rDg7yrj493ZQR5O6PWcbWX3rTGbeluZbx8ay8FHYiDOg/Vo
	 BjtYDfQS3NsP69dj1X/WluuZk//WOb8oBJ2ldIdQ7H4iZxWIg+2hqRt7GYc5iJc8XTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iq7apeWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E509606D836;
	Thu,  5 Nov 2026 12:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iq7apeWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BF41F0093A;
	Thu,  5 Nov 2026 12:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882571;
	bh=17n60/t2P67mde7UFdTZTcEcl1DYU83c2e3eW9XUAxg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Iq7apeWxrKULcW1j7g55joJ+3wJkrT6z0bMK4hGE5a1u+KJn5ag3APZ5X2Et7Iwov
	 5z9Og/noCqCSl8sL0LcGXE86KRmAiuOuKZgRJKWOVbyts1gCr70c/dUFFSvZuigU2H
	 zX9/7Oi+09Z+coVl5xImDHOqLDLNQ+WMypum6fWDY88oIcJMZ//HmpLyUSRFXSYNtJ
	 h0uP/WD78FlpvfeQTC0GaMNbnxBRJLRco04ALvD7EuukqPi6Ns1UM+f3Lr2FSzqx0y
	 41ULBgllZ3hjgTHZnU16Y5wYQZpwf7dyKD6g9AEjEVQukJ3uf4xa0cqI5tVYf6kqpp
	 n5QUt3ZuLWt0Q==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:41 +0100
Subject: [PATCH RFC v2 12/13] fat: sync inode metadata in fat_evict_inode()
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-12-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2085; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OXUqvsCtU2kG/WbMso7j4UEzPtBq/0ADao3mPOR0UJ4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZy3IelJumR1guwJzbMsz3fYCTOxrfA9ruGZLrrl7
 dfmsJTmjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImU3GL4K2BmtVVuud/iCDG1
 2n2bruxd53Loeg0vQ9oVvaDfWy5vPc7wP5D1UZ7art3Wi57ZnXoQXC00lbP9wrtMm6C3e/q13tq
 yMgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

fat_write_inode() copies the inode into its directory entry, marks the
buffer dirty and sets I_METADATA_WRITEBACK so that a later fsync()
writes the entry out and waits for it. But the bit goes away with the
inode. If the inode is evicted and read back in, fsync() finds a clean
inode and returns while the directory entry might still be dirty or
under writeback.

Right now that can't happen because inode_lru_isolate() never lets go
of an inode with I_METADATA_WRITEBACK set. That is about to change.

So call fat_sync_inode_metadata() from fat_evict_inode() for a linked
inode that still has the bit set. It syncs the metadata buffers as well
so it replaces the mmb_sync() there, and it already looks the directory
entry up in the buffer cache only.

Do it before fat_free_eofblocks(). That one updates the directory entry
again for a file with unused fallocated clusters and only waits for it
on a sync mount. That's intentional (cf. [1]) and syncing after it
would turn every such eviction into a synchronous write.

[1]: https://lore.kernel.org/r/87v76co5dv.fsf@mail.parknet.co.jp

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fat/inode.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index d85c8fbdcca4..df4616636c65 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -693,7 +693,16 @@ static void fat_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
 	} else {
-		mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
+		/*
+		 * fsync() can't find what I_METADATA_WRITEBACK tracks once the
+		 * inode is gone. This syncs the metadata buffers as well.
+		 */
+		if (inode_state_read_once(inode) & I_METADATA_WRITEBACK)
+			fat_sync_inode_metadata(inode, &(struct writeback_control) {
+				.sync_mode = WB_SYNC_ALL,
+			});
+		else
+			mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
 		fat_free_eofblocks(inode);
 	}
 

-- 
2.53.0

