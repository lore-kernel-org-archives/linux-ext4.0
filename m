Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6B53EFFC9
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 12:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787479; cv=none; b=JOr6gZVX2UKpKiYXoRCc0vZZKuXreDbpj2PP0fiHaf5Ud7AFQCKfcusyJxbGnQLlgmTBnW7PNTNbyZfKrf8KxkVbjQNX0MC1ZS/XkdE6Bs8aRq4TkYzYR9T9LmqO077H98pPsQj4ZEawD/FZT1EepOCHLXIlEgPJBR1A50zpbA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787479; c=relaxed/simple;
	bh=f8n2UDmqn1QB+yqJ0QszoqnqqBEsBHInfGeBaRszs/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZGZvEZW9qMSlVs5mbMdukb6YYpcxrL4p59uasgPyWQTqq8/Dv1R9it+lhKLHQKMDTeo6ETqgMvwqb3Wq9XMa5BUzAu4H5qi+MH6BGIipDCubeU1w7Vs7VkaRfshQHhe1oYV9hxFQdvX9wFEBJg5xwaz3yA2mmS4FU1ozy+NYdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Wl0T6TyP; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Wl0T6TyP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781787472; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=AJ7VUW7pZ4022n21yA3uAQTvzOvkMAlNXE7YezW+1qo=;
	b=Wl0T6TyPgU0fbdAaYJvJo+7QPDMjmEGQdwBTDMMuZ1v7FheFCS3lJC7+/8o9xvtL7bMNRrLmukv0m2Rd/a4ucwAzqeChX/QlDCJESjb8B1wBwFv2lkYQY0NvdECRJBJ0RDAmdnvSD2o/3mfjlDr1UtLCuZ7UDAzgu8TWGETYcEw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X575f1M_1781787471;
Received: from x31h02109.sqa.na131.tbsite.net(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X575f1M_1781787471 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 20:57:52 +0800
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	yi.zhang@huawei.com,
	ojaswin@linux.ibm.com,
	ritesh.list@gmail.com,
	peng_wang@linux.alibaba.com
Subject: [PATCH v2 2/8] ext4: drain in-flight DIO before buffered write fallback
Date: Thu, 18 Jun 2026 20:57:29 +0800
Message-ID: <20260618125735.4156639-3-libaokun@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
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
generic_perform_write() to drain all in-flight DIO. This ensures
that all DIO clears existing pages before submitting IO (via
kiocb_invalidate_pages()), and all BIO waits for all DIO to
complete (via inode_dio_wait()), thus eliminating the race.

Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
Suggested-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
---
 fs/ext4/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index eb1a323962b1..9f9bc0b13772 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -313,6 +313,12 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 	if (ret <= 0)
 		goto out;
 
+	/*
+	 * Prevent concurrent DIO and BIO to the same file range.
+	 * Wait for all in-flight DIO to complete before dirtying pages.
+	 */
+	inode_dio_wait(inode);
+
 	ret = generic_perform_write(iocb, from);
 
 out:
-- 
2.43.7

