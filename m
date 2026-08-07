Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98EC3A3835
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 04:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786077970; cv=none; b=PRrjANPi3R68ob9cNHW4MY4fS+n2BnUuTKK51cmtAELt3nuboY1aHBYipg0pkRfjulVrYOwIx4RfPScezLr7hvg6GW3Pp9Rbg39sL65lCm8/OUwfgqfvtHYw2U/h2ekubHtUDSbCb4x4ErPgGiJgEPDPo3IERfNG6tsoAUmqxY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786077970; c=relaxed/simple;
	bh=jngCKyciaElQLlDBf0aa/U2Z10yJuKd4Pu2/UMaN1OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a83Avf6kxdFdkROKu9YqXbbG+qjkDEpPuSmb8i+UpLVBs7sHf3v2jUdtGDl3sabXfaZWvai1wqfl/Blx2KSPJBhjTFTSdMfuS9O+6B9klGbCqMLA2rIWL9cbheEBvUpZ4PQdKggWJwKBw9MtehciT/+HfdpgTUltG5K8cCwaNNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hGWm419yYzYQtGZ
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 12:45:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1953740561
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 12:46:04 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgD35kUKY3VqkSujBQ--.42015S3;
	Fri, 07 Aug 2026 12:46:03 +0800 (CST)
Message-ID: <7f0da6ac-4faf-4635-a77b-fbb7888821de@huaweicloud.com>
Date: Fri, 7 Aug 2026 12:46:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] ext4: Fix estimate extent index blocks in
 ext4_ext_index_trans_blocks()
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-6-jack@suse.cz>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260805153605.166545-6-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgD35kUKY3VqkSujBQ--.42015S3
X-Coremail-Antispam: 1UD129KBjvJXoWruw4ktrWrJF1fXr43JFykGrg_yoW8JrWDpr
	srCFyrKF1Sq3WxuFWxWF1UZr15Ga1xGa17Zr45Gr17XF98JryfKr13K3WrCF1SgrZ7CF1j
	qF4rKa47Cw1akrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 8/5/2026 11:35 PM, Jan Kara wrote:
> The estimate of the number of impacted extent tree index blocks could be
> one-too-low. If we modify say 2 extents, already two leaf index blocks
> could be impacted, not just one the current estimate counts with. Fix
> the estimate.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

This is a good catch!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/extents.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 44ab246a3176..713b2c098af5 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2427,9 +2427,17 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
>  	 */
>  	if (extents <= 1)
>  		index = (EXT4_MAX_EXTENT_DEPTH * 2) + extents;
> -	else
> -		index = (EXT4_MAX_EXTENT_DEPTH * 3) +
> -			DIV_ROUND_UP(extents, ext4_ext_space_block(inode, 0));
> +	else {
> +		int ext_max = ext4_ext_space_block(inode, 0);
> +
> +		index = EXT4_MAX_EXTENT_DEPTH * 3;
> +		/*
> +		 * Modified extents need not start at the beginning of the
> +		 * leaf. Already two extents may need two leaf block
> +		 * modifications...
> +		 */
> +		index += DIV_ROUND_UP(extents + ext_max - 1, ext_max);
> +	}
>  
>  	return index;
>  }

