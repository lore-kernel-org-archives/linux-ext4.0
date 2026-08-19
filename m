Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF6A35E953
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2026 14:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787149935; cv=none; b=rJ/QfwUVAMUSkFXfB6Z8ys3i06IzfLe/O8zUHm/JAn1GeBmdcsY6cYgy2TkLZF7wA/UQyhWR3Pagwpe0MfOilqmHFIV/+AQLqmtB/3UWuLIhBnCpKxhGqDpg6v4O/ZPwlDjTOOvq3Z8hA32K8do0uX2nvBNZxM76UkfIPRj6TNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787149935; c=relaxed/simple;
	bh=a9VL/BUPvfhuslXy/b3aIMnPWBDXHgBoZTNcfHd3uX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QltxoHq8JWtRb1emikT0dHUOW97W4dB1eM3ANSf/iB3pNnzedXp5OEJzYY84IFzOXJvztZ21zuWYyGdO3btGl0PmFQH+HNFDskj4gKXkOz+7aI96Zyp25yEZRU3VpA6i4lt7i6hhsAgIpF3DIhzW89glUGKtg8ot50z+MX53G9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XRb+CZOa; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XRb+CZOa"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso712684a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2026 07:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787149932; x=1787754732; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YFX/t4P2LSAhuskixBzY696FzFpYptXep8gVtvQJXY8=;
        b=XRb+CZOanHvYlMl9nY2PSTKToQLbGO64oWfGvaI/sJC3dpvz/aBqL4JhfJF3f2dHIs
         /qF47L84KC0cHRPI45vNFP3m5bExivOrNSSsqdYBtS+jW9zW4dEZ1T73NknJJhhOJGSg
         B/wUmedXT+2cLguGMFFDQGejqJ3HR8B2li2znKr+tEePmgv2O/YGxJNsxBGGsLHG/6O1
         wB6m1a0wkTLAelyX7WtorDKh8PMOfOlU7Af8oWrFAO3HgAHULbZGwHGYraXEk0Nolzda
         PUbmo6QmR+o7ru1zrvLTQCpAo5e5mim8ehlTdbx5mK9hXqsrn7F18G+Abd19ketLWDRQ
         5mOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787149932; x=1787754732;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YFX/t4P2LSAhuskixBzY696FzFpYptXep8gVtvQJXY8=;
        b=Mom4Oxk4K8uEUwAY0cbIpUkhBnnsF9sdxvmHykju+6T+qS0R6UV29td6Hqx5abakWq
         wNHDsjW3KM8nDe/ziy+5otn69LzvoBUilevUClX7V99mj/URl97Ghvaiy4AkAkbf17t+
         hrYgJrsdJQdu0tte2cFWTTXSJJYOZx4uTE4926bqjgzbitbAMmm2s5y314eDy7tQkDeY
         6s3cEiP8OKxpVJ+YPdXUiSuhT4MW72/C+bCzIPxQUKCz9idLUFDMaJ7pXiU4OiE6Ubcu
         Rce3MkdLDf3mabjwM8qyUzxWYzs4xQ0eg32mxqbBQ+rR3FwWOPAD5h/RRha8FI+kRsxC
         4wjw==
X-Gm-Message-State: AOJu0Yy16Y4tPOP84stOoj4ojt5fBWEN9Ya+kvfumMAiEJFP/Cp82CPg
	ulCbq98q5unY23bOo4Pe3/WmOCfk3BBXiWhTCu17YvHN9t378J4LgbkHaRuP02R9xOk=
X-Gm-Gg: AR+sD109lx5EVyyiWuXV/AMljnHvWt5Wa4Xcj5sxVFhWwt901JK8aTwEW/PjHynNj25
	IgLN/L7y3d4iMHUQfutCBdRAvGVX4mQMZ9f8j9dYWSvqZbrEK+YzgMCTRyNV+y/LJCzyYDsS++q
	/8fUyoG3aFAVPYCtb/HeJdjvaj+++TIr6mQQV8MTkJzPzB5aNJPLf2PBcO61S9u5scX40ulIL1c
	VkEMBG9QCFD+zI1VQ3tyV3hF68qY1zIYL+cYOqDV1pf18Oq7ABSPAy7L7Qc2ilNL+K0EktzlCAR
	N+WEYygf7/QBwsDoRzCQgDEnnggFAPlNtzEmC0l1j+bjeOQe//30xl7pTUD0+zWztQbGvpVpoWS
	5AlWvmuuWgGLnnm5jhh8KP3C3y+b4Vtnloq36S7ijDOcm0y5nLwRXKSnygaejiF0ikEyWxqneP6
	XO5ACvbSY2L16IBfqGecYgkHFnQPChUC0wuBejnVvxIdT7NugeIWZ7lDdPE8AW1YDJTQ0ne/MBW
	UZ5Eotr
X-Received: by 2002:a05:6a20:430c:b0:3c4:3112:33 with SMTP id adf61e73a8af0-3cd0107606amr9576018637.6.1787149932182;
        Wed, 19 Aug 2026 07:32:12 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc15567537esm682505a12.19.2026.08.19.07.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 07:32:11 -0700 (PDT)
