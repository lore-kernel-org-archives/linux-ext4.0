Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E823AB87;
	Sat, 27 Jun 2026 03:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782532058; cv=none; b=fYyhzNFnvKBJzKSpytQ6WpPDZ+WDiS0uIzTS3ezNWPYUVE8xdWN/veiCZm9pejcAZ54NjrGcoRy2WPoWsdE6mmvGyK1aDQT5LekwyUgTowtc0I/BFtzNaZ1sauvDVAIBzVrGbzFzXKfRpLPducoMG3nOq1UmdddweiDTmbtfxcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782532058; c=relaxed/simple;
	bh=BIynbG/1mzmyU0HWwUWKvpQT9JHq57uJj6AHws/LJDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpT4TSv7lHFk9fnws8FYs1VbK8clcLiGEufUmhf92y1+DjqfWarBTAVxEhow08sj7enQcfXeapBuLY0SW8NVzJx0d9Qg/1JY6cFMbFovdFtycxPN/KO5Vt0BbG26FYROqI4oa4TP0Ku7KDoJEvDdMeqyIPLlWQzBpd38DI8YGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gnJPT6tt2zYQtmT;
	Sat, 27 Jun 2026 11:46:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id ED1B34058D;
	Sat, 27 Jun 2026 11:47:24 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgA3OT7KRz9qp4cDDQ--.1978S3;
	Sat, 27 Jun 2026 11:47:24 +0800 (CST)
Message-ID: <50c685dd-077f-4352-a8a1-6a0e23daeb06@huaweicloud.com>
Date: Sat, 27 Jun 2026 11:47:22 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: cancel dirty accounting for folios without
 buffers
To: Zhu Jia <zhujia.zj@bytedance.com>, tytso@mit.edu, adilger.kernel@dilger.ca
Cc: libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Zhang Yi <yizhang089@gmail.com>
References: <20260626100740.52455-1-zhujia.zj@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260626100740.52455-1-zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgA3OT7KRz9qp4cDDQ--.1978S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWUGw4UJFWUuFW3Wr1fXrb_yoW8Kw1rpF
	Z8KFWDAr1vvasxCw13WF429a1UKa9xWa17GFy7Ga1jqFn8WFyjgrWjgr1093W7Cr92kFWS
	vF4jkry8ua1jkrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AK
	xVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAwI
	DUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/26/2026 6:07 PM, Zhu Jia wrote:
> Since commit cc5095747edf ("ext4: don't BUG if someone dirty pages
> without asking ext4 first"), mpage_prepare_extent_to_map() handles dirty
> folios without buffer heads by warning, clearing PG_dirty, and skipping
> them. ext4 cannot write these folios because there are no buffer heads to
> map and submit.
> 
> That recovery leaves dirty accounting behind: folio_clear_dirty() clears
> PG_dirty but does not undo the accounting charged when the folio was
> dirtied. We have seen this in production as Dirty/nr_dirty staying high
> while Writeback/nr_writeback and device write IO stayed near zero, with
> many writer tasks blocked in balance_dirty_pages() throttling. Thus the
> warning-and-skip recovery can still become a dirty-throttle DoS.
> 
> Use folio_cancel_dirty() so dropping PG_dirty also cancels the dirty
> accounting. Then cycle the folio through writeback state so the generic
> writeback helpers update the xarray DIRTY/TOWRITE tags.
> 
> Fixes: cc5095747edf ("ext4: don't BUG if someone dirty pages without asking ext4 first")
> Cc: stable@vger.kernel.org
> Suggested-by: Zhang Yi <yizhang089@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Zhu Jia <zhujia.zj@bytedance.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
> Changes since v1:
> - After folio_cancel_dirty(), cycle the folio through writeback state so
>   generic writeback helpers update PAGECACHE_TAG_DIRTY/TOWRITE, as
>   suggested by Yi and Jan.
> 
>  fs/ext4/inode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d1..4c25dcd47fb15 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2715,7 +2715,15 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 */
>  			if (!folio_buffers(folio)) {
>  				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
> -				folio_clear_dirty(folio);
> +				/*
> +				 * folio_cancel_dirty() pairs the dropped dirty
> +				 * state with dirty accounting. Cycle through
> +				 * writeback state so the generic writeback
> +				 * helpers update the xarray tags.
> +				 */
> +				folio_cancel_dirty(folio);
> +				folio_start_writeback(folio);
> +				folio_end_writeback(folio);
>  				folio_unlock(folio);
>  				continue;
>  			}

