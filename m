Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE51537C10C
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2026 06:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783924652; cv=none; b=T7lNhnUkxgO0/mXkm62tXDWrR/FEoMCscNfxjBMqA8FGB3Z45W+zUF9N5P2S6kjcanQEByrgyxmAtUHe8QAFo1TG52bbd9hGgxna5wBG88ZWbUlb2jxBjF/r6bpLeJL9T94HTrDhz0F72eKdFyUHjx4kBUTXuv5s7ZNRrDAb7ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783924652; c=relaxed/simple;
	bh=sDQjdPXx/A4gcsSDwiOadlaj5ExC9fPRLmccZtKqw/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OE+sApgIFaTES9BeYywykycyy4S3Uo2gDeT8sUfHt6ISn7GijIZoSsstLRQbWnnuJGM9AURCpZrVC7zPr9xkraFoSyu/BG6VbNPH2fnxn69OM+HTrJFy8PoNQnOP6yR6L77dr3D87ig40gfSyFys7kVQQ9ysajPcM2HLhHqelAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHBL35Gr; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHBL35Gr"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cacf197759so40712925ad.2
        for <linux-ext4@vger.kernel.org>; Sun, 12 Jul 2026 23:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783924650; x=1784529450; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6UMocpabDNhUBeWAPvFfR1DoyVH/T9G9hR9WUGxdPt8=;
        b=mHBL35Gr7VrHp9HikipnkBDhSQetC5jMGuiRrT7qHgLcEmOoeMFaX2TMpHjmgJpfBH
         9RHW22CrqAWJeetUOs/K9Hzn9IHJMz2qrMJE+upVELJ1gTv2gwJaqJY/PDXKKkFYHdPK
         tZ7R6x5GyjZ/i08bTKHmyVBuwu3AbwfvAqwQpVEQ+N3Q6tGP0dTRwLLI/uaHukEXcDf4
         4ctjqRYoO4OGX5MIhUsySOPn6X0ruBeKVcyQl63LUDjgoX02wcoUQVpwjlso4O9T3DyG
         FrCiljKikFHVZq6qW7Rs+iNAbfvKdM8hqDPXk+W6a4GI4d+Djg/mR1sHyqzonJVYRN0A
         O23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783924650; x=1784529450;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6UMocpabDNhUBeWAPvFfR1DoyVH/T9G9hR9WUGxdPt8=;
        b=mJMEUuL46JhGcSWaisskQxHBNQZ65gJvOlM7Ueg/iHFvb0TUm9JrSzV9fTc1pKp2xM
         vNbbeVJQhsCRIS0XjMwacRjUWAu2byNbxaKtOO/c/IeECrPu5nMWPmk71zjqs+VaMRoX
         EyjdxxBlS8kSIN7rozLMnyFtYLqgmxPiPICTrY4qgrbCe8jkeIvqbE8moJf5gxXcIzEy
         S+LsTAkpv8/Jme35H9SdfdXimoUFF57Cb2XfpL33NURPzYEDRBD315DJrrcEm8w/z+3Z
         mv0wk9kIr+vOqLsEgifBAdJHmzcX868+KHFx6pC06gkNWXYvGpqKHXTnORXcXfQLWsl/
         Y2Vg==
X-Gm-Message-State: AOJu0Yw4PTnRV6Kd3u1TJTCjWsPcFY02v+WZlyRHfQx7uDfiD8EefWto
	l1urUbzESB5SzQsUcIhFtLZxadNbXdmqGNQpVVK84ChuorH3+nWrcbWF
X-Gm-Gg: AfdE7cnOrthKNxtQboeXMnAtlGRODS18pQg1cl2W0ut4VZlxMbwh+hsqP2Eev0Spz5E
	d36dr9ACZ6tZ2VfUnSs5G7a2zpGUfzDIBLY+Cvy0MoPaM2pQm9gUBkF9abjHg/wXUMYoEuMLN+E
	H246kmnBQWQT+1EQyX+GntjanqkLuIK6XIXtQnlFcyxT2Tk8CZefRb1VprjCJkvqL+ORAQTyko8
	JWZisQoBoD6OXCdhxRcIzFlwhMlV1puOZN6R/pj7U1xAZ3xZdMG7YBcZg5iaFjn2826p8lxMZpL
	BGl6OBaNdSZDWc0YlMzPbTVkqppOrBB3I7emEu5BIvU0OKXnvqKKuNR1HGWEmu27VfFcuVbsI9J
	E5FN8Im4iezea8xx0pFuswHElZszZQUGFcleUb9cqjunfMqWmSfg6RN5iC2kmn8OsN5EcRM7W3L
	LnmglqzrBYWPZgejqaCjbbNKqwwTxVy9DR
