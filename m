Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D862248BE
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781003535; cv=none; b=smq42vgi97bpcR93ut3CPbSRldkDlVHaozHLda/tmu+vL4hEMgjjcDYh7FcwcHVjoY4eNk9MFo8koFRmUVBsMdQkI7zJn8Ja5vcfngYXzvlnRDFdmHzT/o90hKB7LarBC+ZMzGxplOLB2Pg9zzT5YjPlyMyvuFLMYKx096XFJjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781003535; c=relaxed/simple;
	bh=YJ5yBrbkzoqM4V8UJOgvSKoVZqkH6NFXlovsWbsbbKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cG249ztOuq6iweBJerImqk26FJETnFzXF251B86/qCp+2EB0lGuUyf7YJOiWMV84vpWJbb6c5V2TQ9Z7UKdt2bMJRW640TBtnyxDLuc4nO+aCnqXgyYn+xJ0cnhTQcE4tt+BfYxm1JmK1k7uquk0OjwwR+CkH7jEN79vRZORm/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gZR7T5HHszYQttp
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 19:11:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7B4FF4058D
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 19:12:06 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with SMTP id cCh0CgBXpzwD9SdqhZC0BA--.42871S3;
	Tue, 09 Jun 2026 19:12:04 +0800 (CST)
Message-ID: <5b155ff7-8a9a-4aa5-a672-9b4f91f0fd82@huaweicloud.com>
Date: Tue, 9 Jun 2026 19:12:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ext4: reduce max cluster size to match documented
 256MB limit
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 Sashiko <sashiko-bot@kernel.org>
References: <20260608111150.827117-1-libaokun@linux.alibaba.com>
 <20260608111150.827117-3-libaokun@linux.alibaba.com>
 <06543725-5f38-4cac-9fdd-8a72cfb28f84@huaweicloud.com>
 <d3afb165-49f7-4c7a-b110-95d6a94a8845@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <d3afb165-49f7-4c7a-b110-95d6a94a8845@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXpzwD9SdqhZC0BA--.42871S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur15Aw1rGw4kZFW7ZrW8Zwb_yoWrCw45pF
	W8tFyFqws8JFnrXFsFkwn2v34rK34xG34UJw4kXryI9rn0kryxKrsxKrya9F97Grs5J3Z0
	vFWa9a4293s8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 6/9/2026 5:43 PM, Baokun Li wrote:
> On 2026/6/9 10:48, Zhang Yi wrote:
>> Hi, Baokun!
> 
> Hi Yi,
> 
> Thank you for you review!
> 
>> On 6/8/2026 7:11 PM, Baokun Li wrote:
>>> The mke2fs man page documents:
>>>
>>>   Valid cluster-size values are from 2048 to 256M bytes per cluster.
>> Hmm, I checked the mke2fs(8)[1] and didn't find this sentence, instead,
>> it said:
>>
>>   Valid cluster-size values range from 2 to 32768 times the filesystem
>>   block size and must be a power of 2.
> 
> Oh, I was indeed looking at a slightly older man page. It was changed to
> the current description in commit 87cbb381f2e2 ("e2fsprogs:
> misc/mke2fs.8.in: Correct valid cluster-size values").
> 
> That commit assumes the number of blocks in a cluster cannot exceed the
> maximum number of blocks that a single extent can hold
> (EXT_INIT_MAX_LEN = 32768). I believe this is wrong — a single cluster
> can be covered by multiple extents. So we should fix the bug in
> ext_falloc_helper() rather than working around it by adding a
> restriction to the documentation.
> 
> The root cause is in ext_falloc_helper():
> 
>     max_uninit_len = EXT_UNINIT_MAX_LEN & ~EXT2FS_CLUSTER_MASK(fs);
>     max_init_len = EXT_INIT_MAX_LEN & ~EXT2FS_CLUSTER_MASK(fs);
> 
> When cluster_ratio >= EXT_INIT_MAX_LEN (32768), the `& ~CLUSTER_MASK`
> operation zeroes out both values, causing ext2fs_new_range() to receive
> len=0 and return EXT2_ET_INVALID_ARGUMENT.
> 
> The kernel handles this correctly — ext4_ext_map_blocks() simply
> truncates m_len to EXT_INIT_MAX_LEN and lets the caller loop.  On
> subsequent iterations, get_implied_cluster_alloc() detects that the
> requested block falls within an already-allocated cluster by examining
> adjacent extents, and returns the physical address without allocating a
> new cluster.
> 
> I'll send a patch to fix ext_falloc_helper() so that when
> cluster_ratio >= EXT_INIT_MAX_LEN, the allocation loop can create
> multiple extents within the same cluster — skipping ext2fs_new_range()
> and claim_range() for mid-cluster iterations where the physical blocks
> are already claimed.
> 
>>
>> However, the implementation of mkfs does not seem to respect this
>> constraint and instead directly uses static macros to limit the
>> user-specified cluster size.
>>
>>   #define EXT2_MIN_BLOCK_LOG_SIZE         10      /* 1024 */
>>   #define EXT2_MIN_CLUSTER_LOG_SIZE       EXT2_MIN_BLOCK_LOG_SIZE
>>   #define EXT2_MAX_CLUSTER_LOG_SIZE       29      /* 512MB  */
> 
> I was going to set EXT2_MAX_CLUSTER_LOG_SIZE to 28 to align with the
> kernel's EXT4_MAX_CLUSTER_LOG_SIZE.
> 
>>
>> This is confusing, or perhaps I missed something. If I understand
>> correctly, users can now format an image with a maximum cluster size of
>> 512 MB (I tried it, and it worked).
> 
> 
> Yes, a 512M cluster size also works correctly on the current kernel.
> The upper limit on cluster size here is to avoid the 32-bit overflow issue
> that Sashiko mentioned — theoretically the maximum could be 512M.
> 
> It's just that the old mke2fs documentation originally specified 256M as
> the intended maximum, so both the kernel and e2fsprogs target 256M as the
> upper limit. If anyone prefers 512M, I'm happy to change it.
> 
>>  If the kernel's
>> EXT4_MAX_CLUSTER_LOG_SIZE is limited to 28, this would cause such
>> existing images to become unmountable, even though I don't think images
>> with such a large cluster size actually exist in practice. Therefore,
>> I'm not sure this is safe.
>>
>> [1] https://man7.org/linux/man-pages/man8/mke2fs.8.html
>>
> 
> I personally don't think such images are likely to exist in practice,
> since formatting with the default 4K block size would already fail.
> 
> 

FYI, I tried the following parameter:

 # mkfs.ext4 -F -C 512M -O bigalloc,^has_journal /dev/sda
 mke2fs 1.47.0 (5-Feb-2023)

 Warning: bigalloc file systems with a cluster size greater than
 16 times the block size is considered experimental
 /dev/sda contains a ext4 file system
         created on Tue Jun  9 07:01:10 2026
 Creating filesystem with 39321600 4k blocks and 304 inodes

 Allocating group tables: done
 Writing inode tables: done
 Writing superblocks and filesystem accounting information: done

After this patch, the kernel refuse to mount this filesystem and complain:

 EXT4-fs (sda): Invalid log cluster size: 19

Thanks,
Yi.

