Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805E73E3C48
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782462937; cv=none; b=R3wesTWhDgW2x1lQaKoLRD6DLPnfZ8gwbT1xqYycKohzrGP+cc28B233dcJlD1HJYXQRmPkx0M8cKCi7H5jEMVntmFtI4uLuYYTgN45hYCiJaOD/hpBrqRYG539nwEn73KduMBJnmdmmiY4RKZ6NEEwg++UwrCmdi0HNh4IsVGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782462937; c=relaxed/simple;
	bh=dIodXIa25zp+wFZekGagvKBkctMQIXtfB9VYdRRSLn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9HpoqsS9bnkFgAlSmyoOaU8+JohHVYEedMz7UAd5JNSoHCV+uRVSvMFXgBA887kZYaZdnHf+ezLSrNm9MM3lLbm/jPrMJh/sdER6ExuMiYZdOhFulZw9GLT8WIokx9sn6zWxKN+TQhPiNM+Tk+GmK2uSDppabxyqk+6zjR0xQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DJy9PZPt; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DJy9PZPt"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782462931; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=HCQEdys372BeUTJyN2T9I+3CAtzNpqFjiClwous+eV4=;
	b=DJy9PZPt7gCotndnqJwOPqIg39Z8X1yX2Bu2TqVTRk85sOPQZlm5M0kqrEir0SMiZM1XgcR23D5kogn2Ai1WpiSGP2LIjuf6WDys5kRkx+LK9H/u18SO6GvQFGrPO3t+LZnGNbC02c/E5GrmP5b4MAOi+PgdXfDVQeJAznT+KAo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X5e4zi0_1782462930;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5e4zi0_1782462930 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Jun 2026 16:35:30 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v3 2/9] ext4: drain in-flight DIO before buffered write fallback
Date: Fri, 26 Jun 2026 16:35:11 +0800
Message-ID: <20260626083518.1064517-3-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
References: <20260626083518.1064517-1-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

generic/746 started failing intermittently on ext3 (no-extent inodes).
The test triggers 'Page cache invalidation failure on direct I/O'
warnings and subsequent fsync returns -EIO. Adding a 50ms delay
between ext4_buffered_write_iter() and filemap_write_and_wait_range()
in ext4_dio_write_iter() makes the race almost always reproducible.

On no-extent inodes, DIO writes to holes cannot use unwritten extents,
so ext4_iomap_alloc() leaves m_flags=0 and ext4_map_blocks() returns 0.
The iomap layer then returns -ENOTBLK, causing fallback to buffered I/O.

The fallback path in ext4_dio_write_iter() calls
ext4_buffered_write_iter() which dirties pages, then does flush and
invalidate. However, there's an unprotected window between
ext4_buffered_write_iter() returning (with inode lock released) and
the subsequent flush+invalidate.

Concurrent async DIO completions from other threads can run
kiocb_invalidate_post_direct_write() during this window. If pages have
been re-dirtied, post-invalidation finds dirty pages and triggers the
warning, setting -EIO in the error sequence.

Consider a file with two 4k extents: [hole][written]. Thread A does
DIO to the written extent, while thread B does DIO spanning both:

  kworker A (4k DIO, allocated block)    kworker B (8k DIO, fallback)
  -----------------------------------    ----------------------------
  inode_lock_shared()                    inode_lock_shared()
  iomap_dio_rw():                        iomap_dio_rw():
    kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
    submit_bio (async)                     dio->size = 0
  inode_unlock_shared()                  inode_unlock_shared()

  [bio pending in block layer]           /* fallback: lock released */
                                         ext4_buffered_write_iter()
                                           inode_lock(exclusive)
                                           generic_perform_write()
                                             -> dirty pages [0, 8k]
                                           inode_unlock(exclusive)

                                         /* pages dirty, no lock */
  [bio completes]                        filemap_write_and_wait_range()
  iomap_dio_complete()                     -> flush dirty pages
    kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
      invalidate_inode_pages2_range()
      -> finds dirty page!
      -> dio_warn_stale_pagecache()
      -> errseq_set(-EIO)

This issue can be triggered through normal I/O paths, not just
intentionally overlapping DIO writes from userspace. For example,
generic/746 uses a loop device where multiple kworkers issue concurrent
I/O to the backing file. Additionally, when block_size < folio_size,
non-overlapping DIO writes that share a large folio can also trigger
the race.

Add inode_dio_wait() in ext4_buffered_write_iter() before
ext4_write_checks() to drain all in-flight DIO. This ensures that
all DIO clears existing pages before submitting IO (via
kiocb_invalidate_pages()), all BIO waits for all DIO to complete
(via inode_dio_wait()), and ext4_write_checks() observes the inode
size after all completed DIO so that ext4_block_zero_eof() does not
race with in-flight DIO, thus eliminating the race.

Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
Suggested-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index eb1a323962b1..130edf1ac242 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -309,6 +309,13 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 		return -EOPNOTSUPP;
 
 	inode_lock(inode);
+
+	/*
+	 * Prevent concurrent direct I/O and buffered I/O to the same file
+	 * range. Wait for in-flight DIO to finish before dirtying pages.
+	 */
+	inode_dio_wait(inode);
+
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
 		goto out;
-- 
2.43.7

