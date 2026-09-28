Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630DD4B95B0
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597423; cv=none; b=AE7eX/DZnzzNHo0wkRxRbPcuKDpJvqRZsxIJVADrlgf8Va5Vufgp0Z23rKqLM+lwR8EMMtsRxoqsArFRVl5/VxYx8YHyhAvqJl+RCHD24P3MDMQURva8yZN3Dmo7tZjJKPhhCEULl0Ywy78OoFgAQah8acnlSyb56cRH2h5UWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597423; c=relaxed/simple;
	bh=dRu7Kn49A03hqpkganvlzxpNEYuOOLrk6BWNQL5j5yg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9qMvmYf/Wf6z5n1IdPAer+biHEtuQqKc/J5pPiUeTP7GPHD8vTXesHhMGLVSeLdgD+p5ZIsAWKnjWdwSWGmijZRW4lKmwzcOYOSiLDbmgzwZipdGfvcg3TGGg+1vqMrIjVXj4daONzN/TPEiluz1kaQ3BpNE4wiWH4lEz1EBdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jyCQClIo; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jyCQClIo"
Received: by mail-pz2-f39.google.com with SMTP id d2e1a72fcca58-8807e5b8fa9so1654374b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 05:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790597422; x=1791202222; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N2gttpqyYU6mN3+vG6WWAdW+b+2S6eD72/pblRbqkM0=;
        b=jyCQClIo3AElUAT17p/0KgHrvYT2Om0M9F60+rFRfvS5uy6jckKuetSU+twm+bXrt6
         8uyyghCQptypfw/PRpca5BDL/I3OhN/7kOAZWtFcZ8HjRtSXHyv/YapZo+Jv38+duMxm
         6s8sCXXqPLJINgxS+Q3H/tz4FRu8Kf5WFksl3Z8P6QFgXdKj0M37QfovK3Auco/jOjMb
         WuSK45TTsnPrRP4EucIhnoLvc+czM6Wia1Eq/QPsv7suTKCvuEZWgeEGU3bfJFeSXySD
         C0f4OoEry1feLkS8kGu+uADBnWPx4mmfWbP7oyQv2qX1sZnvTLFYdkKXMsHqhHXRR1vY
         2Ijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790597422; x=1791202222;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N2gttpqyYU6mN3+vG6WWAdW+b+2S6eD72/pblRbqkM0=;
        b=KrGJHv+LKJPytjx2Qg17y7RIExHoHH7YUBZHoFvOtx3Pxmo2QKZSTy6QIKgOfbyKBh
         rhlFxwyL1We0Vnh3Djsq63MDqvwM64AY6c59WthLpkkRCBhj1vOTkWkj949ptnIUBGBP
         IRyyz8mw/qqOaerSWkt3y9nkiPe/l6P276Gxg3li6oYNCJU1jBR1ta1sfId108XUjjQ0
         wuv839RnDsMx57nKuOCquBc1J5DCRzosYEw6xTDYGU8QzRHlGPSXj/lqWuzRMlgGLD8F
         wSvmORRutuMU6paYMPFhkz/6QJuXxkMe9LKQCUajDx9Agp9Zr3aAjkbHALEW8fz29rwV
         HT2Q==
X-Gm-Message-State: AFuF++kK1hTLeA/hw3nUkOFB8WWz0z7Owr1WdfxVv7Uhr3tQHRqkFeUd
	X1A8uN3AL6bwHYzyd7ch9mj94A9ucstobB7kI6LcL8GO9KqQbkTXEayY
X-Gm-Gg: AYBFou28ugUah9HIiujdg2VZbFRs7RPh0C3/4tUh5X5c5PXZ2LukL25e9z76hTYyBn/
	AzP5TSqaAeWVgav/YtJHzK4wsL+L1kUjONuHwebp4/EAQ4lglbRCvTRBic8KRLg53vLEZrgcMVo
	mcu6ysrVUwvKVf+6xdTf3EseluBo1ITWPH8VvVXRyZLW+TQkdguJhGe369PYN9bZebEKWhjQbKV
	pV0TriyY47rimRbedaqLBdufRu9EtrJ2v+XH2t7tNWHMrOc61ljFG5EZfORXdrt9dB5giVuuj3r
	jnWa1jWK0T5outBoO+SjsVf+QorlfEa8yraPtwVkz19V69CqMxhPClUy9+qvPgoJgpkKBbPwnTA
	QOs2irallC6iH1PhVT8jHP3va3mW1lPPP59y8wXRgXGao0D0Y6WlECoRvPfxAsBxR0+JsGgly1l
	KdG/wxbOwLJPCyHyA6mEs5376iwE7HcZ7J34+WiwaTIvEiSkJCX6YRK+UMd5yJUbzMu7VfS7gro
	0In+us8358wesIQszV+62azRqXn8Q==
