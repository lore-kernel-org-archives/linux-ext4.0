Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639154788
	for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 08:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786782654; cv=none; b=pf8llsy7Ai3MG7RbsLGPtcWjAwje1zHYD2U5WUJcSacke/VlgmL8YEpiWTd9r3zUg2fZzEz9NvkrrFe6YexOp9bqJYde/cOwFDtJtMBEQU4EnA/4US5G0SWBBTH+HuqBoNdv68GxLgUtq50Kv7ZxgFo3pIQWOrJPuR/IvOV95mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786782654; c=relaxed/simple;
	bh=nQf+oRV2tsje4ZAAo4tpszk2WhvhadMFLZRKKhKbilE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UaniZW2hC+UKF6HAjU7biNywvqYMF7qRwQQZVTINxTqjYSJJ3EKJgdUEklUrhaV5ENJVXCCKgD6yUHAb9N9TCpL8oZE3XZrhG8JbTQaY9+904o+XFoCwiKefo00kDqGf4N2AqnbWstWoht8g+MTZhW9nIzE/aGrOA/Piy6oD2uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PrEb0k4j; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PrEb0k4j"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc97653887so30692885ad.1
        for <linux-ext4@vger.kernel.org>; Sat, 15 Aug 2026 01:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786782652; x=1787387452; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JOcULi8LDrPr9znFK69f8PAs3Dh2L7dZMUzvNkwuPa4=;
        b=PrEb0k4jYtJEwa4CrKXurmqsmjLcBKynYrHNE51r51qTdD8Ng6wduCX6VTjZpVQZW4
         UHkXnyzPQNTbKZIykuze31XSV8D/lRH3kn34kyvKVj/egnt+2RgENPJ1nD0E0Tx69vSs
         VMDmmbqAMcmQ/hyWbKgy7uUmRLPaol6HLFL1zLvFAx4KOwzb2LVt3bES8ZRbe9kumYjK
         5Fjr3I7jqn6olfVBQpCsMHfohMcXduXGZW4eef6kBj8WpBJb7dJgxOwfOKInXsFWo8o9
         bnUeMkzGmqcIW170gTi1hcxofgivdqZ9Hm+io3iVLna5hGon3i114/8Xh8DtaFhFROai
         IO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786782652; x=1787387452;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JOcULi8LDrPr9znFK69f8PAs3Dh2L7dZMUzvNkwuPa4=;
        b=M7IGA+uIkDs9ym+lpAXsIXc45BLd6kCQF3uZjK7yupANK60kDeocxsQX9kRHIvB12D
         TyMuPwzcUMT+/GdCsi93Yg4VtTt3XzR+mog7eVhkR/F6iFBzsdeRwo9pDfXh0knqAON4
         MyPSxw2tbXpmAXrjojRmAyssTd+XW7VXCqtGXDR12M1o7XxtFZ3cD8qfHFxbjZYuPxXA
         x72xE7hntbdWtJ6ViJ1iEKVL2JlDMIXVy2uEwESrahNaUIDUtXqcHCgI7uTuN/AlhlkH
         WDoU9WVC+xA6i7cZKD9MO1WmhsYtK0aR7TpBX9eACftVNcRufv2Exh1TDyZGWG38HPiW
         P7Kg==
X-Gm-Message-State: AOJu0Yw4szGCENCO2np7RfNtIbn77J1EmhnaSIfANDflMB+JXRcfRqvl
	iz6WdbuyCx88xcEQiItS2FrCbJf/fCrm9N0D8oV1lAgTmTET+Gqb0REB
