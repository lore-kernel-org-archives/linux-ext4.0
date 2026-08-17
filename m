Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F585C613
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 02:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786932908; cv=none; b=YaWjsje8AaN0Dao/A9ysNKbhT8vxER94pDokfTVEF64nX6+Boxbpj0zs2oJPMRGcjgfTse8Vx1541wcCJPnih/+P/1oV+HD5yyGW4etYKqLVIPoiERO1um6n/6v0laTtnH6FFkqYCE6V/ldJdJKkS7ooZ5hOzslJ5EXN/AjAjkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786932908; c=relaxed/simple;
	bh=4PDxVHxzEtixMQxj375u5qupcw8HmdOETUyxhxESZ+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rr3Ua0D2q49W1NuPiHLUN0m3Hkuq4LCmDp1z2mKebVoiOt0bGDj/AFMk1GnyK2zKWhaQpWW8SvyvfHbOnj5VWb/5FVn8wa2cQ90PQbMWHfeufBUi8FsmFnd2DeszJGxxhP3xEyBT+NE3EcTVqOABtnkHpEoGsuQz4PST8xH4YKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MIOeRZ8G; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MIOeRZ8G"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ceab75934dso35124555ad.2
        for <linux-ext4@vger.kernel.org>; Sun, 16 Aug 2026 19:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786932904; x=1787537704; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aTuatPTaLF+hATnCNZpEBrhBXHe7FOsOaL8XbwX/BY8=;
        b=MIOeRZ8GsRfhSXT+HS8gwTVYerh1Z9o+sDHuzbkUoauxHgWwGaLCQ1H/tLhI6N593+
         hQz2tpdtw47c3jZkkqO2KumwrSDPFGmpkwYbrJ1nIhVhbPcU8Kq71GLnEVpt2iwJTOlk
         D2u623eqZrP1D8qKIqxSA0ez2b6ZuEDvAJHWATQUTz3PIYRJXMbx2VXoQx+tio0lKvUw
         t/SctZGSrq1Q+mnkf/538u+5VRj0Xilg3cBetA6Czm1hMZjh356u6pwz1qJELozjKHan
         SkV7cB0+t6Onp1kH78jUc0eW10HgNFwdaOyaBTKvffpTcIYJPVGXKTNLh8ePiHPh21xC
         0+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786932904; x=1787537704;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aTuatPTaLF+hATnCNZpEBrhBXHe7FOsOaL8XbwX/BY8=;
        b=BFKbi1YrAeYpl+t1iKXI8Cq2SDa/8fQQN+sln1zoqQecefhxp5PbdMQ6Wk++ZOXSbu
         3yAxVUyTNrLge4HIMDalvlZjQKgKAY4f0ecbhxjTQlqa4Dt/ediUMBh45f4qUbAnl3la
         k6olg/M8Nz+R6yg0ON7uwxwp1EW6A6Yd7u9/h1X4N4HBy+lmrNgbUaRL93FMDpIz0cvL
         UDZ4xINrX+p2Gsk6t5B0fO1I9ucgxyeoxudxsEZ1Vcn/uCj0LzR//14xIMPE6L9F0i+h
         pk7J39vHl3GbUGXWjgWaKR/+BOkLpfNxt1pPOh4FTXPRNmpx3lOtlVNmxQzkxJLBB43z
         ypOw==
X-Gm-Message-State: AOJu0YyXsnLN1oNlCo0NUAJipLpSP1ocLxLEz6hdE9b6bp5bnQLnU4W3
	qpet9hmZVdbb9h63Dd474hsDrh2KzBH23QjpKh/pVEzLTBfsd0DhTFuK
