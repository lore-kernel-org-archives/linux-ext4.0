Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A9377EC3
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 13:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781615435; cv=none; b=XrDEIsxqBdQjCdXHT7oK88hubVKqhDO9JTxO89aeTaEyelemIrN1uvXsuNrBRTw3q0GLDnJ553CVWOueQ3Sd5SEYL+xNbRpdCocHrsh2gRppuxgTtAIDgJMCqb7eB6qKFr30islGBxl8Ff8NzFnzcCyfPOa9DsbuDN2PvfQFqDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781615435; c=relaxed/simple;
	bh=kGI9SmCfJc2T7tFwIKJvib66L1GFSOzeRJB4HHgajUo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=TZ2cZ4LU4h/36YxJrhaXMwZmP/PoYrPdZxW2rWQmmYd7S9nIEMix8hwwXs9tlJzVUorsvL3VOicJaqjtuxicf8qzEluzkUMvgx7i9qBP4I3cM0VzH7zHtjz3SqisiGWQIGcUETumutshu40gGD9WLNqixsF8X64wv5emAz0LaX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZLiWBXEa; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZLiWBXEa"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781615415; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=kGI9SmCfJc2T7tFwIKJvib66L1GFSOzeRJB4HHgajUo=;
	b=ZLiWBXEaK81RwYq3KygD808nnmfWUf9Wqv08m8/2ajp1VGwrgt3+e6Jomqij1RAnvxFGZ9GSCOjUVee4G/YpmW3AcG4E6g4elCEkB4aMSabrhn+Q9WA5BnwgSGb6rv4FGDoYrOPFB8nXBLfYa37aZ9TWXwz/USGArrmQ0sUhb20=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X5.YP5p_1781615413;
Received: from 30.221.147.255(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X5.YP5p_1781615413 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Jun 2026 21:10:14 +0800
Message-ID: <060f63e0-d64f-40df-99a7-af53862049ee@linux.alibaba.com>
Date: Tue, 16 Jun 2026 21:10:12 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
From: Baokun Li <libaokun@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 peng_wang@linux.alibaba.com
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
In-Reply-To: <20260611163441.2431805-3-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

Thank you for your review!

After extensive testing, I found that after merging this patch, generic/746
started failing intermittently on ext3 (mkfs.ext4 -O ^extents).  The test
triggers a "Page cache invalidation failure on direct I/O" warning, and
subsequent fsync returns -EIO.

The underlying race existed before this patch, but this patch appears to
have widened the reproduction window considerably, so I thought it worth
trying to address.  Here is my analysis:

On no-extent inodes, DIO writes that hit holes cannot use unwritten
extents.  ext4_iomap_alloc() leaves m_flags=0, so ext4_map_blocks()
returns 0 for a hole, and:

        if (!m_flags && !ret)
                ret = -ENOTBLK;

The iomap layer returns -ENOTBLK to ext4, which falls back to buffered
I/O.  The fallback path dirties pages in the page cache, then flushes
and invalidates them.  However, concurrent async DIO completions to
other blocks on the same inode can run kiocb_invalidate_post_direct_write()
without holding the inode lock.

Consider a file with two 4k extents: [hole][written].  Thread A does DIO
to the written extent, while thread B does DIO spanning both extents:

  kworker A (4k DIO, allocated block)    kworker B (8k DIO, hole->fallback)
  -----------------------------------    -----------------------------------
  inode_lock_shared()                    inode_lock_shared()
  iomap_dio_rw():                        iomap_dio_rw():
    kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
    submit_bio (async)                     dio->size = 0
  inode_unlock_shared()                  inode_unlock_shared()

  [bio pending in block layer]           /* fallback: inode lock released */
                                         ext4_buffered_write_iter()
                                           inode_lock(exclusive)
                                           generic_perform_write()
                                             -> dirty pages [0, 8k]
                                           inode_unlock(exclusive)

                                         /* pages still dirty here */
  [bio completes]                        filemap_write_and_wait_range()
  iomap_dio_complete()                     -> flush dirty pages
    kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
      invalidate_inode_pages2_range()
      -> finds dirty page!               /* window closed */
      -> dio_warn_stale_pagecache()
      -> errseq_set(-EIO)

The critical window is the gap between ext4_buffered_write_iter() dirtying
pages and filemap_write_and_wait_range() flushing them.  In this window the
inode lock is not held, so another thread's async DIO completion is free to
invalidate the still-dirty pages in the page cache.

This race has always existed on ext3 because indirect-block inodes lack
unwritten-extent support.  However, the window was extremely narrow in
practice, because the old ext4_overwrite_io() checked every block and
would conservatively take an exclusive lock.  This patch replaced it
with ext4_dio_needs_zeroing(), which only checks head and tail blocks,
making unaligned DIO more likely to take a shared lock and
proportionally increasing the chance of hitting the race.

I tried a couple of alternatives before settling on the patch below:

1. Force exclusive lock + IOMAP_DIO_FORCE_WAIT for all no-extent DIO.
   This closes the window for new DIO submissions, but does not protect
   against bio completions from previously submitted async DIO, which
   run independently of the inode lock.

2. Wrap the fallback dirty+flush+invalidate sequence in
   filemap_invalidate_lock().  However, the ext4 DIO and iomap layers
   do not use this lock, so it would not serialise against DIO
   completions.

One straightforward approach that seems correct is to skip direct I/O
for no-extent inodes entirely, by returning 0 from ext4_dio_alignment():

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6131,6 +6131,8 @@ u32 ext4_dio_alignment(struct inode *inode)
 {
        if (fsverity_active(inode))
                return 0;
+       if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+               return 0;
        if (ext4_should_journal_data(inode))
                return 0;
        if (ext4_has_inline_data(inode))

With this, ext4_should_use_dio() returns false for no-extent inodes, and
all I/O goes through ext4_buffered_write_iter() directly, bypassing the
DIO path entirely.  On ext3, DIO to a hole already falls back to buffered
I/O, so there is essentially no performance benefit to using DIO in the
first place.

Note that with this change, the fallback branch in ext4_dio_write_iter():

        if (ret >= 0 && iov_iter_count(from)) {
                /* buffered fallback */
        }

would also become dead code for extent-based inodes (since unwritten
extents guarantee iomap_dio_rw() never returns zero with unconsumed
data), and could be removed in a follow-up cleanup.

Thoughts?  Is there a reason to preserve DIO on no-extent inodes that
I'm missing?

Looking forward to your feedback.


Thanks,
Baokun


