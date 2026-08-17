Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C33D349F
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978049; cv=none; b=c90Tw3T61WFXmnaOTNKTWeYZMy1U4MnDXzDlNoX45IPqrph0TrCN+Ljr1WXhqV5Rk+a5z+X52AEnAKkLoeFwE5eDEcvZ3HxdX8oEsXyQcV0cTADevfcEKfQOvywP7MQU+gH6Mfeoc9dFSYNHoiapXM74jip2WFI3K4bS0jIKnHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978049; c=relaxed/simple;
	bh=VjRBWIZ7jCjzGwCy3qWaHGfSyVkw9yLe6o95oB78wvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfpjTjT6noxNBbBA8PjEWWqUyD45ty4HmHigP60YIIu3co9uUZoYv04hn8PWAh2N3M5zOK3uGr5cLznie2ha+pgdZC+xpLoizBKnCCDmcSoqwStdMCtcr8lKzEzZ1f7NaRGkXZzlxoJnPePehAoQCyIfM4mlHsRPSV1LS8pg7m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GnZ9O2qq; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GnZ9O2qq"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ccf2360620so34084345ad.3
        for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 07:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786978047; x=1787582847; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aRO8UGMW+tNmWJMMz7cDo17X2CmKWu2MLoaJw7nqMk0=;
        b=GnZ9O2qqpE30ZHF10Nn+n1T7bOMajF2fcAb7V60pXq8LDM6lilUvJEdih41Clm83nQ
         ZsTJ+JKgh8j2F82cP/YfXUnsgNif2uT6S/C9EkXExaQygIW3A3tVi6E98Uy+ytP0nrTp
         8qaIyozdG3rgln8yk1cZxz24XsqHhkNL23f9zl6rlpna/su+46CulwPQ6lu8OBMuxqQO
         CUJmliHT/nOlkzIWZwhlhHvEKegCcMDWBX8h4TDyIKkfxzt082GdUoliSAOpLbrbYBt3
         pEYt1fe/NqcP/DxLurVNIkyMLwtMLB143IvSSrVRXPXmlfXEAjE7vxYGXF1DlJweDQjS
         94Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786978047; x=1787582847;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aRO8UGMW+tNmWJMMz7cDo17X2CmKWu2MLoaJw7nqMk0=;
        b=cqqhCnGud5RYnEM+QKTQnfIxQQDG4CCRPUCRnm97q/3aYkNYJMHr7kHhpethhe1X+c
         6EfzRpuaoVlC6cymmK8XTndfyPb2Fnc5iYttFnNz98epQqouiZQtlQGK5OwZeyRKRk5C
         5gsKiF1LVzouTJS24bsuPJsK11ODNK/54gl5FKjX42pR0w3ZVEgOzfeZZRAXPcy+zk/E
         M92NYiNdnyUQr9coNZ+4RiWVwUnI04vOFTY6TNvHPxTbuBNY9WiVCpXrr6SNjouiTHix
         bAU4kKu5xCXE9l/cj/uXVcAI6IGnJfqffwS9H0lUDAZytvbDXTVe9aTr3xy7DkQDXuXX
         w+IQ==
X-Gm-Message-State: AOJu0Yw2X7zkL3QxcVSfi9KovWAsYFhLz8NLrNjg/JeXoFF69jELyDtQ
	r78j14NicgYHv8+IxbcZG98Ta7EJK9CcNMTkdByl1juWlbe6KmGEvPEcFy/Ms3VVtHQ=
X-Gm-Gg: AR+sD13CyS/Iw/j+8BxFjEviat+3KMj1NhrArn7RLvsxVMoqc7+TcOfLwYhFQq19qO7
	gHoIOiQgN+Shewb6Cmz0IQuD6Lg6HEe/3Il1xaOIVDAoRj7AtcNZPU0/EZ9dNphXX6W7MO1HoiY
	HT9nnbxXxts0roKUPaxCoa+9JjOIKg2NKtlx9Zt+xGgpfvkkMUD7VYaNOxezbiMdmwSVtjkp2C0
	GK75j4FSy+vobtxvrdyp7ULkIIJDfKcExWL6bVJmMIroT5FzSJm5wmcM98rctcngoWco0SUhgUA
	yokwgbYi8OVvgaoRlkj2wq0gif0JSpDWQzoND0j9xfzf41/7yknFbkTbo2kUVv8lam7Bvdrcd14
	TClbJr48+s8/5vpji4HbPa2L2Tw7qhwLC6tLa0R/zEadHHa4fgcE4ug4b5twz4Q+EuZzBH6uSXr
	0wpN8ITTW5rNdHbpAAJlSZOHKKbXgSJ2hARhDFuq06zExhvRkJd80W0eA6aPDImivYJ/Kk66n+E
	e/o+xqM
