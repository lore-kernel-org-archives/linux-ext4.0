Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1359232C8B;
	Thu, 24 Sep 2026 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790242309; cv=none; b=KqDQG0PKJaAmGGWePaWMgwUN+GmYe4N6/mHOMOx+s1cm4xsCZOUUPvzvR9r3YCBk/PaPikHrPUkbcaCYDqqJmIDK7q9jraAjXg2ZYLnlTueqp9cPrZmN1flE1mX/2RMkg83QfLTKuuMfG19wp4jOOMdBWSGOnGIfyfD3d2fQvVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790242309; c=relaxed/simple;
	bh=Eii8pIapq3+IVKHeZMnWF/ITHh8UnbjO9k7WQIJ1NC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tqbWunvGgsx/RY93jTdtPbSE2oKnU9ynI6XUNcGPzMwgiANzyd8UROIhjeCZTmJm2XDaV8Ov4vGkTO30gGZfnraMeESV1j/1uOdK5YEguhXQFj9Ww1miB9fRMxsUxa23VAk0nslHWi20s+7KnLXrjJiKhxl76TnBrtUR8o1vMY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hr7r35d2TzKHMdk;
	Thu, 24 Sep 2026 17:31:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 10A5D40574;
	Thu, 24 Sep 2026 17:31:43 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXdCf87bRq9wz3BQ--.25718S3;
	Thu, 24 Sep 2026 17:31:42 +0800 (CST)
Message-ID: <5a454f2a-8ae2-491d-b903-750c945cfb9d@huaweicloud.com>
Date: Thu, 24 Sep 2026 17:31:40 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, jack@suse.cz,
 bfoster@redhat.com, ziy@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, joannelkoong@gmail.com, djwong@kernel.org,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXdCf87bRq9wz3BQ--.25718S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF13Kr15CrW8WF4kKr4UArb_yoWxWw1kpF
	WUKrnayrW8Wr47Cr4kua1kZr1rW3ykXa1UAFyxGr9ayrnYga42kry2g3W09ay8Kwn7AF1F
	qF4jvFWq9a1qyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	4xRDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/



On 9/22/2026 7:07 PM, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When the mapping has a non-zero minimum folio order (min_order),
> folio_split() in truncate_inode_partial_folio() stops at min_order
> instead of order 0, so the sub-folio containing a split point stays
> aligned to 1 << min_order rather than to a single page. The original
> boundaries in truncate_inode_pages_range() were based on page
> granularity, so either boundary could land inside the min_order chunk at
> its edge, and the truncation loop would drop that whole chunk, valid
> out-of-range tail included.
> 
> For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
> offset 0 to 36K:
> 
>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>   folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
>   2nd split of folio2 -> [p8-p11, p12-p15]    # success
>   end(old) = p9                               # BUG: p9 inside [p8-p11]
>   loop truncates ... p8-p11               # p9-p11's valid tail is lost
> 
> It has gone unnoticed so far for two reasons. A non-zero min_order is
> only used by filesystems with a block or sector size larger than the
> page size, and those either always write back the affected range before
> punching a hole or truncating, or they carry filesystem private data on
> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
> fail and folio_split() abort with -EBUSY, so the folio is never split
> and the old start/end boundaries remain valid. The bug only becomes
> reachable on paths that truncate dirty large folios without prior
> writeback and without filesystem private data, such as the upcoming ext4
> iomap buffered I/O path.
> 
> Align both start (rounded up) and end (rounded down) to the mapping
> minimum folio order so they always fall on a folio boundary.
> 
> Reported-by: Joanne Koong <joannelkoong@gmail.com>
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/truncate.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..f9625bb4916f 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>   * @lstart: offset from which to truncate
>   * @lend: offset to which to truncate (inclusive)
>   *
> - * Truncate the page cache, removing the pages that are between
> - * specified offsets (and zeroing out partial pages
> - * if lstart or lend + 1 is not page aligned).
> + * Truncate the page cache, removing the folios that are between specified
> + * offsets (and zeroing out partial folios if lstart or lend + 1 is not
> + * folio aligned).  For mappings with a non-zero minimum folio order, the
> + * boundaries are aligned inwards to 1 << min_order so the edge sub-folio
> + * straddling the range is kept.
>   *
>   * Truncate takes two passes - the first pass is nonblocking.  It will not
>   * block on page locks and it will not block on writeback.  The second pass
> @@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	int		i;
>  	struct folio	*folio;
>  	bool		same_folio;
> +	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
>  
>  	if (mapping_empty(mapping))
>  		return;
>  
>  	/*
> -	 * 'start' and 'end' always covers the range of pages to be fully
> -	 * truncated. Partial pages are covered with 'partial_start' at the
> -	 * start of the range and 'partial_end' at the end of the range.
> +	 * 'start' and 'end' always covers the range of folios to be fully
> +	 * truncated, with both boundaries aligned inwards to 1 << min_order.
>  	 * Note that 'end' is exclusive while 'lend' is inclusive.
>  	 */
>  	start = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
> @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space *mapping,
>  	else
>  		end = (lend + 1) >> PAGE_SHIFT;
>  
> +	start = round_up(start, min_nrpages);
> +	if (end != (pgoff_t)-1)
> +		end = round_down(end, min_nrpages);
> +
Hi, all

