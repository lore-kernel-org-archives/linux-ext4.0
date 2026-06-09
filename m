Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EB9370D44
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 03:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780976021; cv=none; b=gIFdAeY/1V8jvC4skAX9RQ5WCDDv/YzbBxFPUCBjcgwBR8UZkM0ITEyF0+uD+7hKoD2KGCvPntkufbG+AxRjlGvApyWTsxVUQbueQ5i+ggWkp6NsrRrR/z9e6ErDEF3u2pNCVZwEFYUyp9zsBx0TV9vBydhWBB8lr07449pZ6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780976021; c=relaxed/simple;
	bh=wYixzlbK3N5pUlIu7aXX20rOYApz4HC3YC2T7FGXcCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tQT9Tf3qi4Z3wRo4AR+qukh6TGAI69N2nJzvBMXBx0+b3fJmnOiUAnYyhs8RRfNfNMu1u3+OoAIL7RdYAT7qQAxBc1BpWEto40ycn1aD+MzRaI+a9CTSp4hOBV0n1JZq9m5o2c0yNNCR4Kpai+kqik3KBfnMJMBbrNTBckugiVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gZDy05FMBzKHLvY
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:32:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id A15C840574
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:33:31 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgAXGj+IiSdqIhWOBA--.63111S3;
	Tue, 09 Jun 2026 11:33:30 +0800 (CST)
Message-ID: <930f4453-d4ab-4d8f-9d17-73073efcaaa8@huaweicloud.com>
Date: Tue, 9 Jun 2026 11:33:28 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] ext4: reject mount if inodes per group is not a
 multiple of inodes per block
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-4-libaokun@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260608111150.827117-4-libaokun@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAXGj+IiSdqIhWOBA--.63111S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFWkGryUGr1fArWDArWDArb_yoW8XrWfpa
	n7CF1xur1rWryq9a1kCrWIvF1Ig3WkKa17GryxZr18GrW2q340qrs5t3WjkFsFqaykZr1S
	q3WI9rW7Za48J37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
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

On 6/8/2026 7:11 PM, Baokun Li wrote:
> If s_inodes_per_group is not a multiple of s_inodes_per_block, the
> division that computes s_itb_per_group truncates, reserving fewer blocks
> for the inode table than needed.
> 
> On a crafted filesystem image, this allows __ext4_get_inode_loc() to
> compute a block offset beyond the inode table, reading unrelated data as
> an inode structure.
> 
> Add the missing divisibility check alongside the existing validation in
> ext4_block_group_meta_init().
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3ddcb4a8d4db..5ec9e1ef00c0 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5306,7 +5306,8 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
>  	}
>  	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
>  	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
> -	    sbi->s_inodes_per_group & 7) {
> +	    sbi->s_inodes_per_group & 7 ||
> +	    sbi->s_inodes_per_group % sbi->s_inodes_per_block) {
>  		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu",
>  			 sbi->s_inodes_per_group);
>  		return -EINVAL;

