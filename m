Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AFD1E1E04
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 02:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781664342; cv=none; b=lX1g2rLGFWsYbs3Dt26hOtpSdTzOrcZ1PzaqQK5ln46BJgTQ1vurYXjoixzsmBYTgKL42nQz7ZhmkzYTJZgAdTDsyGBaKl9dh4FZ/uNzV862S8th/I5fS3+FbVtqQ/j9WVNnUzEeaY3Drs+87PeujIN7AcdZosWyni2V7GfoirY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781664342; c=relaxed/simple;
	bh=lDRhFpzBFkGxhF5OgP0hXmbM5S0pwmEaaozsbOysbOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YMVbIIwtwAwuU/dhSSN3lQbLUJ4vMbAsFa33whAqTs8Ty9+BfraxctFKO/wmBg1uCrwR9KlIrrqY7L5JG9ew5pRMyXwwKbkmaK5HK7JxeqLModxjmS1EquKgK2enzFhh0T1d68P/T9jCpBtz6jeQGbWUWriOCRmgO+CrVR1bzKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efbiiWUX; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efbiiWUX"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8423efd76c8so3690821b3a.0
        for <linux-ext4@vger.kernel.org>; Tue, 16 Jun 2026 19:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781664341; x=1782269141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dkOBR/IN8JtGeGvY/n6b/PZDPq4NnY16Ch4SZ7yVvy4=;
        b=efbiiWUXA3l5zg5PsiVDzHxjgGjh0MVMkSrw0RNKKASqWo9uJIz+k4ZSHfCWJPrJH1
         Vn2ikLsXrYP2hgfOEJOz+W294XO7ILgl4P4eKrAC6EW56c3rmwmx+PWIr1kdjEjDdz8J
         QaP5fM9jEhkm9DwSQSnne9mzHK8ic6QxKuCp/HJnJRxa5NB6nkfFrVjmOkp6nb8RbYy1
         IowEak/N50E791QAYdoFm6HnYuVIe8F1TUk3nl4KcuIRao3f2ancyNhujKH1nh2yj/GP
         2hjTeIFS4bLhS7Z99h4foVMsZmCEtz9za4EUBJUBVFqVuRvgOB83wvy9vDK7j5Bsd9ZQ
         VYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781664341; x=1782269141;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dkOBR/IN8JtGeGvY/n6b/PZDPq4NnY16Ch4SZ7yVvy4=;
        b=CdFQQ1mMIXKPDLgOgiqmq9ya9LweT5APm8m6Ey9iwtVBSq/SH12QzMals7LNjPClL9
         NEpkd68RrDG4TRW1etJq6aosKzGjo7u8EGAOZ9ns/mCDscYuBBsgTnJa1HW/rIqtoofV
         qMC/dS5W2rsE69R79JRHPH7gl/gIJsSEdDDuMSiaH52ql+DdD8pivzStWjb2FWXFnhlH
         vExxwZyBB/TkjhLuo1vTILorlRWCcXmADF/2T570xivUl0BQIJZ8EUcxBkTI0N2N+0Dg
         JMSkBmKMizNGBMJ3Tb9e5UyLHLTleHSLhk3YA6ObWNZ3KVLK0piHEAUPVHoHVPRZWr9j
         IgwA==
X-Forwarded-Encrypted: i=1; AFNElJ+O10U56vI9nswgW7QSpTfsagftKt7hSyo9MlwfZFFeM7qKYIqYlPw5ySSgvdz/jlq4LCAITrvuglW7@vger.kernel.org
X-Gm-Message-State: AOJu0YxYgzIE51l+kaMrWesXF6nXYjOU/jZvwkzr8vlOmPLgfT+02FfI
	Y6PVLsxakb6+Xl0sc2aYYtP5cd2QcvzX1IzqYU2wvOSnIFHj99DrMFZn
