Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B133E0C5A
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774448849; cv=none; b=hbykKQ/USCaQbs0VHxeMPRR9r7ha0fqjHRSqWB+Hd+JY8O9tyJiz2pDtdJRAan/X+vxs7t+Pxgnw6POPsWJ9hTVPsXDhF9ef/9BBT1rMZfsGEJpvSrVxoOfdID9zkNMiq6Uw9XxCJA0TwzFTS/H/OkFMePfp1CLIn7V+Wh7UhyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774448849; c=relaxed/simple;
	bh=DPgC4r4t9YgPeQc6G7vPdpzUoDB6zcmmHLwvynylhXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DKVsWcIbCv3KhLNkH8NoyNGPe/LbuPkftKDsDWmK99v9Fhlfm1HwlTqj0zIbg/rs50byf8AaNCrVyNRwBnznKrlB1ymm0CeLDyeKw8Es0BH34pW4hPnfybzqDjov7eGVcvEGcYVf8s7N128kC3kbFKvuGwl/z+gbZaTefD6Q67M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4m+R0JT; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4m+R0JT"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35c1a131946so25247a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 07:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774448845; x=1775053645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+HbLmM1zEuc8AHm8qtNLH+mQFIhDfBmY8SlHP2vRU+U=;
        b=i4m+R0JTVt7TRk93noS7bxsVxb7aWp/RNIBxXtf267iASQXYWEogiX58BzXf0TZNjG
         6MvIt9iQqzH0VwhxNX8LUYACP8AUDETjEd7nnR08QjA8sTpJx4Br3CJ+GYBqExiLFMOT
         NgyGuvCnu6Xm77ydpmmkx9htEyCULjx+WP44pst4kFcORl7s/U6TAOcMovcTGr3WuExp
         o21Xu1cZJsB3DLBvZi5lP6SjrNumibqh7zhY4VeOUh1uJzGsfCRWSVHeMxu3ylNSDdKt
         ZyM2QSfIBtT4b1rJkrSZ8WC02rMGEU+P31p3HMRBPGbX0me7F7ICBqLMWDhH/p6OG3g6
         1F/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774448845; x=1775053645;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+HbLmM1zEuc8AHm8qtNLH+mQFIhDfBmY8SlHP2vRU+U=;
        b=fLpxIu3My1QXJVpMDHBzCCybJZdFJqlBMVAPggtP2W27jRQUqWyumTYqF6+CQSV0+8
         Ii1L7sj/WCordrC/3Hf5ssz2HV5KnCVX+KT86u7siJnzcQQB5UP1O9pSnmDtzLRhtQ3S
         zvsayoX4U9wQ/LMQ3FGfvLLmFnFnWT9Gj/wbwsUH8ap63tkwOTbKQ5EHLnA/auk9gYic
         xDbyGvJasdxo8rpFcNftj2nQ05nhElKTJIC9yRxPE5hbJspsWN5kmYPbHyT+6cCPi702
         xqVSz4+KddoliFKYjkeyJaLLblK/8Sp1PI9hXwDVEqH0wOOeSV+uaUba1IVgVbkCZCOU
         4O1A==
X-Forwarded-Encrypted: i=1; AJvYcCUQXczHLCumUIB1RLRaKm2RlGoqSZVdLuVhW8khGnTQpyOii5Gji8BkpMuQlon5JI0yf8E/9IeGsYYk@vger.kernel.org
X-Gm-Message-State: AOJu0YyU2g/6zMEgeVcYC5WXDKEHH2BlksuTUgrH44Pme2B4jGMdDOkH
	3ugBWVU70Xb9VbGpBwg37Dl40xV+g1pissEEbqtTtnbyzN0PmFxbJHta
X-Gm-Gg: ATEYQzz/9XBPt+lZ9odaoXuslPyRKL0jIsDX9CtUx5Z8WpEwWbpLyQrObpcoQ2QCNny
	nn8AdOFecAhDcpOEQlq3yYd08uP2068kOfQtDhCuZsWxOLj0zlojZTNYSlHcV8nul6JQu2aZLrH
	KTR/EEUIPcDELLoFJqhRnn1/I6BrRqjn5t5OlBoCZ3wiAy8sSWjAi/twfqJtjhqHwrUT96nVnib
	o7E16z49cxtMWb+AK0KOUlvedlTX+/OoySuGpDN9q4TB7OUghZIB9mdfwPQg5nbjkweWQ1v28SE
	9i9mHVc9FZpCVHsHmCCiwWiETsVlt0Xe7HfwZrwj7CO8q7leDDk/ro5lHJzb3yhK6TvDcu43t7H
	OjBAVAYAx+qLKZuOorbMRbfaVzrY7otWBXffcplBPXmNACiXDKtaD+yFpsgTtVLg7pr5hAvyopg
	Il+2b2jq7D/CedkbRUxZjdHVZGXQ8ubJpJVZtRUi2/EQ8TAjXK2CfcyUINb9swPfp+l6mngC0=
