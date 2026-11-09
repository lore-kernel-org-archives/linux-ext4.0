Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794243140;
	b=j9gqyw9Y7vmGp8OC1GQhyY64pshq3kTL9XQ7mjQlVCDNdJjBOBrnx+Z/0HAq0qPIRR2/
	 sdHHvwrms4C9JGSDrkOG45wE3SHmC2BKUovYi9SZRUYLVt8gMs93DrXNg6joVQ6ajzSpa
	 ypfwEYcghN9jtnpQw/gw+mjZ1xJaxOCP3mBhzJoqyWhuU9YHlUR3g2BQ6LvoPBDcXLgI8
	 bYbadIsM6jeTeu+Z2X2xF5O890T1CT4cNzKWNR0yrhmewXzXaJLVGJvEm0Djd6LzClvqB
	 7Gy7LwjRwPY9qswOWWcH2RUKS+vkYl/4UL7+fgfYP4w9DsvgoG/6laaY59hk67uTrRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794243140;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Hpra49h2tIJZvGGHDR5HzCg/FGYiBsWReE6wHFXQ1q0=;
	b=btla3v6zsAo8sK1YYK0iCSByQxcrvhl5UYJ1K6s4PbpxvuWUsrnLTus79fEKmtpccoTS
	 vuU+pna3DMfdvsqQVsw7UP1jOatH1lmOmby/qdU17E8khDAIwqSGiwf/JfkNzMlNufE7d
	 kL607N6w1Avn3t1LOXzaGS8nDpOj7a3MDeDjSDwhAkGJB1n29Mr3mamwrPsMHp6ZxQUoQ
	 M8Fr4pq70tZIG7cUBBlqpFM/CInhybpVR41AhMrLpUW+1+F19un20A5sANf3WZgtO4FjM
	 lzKGxeGqvcNJJZ4NiQHOjSgrrO7CkhS1EuA42NgsnJYW3idSdlKAun5ni8FcB/gfDOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Px3vFDNb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662A860A3819;
	Mon,  9 Nov 2026 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Px3vFDNb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215401F008A3;
	Mon,  9 Nov 2026 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794243140;
	bh=Hpra49h2tIJZvGGHDR5HzCg/FGYiBsWReE6wHFXQ1q0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Px3vFDNbuRf4BKZ+0r3NxXrVPJIcyR41yigy3WxkRjlVoEhbvJnKFwTBlb3GqU+fx
	 qEscLH/rzlW8X41ca7Q7ifAnzb+KeUhWaSEU7ePcnCclprGXq70Rwdeq2KZTtktFzJ
	 Uc7a8ksokm5FJdUSmX7cTWpfrFSPYuvOKmnZCG54qsBD+/ik+OJ+zAFCUi9YNuV99r
	 mpuLwP0yGV/hi7ZPHa95RSUjorq9eq7ABeoKWUXPUDpHqZvj4f17KBs84ZcXCyuWjw
	 zeZkQJFJGuuAMZT1kOkJrWJmVXx27TJ1IuaEeUssZp8D3TnGQMVI3zBJU9TphI/3yD
	 PnRuqGofgsWfA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 09 Nov 2026 17:51:22 +0100
Subject: [PATCH RFC v3 07/14] udf: don't allocate the inode block in
 udf_sync_inode_metadata()
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
Message-Id: <20261109-work-inode-metadata_writeback-v3-7-91ac6c024018@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2116; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DSJoqNCEmQBwJLJ0nW3J2QU7yw43pwXr0BYIRgRbH9c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9/CUbcU952hpLubk9dtIqjt0Bzr2Ht0U8SHWbejRJV
 G2Vr4t5RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQEZjMyrFrJpPyU9XzMkiOG
 ByW+WHyx3JfPMUtc4Vv5sotTwmKOLWBk2Kgt1JL68MOGGwtnLerfMz9Az3b2srTNrL/j+ZUslaZ
 c4QYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

udf_sync_inode_metadata() looks the block that holds the inode up with
sb_getblk() which allocates a buffer for it if it isn't cached. But a
block that isn't cached is neither dirty nor under writeback, so there's
nothing to write or to wait for and the buffer just gets thrown away
again.

That allocation is also something we can't afford once inode eviction
calls ->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/udf/inode.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index bacf2a86161e..b3e7c07cb9e7 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1742,25 +1742,24 @@ void udf_update_extra_perms(struct inode *inode, umode_t mode)
 int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
 {
 	struct buffer_head *bh;
+	unsigned long block;
 	int err = 0;
 
-	bh = sb_getblk(inode->i_sb,
-			udf_get_lb_pblock(inode->i_sb,
-					  &UDF_I(inode)->i_location, 0));
-	if (!bh)
-		return -EIO;
-
-	sync_dirty_buffer(bh);
-	if (buffer_write_io_error(bh)) {
-		udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
-			 inode->i_ino);
-		err = -EIO;
-		goto out;
+	block = udf_get_lb_pblock(inode->i_sb, &UDF_I(inode)->i_location, 0);
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	bh = sb_find_get_block_nonatomic(inode->i_sb, block);
+	if (bh) {
+		sync_dirty_buffer(bh);
+		if (buffer_write_io_error(bh)) {
+			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
+				 inode->i_ino);
+			err = -EIO;
+		}
+		brelse(bh);
+		if (err)
+			return err;
 	}
-	err = mmb_sync(&UDF_I(inode)->i_metadata_bhs);
-out:
-	brelse(bh);
-	return err;
+	return mmb_sync(&UDF_I(inode)->i_metadata_bhs);
 }
 
 static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)

-- 
2.53.0

