Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243159;
	b=ruOQ7DGk76oJ4BHIL053NFHUtvqm9WTRphSFYqG/uYLVlytH9Uu++jdXGBVgNCYuZMH6
	 yPjwGxFsg7E8F0CM7Ryx/x8QUyPDa8awsGs/4WkMxMexizqB1KXoxIH5vOc/X4h9SyU4E
	 GV0Dcrvy/0YH9c/hx8EoleMtsl7xQXPPKpGHzFDRKahhV4jSDtmCQG302JC/0HLDI1piT
	 EfCcCuW8/48USIgh7KzlqmaD0EE9WBnHO4wPhTXYw4jvp4M+VSJA1qaZZD9JIbvrcJuxr
	 77KpgZQneinS9H/t9B2MOheDRHqW91+g9obp6gm2ED+GlkvSYyI0yBkEZxqk5lU+5YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243159;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=PBdYE8gTePlTsSDTUSPcSAaMmvhQ74SISEXvKCm5BFA=;
	b=XC2mywaWh/+gyGM/7GflfU6E3lwz2URsO7f76hrNhDgWZ6thztrtgnTxKAm2l+PJsA55
	 M0GyAK+1rNnt9OKe6Zcr9WOcvOXxuOrDWSfYnR5PODwFlwZ3pwH6KcbYVCTfCxlhHG3TE
	 8dbt2MPobvBUm5+JZvpJob/0hraEEJcWv3PfiDXe8+2dsUtN3Wa01OPvuRq8JhTGcBzOr
	 G/9gXYd20a9n6eQFXeDmHpddlwRgnIvN9gTN7KvSK053WmGGivP1UcFc+4X4lwYvHPQvV
	 1GZ4+ovWnJkq4BID14nIBaXBNOKFBcnZmPAaagaIKahQM+/DghqmhVCXE6J3In6yWxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iYKk11fp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6793560A2610;
	Mon,  9 Nov 2026 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iYKk11fp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6441F008BE;
	Mon,  9 Nov 2026 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243159;
	bh=PBdYE8gTePlTsSDTUSPcSAaMmvhQ74SISEXvKCm5BFA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iYKk11fpyP3xK1MK0uu7jgMeN0kle6cnkmFIZLv8gEYU5IZ0GGutCcqXNVqOOHNpb
	 kY/Ycl3+5gFnXiqOI7nRP2rZloz6PhBYZVyK/7Q4wauf2YmhnelNjYs2io9tFk0IFq
	 9KkM08YXP2wCoaXhKJ6anARtndQlXdV+WK+LeZ8kZ8x72xH1KusOZgQEufPyxAp+ld
	 X94nHwyleBmSpZB3JIj+WNKfc6cq/Q2tJjPhBC8XEE5gpC4U42w6IDXd0QfGuAMZRz
	 tcQDugHfihtyyunUkTeom+5b/QkzW1SmY8xWNRqWYwqti3lMfN/DC2qlt8TVT0W149
	 q+mUY/CaoDdNA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:28 +0100
Subject: [PATCH RFC v3 13/14] udf: drop mmb_sync() from udf_evict_inode()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-13-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=815; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Rs2sbItXFEwkQJAbLj7uhlNQUFK7bafJDRbBesxusX8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/KViEBF3Sq7auXDa5Du8vDdOL57XecRQ/WJXhZkLR
 3HbjBPsHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZc4Hhn2F1aMIHPVMBobU6
 itd70pRW7VabKyr90vVhiE5roqRfOMM/+2bTzS2eIWdUvn4q3cJ05Pck3d4jjXFXnbb3rp2q6FD
 KDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

evict() writes out what I_METADATA_WRITEBACK tracks before it calls
->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
includes the tracked metadata buffers. So there's nothing left for
udf_evict_inode() to sync for an inode that isn't deleted.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/udf/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index b3e7c07cb9e7..a6c0b9d70ffb 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -152,8 +152,6 @@ void udf_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
-	if (!want_delete)
-		mmb_sync(&iinfo->i_metadata_bhs);
 	mmb_invalidate(&iinfo->i_metadata_bhs);
 	clear_inode(inode);
 	kfree(iinfo->i_data);

-- 
2.53.0