Message-ID: <b7b4f781-9bea-4658-8eca-d7fc4cb5569f@gmail.com>
Date: Wed, 19 Aug 2026 22:32:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 27/32] ext4: clear DISKSIZE_GROW_PENDING on
 truncate or error
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-28-yi.zhang@huaweicloud.com>
 <20260814103129.98BD71F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814103129.98BD71F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:31 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The EXT4_STATE_DISKSIZE_GROW_PENDING inode state bit is never set anywhere in the codebase. As a result, the entire deferred disksize update mechanism introduced in this patch series is non-functional.
> - [Medium] The DISKSIZE_GROW_PENDING state is not cleared for linked inodes (i_nlink > 0) during eviction, leading to a WARN_ON_ONCE in ext4_destroy_inode() on forced shutdown.
> --
> 
> --- Patch [27]: [PATCH -next v5 27/32] ext4: clear DISKSIZE_GROW_PENDING on truncate or error ---
> commit a9d36fc1a5b406105120b9e8fd8d91b4a9fe12f0
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: clear DISKSIZE_GROW_PENDING on truncate or error
> 
> The disksize-grow-pending state is set when a zeroed EOF block is queued
> for writeback and cleared by the ioend completion path once writeback
> finishes. This patch clears the disksize-grow-pending state on discard,
> inode eviction, filesystem emergency state, or truncate to avoid blocking
> writebacks and preventing warnings in ext4_destroy_inode().
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 056937e278594..a1dfb70127ca8 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -273,6 +273,8 @@ void ext4_evict_inode(struct inode *inode)
>>   
>>   	if (ext4_should_order_data(inode))
>>   		ext4_begin_ordered_truncate(inode, 0);
>> +	if (ext4_inode_buffered_iomap(inode))
>> +		ext4_iomap_clear_disksize_pending(inode);
> 
> [Severity: Medium]
> If a filesystem is forcibly shut down (e.g., via EXT4_IOC_SHUTDOWN without
> logging an error that sets EXT4_ERROR_FS) and then unmounted, dirty linked
> inodes will be evicted.
> 
> Looking earlier in ext4_evict_inode(), if inode->i_nlink is > 0, the code
> jumps to the no_delete label, completely bypassing this cleanup:
> 
> 	if (inode->i_nlink) {
> 		...
> 		goto no_delete;
> 	}
> 
> Will this cause the newly added WARN_ON_ONCE in ext4_destroy_inode() to
> trigger for linked inodes since they bypass this state clearing?
> 

Yes, this is right. A linked inode evicted after a forced shutdown
bypasses it and would hit the WARN_ON_ONCE in ext4_destroy_inode(). So
I'd tightened the WARN_ON_ONCE guard in ext4_destroy_inode() to skip the
check when the filesystem is in an error or emergency state, since the
pending block may not have been written back in those cases. Besides,
drop the emergency-state cleanup added to ext4_iomap_writepages()
because it becomes unnecessary.

Thanks,
Yi.


>>   	truncate_inode_pages_final(&inode->i_data);
>>   
>>   	/*
> 
> [ ... ]
> 
>> @@ -6741,7 +6759,18 @@ static int ext4_truncate_down(struct inode *inode, loff_t oldsize,
>>   	start_lblk = newsize > 0 ? (newsize - 1) >> inode->i_blkbits : 0;
>>   	ext4_fc_track_range(handle, inode, start_lblk, EXT_MAX_BLOCKS - 1);
>>   
>> -	ext4_set_inode_size(inode, newsize);
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>> +	/*
>> +	 * Truncate the zeroed EOF block invalidates the pending disksize
>> +	 * update, so clear the disksize-grow-pending state.
>> +	 */
>> +	if (ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING) &&
>> +	    (newsize <= EXT4_I(inode)->i_disksize))
>> +		ext4_iomap_clear_disksize_pending(inode);
> 
> [Severity: High]
> Is the EXT4_STATE_DISKSIZE_GROW_PENDING bit ever set anywhere in the
> codebase?
> 
> A search of the tree indicates the literal EXT4_STATE_DISKSIZE_GROW_PENDING
> is only ever read or cleared, never set via ext4_set_inode_state() or
> similar.
> 
> There is a TODO comment in ext4_block_zero_eof() indicating that this state
> should be set:
> 
> 	/*
> 	 * TODO: In the iomap path, handle this by tracking the ordered
> 	 * range and updating i_disksize to i_size after the zeroed data
> 	 * has been written back.
> 	 */
> 
> If the bit is never actually set, won't this entire deferred disksize update
> mechanism be non-functional, leaving the filesystem vulnerable to the stale
> data exposure this patchset was intended to fix?
> 
>> +
>> +	i_size_write(inode, newsize);
>> +	__ext4_set_i_disksize(inode, newsize);
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>>   
>>   	ret = ext4_mark_inode_dirty(handle, inode);
>>   	ext4_journal_stop(handle);
> 