X-Received: by 2002:a17:90b:57e3:b0:34a:be93:72ee with SMTP id 98e67ed59e1d1-35c0d1451d7mr3028367a91.8.1774448845550;
        Wed, 25 Mar 2026 07:27:25 -0700 (PDT)
Received: from ?IPV6:240e:390:a8f:6471:c002:22f6:23a0:e7b? ([240e:390:a8f:6471:c002:22f6:23a0:e7b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0ea59e43sm895702a91.11.2026.03.25.07.27.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 07:27:25 -0700 (PDT)
Message-ID: <e5c657e6-ffbd-4327-adaf-ae52cb50b96d@gmail.com>
Date: Wed, 25 Mar 2026 22:27:13 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] ext4: fail fast on repeated metadata reads after IO
 failure
To: Diangang Li <lidiangang@bytedance.com>, Andreas Dilger
 <adilger@dilger.ca>, Diangang Li <diangangli@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, changfengnan@bytedance.com
References: <20260325093349.630193-1-diangangli@gmail.com>
 <20260325093349.630193-2-diangangli@gmail.com>
 <B53E253C-F314-4376-BD9D-58867FC8D3F6@dilger.ca>
 <c6f4b982-c6e4-4f77-a16d-0c381c1e25f0@bytedance.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <c6f4b982-c6e4-4f77-a16d-0c381c1e25f0@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Diangang,

On 3/25/2026 7:13 PM, Diangang Li wrote:
> Hi Andreas,
> 
> BH_Read_EIO is cleared on successful read or write.

I think what Andreas means is, since you modified the ext4_read_bh() 
interface, if the bh to be read already has the Read_EIO flag set, then 
subsequent read operations through this interface will directly return 
failure without issuing a read I/O. At the same time, because its state 
is also not uptodate, for an existing block, a write request will not be 
issued either. How can we clear this Read_EIO flag? IIRC, relying solely 
on ext4_read_bh_nowait() doesn't seem sufficient to achieve this.

Thanks,
Yi.

> 
> In practice bad blocks are typically repaired/remapped on write, so we
> expect recovery after a successful rewrite. If the block is never
> rewritten, repeatedly issuing the same failing read does not help.
> 
> We clear the flag on successful reads so the buffer can recover
> immediately if the error was transient. Since read-ahead reads are not
> blocked, a later successful read-ahead will clear the flag and allow
> subsequent synchronous readers to proceed normally.
> 
> Best,
> Diangang
> 
> On 3/25/26 6:15 PM, Andreas Dilger wrote:
>> On Mar 25, 2026, at 03:33, Diangang Li <diangangli@gmail.com> wrote:
>>>
>>> From: Diangang Li <lidiangang@bytedance.com>
>>>
>>> ext4 metadata reads serialize on BH_Lock (lock_buffer). If the read fails,
>>> the buffer remains !Uptodate. With concurrent callers, each waiter can
>>> retry the same failing read after the previous holder drops BH_Lock. This
>>> amplifies device retry latency and may trigger hung tasks.
>>>
>>> In the normal read path the block driver already performs its own retries.
>>> Once the retries keep failing, re-submitting the same metadata read from
>>> the filesystem just amplifies the latency by serializing waiters on
>>> BH_Lock.
>>>
>>> Remember read failures on buffer_head and fail fast for ext4 metadata reads
>>> once a buffer has already failed to read. Clear the flag on successful
>>> read/write completion so the buffer can recover. ext4 read-ahead uses
>>> ext4_read_bh_nowait(), so it does not set the failure flag and remains
>>> best-effort.
>>
>> Not that the patch is bad, but if the BH_Read_EIO flag is set on a buffer
>> and it prevents other tasks from reading that block again, how would the
>> buffer ever become Uptodate to clear the flag?  There isn't enough state
>> in a 1-bit flag to have any kind of expiry and later retry.
>>
>> Cheers, Andreas
> 

