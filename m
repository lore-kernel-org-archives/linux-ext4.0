Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882559;
	b=x9JE+Y6dk1f4+6kz+4ujACwHJkGe+cRbXb48teLCR89mvQvuXaITqVUenmsxFyhkKgBi
	 Js3UpEmkR6QtIkbx1nBslcPNRVOFGSrH0coHr4kxXaR3W0Qos5HuLlQ9YwfmVlY02EtyP
	 I/DbUBVO16ZY3WosZSEECZkrXwpQDs0Bvme4Ghh50EjWfRfKeSF0jMMT+4hYVsrFit/mS
	 C2SfaLMNcndZsxUF0PDZs9xP1qlJjggFw/9oR/Ir6AW60Z9LhwdzGV/JvCG2EYDCBqr6o
	 Z64Xs6eCrGjFuJm80OgnQNJsGS+w6G517zdOSubMb5/VXEp1mg3xQx7GphSRWHE8rcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882559;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=aVQosNCaKSj9sGFZm3OzSLAh+WDNR5REm0O9s4BZk4Y=;
	b=QQ5plwQdAQtP1mDhRGIWtr0KnsEINhdh5Gi9D/BSJBNlPe4LRqNi92PBX3AURjPa31xd
	 97LveoZJLnpNuvNT8McH7p6ZXL/0SrF1kHgkYgz2Y0BIGcmvQU0dUo8sC3dU7UfcO8qPq
	 1UibJDQx7jcpWkggNrY+8OMrCAua54+kKCF2DmhcQSiVon2K28wIEfoKwmaORti4f5JGw
	 LOb3UHpaP9GDj8v9WMp/AcusJ+upQuxigOJpjB9q1eKu62PP27yxgjbLqoPj3Rg/hwDXn
	 h35Pv2KGZh966LviWcsCBkIc8m3YSN/yL94bQGPTFhnN5ktyyDbpd+8caT3EuHBi/Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZbiAaiWO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00350606EEA6;
	Thu,  5 Nov 2026 12:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZbiAaiWO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA381F0093A;
	Thu,  5 Nov 2026 12:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882558;
	bh=aVQosNCaKSj9sGFZm3OzSLAh+WDNR5REm0O9s4BZk4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZbiAaiWOVYBixRjNTMHkEa33PClLZij9BzIVjKR62lvtdIyqfXNQqcfJQ4k8NT23c
	 IQjHSWfpBH5IR56zWp1o9gmj8n2f9tkeAU9ITAaNT4LcsuI5RjKp2Hs26/Bt4H0ZQP
	 9UjfVZZn+kKh43V2heWO4HvzXIuEdxGx8D3HVcvkz/cnf6NugvgOpyMnEV4fzSMumz
	 YtBaoCtsD3t+HRS1jsBPShnky3lActHwz12Lb73+stwrtPkCqFtVORrIRgrJUO+lB1
	 Ol074FeiNrVdVADhqNTAu6Di43uu/xNDKIQlKjNjcJKiE+Qmh5qh7o3oIZz7GfMQAI
	 NpH3cbEvbxG6A==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 05 Nov 2026 13:41:37 +0100
Subject: [PATCH RFC v2 08/13] minix: don't read the inode block in
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
Message-Id: <20261105-work-inode-metadata_writeback-v2-8-48628c60c336@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1762; i=brauner@kernel.org;
 h=from:subject:message-id; bh=i0iFIRlfPbgkN3WC6uE5i+bRrUzqXZsZa3h0C0TGQr4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9qZwZeudDB0vNA5HfDc7uJ0ourny1mPXY8ZfJ7hXqD
 deTwgWLO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyKoOR4c/mtr8W7dVOnodu
 6txsK/7MLzzzF9tj14x2/o49LeEFuQz/y4MyZvTenb7cs8E/iT1+DavZStvlX35vzj8Z9NM5ZKE
 sMwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

minix_sync_inode_metadata() looks the inode block up with
minix_V1_raw_inode() or minix_V2_raw_inode() which read it from disk if
it isn't cached. But a block that isn't cached is neither dirty nor
under writeback, so there's nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
sb_find_get_block_nonatomic() instead.

Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
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