The sashiko pointed out an issue on this patch:

> [Severity: Critical]
> Can this integer overflow on 32-bit architectures?
>
> In truncate_inode_pages_range(), pgoff_t is a 32-bit integer on 32-bit
> systems. If a hole punch or truncate operation occurs at an offset near
> MAX_LFS_FILESIZE, the start page index will be close to 0xFFFFFFFF.
>
> When min_nrpages > 1 (e.g., on filesystems supporting min_order > 0 like
> Ext4 with bigalloc), rounding up this index wraps it to 0.
>
> Would this wrap-around cause the entire page cache for the file to be
> truncated instead of just the intended tail, leading to data loss?


This is a pre-existing issue, and it is not specific to the truncate
path.

On 32-bit systems, for a mapping with a non-zero minimum folio order,
the last min_order-aligned block of a file of MAX_LFS_FILESIZE is also
the last block of the page index space, so the folio covering it ends at
or past the last representable page index.  All places that do offset
calculations on such end folios carry an overflow risk, e.g.,
folio_next_index() wraps to 0 for that folio, and the values derived
from it are wrong.

For example, on a 32-bit environment I create an ext4 filesystem with a
16KB blocksize, where the maximum file size is 0xFFFFFFFF000
(MAX_LFS_FILESIZE). If we run:

 xfs_io -f -c "pwrite -b 0x10000 0xFFFFFFFC000 0x3000" /mnt/foo

The last folio starts at 0xFFFFFFFC000, but its length is 0x4000,
so calling folio_next_index() on it will overflow, leading to
unpredictable errors.


I think the root cause is that sb->s_maxbytes is set to
MAX_LFS_FILESIZE, which on 32-bit is (loff_t)ULONG_MAX << PAGE_SHIFT.  A
folio is at least min_order pages and min_order aligned, so the file
must have at most ULONG_MAX + 1 - (1 << min_order) pages for the last
folio's next index to stay representable.

I suppose filesystems that use a non-zero minimum folio order should cap
sb->s_maxbytes instead of using MAX_LFS_FILESIZE directly, something
like this:

static inline loff_t max_lfs_filesize(unsigned int min_order)
{
#if BITS_PER_LONG == 32
	return ((loff_t)ULONG_MAX + 1 - (1UL << min_order)) << PAGE_SHIFT;
#else
    return MAX_LFS_FILESIZE;
#endif
}

Any thoughts?

Besides, I understand that since this is a pre-existing issue, it
shouldn't block the merging of this series?

Thanks,
Yi.


