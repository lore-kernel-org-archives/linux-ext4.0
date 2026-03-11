Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49137278161
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2026 02:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773196716; cv=none; b=mTl3vI3+DrMwnBfR0DXw3YeLD0Ua6jZgz7HrPDTBnwkKLbJVZwiiskcjhDmZccpHDZqmeOLZYUnUGwXG/i+LmdUhEZ/Buqvv2gsz+5oDve9QhGjwLn9DLRX9vxjwima+V5VaEDD85ToUVVGiw79TRGSgOcfNJKQ+j9oW8GvEfuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773196716; c=relaxed/simple;
	bh=aq4avvuibgsN50dMoTC/3Pr6X4jtYnIpJdujbfSHWbE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tsEp2gqYELPsKmeiG9p/+OdhYy/Qvvtlfzk77zFRbwytUxjtivszR2hLCkoIoHfMP2TU4qF3itVte2/32ojQtVdaR5m/hpcbXCBb00RK7VmniGZfg8mvjzNRIxggRI6od22Be2azhWmezPjv+hjYVZoAhZd7drULwhcD+9urDis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=bYREo80Z; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="bYREo80Z"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773196702; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+1Ii/LXw6ucwfmSPhS6buDS/Z8cFHFhpzl/LJx+StbY=;
	b=bYREo80ZfWA9U3I6fqMRgQO+xUv6VlUYHOWqMYZ5FKcuL7QmcXuWdwc1st29/7kZVDot3hprAQEj2LOTcMOXKqTa9/1QxS+BhtYybAnbcSXTWMZ6lwexwY8SwDaGUO6a9tgL6+wRASrP1Y2RHhO6L3p116jYNFXDT56KZ2gGrMM=
Received: from 30.221.147.134(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-iF1fg_1773196701 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Mar 2026 10:38:22 +0800
Message-ID: <5ce9dfe2-721e-4d20-9bd9-3560aa76888d@linux.alibaba.com>
Date: Wed, 11 Mar 2026 10:38:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ext4: handle wraparound when searching for blocks for
 indirect mapped blocks
To: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, libaokun@linux.alibaba.com,
 Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <20260310122806.1277631-1-tytso@mit.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260310122806.1277631-1-tytso@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ted,

On 3/10/26 8:28 PM, Theodore Ts'o wrote:
> Commit 4865c768b563 ("ext4: always allocate blocks only from groups
> inode can use") restricts what blocks will be allocated for indirect
> block based files to block numbers that fit within 32-bit block
> numbers.
>
> However, when using a review bot running on the latest Gemini LLM to
> check this commit when backporting into an LTS based kernel, it raised
> the following concerns:
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
>    Also, in the optimized scanning paths like
>    ext4_mb_scan_groups_p2_aligned(), start is passed into
>    ext4_mb_scan_groups_xa_range(). If start >= ngroups, will this
>    trigger the WARN_ON_ONCE(end > ngroups || start >= end) because end
>    is set to ngroups? Furthermore, after wrapping around, end will be
>    set to the original start which is > ngroups, triggering the
>    warning a second time. Should this code clamp start to < ngroups
>    before scanning?
>
> After reviewing the code paths involved and considering the LLM
> review, I believe that while it is unlikely, it is possible that how
> commit 4865c768b563 added ext4_get_allocation_groups_count() doesn't
> completely address all of the possible situtions that might show up
> when using indirect-mapped files and allocating blocks on a file
> system with more than 2**32 blocks.
>
> So this commit adds some safety checks and wrap around logic to some
> functions if the multiblock allocator: ext4_mb_scan_groups_xa_range(),
> ext4_mb_scan_groups_best_avail(), ext4_mb_scan_groups_p2_aligned(),
> and ext4_mb_scan_groups().
>
> Fixes: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: Jan Kara <jack@suse.cz>
> ---

Good spotting! ext4_find_goal() ensures that the goal block obtained for
indirect-block-based files will not exceed EXT4_MAX_BLOCK_FILE_PHYS.
However, on an ext4 filesystem where the two file formats are mixed,
it is indeed possible to get an excessively large goal group via stream
allocation.

Since the mixed-format case is quite rare, I think we can simply validate
start in ext4_mb_scan_groups() and reset it to 0 when it exceeds the limit,
like this:

        /* searching for the right group start from the goal value
specified */
        start = ac->ac_g_ex.fe_group;
+       if (start >= ngroups)
+               start = 0;
        ac->ac_prefetch_grp = start;
        ac->ac_prefetch_nr = 0;

This way, we don’t need to add similar checks in every CR.


Besides, ext4_mb_scan_groups_xa_range relies on the caller to handle the
wrap-around logic so as to ensure an overall one-way traversal of groups;
see commit a3ce570a5d6a ("ext4: implement linear-like traversal across
order xarrays") for details. So in any case, I don’t think it is necessary
to add wrap-around logic here. It should be sufficient for the caller to
guarantee that end <= ngroups and start < end.


Cheers,
Baokun

>  fs/ext4/mballoc.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..454d5a1b4803 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -915,13 +915,17 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	enum criteria cr = ac->ac_criteria;
>  	ext4_group_t ngroups = ext4_get_allocation_groups_count(ac);
> -	unsigned long group = start;
> +	unsigned long group, end_range;
>  	struct ext4_group_info *grp;
>  
> -	if (WARN_ON_ONCE(end > ngroups || start >= end))
> -		return 0;
> -
> -	xa_for_each_range(xa, group, grp, start, end - 1) {
> +	if (start >= ngroups)
> +		start = 0;
> +	group = start;
> +wrap_around:
> +	end_range = end;
> +	if (end_range > ngroups)
> +		end_range = ngroups;
> +	xa_for_each_range(xa, group, grp, start, end_range - 1) {
>  		int err;
>  
>  		if (sbi->s_mb_stats)
> @@ -933,7 +937,11 @@ static int ext4_mb_scan_groups_xa_range(struct ext4_allocation_context *ac,
>  
>  		cond_resched();
>  	}
> -
> +	if (start) {
> +		end = start;
> +		start = 0;
> +		goto wrap_around;
> +	}
>  	return 0;
>  }
>  
> @@ -967,6 +975,8 @@ static int ext4_mb_scan_groups_p2_aligned(struct ext4_allocation_context *ac,
>  
>  	start = group;
>  	end = ext4_get_allocation_groups_count(ac);
> +	if (start >= end)
> +		return 0;
>  wrap_around:
>  	for (i = ac->ac_2order; i < MB_NUM_ORDERS(ac->ac_sb); i++) {
>  		ret = ext4_mb_scan_groups_largest_free_order_range(ac, i,
> @@ -1099,6 +1109,8 @@ static int ext4_mb_scan_groups_best_avail(struct ext4_allocation_context *ac,
>  
>  	start = group;
>  	end = ext4_get_allocation_groups_count(ac);
> +	if (start >= end)
> +		start = 0;
>  wrap_around:
>  	for (i = order; i >= min_order; i--) {
>  		int frag_order;
> @@ -1199,6 +1211,8 @@ static int ext4_mb_scan_groups(struct ext4_allocation_context *ac)
>  
>  	/* searching for the right group start from the goal value specified */
>  	start = ac->ac_g_ex.fe_group;
> +	if (start >= ngroups)
> +		start = 0;
>  	ac->ac_prefetch_grp = start;
>  	ac->ac_prefetch_nr = 0;
>  