X-Gm-Gg: AR+sD11op/FogPhVDrYzKFMWumv7jGBQwzL8Slg3tNwTall08kFdJHLU7S2oJxUfNvC
	2xYxX5V2dWkHPCd60b1Sf4GjUU6wamPE+4yenTxifpnuk/FFJTXfgTc+tULBqvxVLBh6zd89sB0
	hQY77AdH0CPSnwgyMJ5yx94rv2nlSTpCEoKmc32BLg9kqoi5gfrV499hdZRBtZfehDcoXdf/TmT
	KNiZ/BnbyxkYLnvY3lpP1+ZCqRbVsHF0Vlu4ev3E2D0KcWAzZK/ouTEtDinu/EB45a2odGTONsx
	qjvhI7IVdV7mbouvakVAaupn6p/LuSdpqQjWZdiWMgxfga4qo6AQoYm5ysB0Vjx5r4+MZbJ1CUp
	EM7/0zZ2uzR1jvqczT6cqdadU2XxztN+FfNAmtkCXaEckat/reWWHDRU1JPt8cFvooVHcJrKEJH
	mzN1rzQyt63b+latg6rufGX1U6eDzaF+W9q/VIN59PQp1CDqyLTXyyUjVeYOaJ/lQD8KcgIBv/p
	hUBL4+cgnFc2YLqy/8=
X-Received: by 2002:a17:90b:4f:b0:38e:ad9d:1161 with SMTP id 98e67ed59e1d1-3933b833613mr26020542a91.0.1786932904324;
        Sun, 16 Aug 2026 19:15:04 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d2b6efcsm321769a91.1.2026.08.16.19.15.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 19:15:03 -0700 (PDT)
Message-ID: <915be46d-de6f-4d61-80ce-2236c7208028@gmail.com>
Date: Mon, 17 Aug 2026 10:14:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 10/32] ext4: skip block allocation for holes in
 the data submission path
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-11-yi.zhang@huaweicloud.com>
 <20260814101554.428AA1F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814101554.428AA1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:15 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4_convert_unwritten_extents_atomic() silently aborts conversion if it encounters a hole, leading to data loss for the rest of the atomic write range.
> --
> 
> --- Patch [10]: [PATCH -next v5 10/32] ext4: skip block allocation for holes in the data submission path ---
> commit 741674f6128ebda7382e0529fd0b709e4ae876be
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: skip block allocation for holes in the data submission path
> 
> This commit updates ext4_map_blocks() to avoid allocating blocks for holes
> in the data submission path, returning 0 instead. To prevent data loss
> during extent conversion, ext4_convert_unwritten_extents() is modified
> to skip over unexpected holes and continue converting subsequent blocks.
> 
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 76038b6c36552..0d62d9312284e 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -5167,11 +5167,15 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
>>   				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
>>   				      EXT4_EX_NOCACHE);
>>   		if (ret <= 0) {
>> +			/*
>> +			 * If the ret is zero, an unexpected hole may cause
>> +			 * conversion to fail.  To avoid data loss during I/O
>> +			 * end conversion, skip the hole and continue
>> +			 * converting subsequent blocks.
>> +			 */
>>   			ext4_warning(inode->i_sb,
>>   				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
>>   				     inode->i_ino, map.m_lblk, map.m_len, ret);
>> -			if (unlikely(ret == 0))
>> -				ret = -EINVAL;
>>   		} else {
>>   			conv_blocks += map.m_len;
>>   		}
> 
> [Severity: High]
> Since ext4_map_blocks() will now return 0 for holes when
> EXT4_GET_BLOCKS_IO_SUBMIT is set, should
> ext4_convert_unwritten_extents_atomic() also be updated to handle holes?
> 
> In ext4_convert_unwritten_extents_atomic():
> 
> 	int flags = EXT4_GET_BLOCKS_IO_CONVERT_EXT | EXT4_EX_NOCACHE;
> ...
> 	while (ret >= 0 && ret < max_blocks) {
> 		map.m_lblk += ret;
> 		map.m_len = (max_blocks -= ret);
> 		ret = ext4_map_blocks(handle, inode, &map, flags);
> ...
> 		if (ret <= 0)
> 			break;
> 	}
> 
> It looks like if ext4_map_blocks() returns 0 for a hole, the loop will
> break early and the function will return 0. Will this leave the remaining
> blocks in the atomic write range unconverted and cause data loss?
> 

For atomic writes, if we hit an unexpected hole during conversion,
there's no point in continuing the loop since the data is already
torn. We should just return early.

Thanks,
Yi.

