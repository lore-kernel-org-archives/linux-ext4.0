Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCA4438037;
	Mon, 12 Oct 2026 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791788152; cv=none; b=e/ot3aluBqMC0MJdrIItfSU6ZxGHgrU3/HtX8wqyWTI7ZgeRA75fw2Cb1QGkDyH8YyZkL/IKLNHWaK4hklJ7tAyylOzn6LR5sIBJM/+T8MiTI3yQdcv5yGOAXqKfUMidt9Vmpp6dtGI2pZJdDcc+le+SKc499nefoQA8PjnxQWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791788152; c=relaxed/simple;
	bh=MN6j/jDgbPWTAPCKl/9lUmdH5PiDX9KTv2YknUczJmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAGgqXYdYZTXZM5/a25dUat03ZRQp5TiihaH5JLmcG9G41C+LMNW+L2fl+m1bm1LAZeE9buz1M9nF29rtVHlSp8Ex7Vl+p/vNll3BM9KQyuhe1AaRBRCIcBAC4cV+EJw3V5uCj/dpIfPHa6PQ3Un2h/G/0QqiC1B95jqgq3O7zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j37W72N0mzKHMNB;
	Mon, 12 Oct 2026 14:54:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EBB3E40539;
	Mon, 12 Oct 2026 14:55:39 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZPNqhMxqV2+QAA--.34644S3;
	Mon, 12 Oct 2026 14:55:39 +0800 (CST)
Message-ID: <5baa0f89-11b1-46c5-91e9-fbb89f8a325b@huaweicloud.com>
Date: Mon, 12 Oct 2026 14:55:38 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix buffer_head leak in ext4_ind_map_blocks() error
 path
To: guolingxing <guolingxing@tju.edu.cn>, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261009062846.327298-1-guolingxing@tju.edu.cn>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20261009062846.327298-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAnZPNqhMxqV2+QAA--.34644S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr48Gr4DZw47Wr4xZFW8JFb_yoW8Xr15pr
	sxKF9akrs5uryIkanrX3W8ZFyxuan3Gw45Grs2kw4UZr9xuFnaqrZ8tF18XFWxArZ5Ja12
	qFW5KryxW34Uua7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/9/2026 2:28 PM, guolingxing wrote:
> When ext4_ind_map_blocks() is called with EXT4_GET_BLOCKS_CREATE on
> a non-extent mapped inode of a filesystem with the bigalloc feature
> enabled, it fails with -EFSCORRUPTED via 'goto out'.  However, at
> this point ext4_get_branch() has already acquired buffer_head
> references for the chain of indirect blocks, which are stored in
> the stack variable 'chain'.  Since 'goto out' skips the cleanup
> loop that releases these references, they are leaked permanently
> (each failed allocation can leak up to 3 buffer_heads, and repeated
> allocation attempts keep pinning the corresponding pages in memory).
> 
> Jump to 'cleanup' instead, so that the chain of buffer_heads is
> properly released before the error is returned.
> 
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/indirect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 5aec759eed70..9f1f4e6c37a4 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -603,7 +603,7 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
>  		EXT4_ERROR_INODE(inode, "Can't allocate blocks for "
>  				 "non-extent mapped inodes with bigalloc");
>  		err = -EFSCORRUPTED;
> -		goto out;
> +		goto cleanup;
>  	}
>  
>  	/* Set up for the direct block allocation */

