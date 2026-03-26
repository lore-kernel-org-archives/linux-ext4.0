Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A29D3CB2FA
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774519616; cv=none; b=nr3NudwrmMAPHzotqrnQejEOSOa2UqM1QTBOQXxZawwJhoP8K0Hl0uS74jOSNTBnvdM2bEmAKIy3PxkvHrURdq1uzvOTe+rf41s8LFeFBbbQJc56U2y/R/k5RirgJGa/FrNg6osOt8yAwk2rOtWkVWbbJpnmE77K44qe7f+88F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774519616; c=relaxed/simple;
	bh=W3hfnEfC4QHJ88cnd70F/RXgFF7PbzG0uLgqXD7/oxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nyg0byKobJ2WR4fG+8xxzx7reQJYmG4fT4PlHVih6NhL6QyWRcFuPSCtbs59uzeYfZwkRK6Vmo5xCiaGKA84WUA02ozd3pCDH6KoBuavPuGm9zD4KAEgnzGa9CIgoW2JTfM4IUWmM0RU08Wi5C76W0Ult4V/ybV5QQ7KCMBbtdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XX4Jpz7y; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XX4Jpz7y"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774519610; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PXys96BnuBntlzPO08XXnlDVCapTfyq2C7/O356NDSw=;
	b=XX4Jpz7y5H+x+muqEbcgpWj+tKQFgPkkYlvsLymLJQfr7ppCDqnG73VHmF0tot6MNj0gtj5Tr/1yDnhFLBJvAl3sobOqjklogTzxtzS3YWifyZYddC9yhvZBLJijjktKduqZAGn7od6J82MXBWKFwFTyi/vE25nHFTso3YE1CQg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0X.l2cAt_1774519291;
Received: from 30.221.131.86(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X.l2cAt_1774519291 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 18:01:32 +0800
Message-ID: <a2ba82d0-c0b3-4664-aab6-04615ef316db@linux.alibaba.com>
Date: Thu, 26 Mar 2026 18:01:31 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v2] ext4: handle wraparound when searching for blocks for
 indirect mapped blocks
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
References: <20260326045834.1175822-1-tytso@mit.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260326045834.1175822-1-tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/26/26 12:58 PM, Theodore Ts'o wrote:
> Commit 4865c768b563 ("ext4: always allocate blocks only from groups
> inode can use") restricts what blocks will be allocated for indirect
> block based files to block numbers that fit within 32-bit block
> numbers.
>
> However, when using a review bot running on the latest Gemini LLM to
> check this commit when backporting into an LTS based kernel, it raised
> this concern:
>
>    If ac->ac_g_ex.fe_group is >= ngroups (for instance, if the goal
>    group was populated via stream allocation from s_mb_last_groups),
>    then start will be >= ngroups.
>
>    Does this allow allocating blocks beyond the 32-bit limit for
>    indirect block mapped files? The commit message mentions that
>    ext4_mb_scan_groups_linear() takes care to not select unsupported
>    groups. However, its loop uses group = *start, and the very first
>    iteration will call ext4_mb_scan_group() with this unsupported
>    group because next_linear_group() is only called at the end of the
>    iteration.
>
> After reviewing the code paths involved and considering the LLM
> review, I determined that this can happen when there is a file system
> where some files/directories are extent-mapped and others are
> indirect-block mapped.  To address this, add a safety clamp in
> ext4_mb_scan_groups().
>
> Fixes: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
> v2:
>   * Remove extra checks that were not needed once we add the clamp
>     in ext4_mb_scan_groups().
>
>  fs/ext4/mballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..b10db5d7545b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1199,6 +1199,8 @@ static int ext4_mb_scan_groups(struct ext4_allocation_context *ac)
>  
>  	/* searching for the right group start from the goal value specified */
>  	start = ac->ac_g_ex.fe_group;
> +	if (start >= ngroups)
> +		start = 0;
>  	ac->ac_prefetch_grp = start;
>  	ac->ac_prefetch_nr = 0;
>  

