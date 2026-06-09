Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEED388379
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 09:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780998226; cv=none; b=RQ1d8/sM+JFYma49A7lyyeSIAQE5yXBSTgVWn1dB2OUEF/45m2DJP1eXCZHTRc1fOu10YWVWLw3RIbAHRZvFppSbhathTJpGzKjjr4Ii6gWC0auoFu5MIzQcVooCPhMy83W+RtGKqUjEXsXLg1eNJwbOAHklZxQQXf1R2yKV5uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780998226; c=relaxed/simple;
	bh=/pHFQ6wUaI0Ajiotg/IAyO1JrqyEfN2PxKhXJKPwoLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o1Us0DqS5xo+HtX+y0WGUNSgkSkqXVlwfiiyfJrRMGGtMeJjkWFQ6BmoaxAzuinawS48UpKpM9gb0NMvtLMWjDInSypB/+wsJ81EK+n8+dphwvGJCD0zW/E+LWLQw4XGMa+hZUES4OI2+boMKUWQh/FSogJ9NSFnBPXGSo0V+rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LIBXdQ4w; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LIBXdQ4w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780998221; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ms7lgUyIRFgG/Dyz3jOQoVbEuG7qDUjgwhIA9rqhhew=;
	b=LIBXdQ4w5DkUo7Gmfq4SZWoNxnu4jYb6UPfHZlYtRVNaO3Pea9vHU2/1mUvxXGpwvVIXOACeg0lVCvpTkWtMvS24MCzIF4pif2vsnFenXBbzxkq6VFokhIYvOVT8C19VZzeNAMX4lrPBeyYDlelNUFZszpTzkgV5vGeSzmOzRFw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X4W.Oc3_1780998219;
Received: from 30.221.147.173(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X4W.Oc3_1780998219 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Jun 2026 17:43:39 +0800
Message-ID: <d3afb165-49f7-4c7a-b110-95d6a94a8845@linux.alibaba.com>
Date: Tue, 9 Jun 2026 17:43:38 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ext4: reduce max cluster size to match documented
 256MB limit
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-3-libaokun@linux.alibaba.com>
 <06543725-5f38-4cac-9fdd-8a72cfb28f84@huaweicloud.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <06543725-5f38-4cac-9fdd-8a72cfb28f84@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/6/9 10:48, Zhang Yi wrote:
> Hi, Baokun!

Hi Yi,

Thank you for you review!

> On 6/8/2026 7:11 PM, Baokun Li wrote:
>> The mke2fs man page documents:
>>
>>   Valid cluster-size values are from 2048 to 256M bytes per cluster.
> Hmm, I checked the mke2fs(8)[1] and didn't find this sentence, instead,
> it said:
>
>   Valid cluster-size values range from 2 to 32768 times the filesystem
>   block size and must be a power of 2.

Oh, I was indeed looking at a slightly older man page. It was changed to
the current description in commit 87cbb381f2e2 ("e2fsprogs:
misc/mke2fs.8.in: Correct valid cluster-size values").

That commit assumes the number of blocks in a cluster cannot exceed the
maximum number of blocks that a single extent can hold
(EXT_INIT_MAX_LEN = 32768). I believe this is wrong — a single cluster
can be covered by multiple extents. So we should fix the bug in
ext_falloc_helper() rather than working around it by adding a
restriction to the documentation.

The root cause is in ext_falloc_helper():

    max_uninit_len = EXT_UNINIT_MAX_LEN & ~EXT2FS_CLUSTER_MASK(fs);
    max_init_len = EXT_INIT_MAX_LEN & ~EXT2FS_CLUSTER_MASK(fs);

When cluster_ratio >= EXT_INIT_MAX_LEN (32768), the `& ~CLUSTER_MASK`
operation zeroes out both values, causing ext2fs_new_range() to receive
len=0 and return EXT2_ET_INVALID_ARGUMENT.

The kernel handles this correctly — ext4_ext_map_blocks() simply
truncates m_len to EXT_INIT_MAX_LEN and lets the caller loop.  On
subsequent iterations, get_implied_cluster_alloc() detects that the
requested block falls within an already-allocated cluster by examining
adjacent extents, and returns the physical address without allocating a
new cluster.

I'll send a patch to fix ext_falloc_helper() so that when
cluster_ratio >= EXT_INIT_MAX_LEN, the allocation loop can create
multiple extents within the same cluster — skipping ext2fs_new_range()
and claim_range() for mid-cluster iterations where the physical blocks
are already claimed.

>
> However, the implementation of mkfs does not seem to respect this
> constraint and instead directly uses static macros to limit the
> user-specified cluster size.
>
>   #define EXT2_MIN_BLOCK_LOG_SIZE         10      /* 1024 */
>   #define EXT2_MIN_CLUSTER_LOG_SIZE       EXT2_MIN_BLOCK_LOG_SIZE
>   #define EXT2_MAX_CLUSTER_LOG_SIZE       29      /* 512MB  */

I was going to set EXT2_MAX_CLUSTER_LOG_SIZE to 28 to align with the
kernel's EXT4_MAX_CLUSTER_LOG_SIZE.

>
> This is confusing, or perhaps I missed something. If I understand
> correctly, users can now format an image with a maximum cluster size of
> 512 MB (I tried it, and it worked).


Yes, a 512M cluster size also works correctly on the current kernel.
The upper limit on cluster size here is to avoid the 32-bit overflow issue
that Sashiko mentioned — theoretically the maximum could be 512M.

It's just that the old mke2fs documentation originally specified 256M as
the intended maximum, so both the kernel and e2fsprogs target 256M as the
upper limit. If anyone prefers 512M, I'm happy to change it.

>  If the kernel's
> EXT4_MAX_CLUSTER_LOG_SIZE is limited to 28, this would cause such
> existing images to become unmountable, even though I don't think images
> with such a large cluster size actually exist in practice. Therefore,
> I'm not sure this is safe.
>
> [1] https://man7.org/linux/man-pages/man8/mke2fs.8.html
>

I personally don't think such images are likely to exist in practice,
since formatting with the default 4K block size would already fail.


Thanks,
Baokun


