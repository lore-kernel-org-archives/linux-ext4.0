Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66EE1DF25C
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 02:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780973328; cv=none; b=IRlsRvsRmUjrr+FmbUCx/EyZ2inx7ZpbLFwmSqpvX/6fm8NVePTJ1j8a2VapmE17W7kqoKmr/HqP3WtEmb7V1VvB1tSRraqka6gz5EAb1oFfPFfFJx40ilyg9bFKsat6EjKQ23OxXAOX6vFln3oE70AquU4obTHCCRejV0HmZno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780973328; c=relaxed/simple;
	bh=UlHxB6kZY5xLiDlAjXY7MQP7/baLaY9XgatyAgSSKBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FpYmtjwGyPhHCSx8RbaIq7AcvhGlLVOt6fYhj4GhId1DIxy+k9rzNpcOdZdwa6cx40pTrL7+mmp2fVB1H+8IdiGUU+sKhFjjWTbV0PEOdDRS+klr4HeFb0o4GcNEYu3X2csDnYpoIROkdpWRK0B+b6sCcRNu/JEt1yHs6cdlrO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gZCyB2F28zKHMYM
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 10:48:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3045640561
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 10:48:37 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBXWj8Afydqv1KKBA--.61811S3;
	Tue, 09 Jun 2026 10:48:34 +0800 (CST)
Message-ID: <06543725-5f38-4cac-9fdd-8a72cfb28f84@huaweicloud.com>
Date: Tue, 9 Jun 2026 10:48:32 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ext4: reduce max cluster size to match documented
 256MB limit
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-3-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260608111150.827117-3-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBXWj8Afydqv1KKBA--.61811S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UGw1DArWUCFy7XrW8Zwb_yoW5Xw17pF
	47CFyYgw4jkF1qgayjgw12vwn7K34fCw1UGrZ5Xry7Gr98tw4xGrsaqw4FvFnrKrWrJ34D
	XwnI9w1Y9393CrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi, Baokun!

On 6/8/2026 7:11 PM, Baokun Li wrote:
> The mke2fs man page documents:
> 
>   Valid cluster-size values are from 2048 to 256M bytes per cluster.

Hmm, I checked the mke2fs(8)[1] and didn't find this sentence, instead,
it said:

  Valid cluster-size values range from 2 to 32768 times the filesystem
  block size and must be a power of 2.

However, the implementation of mkfs does not seem to respect this
constraint and instead directly uses static macros to limit the
user-specified cluster size.

  #define EXT2_MIN_BLOCK_LOG_SIZE         10      /* 1024 */
  #define EXT2_MIN_CLUSTER_LOG_SIZE       EXT2_MIN_BLOCK_LOG_SIZE
  #define EXT2_MAX_CLUSTER_LOG_SIZE       29      /* 512MB  */

This is confusing, or perhaps I missed something. If I understand
correctly, users can now format an image with a maximum cluster size of
512 MB (I tried it, and it worked). If the kernel's
EXT4_MAX_CLUSTER_LOG_SIZE is limited to 28, this would cause such
existing images to become unmountable, even though I don't think images
with such a large cluster size actually exist in practice. Therefore,
I'm not sure this is safe.

[1] https://man7.org/linux/man-pages/man8/mke2fs.8.html

> 
> but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
> filesystem images to specify cluster sizes up to 1GB.
> 
> On 32-bit systems with bigalloc enabled, the consistency check in
> ext4_handle_clustersize():
> 
>   s_blocks_per_group == s_clusters_per_group * (clustersize / blocksize)
> 
> can overflow when the cluster ratio is large enough. Since
> s_blocks_per_group is not range-checked in the bigalloc path, the
> wrapped product can pass the consistency check, leading to inconsistent
> group geometry and potential out-of-bounds block allocation.
> 
> Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
> limit. With this cap, the maximum product is:
> 
>   (blocksize * 8) * (256M / blocksize) = 2^31
> 
> which fits safely in a 32-bit unsigned long for all block sizes.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> ---
>  fs/ext4/ext4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a991e5c..11e41a864db8 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -334,7 +334,7 @@ struct ext4_io_submit {
>  #define	EXT4_MAX_BLOCK_SIZE		65536
>  #define EXT4_MIN_BLOCK_LOG_SIZE		10
>  #define EXT4_MAX_BLOCK_LOG_SIZE		16
> -#define EXT4_MAX_CLUSTER_LOG_SIZE	30
> +#define EXT4_MAX_CLUSTER_LOG_SIZE	28
>  #ifdef __KERNEL__
>  # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
>  #else

