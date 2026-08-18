Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1C3352C35
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 12:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787054911; cv=none; b=H5NuEToptNM+OSIUghjStGUIKYBtXUs6LHSeWSyhqEcdyXUIVce4bK5eDrUT58Lu1d30F4REUUn3R06TvF7yOfT48EyqryXV3LWNDfigGBY8sevWXLC5dgdbbE9ug6jUEnb4Q6/rIHUEmwnddxIyBBr6l0usMeOINK8NDnbXQIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787054911; c=relaxed/simple;
	bh=fAUDPvxqaw+6pr5mc39n3eur2Tcogs78ZHJo5w0bH/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GUP0JX8bK5okedpRz2wz0TGZcVCTMbw6Q/vPZZ1Od+CEgAT0c43NKiLD/Fuy4I6qgAPk/b5xm4gK/9AN5rNE105yKqpwoubNh/bTzfLtK31lnUeUULi+hMHHNDSXqnOo7F/jsfb8b4pK7+SX7mMjBmFnTfza0HY0cV7yvO5WuYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UW74K5fx; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UW74K5fx"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so3899291a91.2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 05:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787054910; x=1787659710; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SLWRR6bd/B1YfeV+dpf0DikAPd8jlRuMRPf5YKC5xI0=;
        b=UW74K5fxJudZ3QIDRTinYz0/wFAB6etBOSZXOnhtYeTRu1lH1s6yj7fZQxKzVPHv1c
         2lJiMrUKqFZ5K5LpxN8xaiQ1g4AsoPar8SxyHSUGxZIAvaHU0kFMDhoIKt4iecKqeQCW
         Uv3Mh/uDt3bxPCqEyFT5ccz0Mx+XkDWb53zVie1iGKyOrortIGHNmObMmWhc2zAOgYsp
         JTs/AlKOPxipO37Xzh09T4184vTrVbImRa3EI1CTurb8sLTeMJqW5ZDjctQ+XP7jHvhx
         UorMLTaqgVm01chyB4PwotrtmzF4ErQLsIzFObz51UJ5/i3Ztkn96p6vIa+7eK852lH8
         DN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787054910; x=1787659710;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SLWRR6bd/B1YfeV+dpf0DikAPd8jlRuMRPf5YKC5xI0=;
        b=PB7Id7yseg5smpV9DkXBiTJbvzr7d1oQq2YzC+4QP2ERxam3AjbDGepptsBRjuQlYt
         nFPWNoULHuR0jyioN1Pcqt88jQJSawtCL/MynozX/NLe9WNlFrYQPqkLMXWcThblpB5h
         c9oB8QPaAaxqhEpZvoICZD4rDW1YWHWpMwrKNkwDvOUJ+MqJmHcw3Z5jia6jYgHFoaav
         wXgkOppaUXzRHWLpBXqiYyHpEsmiXQ4jZ/eRejUyrY5b4H+qZj6O2Lck3BWmY/55ecKh
         qnwgb8+UR+yaRmKOBmBgLXlvlflF/sSAiXbKd4mL7dxf5t0w1dzHRU+R8eFZU2VWa+oT
         kUJQ==
X-Forwarded-Encrypted: i=1; AHgh+RqdXrDvvsaMokysAbWHRaWQajLLU1JsWR2g2LVvBKMc2dG7n1I30YnmfteQofO00iSxR8AqH7x8LZQk@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh8SxlqTwt6Vc4+6M4kY/Cnp7uKCQW8zx5vrWdL+0d+b70Jyli
	rjmRy6sdJF1XPN9yeoaXC23GJzoDMeFKRL7y6kq9cReeGfd8T40xc7Xw
X-Gm-Gg: AR+sD11Mg/N/7U5DeUAci6eVAytaiCL25SZxrzQGaFl41Bl3+ysdR0X1iF9IEUdQz64
	pP5p9pxOPgQy/NVorxd9kodUVZ61BMX/JjD9m1WhpZbB/FM1athb9vyex8cAzrI6habq+JN8f15
	gT9yM0b+RovKlQUPXH5L03Lc8ceVTyuYuULbvXkK7SmzkL7Yf0cm0E0AwCaffHCYAGASKqsX3K8
	ku7/OCL7W6aDxmuQr9YYZx5hdrIpIe9tSWLTpPW3udveuOQIWtNITRRFxjarcP+C47PTFwt/Z/6
	2CXY8pbViJEKKNmEYpMm2giQH2yPMVVuPdWWP4oACh2z0/YFyaxXk3ViGr/QgTyYgrZhKcMkH/O
	vi8mdI9wQ6EQstRzo2x7vWGnf4VcND+7desJsQLBFDXBrZLn3hwpZ0TWNot82y1HaUCD9WlF/Sf
	dY6UwGJ5Lbbu/9yLp634kr1IirwS2Tx0shnnfcWC84M33xcTkeD1woMqaujvFayTgHESuAceOMw
	g5DBG9G
