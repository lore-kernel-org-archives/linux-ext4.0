Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB336215F
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954796; cv=none; b=U48m1D3YfgZ7CahNoHzuADu81NulXAFgiZdbF/Hu2U6vFr3QhhjINCytQ/v24s51gCNUx5tZzyVPzFAO1PSQ1PI2RneLxbJ4JvnwNoeFY0oomnsg0IxEERrwlHH6osgxYZL56OQXeFjw+sisWSxwaE90nMN+GhS/bHdD/VHnccM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954796; c=relaxed/simple;
	bh=JFYjF+DkAm3gYNXAdMMu5qOjcHaagFMmdqt+ajQe3Ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J23k+pfJ6gwz1b9i5v2UmCAHWmCbbZI0/TjF0o2/5xukt44ct8DxVj1k5jlY7LR17LLikwVHh4tXTu+5rEH/vxOoIbXmkz6dUhR/um+m8egMuWA1EGQOxkIuXw7RykUE5TZKqhCScgGtptRP02Cd6bcWi36F5CYja0p8O/UqT/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cCOE3N2w; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cCOE3N2w"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso1959129b3a.0
        for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 01:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786954794; x=1787559594; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7anIaDpbEisdhPG9Mmo3P2k8j+qj13jEqhUX32axBYw=;
        b=cCOE3N2wkhZo1RC3RRoR3R8PrXo907jOEd8zdeRtoZoyJHpgsA3S4TColTUk24WhI2
         UtuMyetn3t/TFaYWFZ9i3hzDxP5RuXlYYhPu/gFeAehpYEFuMLnOXdG6gzpvyXTkQRKf
         K2vTT39oPN6dTmmVLuDV9YtXNf3pBMdtVco9ncgJ7svLGRjgaw2amFOBsUT3E8Xy82nK
         ROkyI6joTWIXF8XLip9TfaIrAbMvJz+NNFWVAyjooOu7fDDjmCMJ53jSSr6KPn/h1qS5
         VtIVG/fYYSAopSel4zlRL4Yztpl+CysP/8SLOTIhQLasvCRQlVV1QmaYEuuvERFVQv5B
         zkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786954794; x=1787559594;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7anIaDpbEisdhPG9Mmo3P2k8j+qj13jEqhUX32axBYw=;
        b=jJbrNSNpX1uomvhNULhOIi6DnpKlJErBWLCS/GpmijD7uLiPhOitTkGqUciUDcrUDI
         M99XZN/hT4CNNRze3J18aBa9fEB4WPwavCIdeW4bRObhs7orXkKfz+nFakpMhjyzLVon
         hv8QlkmO5T6nQtYRABjNCwTwBHkx/mxWFRh/a3s9hpKWfQmmJGTNeAfusskE5grot2Ek
         uWaiX/5yyj//5oXB2X2G5A0OH/eO0v29j229Xl0GNcWH5n0PPgXKVmL02iQ10SuSSAG9
         p0N7Z68bFV45n0h0QRxsph2wga6UtPDH3wtsBiayUpZdq/hIA0Vg5OWGK9hffrtZVS9y
         h7MA==
X-Forwarded-Encrypted: i=1; AHgh+RraNGRqlULXlPIjLaBTWgGp7TnXzYSdjB2SAlfXIjrMeG33RepuAn1lzhhJIU5VS57Zw0gnw66ENA0R@vger.kernel.org
X-Gm-Message-State: AOJu0YwQZDHI2wnJPHriFjjyMuJw8WNiJ+8ZDO8XzVhEzU8KiAyW9NJ9
	TV4Wp07C1v5UMzat7lpo3Huuii9Bive1s5fD6uMEgDD0cebwp12yIZsBTKDTJjQ+v5c=
X-Gm-Gg: AR+sD11sxrKljV6KwN5G1cawNP1QMYaoFzlycrnJxGzwMuiSJr46Ko6WW2rDkROTgq+
	hj8igkPEvAaQI3MFWBI3k2lNSsmDPbqRVWDphZJ5R3iKMgCSyE2hQaE97sAEAH8Xv6bLiA/DD2y
	Lgrcv1nYTuOzip3Yjv8XPu2EAnnEqiaxo2ugaoXG13RUQnmHX5eTIpOZhk/Xr9EGdAjJERYx0nv
	KOABfO18cltCcccKbXK8F6GcUMgitiigDidO1eRZomNoNcFZ+eI7XVDKRreYeNV+hlILi7OAh5r
	n1RNpWbQ85zJQbZ4Ie8IJJvo0CMbfn9z7gY3UgdFxb3/ULOKx7fYVV5oeDQht5bby3ZVMjikylj
	eUaHH4fDzfRKG0olAeLNrgpDD8fSM1t3Qrl7cDrzYKJAv+K250KXCzAmdJcixqyJKGcJQqb8F+J
	98n/XYA7SmoxfEkhqHqg5QPlKVZXVBdtwjFqrzZyV5Mfm5eJd67coA3GeJ3+qqmDsMq12Uq2KNT
	v/nG89qHtKjVXBNaHw6
