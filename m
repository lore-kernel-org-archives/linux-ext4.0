Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FCE3AC0FB;
	Wed, 24 Jun 2026 08:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782289218; cv=none; b=CYWvUJHUGb33iQgvuAkfDLl43GryWzVuoYeM/3HDIunKUIJj/tJ5IcTjyJu7VdRq4QsZUPztjuHZVs/sv625PbminTLwDlHcmXn9C2pMR4qoeanWsWigiVuWeFEYH8UIhbBW4vUqcFaVQ8h3J5cVy8VkglPY5cK1RIhdb9W1s6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782289218; c=relaxed/simple;
	bh=2zg9BWH7scCDsn2NtD/89iAObk1ppChjKw5IxGVKxL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s4o0d1ih43igsD1uGt1gR0RBH1ddMx/cH6BSmTkC0Z+jukSXA/n43bY3vIxjLzZXh6lc7my77/GBNFUCmS3vdS4wV0ubSlE+7Oaj2k+43xnKQ6xeNqMIDbH8Y3Mw+FRIl/wWS4jTN5kXzMOaRxzLM5Mq/63YSYDXTcKgmERhS6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4glZbX6w08zYQtsg;
	Wed, 24 Jun 2026 16:19:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 25620409D9;
	Wed, 24 Jun 2026 16:20:03 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBXWj8xkztqw3mxCw--.15244S3;
	Wed, 24 Jun 2026 16:20:02 +0800 (CST)
Message-ID: <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com>
Date: Wed, 24 Jun 2026 16:20:00 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
To: Zhu Jia <zhujia.zj@bytedance.com>, tytso@mit.edu, adilger.kernel@dilger.ca
Cc: libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260623094947.7853-1-zhujia.zj@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260623094947.7853-1-zhujia.zj@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBXWj8xkztqw3mxCw--.15244S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWUGw4UJFWUuFW3Wr1fXrb_yoW8tr18pF
	W5KFZ8JrsYqasxCa43ua1UXr1UK393Wa1UGFy7J3Wjva45GFy2grW8KF18uF13Jr1xJFWF
	qF4jgw17WF4UCrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/23/2026 5:49 PM, Zhu Jia wrote:
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
> accounting.

Hi, Zhu jia!

Thanks for the patch. This overall looks good to me. But should we also
clear PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE here? Since the folio
won't be written back again until it gets dirtied, it seems cleaner to
remove these tags as well. Are there any side-effects I'm missing?

Thanks,
Yi.

> 
> Fixes: cc5095747edf ("ext4: don't BUG if someone dirty pages without asking ext4 first")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhu Jia <zhujia.zj@bytedance.com>
> ---
>  fs/ext4/inode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d1..7ea280e70c06e 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2715,7 +2715,13 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 */
>  			if (!folio_buffers(folio)) {
>  				ext4_warning_inode(mpd->inode, "page %lu does not have buffers attached", folio->index);
> -				folio_clear_dirty(folio);
> +				/*
> +				 * folio_cancel_dirty() pairs the dropped dirty
> +				 * state with dirty accounting, but leaves stale
> +				 * PAGECACHE_TAG_DIRTY/TOWRITE tags behind. Later
> +				 * writeback may rescan this clean folio.
> +				 */
> +				folio_cancel_dirty(folio);
>  				folio_unlock(folio);
>  				continue;
>  			}