X-Received: by 2002:a17:90b:3c8c:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-3933b91661emr37890092a91.11.1787054909608;
        Tue, 18 Aug 2026 05:08:29 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531fbb3c5sm8561385a91.9.2026.08.18.05.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 05:08:28 -0700 (PDT)
Message-ID: <4706b63c-a74f-43ec-9b25-773192d7b55a@gmail.com>
Date: Tue, 18 Aug 2026 20:07:58 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 25/32] ext4: defer i_disksize update while
 DISKSIZE_GROW_PENDING is set
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-26-yi.zhang@huaweicloud.com>
 <20260814103123.E1A601F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814103123.E1A601F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:31 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Missing State Initialization / Dead Code: EXT4_STATE_DISKSIZE_GROW_PENDING is never set.
> - [High] State Leak / Data Loss: Discarding the zeroed EOF folio without writeback permanently leaks the pending bit.

These are false positive. EXT4_STATE_DISKSIZE_GROW_PENDING is set
in patch 28. This patch is just preparing for that functionality.

> - [High] Durability Loss: O_SYNC extensions via fallocate/zero_range silently persist a stale i_disksize.

This is a false positive. O_SYNC in fallocate operations is handled
in patch 26.

Thanks,
Yi.

> --
> 
> --- Patch [25]: [PATCH -next v5 25/32] ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set ---
> commit 5fa612fe6ec599be935a3aa55b36845e34d3180e
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
> 
> Operations like append allocate, zero range, and truncate update
> i_disksize directly. If the new i_disksize exceeds the original value
> while the zeroed EOF block is still awaiting writeback, metadata may be
> persisted before the zeroed data, exposing stale data on crash.
> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3605,30 +3605,67 @@ do {								\
> 
> [ ... ]
> 
>> +static inline void __ext4_set_i_disksize(struct inode *inode, loff_t newsize)
>> +{
>> +	WARN_ON_ONCE(!rwsem_is_locked(&EXT4_I(inode)->i_data_sem));
>> +
>> +	if (newsize < EXT4_I(inode)->i_disksize ||
>> +	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))
> 
> [Severity: High]
> Could O_SYNC extensions via ext4_do_fallocate() or ext4_zero_range() silently
> persist a stale i_disksize here?
> 
> If the size is extended with an unaligned old EOF, the i_disksize update is
> deferred. Since O_SYNC immediately commits the journal without waiting for
> the pending zeroing writeback to complete, it seems it will commit the old,
> deferred i_disksize to disk.
> 
> Would this cause the file size to revert on crash despite a successful fsync,
> discarding the size extension?
> 
>> +		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
>> +}
> 
> [ ... ]
> 
>>   static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
>>   {
>>   	int changed = 0;
>>   
>> +	if (newsize <= inode->i_size && newsize <= EXT4_I(inode)->i_disksize)
>> +		return 0;
>> +
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>>   	if (newsize > inode->i_size) {
>>   		i_size_write(inode, newsize);
>>   		changed = 1;
>>   	}
>> -	if (newsize > EXT4_I(inode)->i_disksize) {
>> -		ext4_update_i_disksize(inode, newsize);
>> +	if (newsize > EXT4_I(inode)->i_disksize &&
>> +	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING)) {
> 
> [Severity: High]
> Are we setting EXT4_STATE_DISKSIZE_GROW_PENDING anywhere in the codebase?
> 
> Looking at this patch series, it appears the bit is checked here but never
> actually initialized or set. Does this mean the deferral condition is always
> bypassed and i_disksize is always updated immediately?
> 
> [Severity: High]
> If the EXT4_STATE_DISKSIZE_GROW_PENDING bit is properly set, could it leak
> if the dirty folio is discarded before writeback?
> 
> For example, if a file is truncated down before writeback completes, it
> seems the bit might never be cleared since the writeback completion function
> wouldn't be called for that folio.
> 
> Would this leak cause all subsequent appends to skip updating i_disksize,
> leading to silent data loss on crash for future writes to the file?
> 
>> +		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
>>   		changed |= 2;
>>   	}
>> +	up_write(&EXT4_I(inode)->i_data_sem);
>>   	return changed;
>>   }
> 