X-Received: by 2002:a05:6a00:21c8:b0:847:973b:3cf6 with SMTP id d2e1a72fcca58-84fddde3c32mr21634131b3a.0.1786954794092;
        Mon, 17 Aug 2026 01:19:54 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b401ec98sm203757b3a.6.2026.08.17.01.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 01:19:53 -0700 (PDT)
Message-ID: <e6ee7c12-c0bf-4940-95fb-af71127745c7@gmail.com>
Date: Mon, 17 Aug 2026 16:19:43 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v5 17/32] ext4: implement mmap path using iomap
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-18-yi.zhang@huaweicloud.com>
 <20260814103531.D9F861F000E9@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260814103531.D9F861F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/2026 6:35 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] File operations that zero partial blocks will crash on iomap-enabled files due to legacy buffer_head dereferencing.
> - [Medium] Bypass of inline data conversion for iomap-enabled inodes causes failures and kernel warnings.
> --
> 
> --- Patch [17]: [PATCH -next v5 17/32] ext4: implement mmap path using iomap ---
> commit 355e5d2bcead3197b1566acfa637f19866c3b52c
> Author: Zhang Yi <yi.zhang@huawei.com>
> Subject: ext4: implement mmap path using iomap
> 
> This commit introduces ext4_iomap_page_mkwrite() to implement the mmap
> iomap path for ext4. It delegates the heavy lifting to iomap_page_mkwrite(),
> using ext4_iomap_buffered_write_ops and ext4_iomap_buffered_da_write_ops.
> The lock ordering documentation in super.c is also updated accordingly.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 0b3e54e12b78f..a054456258953 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> 
> [ ... ]
> 
>> @@ -7318,6 +7343,11 @@ vm_fault_t ext4_page_mkwrite(struct vm_fault *vmf)
>>   
>>   	filemap_invalidate_lock_shared(mapping);
>>   
>> +	if (ext4_inode_buffered_iomap(inode)) {
>> +		ret = ext4_iomap_page_mkwrite(vmf);
>> +		goto out;
>> +	}
>> +
> 
> [Severity: Medium]
> Will this bypass inline data conversion for iomap-enabled inodes?
> 
> If ext4_inode_buffered_iomap(inode) is true, we route to
> ext4_iomap_page_mkwrite() and skip ext4_convert_inline_data(inode).
> 
> However, the iomap implementation explicitly forbids inline data, triggering
> a warning and returning -ERANGE:
> 
> fs/ext4/inode.c:ext4_iomap_buffered_do_write_begin() {
>      ...
>      /* Inline data and non-extent are not supported. */
>      if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
>          return -ERANGE;
>      ...
> }
> 
> Should the inline data conversion happen before checking for the iomap path?


This is a false positive. The iomap path doesn't support inline
data at the moment. But for future-proofing, I think we should
move the inline data conversion before the iomap path check,
even though it's harmless for now.

> 
> [Severity: Medium]
> Will file operations that zero partial blocks crash on iomap-enabled files?
> 
> When an application performs an extending write or truncate up on a file
> with EXT4_STATE_BUFFERED_IOMAP enabled, ext4_write_checks() unconditionally
> calls ext4_block_zero_eof() without checking if the inode uses iomap:
> 
> fs/ext4/file.c:ext4_write_checks() {
>      ...
>          ret = ext4_block_zero_eof(inode, old_size, iocb->ki_pos);
>      ...
> }
> 
> This proceeds to ext4_block_do_zero_range() and ext4_load_tail_bh(), which
> calls folio_buffers(). For an iomap folio, folio->private points to an
> iomap_folio_state, not a buffer_head:
> 
> fs/ext4/inode.c:ext4_load_tail_bh() {
>      ...
>      bh = folio_buffers(folio);
>      if (!bh)
>          bh = create_empty_buffers(folio, blocksize, 0);
> 
>      /* Find the buffer that contains "offset" */
>      offset = offset_in_folio(folio, from);
>      pos = blocksize;
>      while (offset >= pos) {
>          bh = bh->b_this_page;
>      ...
> }
> 
> Treating iomap_folio_state as a buffer_head leads to a crash when iterating
> bh->b_this_page. Since there are no callers setting EXT4_STATE_BUFFERED_IOMAP
> in the current codebase, this is a latent regression. How should partial block
> zeroing be handled for iomap-enabled files?
> 

This is a false positive. Patch 18 adds a new function
ext4_block_iomap_zero_range() for the iomap path.

Thanks,
Yi.

>>   	err = ext4_convert_inline_data(inode);
>>   	if (err)
>>   		goto out_ret;
> 

