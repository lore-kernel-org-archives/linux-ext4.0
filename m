Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907E640DFA1
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 07:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773474122; cv=none; b=lIxhWHiHBUgetLSzZbKHNu1IEnKb8UzumTBv+xelnzNz/SCOXeXPZQhP+xxxrC7w4wNLtn+3bdqw46eu4oiqO7QW9VcBLt/siufRaLTrMUbMSTkZWV2n6aUs8/jKfQyujzkv432gWbEhF5A0o/Zkl48AtYC7kO8/jBOuQZQ3LL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773474122; c=relaxed/simple;
	bh=e6dAMY2UcHHW9Si0S5gvkvqVshlXtIxRSy47KwWKA4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gv2lfnBoQbKDzgBX3p57BHaZQU2cqRTuos8RSQmM7TJyxPTIl3gpLz+GljaroJR09PMrJdFS98vZ6TjqE+aNSE2TR8KQSDgFXFiIO2+DB6R4hMU+YGSR8Py++hCM1b5tHoNS2xJ+8rlKSftYyujcS3vMY1xL2mAvmFPNODMpUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=gaNKgDqP; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="gaNKgDqP"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773474114; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=juJMIhACt0N6RqB0iR/nekytbprC/opCSKTEKZkDldk=;
	b=gaNKgDqPotBFnMG+qgiwz2n88HdyybdsokDF3dHlyam687kgQbpZ9SmwwXX+TAofGl6fQb9c7BpLiydqzYD34GTK0ce5HeZZghsi55ZDLthd+vagOp4FHNn6jV94MsULOe/oz/54U3xX69t1IiW8j2iBZSNyfWgNHFTxT97iRG0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X-vC0ic_1773474113;
Received: from 192.168.3.86(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X-vC0ic_1773474113 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Mar 2026 15:41:54 +0800
Message-ID: <f499f164-2e93-4fa7-a6dd-b3949e1a1223@linux.alibaba.com>
Date: Sat, 14 Mar 2026 15:41:52 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] ext4: handle wraparound when searching for blocks for
 indirect mapped blocks
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Ext4 Developers List
 <linux-ext4@vger.kernel.org>, libaokun@linux.alibaba.com
References: <20260310122806.1277631-1-tytso@mit.edu>
 <5ce9dfe2-721e-4d20-9bd9-3560aa76888d@linux.alibaba.com>
 <20260312142345.GA4689@macsyma-wired.lan>
 <2a047aeb-6db8-4be9-8908-b12632d5e632@linux.alibaba.com>
 <20260313143101.GA38016@macsyma-wired.lan>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260313143101.GA38016@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/13/26 10:31 PM, Theodore Tso wrote:

> On Fri, Mar 13, 2026 at 10:00:04AM +0800, Baokun Li wrote:
>> IIUC, ngroups/end here only depend on filesystem size and whether the inode
>> is extent-based, and both should stay unchanged during block allocation.
>> So doing the check once at the beginning should be sufficient. Am I missing
>> anything?
> The problem here is that case where we use
> ext4_get_allocation_groups_count as ngroups and end are different.  In
> some places we do this:
>
>         ext4_group_t ngroups = ext4_get_allocation_groups_count(ac);
>
> and in others we do this:
>
>         end = ext4_get_allocation_groups_count(ac);
>
> Now, if start is zero, then these two are equivalent.  But if start is
> not zero, but say, is 2**32 - 8, then where we use
> ext4_allocaiton_groups_count() as the last block group to search, then
> we only will search exactly 8 block groups, and if
> there are free blocks in the first 8 block groups, then the scanning
> function will fail.

ext4_mb_scan_groups_p2_aligned(), ext4_mb_scan_groups_goal_fast(), and
ext4_mb_scan_groups_best_avail() will all wrap around and retry
[0, 2^32 - 8) after failing to search [2^32 - 8, 2^32). So if there are
free blocks in the first 8 block groups, the allocation will not fail.

>
> Alternatively, if we just do the check at the beginning, then 2**32 -
> 8 is a valid starting point, but if we just search forward by ngroups,
> then we may end up returning a block group which won't work for
> indirect mapped inodes.

Here, ngroups refers to the number of block groups available for
allocation, i.e. the range [0, ngroups), rather than implying that
ngroups groups are scanned on each pass. In general, we first scan the
[start, ngroups) portion of the xarrays, and then the [0, start) portion.

For indirect-mapped inodes, ext4_get_allocation_groups_count() returns
s_blockfile_groups. The end of those groups should not exceed 2^32 blocks;
otherwise, the s_blockfile_groups logic itself would be broken.

> Hence, in *every* function where we call
> ext4_get_allocaiton_groups_count(), if the goal is to search all block
> groups that are valid for indirect mapped inodes, and start might be
> greater than 0, we *have* to handle wraparound.
>
> Does that make sense?
>
Thanks for the detailed explanation, but I’m afraid I still don’t
quite follow.

Take `ext4_mb_scan_groups_p2_aligned` as an example:

ext4_mb_scan_groups
  ngroups = ext4_get_allocation_groups_count(ac); // safe
  start = ac->ac_g_ex.fe_group; // may be greater than ngroups
  ext4_mb_scan_groups_p2_aligned()
    start = group; // may be greater than ngroups
    end = ext4_get_allocation_groups_count(ac); // == ngroups
wrap_around:
    ext4_mb_scan_groups_xa_range(start, end)
      ngroups = ext4_get_allocation_groups_count(ac); // == end
        // `start` may exceed `end`, but `end` is always within bounds.
        // So we only need to make sure the `start` computed by
        // ext4_mb_scan_groups() is less than `ngroups`.
    // Forward scan failed; let the caller handle wrap-around.
    if (start) {
        end = start; // `end` may be invalid if `start` is invalid.
        start = 0;
        goto wrap_around;
    }

So it looks like the later start/end values only go wrong if the initial
start is already >= ngroups.

Did I miss something here?


Thanks,
Baokun

