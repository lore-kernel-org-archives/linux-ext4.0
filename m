Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882546;
	b=VZpVPa6cjey8BKf2n7Oaiwq4T731X2zXI0RQYZ1czxkg+YYuXN8qTCIVMTsm7kxmQfHY
	 0ZRupXFynjQAThMJpJPzjaYYJ+kUa4/cy+1KycUQLeU9egsx0GU+rbXxkhtNzgeq5/utD
	 qkwjnmIlcGSD0nrTLaM2Tr4W3a7kA+vEC/+iHSgCdmGEfxwHIUTqiQ2WlA9mrmflBiYzn
	 S3Kl30fKZ6iByD8RtcAE0+mKyTFhFNYKFgllNa5Asl6wub9C72ciARU5vUXKE7eune6zF
	 g+Z777SCAy21OW3UAWV2DZuw14Pb/NqWiXAaapoPqFfkUByQnc6hNp+37jlDfpNi/Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882546;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=EZmGRSBN+eB3puIB/42VP1XZb+vVSV1IFt0IZ+Cg4YM=;
	b=j/zp+aEJe442+c1MkAycLKfZyk0MB+CS/l9tGgPhGblVMTAZ11XIeUDuE9Eq14EtgN1B
	 UeYLv/BOKNNXMrld0SF49eDgevskcvFfrh1PKhAA1tn9RlrWTNz3XcH4TIMZnUYmtKdN8
	 WAaWdjQLZb2ub8qrBaAzg31ykBJKu+IEo0DWD8UsMsQFQTIa0AYsOuK6foi/p+06vNzSk
	 Agm38RtZpzJAD6dr9sr6/ytV+FWvtJcI8B/im1q2NdMOpQd+fp5SR9TsXZeNF+Ud9xwIl
	 /oZjJWg2u0yttHPts+KMaqkwzoSjrOuAAqyNiRewPRPFKwL+E0Oy6Gdqxz5SXmAtsKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="cq+/olqx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E014606A339;
	Thu,  5 Nov 2026 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cq+/olqx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2451F0093A;
	Thu,  5 Nov 2026 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882545;
	bh=EZmGRSBN+eB3puIB/42VP1XZb+vVSV1IFt0IZ+Cg4YM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cq+/olqxEzdR6EJRb7Lxj5TPf2WYgAV9bsNNOZliDweRdhOxjHEVHBrg/ZT9oZEkb
	 kK65/l1qnyvDpXzPnq7CynwrCNT/Q1PhZ7CVdzqRZ3NWi8dF5/yKSrSzBwkVeypaRr
	 0Lcl7a+ip1JpZfxlzgyEWnDEMeVWOEMEe+neKyBG15kPfkT51sl/EuxzkOPfB3u55l
	 Qc+OpmsoXnJ4MMTh7rFUY1P6CqKKqkmp6BNUXc8zW4qum0BU3fC+4v1rFmm1P8lhQP
	 H51/ARdpyOUUEfV7zfyFjA36ZUO0o0MBN7lGtHs75JOW5pomQ0S6vihihsRlJoKzqh
	 NELFQ4YEYD3WQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:33 +0100
Subject: [PATCH RFC v2 04/13] ext4: use sb_find_get_block_nonatomic() in
 ext4_get_inode_loc_noio()
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-4-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2030; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ua24qmRzKhalRBSxZriDalt6JVdk8y+xrY2DyaH+Udw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZzSr30h90C73L7zqz/MySm1eJlbOnUTb8f9n8+PO
 Rz2nW61tqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiN2sZ/ilfWtyod/bPhNak
 VO/Z5z9Uij6c6mtc3Ta/+avmuR93DzIxMlxkW9yxq1Wdz+XjqpQ5xxUC5Ivz/fTUyhg03mu47bt
 oxgUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

ext4_get_inode_loc_noio() looks the inode table block up with
sb_find_get_block(). That's the atomic lookup. It serializes against
try_to_free_buffers() with i_private_lock instead of the folio lock and
gives up if the folio is being migrated. So it can report the block as
not cached while it is.

For ext4_fc_snapshot_inode() that only means falling back to a full
commit. But ext4_sync_inode_metadata() is going to use
ext4_get_inode_loc_noio() to find the inode block that fsync() has to
write out and there a dirty block must not be skipped.

ext4_fc_snapshot_inode() is the only caller and it can sleep. It runs
under jbd2_journal_lock_updates() and allocates the snapshot with
GFP_NOFS. So use sb_find_get_block_nonatomic() which takes the folio
lock and waits for the migration instead.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b4d581aa5ee1..4484c2383eaf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5876,7 +5876,8 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
 /*
  * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
  * It looks up the inode table block in the buffer cache and returns -EAGAIN if
- * the block is not present or not uptodate, without starting any I/O.
+ * the block is not present or not uptodate, without starting any I/O. It may
+ * sleep on the folio lock of the block.
  */
 int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
 {
@@ -5912,7 +5913,7 @@ int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
 	}
 	block += inode_offset / inodes_per_block;
 
-	bh = sb_find_get_block(sb, block);
+	bh = sb_find_get_block_nonatomic(sb, block);
 	if (!bh)
 		return -EAGAIN;
 	if (!ext4_buffer_uptodate(bh)) {

-- 
2.53.0

