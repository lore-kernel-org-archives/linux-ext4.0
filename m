Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED33BC687
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2026 03:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791601521; cv=none; b=FGWbt52Vn9LGSoHjc5wU7yQQQaEBstSlWR6vPy7MvHzRRgHf/WsHUN0hXvZj+1+/NZh0DiZ1ZmZHTesUFq/u2+267dxQ2AuoG57Qv1DVMRBDoQ0s3xY2oJg/nX0y92B1lFT+23tKONUXu8qriqCAf4pjrDkZJufjUv7agWXcSuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791601521; c=relaxed/simple;
	bh=8cihdIgCaIFHEkgmVa83L+O1B6aYVDGqQ3rqAyOf8Lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hhAwfLtFSxq1iLOUaBbCuRD1e6yCgLZUi8sgJP1yieQ+1efpWiXOIfMT4UcxzNRyiCgRxHamFBZVzDBxnl8PVQ5noq7gVWZCN2Y73eRgqB6nfh9nz4f9W8RWeyk1u/xE9gRlO6NK1QIJWVuoxMkG6vzyDFyzOw2CtCh1B2bp+fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K7MzdFdl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K7MzdFdl"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e608cd460eso1573585ad.3
        for <linux-ext4@vger.kernel.org>; Fri, 09 Oct 2026 20:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791601519; x=1792206319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fmqPFeMYs9Z+NKDlaYJ+n319ZI2tWY2/NF2LRFyiqno=;
        b=K7MzdFdluQDKUr9coZCDg6LvDzSA3hcUD9Qoky/YmsuwOK5eOMhwcOe5JaAGs4u07Q
         z5yTtOt39dqis/MwVJ3VmrZqNgKbMMFN0O+Ob+u6Bl8Q3LKbDSAY0QWbd3Xsm8J1P95t
         QzA01pdTExndyEz8N/YxDMLizv31dd1RM8O2GSbcwoj46/TUDDlA6JRx4KsJTSD6T50d
         BZQUMZMvOKk+Lw20PdSXfDq59a1mgAQWEBR7339TeUsTx+ltzr9JYynbRQc4T5X9i65n
         GRavyIWPOL0rO/lfFhFEDp/a/iGSd1ygts3l5WznxRGeEoOgmLTze46G2IM5YLGuks5M
         ckig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791601519; x=1792206319;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fmqPFeMYs9Z+NKDlaYJ+n319ZI2tWY2/NF2LRFyiqno=;
        b=YHtQIUiQWrUbUGifhd/L2UO8XYq7x+3Z/DmSFjMmf11yBoPQ7b416+0axmFgDRj/Bp
         j9Jdr7acztWUx5BPpVZUok/GgB4SEGdT3W+hbXkDAm/uBHvKpMmkPSnEFrCnlr1Cpoo2
         MeFdb36cb51y/7dv0GAZSBxVb90NTd+oOEwZTo3GfMs9hfkg3x5uFT8u9eEh9LNb6JX0
         f1MRXnv11ET6B+TnWW+p3assay2+HyWkbT3XmNG180ypIWqUCtlwqk4FGtOGjQCB2+aB
         uU62BsYj4OUWD/+jyVl+JVhlyV5BklnZ/STnzxlUnIaEGYowfX11CmLC4fyNBohOSE/i
         L3cA==
X-Gm-Message-State: AFq9FYLMNwcKNPce3nVJ2D+tfptu+dOslHzHMm0XP+CaA4rcJzLgWU7Y
	lds5fO5jDNKhdotDlSCaHNiJITBjSRkEMXdRfgJ0bQpeL8VqQIRABaOr