X-Received: by 2002:a17:903:2288:b0:2cc:ee78:3236 with SMTP id d9443c01a7336-2ce9ef17a75mr74745075ad.33.1783924650060;
        Sun, 12 Jul 2026 23:37:30 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9c25fccsm93152175ad.35.2026.07.12.23.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 23:37:29 -0700 (PDT)
Message-ID: <efe86dda-96c2-47a4-b9b8-a30584633196@gmail.com>
Date: Mon, 13 Jul 2026 14:37:17 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] ext4: skip tail block zeroing for inline data
 files
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, chengzhihao1@huawei.com, yangerkun@huawei.com,
 yukuai@fnnas.com
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-3-yi.zhang@huaweicloud.com>
 <j5jbhizj5ldw3h5tnplfs23zblhqa7di5occ4zbmd6dsqq5hwl@uznnurl5zljt>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <j5jbhizj5ldw3h5tnplfs23zblhqa7di5occ4zbmd6dsqq5hwl@uznnurl5zljt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/9/2026 9:25 PM, Jan Kara wrote:
> On Wed 08-07-26 14:20:42, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> ext4_block_zero_eof() is called from ext4_write_checks() on every
>> append write beyond EOF. For inline data files, ext4_get_block()
>> returns -ERANGE when ext4_load_tail_bh() looks up the tail block.
>> However, this error is currently ignored because the return value
>> of ext4_get_block() in ext4_load_tail_bh() is discarded.
>>
>> Before we fix ext4_load_tail_bh() to properly propagate the error,
>> skip the zeroing for inline data inodes to avoid unnecessary
>> failures or confusion.
>>
>> Fixes: 3f60efd65412d ("ext4: zero post-EOF partial block before appending write")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Hum, but this check is racy (inline data can be removed from
> ext4_page_mkwrite() after this check) so we could in theory miss some
> zeroing we should do. I didn't put too deep thought to whether it really
> can do some harm or not but it would at least deserve a comment.
> 
> 								Honza

You're right, the race does exist. Thank you for pointing this out. Let
me analyze the scenario precisely.

ext4_block_zero_eof() is invoked during a file-extending operation (when
buffered write with start_pos > old_size) to zero out the contents of
the old post-EOF block. This zeroing is intended to prevent stale page-
cache or on-disk data from being exposed.

Now consider a race between a file-extending operation and a concurrent
mmap write. In the mmap path, ext4_page_mkwrite() first converts inline
data via ext4_convert_inline_data_nolock(). During that conversion, the
entire block is zeroed with memset() before the inline data is copied
in. As a result, by the time the conversion completes, any stale post-
EOF data that ext4_block_zero_eof() would normally guard against has
already been cleared.

The only remaining concern is a scenario where an mmap write touches the
old post-EOF block after the conversion but before the file is expanded.
However, that would constitute undefined behavior regardless of whether
inline data is involved.

So from a practical standpoint, I do not see a real issue here. I will
add a comment in the next revision to clarify this reasoning.

Thanks,
Yi.

> 
>> ---
>>   fs/ext4/inode.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 7b2face041ef..a3f7c71b701d 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4218,6 +4218,9 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>   	offset = from & (blocksize - 1);
>>   	if (!offset || from >= end)
>>   		return 0;
>> +	/* Inline data has no tail block to zero. */
>> +	if (ext4_has_inline_data(inode))
>> +		return 0;
>>   	/* If we are processing an encrypted inode during orphan list handling */
>>   	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>>   		return 0;
>> -- 
>> 2.52.0
>>

