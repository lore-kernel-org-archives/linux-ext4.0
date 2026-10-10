Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFA73655C4
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 03:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791603406; cv=none; b=DtWI84+QS3jq8vtnRKRLMCupEiC9b50TXJ4o/7URNLsuzOLaK9ZxcKvduEkzTq6NhcbTFKAmgb+AUsjR1DvV2ewCwR+OtE4VvNWiaNpaD6MVJSnAYgd7ilMu/gQPsHzN0XfDByFyKTn9Ki0lsiYtKa1yOWs73Omwl725mnZcVEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791603406; c=relaxed/simple;
	bh=vrmn4nG402Wh3eHdFr2XcFsAZ4yPsZBXLalOOYJaJEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UHQv/kpjhNPv/QN2t96oW6IS8cYeq3zK2XIlk1f2QEgnJnywShwfagsJhUviSPQljVrT7dgpblx06Eoni4Lb/J5PxBObLKhIl/qbxPww8lnhwAGDyAKrhKiaicO4YH2StRUMXtBVLc5d8kzy/qfyRcH61BEWUGIMIt79OiE+idc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XB3V9tFc; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XB3V9tFc"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so113613a91.1
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 20:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791603402; x=1792208202; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O6kHV2F6sry3hV9XtseqLh6TDAjuJvKbQ4qmJDdtGtk=;
        b=XB3V9tFcjfhuguL1LhjMTgyuHk5bQ5g0HCRXofDqV31YlORluighMQqSM0TRlcwzIa
         dVeh5OitCeoEm9TOJFqzwF+mgrSHmcD6BLPbI15axhN1P4HVsdFSKYPymLW52PhKB8/y
         npiDK8j+J9iHY9GQR0xZCGzsKmYa3wIkRY4DJ2DKY5ZFMV6KLtj13HKBlQOvyRBT3+QI
         FMbC9CeiAku3Q+MJQQr9z1brrd3jIMuDMIJX1upcsr0uvtBYWKsPdoL4tlWixAHkoYAD
         DcFlWZl8G+pFLMnljbPLy3Usk9eli1wZftMac7+QL1n9gkFNFv6blrhpxjMcNsjYcfNU
         7iVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791603402; x=1792208202;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O6kHV2F6sry3hV9XtseqLh6TDAjuJvKbQ4qmJDdtGtk=;
        b=V+jdZAlNbZhHKziMBXxGRzdNDypetdCq9hUChpjlmPPrzhEN4/K2Vt9KYobGkm3LDx
         BdCBMgwH7hWZxYdrnmNK/ccOysRuOXAX9LgMlw8bbzZKnFENhLiuq0pUGKDE2P4Z/Z+i
         4Bi1hVOK6lbiYcsfQGipQL88NgT7OCXzXOp5CMOPJRfcvGYf5EtskE8xwAMxvY2C7HOl
         YitNFPXgw+a1unDfW+E5xqulI1VaH50ydwL5a1Cv9lLs8sTBrZLDUFA2bfakStNtlqMO
         4xA9vrUn7WBgKo42MTvhqidGxxzyXTbOwLlgIg1zhMw0OYDHxrUBiuHxq+ls1WwMqJIC
         0fpQ==
X-Gm-Message-State: AFq9FYKuxJ/TJPsWeNR19gl0W1We8IF/w4s/e8yX0kDl7z48vlSJPlqY
	98A0bQkkQ8kYmY5ZMNsmAUV96hhyQOpcVLcn7qhHQt3gOlaYEVV88DGN
X-Gm-Gg: AYBFou069TB/6h0q0CiHmq2IRD5f7yw4VHsBumnJQRnNSlOB3bbdyPWZNIFHJvZgroi
	zQPSxmYrCp+P0mlyjGwK6xxWB/y6r3V3UzeeVixBx1N6c25R6AjpjLCexH5fnQNLp2YuRVZuLFR
	rYr1oqFhUi3DKOz+RrA9KLj2WIaHlWnO/pvh85cqeHT3BIs6JuVQuAKs0cdZOhQBrw4svAFhWPe
	I6IPNAY5Qrqw0/fWi62Bb7T96fC+tA64D0LXM60WEgtRR4UUfMVYhtn4s+K2hLm4I+W7ZkrdaD9
	zQ5eF1VT1TpXM9YkJxCh8z+MNse/RScB5GkYGKd5f63PczfQc41sZ9Ss7M6SbhzEKfzYoIjTaLa
	WNTI8MJKe1iBBpscYZxqBvM175Ia+L86DyCSMxMMGA7djMJ1qS0NwUuYzDH7ayc8oGaodbZblpb
	DtcP9RqI32oXj9gPgHtFy4ppA7mi7S/TAN8+pFY6pevoYYqmktt8x1UKttFNRP8SC5Vy5zb/DMU
	UTWbEtHiE8PiSR+vQM=
X-Received: by 2002:a17:90b:1dc1:b0:39e:4c7f:7304 with SMTP id 98e67ed59e1d1-3ab3ac9f622mr2746875a91.27.1791603402360;
        Fri, 09 Oct 2026 20:36:42 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b1347sm19336765ad.44.2026.10.09.20.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 20:36:41 -0700 (PDT)
Message-ID: <2efbfcf1-b7af-4ae0-937e-9ae5eb2b4818@gmail.com>
Date: Sat, 10 Oct 2026 11:35:59 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/31] ext4: defer i_disksize update while
 DISKSIZE_GROW_PENDING is set
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-25-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165359@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165359@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:21 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ext4: torn reads of 64-bit i_disksize cause missed updates and data loss
> --

This is a pre-existing and long-standing issue, which can only be
triggered with a very small probability at the 32-bit file size
boundary. It won't be handled in this series.

Thanks,
Yi.

> 
> commit 9dbea84318a994dcee69fb96db7cef1b2100ff28
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set
> 
> This commit defers i_disksize updates while EXT4_STATE_DISKSIZE_GROW_PENDING
> is set to prevent exposing stale data on a crash. It introduces a fast-path
> check in ext4_update_inode_size() to avoid taking i_data_sem when no
> size update is needed.
> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 089dbd39c5c24..b26ce3183bacb 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
> [ ... ]
>> @@ -3605,30 +3605,67 @@ do {								\
> [ ... ]
>>   static inline int ext4_update_inode_size(struct inode *inode, loff_t newsize)
>>   {
>>   	int changed = 0;
>>   
>> +	if (newsize <= inode->i_size && newsize <= EXT4_I(inode)->i_disksize)
>> +		return 0;
>> +
> 
> [Severity: High]
> On 32-bit architectures, can reading the 64-bit EXT4_I(inode)->i_disksize
> locklessly here result in a torn read?
> 
> Because i_disksize can be concurrently updated by ioend workers under
> i_data_sem (for example, when crossing a 4GB boundary), a torn read could mix
> the high 32 bits of a new value with the low 32 bits of an old value,
> producing a falsely large value.
> 
> If a falsely large value is read, this new fast-path check could erroneously
> evaluate to true. This would cause the function to return 0 and skip acquiring
> i_data_sem to update i_disksize.
> 
> Could this leave i_disksize permanently short of newsize during operations
> like ext4_zero_range or non-delalloc buffered writes, potentially resulting
> in data loss if a system crash truncates the file to the smaller i_disksize?
> 
>> +	down_write(&EXT4_I(inode)->i_data_sem);
>>   	if (newsize > inode->i_size) {
>>   		i_size_write(inode, newsize);
>>   		changed = 1;
> 