X-Received: by 2002:a17:903:37c4:b0:2d2:da8e:9017 with SMTP id d9443c01a7336-2d3b0c5437dmr278133935ad.8.1786978047185;
        Mon, 17 Aug 2026 07:47:27 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e91356sm4055195ad.59.2026.08.17.07.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 07:47:26 -0700 (PDT)
Message-ID: <333dc30d-a348-4164-aa5d-e96b6e3ffe1e@gmail.com>
Date: Mon, 17 Aug 2026 22:47:19 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 19/32] ext4: tolerate unexpected holes in
 ext4_convert_unwritten_extents()
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-20-yi.zhang@huaweicloud.com>
 <20260814100917.CB2301F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814100917.CB2301F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:09 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] The patch masks a severe physical block Use-After-Free that causes silent data corruption by suppressing the warning when IO completion observes a hole.
> --
> 
> --- Patch [19]: [PATCH -next v5 19/32] ext4: tolerate unexpected holes in ext4_convert_unwritten_extents() ---
> commit 024b041d5cfa7f6f30a260ff0a2a3cd17336e881
> Author: Zhang Yi <yi.zhang@huawei.com>
> Subject: ext4: tolerate unexpected holes in ext4_convert_unwritten_extents()
> 
> This patch suppresses the warning in ext4_convert_unwritten_extents() when
> ext4_map_blocks() returns 0 (indicating a hole). It aims to handle the case
> where a punch hole operation races with writeback when folio sizes are larger
> than the block size.
> 
> Link: https://lore.kernel.org/linux-ext4/a638a8fb-c184-4069-ae33-379ec12cd514@huaweicloud.com/
> 
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
> 
> [ ... ]
> 
>> @@ -5166,19 +5166,21 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
>>   		ret = ext4_map_blocks(handle, inode, &map,
>>   				      EXT4_GET_BLOCKS_IO_CONVERT_EXT |
>>   				      EXT4_EX_NOCACHE);
>> -		if (ret <= 0) {
>> -			/*
>> -			 * If the ret is zero, an unexpected hole may cause
>> -			 * conversion to fail.  To avoid data loss during I/O
>> -			 * end conversion, skip the hole and continue
>> -			 * converting subsequent blocks.
>> -			 */
>> +		/*
>> +		 * A return value of zero means an unexpected hole was found.
>> +		 * This can happen when writeback races with a concurrent
>> +		 * punch hole in the iomap path. Because iomap may not create
>> +		 * ifs for folios larger than block size, the dirty bit can
>> +		 * be set again after punching. If writeback happens between
>> +		 * partial folio invalidation and extent removal, a hole is
>> +		 * observed at I/O completion.
>> +		 */
>> +		if (ret < 0)
>>   			ext4_warning(inode->i_sb,
>>   				     "inode #%llu: block %u: len %u: ext4_map_blocks returned %d",
>>   				     inode->i_ino, map.m_lblk, map.m_len, ret);
>> -		} else {
>> +		else if (ret > 0)
>>   			conv_blocks += map.m_len;
> 
> [Severity: Critical]
> Does masking the ret == 0 case here hide a physical block use-after-free?
> 
> If background writeback via ext4_iomap_writepages() submits a write bio for
> the dirty folio, and a concurrent ext4_punch_hole() removes the extent, the
> physical blocks are freed.
> 
> Since JBD2 does not wait for this in-flight bio during transaction commit
> (due to data=ordered mode being disabled for iomap inodes), those blocks
> return to the free pool and can be reallocated to another file.
> 
> When the in-flight write bio finally completes, will it silently overwrite
> the newly reallocated blocks and cause data corruption?
> 
> Instead of silencing the warning during IO completion in
> ext4_convert_unwritten_extents(), could the underlying race be prevented by
> ensuring sub-folio dirty state is properly tracked so that punched blocks
> are not submitted for writeback in the first place?
> 

Yes, I think you're right. So it seems the best solution is for the
iomap infrastructure to always support ifs when block size is smaller
than folio size.

Otherwise, ext4 would have to fall back to sync writeback to avoid
this issue, e.g. calling filemap_write_and_wait_range() after
ext4_truncate_page_cache_block_range(). The performance impact should
be acceptable because ext4_truncate_page_cache_block_range() already
ensures the folio is clean in most cases, only the partial zeroed
blocks at the boundary would need to be written back. So we wouldn't be
triggering a large amount of writeback. Any thoughts?

Thanks,
Yi.