X-Gm-Gg: AYBFou06eUO0SGcp3SP2lxAnU9URob3uExfuxoQLoJ/xwdvxAuRHJQBIeJiuJuZVypG
	6D0Y9EU1Sn4DKov1cuHzaVjP0UGUmlnCdBNASZoRCj6oMKhcYtRVoLH84vyy2swPHVUB6LeNJn9
	oJ6kUmO6wc4WEQ67H/akcvFNI0Q0j2+eMekZuTOFzhi7pzjdA02WimOKZSSQU+T9cwCDOiOT0vk
	AffsSNBCXsHb/fsd3Dcm6L7hzt3hbwbL7+Dj6/QR7Qy08CDRv1pycWtU3tpz3PytmVuAdHsacX5
	8t5SS6WZX4J+uYwHCViQFm+fRGA0PBd4SbmlZGxR4SvhkMsbQhCVHNvZbQXRYNLDfqF587m+LoA
	cdquO2MmtstUCXF9iGfYCR3hiwCc7SUM4hwQxueB6sMr9vmaS5Te17pzRNwhNr+WfR8H6r9wjVP
	brZVAewYd0MpVXdi2r3Xw79yKsLhXREzRtloV5SLEPd2e2liQE2Bk/SXS+esyWNSVuW824dnHuu
	397kE+Vq0yhz+VPjvIgXzhs+hZ6Jg==
X-Received: by 2002:a17:902:e884:b0:2e5:d2af:8aa0 with SMTP id d9443c01a7336-2e842ab6bbbmr31426325ad.42.1791601519287;
        Fri, 09 Oct 2026 20:05:19 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422b8cc1sm18315685ad.54.2026.10.09.20.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 20:05:18 -0700 (PDT)
Message-ID: <e1e56e82-9459-466b-ae15-0529ae3217fe@gmail.com>
Date: Sat, 10 Oct 2026 11:04:51 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/31] ext4: add block mapping tracepoints for iomap
 buffered I/O path
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20261009103033.2920530-1-yi.zhang@huaweicloud.com>
 <20261009103033.2920530-20-yi.zhang@huaweicloud.com>
 <sashiko-outbox-165305@kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <sashiko-outbox-165305@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 7:03 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] ext4: information leak of uninitialized map->m_pblk in trace_ext4_iomap_buffered_write_begin
> --
> 
> commit 63eb0e998a7a12aca902166168b720bc244eba71
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: add block mapping tracepoints for iomap buffered I/O path
> 
> This commit adds tracepoints for iomap buffered read, write, partial block
> zeroing, and writeback operations. This helps debug the iomap buffered I/O
> path.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 35767c3a7ffff..1c7083a9293e9 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> @@ -4052,6 +4054,8 @@ static int ext4_iomap_buffered_do_write_begin(struct inode *inode,
>>   	if (ret < 0)
>>   		return ret;
>>   
>> +	trace_ext4_iomap_buffered_write_begin(inode, &map, offset, length,
>> +					      flags);
> 
> [Severity: Medium]
> Could this tracepoint leak uninitialized stack memory?
> 
> In ext4_iomap_buffered_do_write_begin(), the local variable
> struct ext4_map_blocks map is declared on the stack without
> zero-initialization.
> 
> When ext4_iomap_map_blocks() is called with EXT4_GET_BLOCKS_DELALLOC_RESERVE
> (when delalloc is true), the mapping resolution routes to ext4_da_map_blocks().
> If this hits a cached delayed extent or inserts a new one, it returns 0
> without initializing map.m_pblk.
> 

This is real, it looks like we should also initialize map->m_pblk
to 0 in ext4_da_map_blocks().

Thanks,
Yi.

>>   	ext4_set_iomap(inode, iomap, &map, offset, length, flags);
>>   	return 0;
>>   }
> 
>> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
>> index 7028a28316fa3..bcf80f518e61d 100644
>> --- a/include/trace/events/ext4.h
>> +++ b/include/trace/events/ext4.h
> [ ... ]
>> +	TP_fast_assign(
>> +		__entry->dev		= inode->i_sb->s_dev;
>> +		__entry->ino		= inode->i_ino;
>> +		__entry->m_lblk		= map->m_lblk;
>> +		__entry->pblk		= map->m_pblk;
> 
> [Severity: Medium]
> Does this assignment unconditionally copy the potentially uninitialized
> map->m_pblk to the trace ring buffer?
> 
> Since ext4_fsblk_t is 8 bytes, this would leak 8 bytes of uninitialized
> kernel stack memory into the trace buffer on delayed allocation paths,
> which is accessible to users with tracing privileges.
> 