X-Gm-Gg: Acq92OEOL131aUBaMnshGc+orJ9oWKZQED/wWxtMEHwJOTKxEufXhzObvJBN250q8/5
	BJf8wR9SmnIq67EIhdM3w3OlEZe9V1q8zebykX36329k+ZvuhrgiHrpUClw/sZwi8HQigWqxcr6
	fqBohhYy8jAoxT3Wb6Qg6qTM+1cq/dxig16feAxpas/MgbcDqMTl8sYmB0CPjzG6ZWsS516d2SW
	PuQ1WSD6abDlhiFfJbYlGoMm0Y+T6aOwf5p9uoFub0oN4SCsuZX1zk/Y9ySeZOSN/WzIpO70D3M
	IB5HzcsIAya6eSCFqYk+g8Sbs+7rE0kFg45cjZZlznO2hcHcVpVAkMdr4Vqt4V/CXQAGz4RNvzO
	FeYLeQG8MKVfgT2HNzBDFCUO4Q8qhQPjM6pyEMBbpH8Wp6uzi9+58sp8sCMAMtWffeHIF1vFlIs
	6Tb06XZn4+yMm/9LC9blhq40f1ts70BOAF
X-Received: by 2002:a05:6a00:391a:b0:82f:623f:e5b3 with SMTP id d2e1a72fcca58-8452458791cmr1798780b3a.34.1781664340611;
        Tue, 16 Jun 2026 19:45:40 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434acd96d8sm17293996b3a.19.2026.06.16.19.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 19:45:40 -0700 (PDT)
Message-ID: <d1adcf7c-c276-458d-9cac-68a4410f7626@gmail.com>
Date: Wed, 17 Jun 2026 10:45:10 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: base unaligned DIO lock decision on partial
 block zeroing
To: Baokun Li <libaokun@linux.alibaba.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
 yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 peng_wang@linux.alibaba.com
References: <20260611163441.2431805-1-libaokun@linux.alibaba.com>
 <20260611163441.2431805-3-libaokun@linux.alibaba.com>
 <060f63e0-d64f-40df-99a7-af53862049ee@linux.alibaba.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <060f63e0-d64f-40df-99a7-af53862049ee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, Baokun!

On 6/16/2026 9:10 PM, Baokun Li wrote:
> Hi all,
> 
> Thank you for your review!
> 
> After extensive testing, I found that after merging this patch, generic/746
> started failing intermittently on ext3 (mkfs.ext4 -O ^extents).  The test
> triggers a "Page cache invalidation failure on direct I/O" warning, and
> subsequent fsync returns -EIO.
> 
> The underlying race existed before this patch, but this patch appears to
> have widened the reproduction window considerably, so I thought it worth
> trying to address.  Here is my analysis:
> 
> On no-extent inodes, DIO writes that hit holes cannot use unwritten
> extents.  ext4_iomap_alloc() leaves m_flags=0, so ext4_map_blocks()
> returns 0 for a hole, and:
> 
>          if (!m_flags && !ret)
>                  ret = -ENOTBLK;
> 
> The iomap layer returns -ENOTBLK to ext4, which falls back to buffered
> I/O.  The fallback path dirties pages in the page cache, then flushes
> and invalidates them.  However, concurrent async DIO completions to
> other blocks on the same inode can run kiocb_invalidate_post_direct_write()
> without holding the inode lock.
> 
> Consider a file with two 4k extents: [hole][written].  Thread A does DIO
> to the written extent, while thread B does DIO spanning both extents:
> 
>    kworker A (4k DIO, allocated block)    kworker B (8k DIO, hole->fallback)
>    -----------------------------------    -----------------------------------
>    inode_lock_shared()                    inode_lock_shared()
>    iomap_dio_rw():                        iomap_dio_rw():
>      kiocb_invalidate_pages -> clean        iomap_begin -> -ENOTBLK
>      submit_bio (async)                     dio->size = 0
>    inode_unlock_shared()                  inode_unlock_shared()
> 
>    [bio pending in block layer]           /* fallback: inode lock released */
>                                           ext4_buffered_write_iter()
>                                             inode_lock(exclusive)
>                                             generic_perform_write()
>                                               -> dirty pages [0, 8k]
>                                             inode_unlock(exclusive)
> 
>                                           /* pages still dirty here */
>    [bio completes]                        filemap_write_and_wait_range()
>    iomap_dio_complete()                     -> flush dirty pages
>      kiocb_invalidate_post_direct_write() invalidate_mapping_pages()
>        invalidate_inode_pages2_range()
>        -> finds dirty page!               /* window closed */
>        -> dio_warn_stale_pagecache()
>        -> errseq_set(-EIO)
> 