X-Received: by 2002:a05:6a20:2d2a:b0:3dd:a196:69df with SMTP id adf61e73a8af0-3de26f28bffmr7894235637.58.1790597421493;
        Mon, 28 Sep 2026 05:10:21 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feaf85551sm4001370b3a.40.2026.09.28.05.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 05:10:21 -0700 (PDT)
Message-ID: <e3b38169-dc4a-4a42-8a42-b017ecff73d4@gmail.com>
Date: Mon, 28 Sep 2026 20:10:06 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/31] ext4: skip block allocation for holes in the
 data submission path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-10-yi.zhang@huaweicloud.com>
 <arpDP43MIAGjaWYx@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <arpDP43MIAGjaWYx@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/2026 6:36 PM, Ojaswin Mujoo wrote:
> On Thu, Sep 03, 2026 at 08:35:21PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> When ext4_map_blocks() is called from the data submission path and I/O
>> end extent conversion path (EXT4_GET_BLOCKS_IO_SUBMIT), it should not
>> allocate blocks if the lookup returns a hole.
>>
>> The writeback path can legitimately encounter dirty ranges that map to
>> holes. For example, when a folio straddles i_size and the tail beyond
>> i_size is dirtied via a mmap write. Allocating blocks for such ranges is
>> wrong because there is no data to write back, the dirty bits should
>> simply be discarded without submitting I/O. This prepares for the
>> buffered iomap writeback conversion, mirrors the existing buffer_head
>> writeback path, where mpage_add_bh_to_extent() skip unmapped buffers and
>> ext4_bio_write_folio() clears their dirty bits.
> 
> Looks good, checking the iomap vs bh head logic. If we consider
> a 1k bs FS with 4k page size, with hte following ops:
> 
>    ftruncate(fd, 0);
>    pwrite(fd, buf, 1024, 0);
>    map = mmap(NULL, 1024, PROT_WRITE, MAP_SHARED, fd, 0);
>    map[0] = 'a';  ---->  mkwrite allocates 1 block and dirties the whole
>                          page
>    ftruncate(fd, 10000);
> 
> Here both non-iomap path (ext4) and iomap path (xfs) will allocate a
> single block but both will mark the whole page range dirty in bh/ifs.
> 
> In both iomap and ext4, while writeback, we skip bhs which are holes,
> and we clear dirty on them as well.. The only difference is that in
> iomap xfs_map_blocks() shall detect a hole and inform about the hole but
> in ext4, we filter holes out before the map block call.

Yeah. In the writeback path, almost all of the work is done by a single
call to ext4_map_blocks() now. This makes the writeback code look very
simple and clear. :)

> 
> So with this change we will be closer to iomap's behavior. Looks good
> althought it's unfortunate that IO_SUBMIT has yet another implicit
> behavior added to it's scope :)
> 
> Feel free to add:
> 
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
>>
>> In the ioend extent conversion path, holes are also not expected because
>> we should wait for folio writeback before punching hole. If one is
>> encountered, it likely indicates a failure in the concurrency
>> protection, so ext4_map_blocks() returns zero, and we keep warning and
>> bail out with -EINVAL to surface the failure rather than continuing
>> conversion on torn data. Atomic writes in
>> ext4_convert_unwritten_extents_atomic() already bail out similarly.
> 
> Ahh that's right we do bail out but we don't seem to be returning an
> error in the atomic write path. I think ideally that would be the right
> thing to do. I'll fix it, thanks!

Indeed, thanks for fixing this.

Yi.

> 
> Regards,
> ojaswin
> 
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>   fs/ext4/inode.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 7a5c74af8ff3..2881596bff8b 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -825,6 +825,13 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   			map->m_flags |= EXT4_MAP_MAPPED;
>>   			goto out_handle;
>>   		}
>> +	} else if (retval == 0) {
>> +		/*
>> +		 * Do not allocate blocks for holes in the context of
>> +		 * data submission path.
>> +		 */
>> +		if (!map->m_flags && (flags & EXT4_GET_BLOCKS_IO_SUBMIT))
>> +			goto out_handle;
>>   	}
>>   
>>   	if (!handle) {
>> -- 
>> 2.52.0
>>

