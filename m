Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792747444;
	b=l3WKTUHFVuYvoNNARvbktItj0DkAG7SFBHurV/sfhhnpwmdEfudOJt7scJAeVXVb8/jg
	 UvHfQlGdPPcUXUvc+rjaYNrsHwvAdgFBJGWLslIWDeOAhhFn3inFCXwA8KLLftyfrLKd3
	 h3tRRjc4iVJFfaCHJN/wTcYlyuahR17eoIumyBWEW7MBFz577GACuxaToC3ZGtvznvTd+
	 FYJHm+CsbxxwuOzWteZS4BMow+5jMYp8x9Kjlys7LhQoZqF0DPyz8RJYWXTBvYlpUcrIy
	 KCblUGdV0XXYNNBqwWmRmrLSRx8W79iHO68L6utTSuMiDxt3dNwxrzmnlwVa5M+hGww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792747444;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=8UWzL+0fgVXGhLJgm6KTUnBKczl9gCV1bEPkcSz2MAo=;
	b=o6C6HG8uMK+nhLv7kivDfwpeIaAkBcM+p5dnp9KuSlPMAZ9dbcwuPvO+vf+iT+T+SZLa
	 YJCGiDy7XG+UYBpTKViN4I97wb1gyBv8V2+6oT1ukr6asqkI6YwDgOpK8KJqDGRe1+/dV
	 EYe28C/yekDI8LKr08Q5xw5Fy/nhVqxArah0r8senXv/2G4OzgaqjNUOSo+z7umdl/QGs
	 Tiwqb7GVP2p9kAqDx6RCxPfRbl0R/9mL4CFQ4sjacayg4LslNt+MaNCqGIOHitbv6tmZH
	 Ya60vbMgFYuY2iWL2htDNxwWuhbPuiUG8Fjp1cCfDnAcg0AVM2HO5NxobObfd2O70Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=none smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF52606A31A;
	Fri, 23 Oct 2026 09:24:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFF52606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4j9yJ93KnPz1c0SR;
	Fri, 23 Oct 2026 17:23:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 31A6C4056B;
	Fri, 23 Oct 2026 17:23:59 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3tfStJ9tqTFwSBg--.20434S3;
	Fri, 23 Oct 2026 17:23:59 +0800 (CST)
Message-ID: <fc8f09e1-02b6-4d76-95d8-d19c5635f4d5@huaweicloud.com>
Date: Fri, 23 Oct 2026 17:23:56 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: skip eof zeroing when the zero range covers the
 eof block
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <sashiko-outbox-181121@kernel.org>
 <20261022122625.1744363-1-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261022122625.1744363-1-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3tfStJ9tqTFwSBg--.20434S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF15WF1DXrW7KFWUtr4Utwb_yoWrWryfpF
	Wa9r1xArs3u395uan7A3WI9r1rCwn3GF45Gry3KF48Z3sxXFyfKFyqga40gFyjkrs3J3Wj
	vF4Ygry7KFs8C3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/22/2026 8:26 PM, Baokun Li wrote:
> ext4_zero_range() drops the page cache of the range before allocating,
> to avoid exposing stale cached data.  However, the dropped page can be
> read back by the eof zeroing:
> 
>   fallocate(fd, FALLOC_FL_ZERO_RANGE, 0, 4096)
>     ext4_zero_range()
>       ext4_truncate_page_cache_block_range(0, 4096)
>         truncate_pagecache_range(0, 4095)
>           truncate_inode_pages_range()
>             delete_from_page_cache_batch()  # drops the page
>       ext4_alloc_file_blocks(..., 4096)
>         ext4_block_zero_eof(512, LLONG_MAX) # not block aligned
>           ext4_load_tail_bh()
>              __filemap_get_folio(FGP_WRITEBEGIN | FGP_ACCESSED)
>              # FGP_CREAT reads the dropped page back
>              # zeroes [512,1024), marks the buffer dirty
>         ext4_map_blocks(...)  # converts the extent to unwritten
>         ext4_update_inode_size(4096)
> 
> The bytes below the old EOF keep the stale disk content.  The page is
> left dirty, so read() returns old data while O_DIRECT reads zeroes, and
> a write into the same block is not converted and is lost until the page
> is dropped:
> 
>   page [0, 4096), 1k block size, file ends at 512
>    0            512          1024                      4096
>    |--- data ----|-- tail ---|---- zero range ----------|
>    | old data    |           |                          |
> 
> For example:
> 
>   $ xfs_io -f -c "pwrite -S 1 0 512" f
>   $ sync
>   $ fallocate -z -o 0 -l 4096 f
>   $ xfs_io -c "pread -v 0 16" f  # old data, not zeroes
> 
> FALLOC_FL_WRITE_ZEROES hits the same path.  ext4_issue_zeroout() zeroes
> the block on disk without updating the page cache, and the block stays
> written.  Therefore, writeback of the dirty page overwrites the zeroes
> with old data.
> 
> Since the whole eof block is converted to unwritten or zeroed out,
> zeroing it here is redundant.  Therefore, skip the zeroing when this
> allocation covers the eof block entirely.
> 
> Fixes: c4602a1d09ec ("ext4: move zero partial block range functions out of active handle")
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Hi Baokun,

Thank you for the fix, this is a nice catch. This makes sense to me.
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

One small point, the condition you added looks a bit confusing. I'm
wondering whether, in the future, it would be more straightforward to
extract ext4_block_zero_eof() from ext4_alloc_file_blocks() into
ext4_zero_range() and ext4_do_fallocate()?

Thanks,
Yi.

> ---
> Changes since v1:
>  * Also skip the eof zeroing for FALLOC_FL_WRITE_ZEROES, which
>    reads the dropped page back in the same way (Reported by Sashiko).
>  * Corrected the Fixes tags: the ZERO_RANGE regression comes from
>    c4602a1d09ec, and f4265b8d32c4 introduced the WRITE_ZEROES one.
>  * Fixed the call chains in the commit message.
> 
> v1: https://patch.msgid.link/20261022065342.3569693-1-libaokun@linux.alibaba.com
> 
> This hunk does not apply to v6.17 - v7.0, where the eof zeroing is
> done inside the allocation loop; those trees need a manual backport.
> 
>  fs/ext4/extents.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ad0d80e33f60..b05015b8b62c 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4639,8 +4639,15 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  	credits = ext4_chunk_trans_blocks(inode, len_lblk);
>  	depth = ext_depth(inode);
>  
> -	/* Zero to the end of the block containing i_size */
> -	if (new_size > old_size) {
> +	/*
> +	 * Zero to the end of the block containing i_size.
> +	 * Loading the eof block back before it is converted to unwritten
> +	 * or zeroed out may leave the page cache inconsistent with the
> +	 * disk, and zeroing it is redundant, so skip it.
> +	 */
> +	if (new_size > old_size &&
> +	    !(in_range(old_size >> blkbits, map.m_lblk, map.m_len) &&
> +	      (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN || alloc_zero))) {
>  		ret = ext4_block_zero_eof(inode, old_size, LLONG_MAX);
>  		if (ret)
>  			return ret;