It looks like this issue occurs when invalidate_inode_pages2_range()
checks beyond the DIO write range, which may only happen when folio size
is larger than block size. Is that correct?

> The critical window is the gap between ext4_buffered_write_iter() dirtying
> pages and filemap_write_and_wait_range() flushing them.  In this window the
> inode lock is not held, so another thread's async DIO completion is free to
> invalidate the still-dirty pages in the page cache.
> 
> This race has always existed on ext3 because indirect-block inodes lack
> unwritten-extent support.  However, the window was extremely narrow in
> practice, because the old ext4_overwrite_io() checked every block and
> would conservatively take an exclusive lock.  This patch replaced it
> with ext4_dio_needs_zeroing(), which only checks head and tail blocks,
> making unaligned DIO more likely to take a shared lock and
> proportionally increasing the chance of hitting the race.
> 
> I tried a couple of alternatives before settling on the patch below:
> 
> 1. Force exclusive lock + IOMAP_DIO_FORCE_WAIT for all no-extent DIO.
>     This closes the window for new DIO submissions, but does not protect
>     against bio completions from previously submitted async DIO, which
>     run independently of the inode lock.
> 
> 2. Wrap the fallback dirty+flush+invalidate sequence in
>     filemap_invalidate_lock().  However, the ext4 DIO and iomap layers
>     do not use this lock, so it would not serialise against DIO
>     completions.
> 

Could we add a call to inode_dio_wait() before falling back to buffered
I/O? That is, in thread B, when falling back to buffered I/O, could we
acquire the exclusive inode lock and then call inode_dio_wait() to wait
for in-flight DIO to complete? This should close the race window. Since
scenarios where DIO writes to holes on ext3 are relatively rare, the
performance impact should be minimal (I suppose).

> One straightforward approach that seems correct is to skip direct I/O
> for no-extent inodes entirely, by returning 0 from ext4_dio_alignment():
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6131,6 +6131,8 @@ u32 ext4_dio_alignment(struct inode *inode)
>   {
>          if (fsverity_active(inode))
>                  return 0;
> +       if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> +               return 0;
>          if (ext4_should_journal_data(inode))
>                  return 0;
>          if (ext4_has_inline_data(inode))
> 
> With this, ext4_should_use_dio() returns false for no-extent inodes, and
> all I/O goes through ext4_buffered_write_iter() directly, bypassing the
> DIO path entirely.  On ext3, DIO to a hole already falls back to buffered
> I/O, so there is essentially no performance benefit to using DIO in the
> first place.
> 
> Note that with this change, the fallback branch in ext4_dio_write_iter():
> 
>          if (ret >= 0 && iov_iter_count(from)) {
>                  /* buffered fallback */
>          }
> 
> would also become dead code for extent-based inodes (since unwritten
> extents guarantee iomap_dio_rw() never returns zero with unconsumed
> data), and could be removed in a follow-up cleanup.
> 
> Thoughts?  Is there a reason to preserve DIO on no-extent inodes that
> I'm missing?
> 

Hmm, this would also cause DIO to fall back to buffered I/O in common
extending write cases, which I think would be unacceptable.

Cheers,
Yi.

> Looking forward to your feedback.
> 
> 
> Thanks,
> Baokun
> 
> 
> 

