Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFD03546FE
	for <linux-ext4@vger.kernel.org>; Mon,  8 Jun 2026 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780917694; cv=none; b=QIHV4T3QEekvZqMY5/nwwo+moLZpMHDuvQC1fJtZBw3qlBY0+wwLwUPoRD79zSNtZLbSafjWZ48BkFgx4yR3bfrNN7voVCFqq1EjeTpM7iVwLevRKSCL2LTxbHEycZHNe7D6Frj8OiYEy9NEk5GTDc3UBazflIsTVn7DaIGv8+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780917694; c=relaxed/simple;
	bh=i82Wa0OjN9LoMec/STqov5h1McfGZ3LAfLVoLSn9kzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sE4t88d6Zt7m3uTAV5E5DS5gLUZpJ9f2JI1RR5IR0/GDalBGJTcmRuaSugrSAteiZVASnN8fRxvXSusTOsxXs7lWKtf6Fr9qVwwGbN9GDD+fyNosq8+TUpt5GC1gcbWhw5G6EXkqY0AGxNvVEsvy2iKSAeTMLlGWabuH2iiE09w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=UskSP6in; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="UskSP6in"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780917683; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gKMt+Ky/d2x82olWAe6C2MA6id7rljSF8aL33aSERes=;
	b=UskSP6inHBWjPxzJKa7N+Xdu1aUL9hN9SMdMXq0Z0LWRckQIJD9VFxR82raUHvicEwknhkHbRuW6O1VCEmdDNHK3fb0WbKOlTElFy2b6s14Bh/SafGcrLHpHZmqZldpBoBGCD7gcBo9mjFGdN6ABH4C2cRo+eszMnHHaHJ+VRQo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X4O-KcD_1780917682;
Received: from 30.221.148.53(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4O-KcD_1780917682 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Jun 2026 19:21:23 +0800
Message-ID: <60d15c65-8fe2-4982-8711-02ce6f5167f5@linux.alibaba.com>
Date: Mon, 8 Jun 2026 19:21:22 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: reject mount if clusters/inodes per group are not
 8-aligned
To: sashiko-reviews@lists.linux.dev
Cc: tytso@mit.edu, Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20260608061112.392391-1-libaokun@linux.alibaba.com>
 <20260608063318.266E61F00893@smtp.kernel.org>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260608063318.266E61F00893@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


I've sent a V2 that includes two additional patches to address the issues
Sashiko reported:

https://patch.msgid.link/20260608111150.827117-1-libaokun@linux.alibaba.com


Thanks,
Baokun

On 2026/6/8 14:33, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> Pre-existing issues:
> - [Critical] Missing alignment check allows integer truncation in s_itb_per_group, leading to out-of-bounds inode table access and potential local privilege escalation via forged inodes.
> - [High] Integer overflow in bigalloc cluster consistency check on 32-bit systems allows mounting filesystems with arbitrary cross-group overlaps.
> --
>
> commit 063bdba3eb2bd319656b0b2534e820244460e17a
> Author: Baokun Li <libaokun@linux.alibaba.com>
>
> ext4: reject mount if clusters/inodes per group are not 8-aligned
>
> The block and inode bitmap checksums are computed over a whole number of
> bytes. If s_inodes_per_group or s_clusters_per_group is not a multiple of
> 8, the trailing fractional bits are excluded from the checksum. Reject such
> filesystems at mount time by adding the missing bitwise alignment checks.
>
> Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7gnl7b3sx@jenszfpcsnit
>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 245f67d10ded3..98f1cefbc6880 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -4475,8 +4475,9 @@ static int ext4_handle_clustersize(struct super_block *sb)
>>  		sbi->s_cluster_bits = 0;
>>  	}
>>  	sbi->s_clusters_per_group = le32_to_cpu(es->s_clusters_per_group);
>> -	if (sbi->s_clusters_per_group > sb->s_blocksize * 8) {
>> -		ext4_msg(sb, KERN_ERR, "#clusters per group too big: %lu",
>> +	if (sbi->s_clusters_per_group > sb->s_blocksize * 8 ||
>> +	    sbi->s_clusters_per_group & 7) {
>> +		ext4_msg(sb, KERN_ERR, "invalid #clusters per group: %lu",
>>  			 sbi->s_clusters_per_group);
>>  		return -EINVAL;
>>  	}
> [Severity: High]
> This isn't a bug introduced by this patch, but while we are validating
> s_clusters_per_group, could the bigalloc consistency check slightly below
> this in ext4_handle_clustersize() overflow on 32-bit systems?
>
> The check does:
>
>     if (sbi->s_blocks_per_group !=
>         (sbi->s_clusters_per_group * (clustersize / sb->s_blocksize))) {
>
> Since unsigned long is 32 bits on 32-bit systems, the multiplication can wrap
> around modulo 2^32. For example, if an image has 16392 clusters and a ratio
> of 262144, the product evaluates to 2^32 + 2097152, matching an
> s_blocks_per_group of 2097152.
>
> Because bigalloc bypasses the usual s_blocks_per_group size limits, the
> wrapped validation would succeed. The block allocator could then allocate
> blocks far outside the truncated group, overwriting metadata of subsequent
> groups. Should this multiplication be cast to a 64-bit type to prevent
> the overflow?
>
> [ ... ]
>
>> @@ -5308,7 +5309,8 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
>>  		return -EINVAL;
>>  	}
>>  	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
>> -	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
>> +	    sbi->s_inodes_per_group > sb->s_blocksize * 8 ||
>> +	    sbi->s_inodes_per_group & 7) {
>>  		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
>>  			 sbi->s_inodes_per_group);
>>  		return -EINVAL;
> [Severity: Critical]
> This is a pre-existing issue, but does adding the & 7 check go far enough
> to prevent integer truncation here?
>
> A few lines below this check in ext4_block_group_meta_init(), the code does:
>
>     sbi->s_itb_per_group = sbi->s_inodes_per_group / sbi->s_inodes_per_block;
>
> Since s_inodes_per_group is now guaranteed to be a multiple of 8, but
> s_inodes_per_block can be 16, 32, etc., this division can still truncate.
>
> Could this truncation lead to out-of-bounds accesses? Looking at
> __ext4_get_inode_loc() in fs/ext4/inode.c, the block is calculated without
> checking against the truncated s_itb_per_group:
>
>     block += (inode_offset / inodes_per_block);
>
> This could allow reading or writing to the block following the truncated
> inode table, potentially allowing local privilege escalation via forged
> inodes if that block is allocated to a user file. Should we also ensure
> that s_inodes_per_group is a multiple of s_inodes_per_block here?
>

