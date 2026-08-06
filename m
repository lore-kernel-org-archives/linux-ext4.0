Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7E2443E4E;
	Thu,  6 Aug 2026 10:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011830; cv=none; b=QYn1MHo1XDinYoSkW94erL3zmrEpVj0CZ88vjUMSsIS1ynyV/4G9x9U3YgrYrsCi4iaz7ev+6IgPQkxJNtWnGVQwuCcEQvmdXt3hms3pmZaNpUn32r3Z6kHLUQU+KoktDHvexTPvSy/veYg+mzU87ZB5K23NZsFRkziqJOz9+jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011830; c=relaxed/simple;
	bh=C5I84RxSp8Qlh8ciQKGh+oj6KPnpAtnfSJGidFpFAWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MekghklLOGjUwHS0MvqTHTGjRHgRhrxhat+y78632I0WJlr3advIfxYx8F2GFPcsltx0M7EnN5oqyFUQi5DFSyzhJ8xfI1f88oBjIU+KTuh9wlwqoCB5LynHszzSPB3ZzQO3Kjgh+LN7CntrjUCiple3ZgwS7yXhg9d23/QKi90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=AmP2HTM8; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="AmP2HTM8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786011823; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KxCQEIJTEpu2HLskEO3anQPPaiXW2MuwM7tILXssSfM=;
	b=AmP2HTM8D4P7lgWEs2a/HsCmTjwVS8a/ak38VnSxN7nWciSuHLBZOgZ6YZviJQy5Gz4JsavgnCG0cREdUMmVDAYl0H7uCHJizoHSFczNv6BfhyXHeeWqHK+YQ2L07IMEpa6+meKV705wcV7bu6/vo9rJjUODED5d7xxYSi5VIcI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X8TmP1U_1786011820;
Received: from 30.221.129.97(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X8TmP1U_1786011820 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 18:23:41 +0800
Message-ID: <5849a28b-ffaa-420f-b173-d8a085d9c61f@linux.alibaba.com>
Date: Thu, 6 Aug 2026 18:23:40 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ocfs2: fix readdir position truncation on 32-bit
 kernels
To: Andrew Morton <akpm@linux-foundation.org>,
 Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com, stable@vger.kernel.org
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
 <20260806022044.167962-3-zhanxusheng@xiaomi.com>
 <20260805214202.a644393ef2f28ffb30090ff4@linux-foundation.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260805214202.a644393ef2f28ffb30090ff4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/6/26 12:42 PM, Andrew Morton wrote:
> On Thu,  6 Aug 2026 10:20:44 +0800 Zhan Xusheng <zhanxusheng1024@gmail.com> wrote:
> 
>> In ocfs2_dir_foreach_blk_el(), the directory cookie position is
>> rebuilt with
>>
>> 	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;
>>
>> `ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
>> unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask
>>
>> 	~(sb->s_blocksize - 1)
>>
>> is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
>> block size).  In the AND expression with the 64-bit `ctx->pos`, that
>> unsigned operand is zero-extended to 64 bits per the usual arithmetic
>> conversions, yielding 0x00000000fffff000.  The high 32 bits of
>> `ctx->pos` are silently cleared, even though directory size is
>> allowed to exceed 4 GiB.
>>
>> When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
>> position is reset back into the first 4 GiB block, making the
>> re-validation path re-enumerate already-returned dirents indefinitely.
>>
>> This is ocfs2_dir_foreach_blk_el(), the extent-list readdir path taken
>> for all non-inline directories, so a directory large enough to cross
>> 4 GiB reaches it.
>>
>> This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
>> bitwise operation having different size") fixed in exfat, and the
>> fix mirrors the equivalent ext4 fix in this series.  Cast the operand
>> to loff_t so the mask is 64-bit before the AND:
>>
>> 	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;
>>
>> 64-bit kernels are unaffected.
> 
> AI review had no comment on your change, but it might have found a
> bunch of unrelated ocfs2 issues:
> 
> 	https://sashiko.dev/#/patchset/20260806022044.167962-1-zhanxusheng@xiaomi.com

It looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

For the issues founded by sashiko, I'd rather track them in a separate
thread.
So Xusheng, could you please send a new fix for that? It seems enough
to do the same check like ocfs2_check_dir_entry(). e.g.

i + OCFS2_DIR_REC_LEN(1) <= sb->s_blocksize

Thanks,
Joseph
