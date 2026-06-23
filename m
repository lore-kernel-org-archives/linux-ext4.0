Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943AB38B7DD
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 03:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782184311; cv=none; b=qH4E1JBu6DiF9OlaLgGUtUmoCSVg4IEq13Rg8HUqd9nZuZkNX6+U37yIKtbZGZWO7PGywN3m+jjEKsJ8USi+qFXhUpYiIoED69ec1WLaP5QLhDBcSqwZW1poRmWHhPu34y17ym7T2w601HyjDrmEB9fdWWli28beFmZUHCiH2lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782184311; c=relaxed/simple;
	bh=mUoAZD5xiZBIte7BTZvDNnRpUoev+yARHIRo/VsnClM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iyonRgqHHnJex2EsXOfM/A5Wao8xsK6HC0p5L3WfDhOJV8vFjhwUWHLij/DqrVWongwAE57GMpyWmU2aXH2/ERZDgqE1jZE1TLNK0pdhG9BQ7WMyV5yRY+ZMEeoo8XuZEC8OmqO+ftp4U9vEn/yyPxEhajpIrSn8gSd9aGEGCF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gkqnr3DLwzKHMbN
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:10:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D88254073C
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 11:11:37 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgB3eT5n+Tlq3XsfCw--.58024S3;
	Tue, 23 Jun 2026 11:11:36 +0800 (CST)
Message-ID: <4030530f-d7ad-4630-b07c-b31645a1a210@huaweicloud.com>
Date: Tue, 23 Jun 2026 11:11:34 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] ext4: drain in-flight DIO before buffered write
 fallback
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-3-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260618125735.4156639-3-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgB3eT5n+Tlq3XsfCw--.58024S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZrW8Jry8WryUZw1kKFW3Wrg_yoWrGw17pr
	yfKF9rGryDXrZrurs7GF48uF1jgwnrJrWfGrZ8W3W8Zryqyr1jgF10gr10vFW3JrZrGw4a
	qF4vv3srWF1jvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/18/2026 8:57 PM, Baokun Li wrote:
> generic/746 started failing intermittently on ext3 (no-extent inodes).
> The test triggers 'Page cache invalidation failure on direct I/O'
> warnings and subsequent fsync returns -EIO. Adding a 50ms delay
> between ext4_buffered_write_iter() and filemap_write_and_wait_range()
> in ext4_dio_write_iter() makes the race almost always reproducible.
> 
> On no-extent inodes, DIO writes to holes cannot use unwritten extents,
> so ext4_iomap_alloc() leaves m_flags=0 and ext4_map_blocks() returns 0.
> The iomap layer then returns -ENOTBLK, causing fallback to buffered I/O.
> 
> The fallback path in ext4_dio_write_iter() calls
> ext4_buffered_write_iter() which dirties pages, then does flush and
> invalidate. However, there's an unprotected window between
> ext4_buffered_write_iter() returning (with inode lock released) and
> the subsequent flush+invalidate.
> 
> Concurrent async DIO completions from other threads can run
> kiocb_invalidate_post_direct_write() during this window. If pages have
> been re-dirtied, post-invalidation finds dirty pages and triggers the
> warning, setting -EIO in the error sequence.
> 
> Consider a file with two 4k extents: [hole][written]. Thread A does
> DIO to the written extent, while thread B does DIO spanning both:
> 
>   kworker A (4k DIO, allocated block)    kworker B (8k DIO, fallback)
>   -----------------------------------    ----------------------------
>   inode_lock_shared()                    inode_lock_shared()
>   iomap_dio_rw():                        iomap_dio_rw():
>     kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
>     submit_bio (async)                     dio->size = 0
>   inode_unlock_shared()                  inode_unlock_shared()
> 
>   [bio pending in block layer]           /* fallback: lock released */
>                                          ext4_buffered_write_iter()
>                                            inode_lock(exclusive)
>                                            generic_perform_write()
>                                              -> dirty pages [0, 8k]
>                                            inode_unlock(exclusive)
> 
>                                          /* pages dirty, no lock */
>   [bio completes]                        filemap_write_and_wait_range()
>   iomap_dio_complete()                     -> flush dirty pages
>     kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
>       invalidate_inode_pages2_range()
>       -> finds dirty page!
>       -> dio_warn_stale_pagecache()
>       -> errseq_set(-EIO)
> 
> This issue can be triggered through normal I/O paths, not just
> intentionally overlapping DIO writes from userspace. For example,
> generic/746 uses a loop device where multiple kworkers issue concurrent
> I/O to the backing file. Additionally, when block_size < folio_size,
> non-overlapping DIO writes that share a large folio can also trigger
> the race.
> 
> Add inode_dio_wait() in ext4_buffered_write_iter() before
> generic_perform_write() to drain all in-flight DIO. This ensures
> that all DIO clears existing pages before submitting IO (via
> kiocb_invalidate_pages()), and all BIO waits for all DIO to
> complete (via inode_dio_wait()), thus eliminating the race.
> 
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> Suggested-by: Zhang Yi <yi.zhang@huawei.com>
> Link: https://patch.msgid.link/d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/file.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index eb1a323962b1..9f9bc0b13772 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -313,6 +313,12 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
>  	if (ret <= 0)
>  		goto out;
>  
> +	/*
> +	 * Prevent concurrent DIO and BIO to the same file range.
> +	 * Wait for all in-flight DIO to complete before dirtying pages.
> +	 */
> +	inode_dio_wait(inode);
> +
>  	ret = generic_perform_write(iocb, from);
>  
>  out:

