Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8CF433E79
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 14:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783003920; cv=none; b=PUS8zkZdjeIi3L5MUf2icLQ1wRWmFii/9BoWYLpKmAj36o2XQmWdS77tuvAqTBEEj+/cbZuia9hqKALZjuQSRPUm55+wg50Odm6aQZCQ0vbZ00GMnoLOuWlKUD5eidlpEKjx5WgQVOleNvmf3M1BRv8EKnGJZoTDgLEvLLHkU/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783003920; c=relaxed/simple;
	bh=NzdDlTDtaGZcoAJ9/MP8h4qe1GlpMNLTmaatim477dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GC2fmcMOtsHGPKmXwSe5Pwa2gcKymaSbYrDYIzcJba6wxRqErXtYPCYLPkFnEVpV/4Yrph81b2vndudLvMdM59hviYQui/mri0UHdEMVRLDMoHnhUi/phxXyjWmDHDHlS7J5lWnHU+S2FmuyH3JC23DbQkLy+L+2TGrKEWeXUx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gXscY5Ja; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gXscY5Ja"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c9b42be8feso19942845ad.2
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 07:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783003918; x=1783608718; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ryZRiX8UMkJ03DIEk3V2Skg/TXE/FZOpB+Y8RQGEeeU=;
        b=gXscY5Ja7coF3tcTzz7cb7W/KUI+032/WloJ2+QNMo6SPruLIukqyfY3dnUVyKmrDd
         V7n6jC/z483kuDxfW7au2aiLuZ1U67amxmY0ltk4uRlmlTLVuVv9lyr066GjM5ym4hyK
         bRkfpUElJQYDshqS4+M0UFfUyAB0TYGMTB/BW7EC5MBRsM4fsuDSwaG0Vhzcxkjm5PIn
         SLohuhDL/X0hRI6vfNpgPXb/FLLXoLL3rfC6LVJZ1jgd9D6kYNScV6b8YP+4ppEvRpc2
         Gz4y5aAUf+qr4gfoKnIh6FtaYzz/aM5jKDJMHRrgKeDcwlmDaiEQXZmECDqJ0gudoKSm
         nezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783003918; x=1783608718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ryZRiX8UMkJ03DIEk3V2Skg/TXE/FZOpB+Y8RQGEeeU=;
        b=CAtT8ZJci9vOfwYPhUU1ZIE28zTkUsRa1jM0DWjiS02W6AuuD6/nn6uwpAb08aTmmt
         WIQESOeK+5zzKZ4zSYts/MOzv78UB8ay3tfpjZZ1z2CkhvG1IZr2ZWTsaWqccNdvHh2D
         d5qGjTkFryAzSo0MV5tVnp0TSM8QIZyUwtlXI0DHMC5KzUcGW9Al1Ntq7/2m3paQVHUG
         etTAMrZJy36l34uiM+I3jGHpEQE02jab+/YVuGNqY4jiATXHqa0EzfS0nkdC0gYINl4J
         u3a70xfyYebvWjBouPD8EmG4Bor40Y/nS+gPMildVCs82FmO2xTIeBcb99D5ZqXvxa3u
         pY+w==
X-Gm-Message-State: AOJu0YzhJW2Qe4DntcwRq/rw/XsnRY3nH4DaxpJ09/byoNABm8lBTJuC
	/GpQSZlDFYk307hP9zTly8FUyjqa3JSWdvkkUSIo+0lSc/kFrwUF1yen
X-Gm-Gg: AfdE7cmJHuHbmGrOpXYXbqIy6sa2KJOh98+D92HwO/toowIKbkEBq1uqr0Qibmi1Nr/
	Nev1s7gYyW+9LhTKXh+B3DpuO2XWTDz0QUTPGd1C01b3c5m+TH0n6WWpwKZVyVruRBhQnNxPbVK
	f0lPcEaJHg5iwlxA70WolCeOM8L82Vy7u3BDgWf9K1WvJtAlsUDoTYhlid4vUY5d1vdjKkYoIX9
	6zOAWWRWPTegpfSNVqzgGTjteGrqSu7c+3ePY5Gokfj7SPCIUNHbsfgfLvcyllyFdTwaHQD9Zr+
	1pd2z+02G/VBK7zwr/mdoABs96+vbfj7LEro1Md+Jc95bJzj+4BrkSRkBvKC8xAlBWxoHZRYR0T
	PD6Ng+rRJLNRuBO7OBfh3vo+tFUZCajnBegJwI0csAsDjnBYdvDCCJdotq5y3MYMd2XF/ncuwZR
	r99LxHQxVpHiHDQvpIMl/lo0GUiUROqtJ2ujyV2sbqgMnfxqTMwXJLIqNunsdQ
X-Received: by 2002:a17:903:4b27:b0:2c9:fee9:543c with SMTP id d9443c01a7336-2ca7e75cee2mr67290825ad.30.1783003918144;
        Thu, 02 Jul 2026 07:51:58 -0700 (PDT)
Received: from ?IPV6:240e:390:e4a:af91:e858:9955:9be:dcd0? ([240e:390:e4a:af91:e858:9955:9be:dcd0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca9a9cd35esm14519065ad.41.2026.07.02.07.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 07:51:57 -0700 (PDT)
Message-ID: <b6d2b697-07e6-4ea7-b8d2-85491a0e63df@gmail.com>
Date: Thu, 2 Jul 2026 22:51:52 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] ext4: skip ext4_update_disksize_before_punch() in
 WRITE_ZEROES
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com,
 yangerkun@huawei.com
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-7-yizhang089@gmail.com>
 <3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <3f6ao5amv7glbgigndtegcucgo3n34ij3lau6l3da3hgdxgn3v@ev66wv3r5umt>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/2026 6:19 PM, Jan Kara wrote:
> On Wed 01-07-26 22:20:09, yizhang089@gmail.com wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> FALLOC_FL_WRITE_ZEROES is mutually exclusive with FALLOC_FL_KEEP_SIZE.
>> In ext4_zero_range(), when end > i_disksize, new_size is always set to
>> end for WRITE_ZEROES, so the i_disksize update should not be lost.
>>
>> The ext4_update_disksize_before_punch() call is only needed for the
>> ZERO_RANGE path in ext4_zero_range(), as it handles the case where
>> KEEP_SIZE may preserve the original disk size. Skip it for WRITE_ZEROES
>> to avoid unnecessary work and potential confusion.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Hum, but suppose i_disksize is before the start of our zeroed range, i_size
> is beyond the end of the zeroed range. Now
> ext4_alloc_file_blocks(EXT4_GET_BLOCKS_CREATE_ZERO) will create some zeroed
> written extents beyond i_disksize and if we crash before
> ext4_update_inode_size() runs, we have inconsistent filesystem with
> written extents beyond i_disksize... Hum, actually that could have been the
> case even before, just now there are more cases where this can happen. So I
> think FALLOC_FL_WRITE_ZEROES mode needs to add the inode to the orphan list
> to truncate the inode properly in case of crash.
> 
> 								Honza

Yes, indeed. I overlooked this case previously. I will address it in the
next version.

Thanks,
Yi.

> 
>> ---
>>   fs/ext4/extents.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index c083703bf704..38753c2ef910 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4748,9 +4748,11 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>>   			return ret;
>>   	}
>>   
>> -	ret = ext4_update_disksize_before_punch(inode, offset, len);
>> -	if (ret)
>> -		return ret;
>> +	if (mode & FALLOC_FL_ZERO_RANGE) {
>> +		ret = ext4_update_disksize_before_punch(inode, offset, len);
>> +		if (ret)
>> +			return ret;
>> +	}
>>   
>>   	/* Now release the pages and zero block aligned part of pages */
>>   	ret = ext4_truncate_page_cache_block_range(inode, offset, end);
>> -- 
>> 2.53.0
>>

