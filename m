Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882565;
	b=n6y1VUdMvOY0Y1UQCovCdVhjKw7TBhb9EKigxb1DxgSHgS4ai369goOWdiCO/z0vFVy1
	 tbT9v6ajl4ctS8+eeBrdZbGisGqYEkL1HWXcjwQDjjFP5jL5yaSuh9u0yipkE9AN2lqHU
	 K2SusL4F2Bg4H2FEghdLkH+aA3xSUJJU1XuhXqgTiy1aLT/sC3+u9OzxKsU8ZnRF+9D4X
	 PLI3c7WaPh6IgHaHiFzXRK8malc5kvc2yO+L6WY9GL+NjqN4THTM3yCNOv+VqeDKRtnRq
	 WWnnJZk9UeqgourGwWpq+Ioo9NSki8OBCBUnZ+unmZpZtZy4OUKk7gLYiGKN0gyK42g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882565;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=Hpra49h2tIJZvGGHDR5HzCg/FGYiBsWReE6wHFXQ1q0=;
	b=nMm2XMGL2oe86XlRu5zQQkeqD5Ve8AjAqzNAjixw8cEeBOJorG3Y4R9lCu+6yIddFr4c
	 4Owlj+Z3SGMKeP79CVCcOkAFk1vBIKW/CLUwz+z8zAn7LM7CQSgwuNRnMDLanuMhragjl
	 +goSvKnKLfiVTrWl8ElF3AOSKzWKgGrSG+kFgG8NFwXC4VUOLwdcJ/G4lKXULl2Pex6Na
	 Seh8A6iMDKVNMXnI5qObHlV8kamVxxljSxrOXdjyu6ySuf3ApWBI+VmakcxvN4UMQt6KU
	 3ByXOcgpFOt7ZK4fuil0Y5BypNPjxL1ISS50V+CT68Ts3Y3YzWXFvdwOZkuUtaAEhOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nv3JJ30q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED02E606D828;
	Thu,  5 Nov 2026 12:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nv3JJ30q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB501F00A18;
	Thu,  5 Nov 2026 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882564;
	bh=Hpra49h2tIJZvGGHDR5HzCg/FGYiBsWReE6wHFXQ1q0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nv3JJ30qrg/q5aGeYQRQKGRnI59swGe3pr6uyrXYP7q4EFwSL6uSOoPEjbveyieAs
	 xpnUptKUZPDW0b91B9FjJL/pKjLFFEnVxwQKf0oqux8JbuucC1OsMm5WUthAotQPdB
	 DSW2IBiAxxtiM6ZwG0xAesrrSkPTfX7qiDFSUMgJioX2gO1MxQGL2TouB0noz36ncD
	 hbY+xmTzxwhtEXXStO1uk3RtivHuNlJO5DQlw/NCcC6NqXyuoQ3jjIFv3/ydTtoA1a
	 55V3Q2Fb1YJ4id/9U0iCHSfSxDtvmfrvJEXsBnCoepVryXh6ONpfWO/8ghlhKEC2Kr
	 XCL+qjuCwYkzg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:39 +0100
Subject: [PATCH RFC v2 10/13] udf: don't allocate the inode block in
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-10-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2116; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DSJoqNCEmQBwJLJ0nW3J2QU7yw43pwXr0BYIRgRbH9c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZw9xXyN1385EeamesvQ32/ipR7Wmwbx3T96I6+f/
 ZiJbdOcjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlUcjMy7JgvFj7zZPPUHXM4
 LmXPyftp/tvrj+3rd6eZhX8p3lFws2Bk+B8d/dbJvKJvwbRHz08L6ezeeHS+mOkheUcFxqMHbBi
 rWQE=
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

