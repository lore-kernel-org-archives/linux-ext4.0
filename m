Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A93E34F26F;
	Thu,  9 Apr 2026 02:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702723; cv=none; b=m2jptE2T6cgbubA072x7iLfYsh32NrFf9vzeoo1wM1NRNwnxbYCKC9WeBUCNSoD7uzEY42CHusJBEacH59cf12Q776dRUoPdMsNEtEtVDnFgkUkpMtHAQfYp3VQPSnFsjkM6znoo6EHh1mHuqu50hRS0HurNxAV/20J1uRqLSWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702723; c=relaxed/simple;
	bh=42jt/B1x0R/zhB+VrV+Mn2VfwG5trZJy9L0IrlmuAvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i4kZm/k3KB747sF12aEaxdBC/AvkndNsU1XNEqe4qPDeRdIaXzlBCvGqDoSrqs09dZyLUPjMhNG8eZ9JS5LVtb0fLVAydImZ2hltrS1gL5OllBjFI8/pCmRwgsGY/WoDMcw0+lS7cKd+Zsn+gBM4nl4a8unXywCD5Gb6b5eK2T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4frkmV0KnZzYQtgS;
	Thu,  9 Apr 2026 10:44:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2AB4640561;
	Thu,  9 Apr 2026 10:45:17 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBHSdm7EtdpP26YDw--.24580S3;
	Thu, 09 Apr 2026 10:45:16 +0800 (CST)
Message-ID: <6864da80-b244-4444-aecd-2555c2d60db0@huaweicloud.com>
Date: Thu, 9 Apr 2026 10:45:14 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] jbd2: fix deadlock in jbd2_journal_cancel_revoke()
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 dave@stgolabs.net, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com,
 yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260409010730.5508-1-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260409010730.5508-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHSdm7EtdpP26YDw--.24580S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CrykXryrXFyfCr1rWF15Jwb_yoW8trW7pr
	90kF1YkrWDuFyqk3ZrWFy5X3Z7Cw1kGryUWFZxuwnrCr45XrnIgFZ2gw1aqFyjqrsrXr4k
	XF4Ut3yrua10vFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Please ignore this patch; this solution does not correct.

Best Regards.
Yi.

On 4/9/2026 9:07 AM, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> Commit f76d4c28a46a ("fs/jbd2: use sleeping version of
> __find_get_block()") changed jbd2_journal_cancel_revoke() to use
> __find_get_block_nonatomic() which holds the folio lock instead of
> i_private_lock. This breaks the lock ordering (folio -> buffer) and
> causes an ABBA deadlock when the filesystem blocksize < pagesize:
> 
>      T1                                T2
> ext4_mkdir()
>  ext4_init_new_dir()
>   ext4_append()
>    ext4_getblk()
>     lock_buffer()    <- A
>                                    sync_blockdev()
>                                     blkdev_writepages()
>                                      writeback_iter()
>                                       writeback_get_folio()
>                                        folio_lock()   <- B
>      ext4_journal_get_create_access()
>       jbd2_journal_cancel_revoke()
>        __find_get_block_nonatomic()
>         folio_lock()  <- B
>                                      block_write_full_folio()
>                                       lock_buffer()   <- A
> 
> This can occasionally cause generic/013 to hang.
> 
> Fix by only calling __find_get_block_nonatomic() when the passed
> buffer_head doesn't belong to the bdev (i.e., !bh->b_bdev), which is the
> only case that we need to look up its bdev alias. Otherwise, the lookup
> is redundant since the found buffer_head is equal to the one we passed
> in.
> 
> Fixes: f76d4c28a46a ("fs/jbd2: use sleeping version of __find_get_block()")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/jbd2/revoke.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
> index 9016ddb82447..8b52d40c27c9 100644
> --- a/fs/jbd2/revoke.c
> +++ b/fs/jbd2/revoke.c
> @@ -464,13 +464,14 @@ void jbd2_journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
>  	 * buffer_head?  If so, we'd better make sure we clear the
>  	 * revoked status on any hashed alias too, otherwise the revoke
>  	 * state machine will get very upset later on. */
> -	if (need_cancel) {
> +	if (need_cancel && !bh->b_bdev) {
>  		struct buffer_head *bh2;
> +
>  		bh2 = __find_get_block_nonatomic(bh->b_bdev, bh->b_blocknr,
>  						 bh->b_size);
>  		if (bh2) {
> -			if (bh2 != bh)
> -				clear_buffer_revoked(bh2);
> +			WARN_ON_ONCE(bh2 == bh);
> +			clear_buffer_revoked(bh2);
>  			__brelse(bh2);
>  		}
>  	}