X-Gm-Gg: AR+sD129YK9ocNGPTlbCX+8kQIU7c4raKv3tupPTaf6StMaUxZ8SYG+ERE9ZCjsDdJm
	2HHUlWzWeX+og3TPJGglZ691V1eBdLrW13MHJIy41/SM6E0/17tJT4Fx5ekDuBe2lk2EtInI87z
	tFjM7QnnuPrnrq+E5wplcclvFIaAOURXV0h1k3cD6O1s46UG6xq1f3ASYU/yB+UcfCrre9Ugl6q
	//gBKKLMP3IIUikyue0p34rfTCbAV2RlKxVtMFtqrhNPUnZRzSxLr3AUG/8q8MlBUtTGgP8Npb3
	yL8HSgCaERiW4pzxsmxdHk/Dt00kd6Fe2TA7vEwnD4R/ji7+kfy29FUh7NRhAP5u2LNkc6NjhZw
	S95KmHGKCnEduMTdcSnCg1VFxr8pOVNnSxTyMEUdDNl/CeUakjHrsjB0G78jkrbTn6XAbjQe/eF
	KLNIp2s7ZIJxkIivAs/eSAzUU1wQClzPi3s6vdNLdFYuxDUBkk3oiqE1L/TdFeHmHCX9IFa5Geg
	yzk2Ir8
X-Received: by 2002:a17:90b:53cf:b0:381:1c96:829b with SMTP id 98e67ed59e1d1-3933bd204d0mr13591060a91.3.1786782652373;
        Sat, 15 Aug 2026 01:30:52 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394ea96c87bsm5480237a91.4.2026.08.15.01.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 01:30:51 -0700 (PDT)
Message-ID: <16bcbf6d-b950-4ea1-a516-ae9330b6335e@gmail.com>
Date: Sat, 15 Aug 2026 16:30:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 06/32] ext4: recheck extent status tree before
 block allocation
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-7-yi.zhang@huaweicloud.com>
 <20260814101548.7E86E1F00A3D@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814101548.7E86E1F00A3D@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:15 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Reading uninitialized `map->m_seq` on error paths leads to an infinite retry loop in `ext4_map_blocks()`, causing a kernel hard lockup.
> --
> 
> --- Patch [6]: [PATCH -next v5 06/32] ext4: recheck extent status tree before block allocation ---
> commit 6ae9b515f2027351280fce82734e7e8361a281e7
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: recheck extent status tree before block allocation
> 
> After acquiring i_data_sem in write mode, recheck that the mapping
> found via the extent status tree or disk query has not changed. If
> we find a valid extent and the sequence number has changed, retry
> the entire lookup to obtain the correct trimmed mapping.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 9dbece14ae569..548a3968c5a7d 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> 
> [ ... ]
> 
>> @@ -820,6 +821,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   	 * with create == 1 flag.
>>   	 */
>>   	down_write(&EXT4_I(inode)->i_data_sem);
>> +
>> +	/*
>> +	 * Check the validity of the mapping found via the extent status
>> +	 * tree or the disk query. A racing truncate may have changed the
>> +	 * extent, since writeback does not hold i_rwsem or the folio locks
>> +	 * covering the full extent.
>> +	 */
>> +	if (map->m_seq != READ_ONCE(EXT4_I(inode)->i_es_seq)) {
>> +		up_write(&EXT4_I(inode)->i_data_sem);
>> +		map->m_flags = 0;
>> +		map->m_len = orig_mlen;
>> +		goto create_retry;
>> +	}
> 
> [Severity: High]
> Could this cause an infinite loop and hard lockup on disk error?
> 
> If ext4_map_query_blocks() encounters an error like -EIO or -EFSCORRUPTED,
> it returns < 0 without setting map->m_seq.
> 
> However, if EXT4_GET_BLOCKS_CREATE is set, the function does not return
> early on error and falls through to this TOCTOU check.
> 
> Since callers like _ext4_get_block() allocate struct ext4_map_blocks
> on the stack:
> 
> fs/ext4/inode.c:_ext4_get_block() {
>          struct ext4_map_blocks map;
>          ...
>          map.m_lblk = iblock;
>          map.m_len = bh->b_size >> inode->i_blkbits;
> 
>          ret = ext4_map_blocks(..., &map, flags);
> }
> 
> Will map->m_seq contain uninitialized stack garbage, causing the sequence
> check to mismatch and jump to create_retry, which then encounters the exact
> same disk error indefinitely?
> 

This is a valid report. I think ext4_map_query_blocks() should bail
out immediately on error, rather than trying to allocate blocks
afterwards.

Thanks,
Yi.

