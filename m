Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CFE2D7386
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784777391; cv=none; b=DngpHAmjASr1qyYe1V5lg2YqqMYXzkzTSWoHAuI7/9s+9xC2/rQ1F/Nz3XuU4dz0qC/JvYOQTdp/9hrxI3O77GjJBTwE6agmRUs9PiL2h4TDGfPrmLsJ47bQgqwwUFT3L03E8iqvoGaB71olZ9ozFLMqnquxD+05C9n9bI3w33c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784777391; c=relaxed/simple;
	bh=cuRCIj8mQCBuqBo/Fnlwy6jKc+J8ia3bH9AAy3XH960=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uoBIhe/GlMCi2AtsmuLnV19l9+RBxY/2Tt7qKGngaJPV/7zebUKt7UvMGZquS7HVE9jvWg8phxi/C42THv+/exc654L8Sgx1Mcd1TqvAiZpC0I0qfwI058HaT5YHKPFoTRkc3z29docnR12GyfzWhFat+2bDHyPJEH7RxP2JcS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h5GnS1ZFQzYQtlt
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 11:29:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 4F74F4056D
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 11:29:46 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCXp3OoimFqvOfkCA--.6872S3;
	Thu, 23 Jul 2026 11:29:46 +0800 (CST)
Message-ID: <6213263f-27e4-4d2a-b6ef-f63093f89e69@huaweicloud.com>
Date: Thu, 23 Jul 2026 11:29:44 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] ext4: protect WRITE_ZEROES written extents with
 orphan list
To: Theodore Tso <tytso@mit.edu>, sashiko-reviews@lists.linux.dev,
 linux-ext4@vger.kernel.org
References: <20260714080044.4038124-1-yi.zhang@huaweicloud.com>
 <20260714080044.4038124-10-yi.zhang@huaweicloud.com>
 <20260714084203.971381F000E9@smtp.kernel.org> <amD3fZPiCKwUqhGd@mit.edu>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <amD3fZPiCKwUqhGd@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgCXp3OoimFqvOfkCA--.6872S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1rCFWxGw1xCr43Ww4xCrg_yoW5JF4rpF
	y3X3yYka1kJFyF9Fn2vF4UtFySkw1xZw45Jry5W3yjy3Z8ZrnIqrWUG3WYgrWkCr48u3Wj
	qF4ktFyrAFn8XFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgmb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

Hi, Ted!

On 7/23/2026 1:07 AM, Theodore Tso wrote:
> On Tue, Jul 14, 2026 at 08:42:03AM -0500, sashiko-bot@kernel.org wrote:
>>> @@ -4701,6 +4729,11 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>>>  		pagecache_isize_extended(inode, old_size, epos);
>>>  
>>>  	return ret ? ret : ret2;
>>> +
>>> +out:
>>> +	if (orphan && inode->i_nlink)
>>> +		ext4_orphan_del(NULL, inode);
>>
>> [Severity: Critical]
>> Does passing a NULL handle to ext4_orphan_del() here corrupt the on-disk
>> orphan list?
>>
>> If ext4_convert_unwritten_extents() fails on the first iteration, epos is 0.
>> The code skips starting a new journal handle, jumps to out: and calls
>> ext4_orphan_del(NULL, inode).
>>
>> A NULL handle removes the inode from the in-memory list but leaves it
>> permanently linked in the on-disk list.  If this inode is later unlinked and
>> freed, could this sever the rest of the on-disk orphan list and lead to severe
>> filesystem corruption during recovery if the inode is reallocated?
> 
> This looks like a valid problem; it's possible to get to this point in
> the code:
> 
>         if (!epos || !new_size)
>                 goto out;
> 
> where we've already added the inode to the orphan list, and we will
> then leave the inode on the orphan list.
> 
> I think we need to fix this by checking to see if orphan == true, and
> if so, we need to start a handle, and then call ext4_orphan_del() with
> that handle, and stop it afterwards.
> 
> Do you agree?

After thorough analysis, I agree that this is indeed a real issue.
However, we cannot simply initiate a handle to remove the orphan list,
because ext4_convert_unwritten_extents() may have already converted
some extents to written even when it returns an error (in which case
epos will be 0). If we remove the on-disk orphan list under such
circumstances, it will lead to filesystem corruption.

Therefore, I think the correct approach is to modify
ext4_convert_unwritten_extents() so that it returns the actual
conversion length, and only returns an error code when no conversion has
taken place at all. This way, ext4_alloc_file_blocks() can use the
returned conversion length to decide whether to add the orphan list
(within the same handle as the conversion operation).

What do you think?

> 
> If so, are you OK if I just drop this last patch in the series, and
> you can resubmit with the fix?

Sure, please drop this patch for now. I'll send a separate series to
address this issue.

Thanks,
Yi.

> 
> Thaks,
> 
> 						- Ted
> 						

