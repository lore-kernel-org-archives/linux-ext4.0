Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC94034AB01
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782183398; cv=none; b=JkTRSwrQ7ysQcXAoIXavTcykfsTq7gMMMOWbiQhuIf7Y/9/5A9C72lk+ELA/oV7sMhJ4yeqQE5iZ4tjUXiT4rqLJPtH8z6m619y7/JzDXoSy57K5egwfoxOSvzRmD1tWCzFzZBPUoUnQucDNaiqA5o7hVvE+1T26kDuq+2AlSxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782183398; c=relaxed/simple;
	bh=7OET6okbeEN4LMrzkwWWyqBnVKN4QvmLN1PN6R7RBn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMahCmxquuNSpmJCDA6ZwkEzxSfWphZHjMJ7wfXXwgQbgzJkG9SxbfaX64nNWPjWp5PgQJhN7w7fFbGvRTibiHBWB2kIm9yVdgQAkxxuP5TphG3ecs4PBpsVx4v14hdPD6XbdumnQNe/vk1N/bWGlZ3wC1mSHYNLbexWLNDST40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gkqSM0hlmzKHMZv
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 10:55:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7C67C40644
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 10:56:28 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgB3ej_Z9Tlq5ToeCw--.57414S3;
	Tue, 23 Jun 2026 10:56:27 +0800 (CST)
Message-ID: <68a59de5-7503-48be-81a7-8a052fb5125c@huaweicloud.com>
Date: Tue, 23 Jun 2026 10:56:25 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] ext4: prevent sleeping allocation in NOWAIT write
 path
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, peng_wang@linux.alibaba.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-2-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260618125735.4156639-2-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgB3ej_Z9Tlq5ToeCw--.57414S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Xr1rAF47trWDArWftF1fJFb_yoW8JrW5pF
	WrGrWxGr12qryv9Fs3W347ZFyjgay5WFW5G3W3tr1xZry3Xr93Grs2ya1xWrsYyrWxA3W0
	qF1YgryxGa1UCFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/18/2026 8:57 PM, Baokun Li wrote:
> Block allocation requires journal access which may sleep, violating
> NOWAIT semantics. Return -EAGAIN early when IOMAP_NOWAIT is set,
> allowing the caller to retry without the NOWAIT constraint.
> 
> This ensures that write paths using IOMAP_NOWAIT (e.g., DIO with
> RWF_NOWAIT) will not block on journal operations when blocks need
> to be allocated.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260611163441.2431805-1-libaokun@linux.alibaba.com?part=1
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

This makes sense to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/inode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..832794294ccf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3672,6 +3672,9 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
>  	int ret, dio_credits, m_flags = 0, retries = 0;
>  	bool force_commit = false;
>  
> +	if (flags & IOMAP_NOWAIT)
> +		return -EAGAIN;
> +
>  	/*
>  	 * Trim the mapping request to the maximum value that we can map at
>  	 * once for direct I/O.

