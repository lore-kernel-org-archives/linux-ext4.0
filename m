Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792652050;
	b=Y2u4bovtrtj3Uzr8/qhjfBlvsVKc1WYTckgntDJZ2SbS470bbDR9Y4DgfV7+fJZHIIhK
	 2C9HALJmLFNpLXZEEpW6AurJ2VYnXM2xkRYneiY85VmLpTBmBRfaZRhZhda1z7jKEZpzx
	 YF+oCgDazgWz+s0zDb4NhCI4h95sdG15XrngXM7T03mwSKmmTUdMxXV4yFQ+e/AvlztB2
	 syISo7Snn2oxfxk0yR5mpterKAilwCh5aS9Cbpwt4AA+vYcAmhcP7ysMDMVLFLKA8wTHO
	 yaBMMR4dduf6uicRiWgyDfF3Fq75/cLB6UVGIA/VuNv9/USSKZ1O8sUAX6YI3jKJTNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792652050;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SYg9jltbjI4Z50mGckymcx0vPC7eF9PA/cqUej8Wfrw=;
	b=rcstA3pvkRQWeP5NMNC6MgKIuD0SapP7zJGUlsqh2d78zOd1ZKqdcb0WEuiKTo8TGs4/
	 KOgMeT+D1FnuS28j9bUd6nBzRa/iV+FD6oqfmIE7VKNf+5gJU7BNefhG5RMuGMz7oJyN5
	 aCjcMTOwPicALxLGRoMTy/WvRWsbUBLl1ha/cecE5gFF0jsfVALO5VaqBss7vBCkSxbDk
	 roE1aruuJWz+YavpgJ2xU3fpbO5O07dWgg1bpR51TMKjgNaCJVVcE0v3D7jzasX1G/wlE
	 dz3O89WoP9wFMLK79wVKcm2nxP2iTQ2wbtQhLWKCvCePLYEylHS+OZwcf+Y+XfrRRnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JelJsuJV;
	arc=none smtp.remote-ip=115.124.30.133
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8FC606A321;
	Thu, 22 Oct 2026 06:54:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D8FC606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JelJsuJV
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792652036; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SYg9jltbjI4Z50mGckymcx0vPC7eF9PA/cqUej8Wfrw=;
	b=JelJsuJVAV6UhJhEvF0JrIjF5OAJh/PB7Gol+YibN38u9MMihld1QcRyp0nR4DYEzFkVE8aoeZ2CQ7rX7Chw8B6KW1gYC9VHQbcPE6lLxK8Xwy5hvf+o/cVddC7DHxENlAIWxTcxeRhLX19ymP12ZSxLtLNimtXSAMOD7LdHGjg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XDISZiK_1792652023;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDISZiK_1792652023 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 14:53:56 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ext4: skip eof zeroing when the zero range covers the eof block
Date: Thu, 22 Oct 2026 14:53:42 +0800
Message-ID: <20261022065342.3569693-1-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ext4_zero_range() drops the page cache of the range before allocating,
to avoid exposing stale cached data.  However, the dropped page can be
read back by the eof zeroing:

  fallocate(fd, FALLOC_FL_ZERO_RANGE, 0, 4096)
    ext4_zero_range()
      ext4_truncate_page_cache_block_range(0, 4096)
        truncate_pagecache_range(0, 4095)
          truncate_inode_pages_range()
            delete_from_page_cache_batch()  # drops the page
      ext4_alloc_file_blocks(..., 4096)
        ext4_block_zero_eof(512, LLONG_MAX) # not block aligned
          ext4_load_tail_bh()
             filemap_lock_folio(0)    # reads dropped page back
             # zeroes [512,1024), marks the buffer dirty
        ext4_map_blocks(...)          # zeroes the blocks on disk
      ext4_update_inode_size(inode, 4096)

The bytes below the old EOF keep the stale disk content.  The page is
left dirty, so read() returns old data while O_DIRECT reads zeroes, and
a write into the same block is not converted and is lost until the page
is dropped:

  page [0, 4096), 1k block size, file ends at 512
   0            512          1024                      4096
   |--- data ----|-- tail ---|---- zero range ----------|
   | old data    |           |                          |

For example:

  $ xfs_io -f -c "pwrite -S 1 0 512" f
  $ sync
  $ fallocate -z -o 0 -l 4096 f
  $ xfs_io -c "pread -v 0 16" f  # old data, not zeroes

Since the whole eof block is converted to unwritten, zeroing it here is
redundant.  Therefore, skip the zeroing when this allocation covers the
eof block entirely.

Keep the zeroing otherwise: the block is still written at that point,
so touching the page cache is safe.

Fixes: c7fc0366c656 ("ext4: partial zero eof block on unaligned inode size extension")
Cc: stable@vger.kernel.org
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/extents.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad0d80e33f60..2ce33fd3b912 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4639,8 +4639,15 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
 	credits = ext4_chunk_trans_blocks(inode, len_lblk);
 	depth = ext_depth(inode);
 
-	/* Zero to the end of the block containing i_size */
-	if (new_size > old_size) {
+	/*
+	 * Zero to the end of the block containing i_size.
+	 * Loading the eof block back before it is converted to unwritten
+	 * may leave the page cache inconsistent with the disk, and zeroing
+	 * it is redundant, so skip it.
+	 */
+	if (new_size > old_size &&
+	    (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) ||
+	     !in_range(old_size >> blkbits, map.m_lblk, map.m_len))) {
 		ret = ext4_block_zero_eof(inode, old_size, LLONG_MAX);
 		if (ret)
 			return ret;
-- 
2.43.7

