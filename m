Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1403618C332;
	Wed, 30 Sep 2026 03:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790739100; cv=none; b=B/1cATY7DcM6HSCTC2rD8W+ieCIP3SukCsYyWg7UDaI1sPdkPY0cxW0WFnW7DMq62Iznz3/5d6td8J/NrMrm/LsfyUwK8PP8sRnc3EUAaRJ06pshjK4Bt7XC3LSZAL5coNaLCEODDjV6y6B9SdO1xK51StI1vYcWVSDfLxZDwdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790739100; c=relaxed/simple;
	bh=Un2SsvgbEIYgTgglYDKydmgeK1/yp2bvZlCHIFZMC20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hxCG0wS609Cp9nwX69I0W0dOnoWaG0kWf9fnoBM09lL/DL1j3SR8G483xhc+LT7+9xMb0hEhF2ierOcc8MPgyWY7H4cE4XZD5+FPxnAf9G7ePTX5o2E2W9F9bdXPYrfpyOopJPikqeoxUZybQfkvD5UCz9ssM9qUYQ2Jf3vyoDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hvgYP07n1zKHLtg;
	Wed, 30 Sep 2026 11:30:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B36D140561;
	Wed, 30 Sep 2026 11:31:25 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVimLgrxqfWvLCA--.49391S3;
	Wed, 30 Sep 2026 11:31:25 +0800 (CST)
Message-ID: <0a0bc36f-e1de-42c5-8126-e577d4c7f998@huaweicloud.com>
Date: Wed, 30 Sep 2026 11:31:23 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCHVimLgrxqfWvLCA--.49391S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr1rKF1xGF18uw1xGw1UGFg_yoW7GrW8pF
	Z3K3y8trZ3Zr9rtr17Z3WkGFWUuw4kZry7Gr9xur1Iyw4rWF13XrW3KrWUWrWjkryxKa1a
	vrsFgFn3W340kaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/28/2026 10:44 PM, Qiliang Yuan wrote:
> jbd2_journal_shrink_checkpoint_list() already tracks its examined
> checkpoint buffers accurately: it decrements its nr_to_scan in/out
> parameter for every journal_head walked, whether or not it gets freed.
> jbd2_journal_shrink_scan(), the shrinker's scan_objects() callback,
> never surfaces that into sc->nr_scanned.
> 
> Because sc->nr_scanned defaults to sc->nr_to_scan before every call,
> do_shrink_slab() always assumes a full batch was examined and keeps
> calling scan_objects() until the one-shot budget derived from the
> (possibly stale) percpu checkpoint count is drained, even when every
> buffer in the checkpoint list is busy and nothing gets freed.
> 
> Derive sc->nr_scanned from the difference between the nr_to_scan value
> passed in and the value left behind by
> jbd2_journal_shrink_checkpoint_list(). Trigger SHRINK_STOP on
> nr_shrunk == 0 (nothing freed) instead of leaving do_shrink_slab() to
> keep calling us: a checkpoint list full of buffers that are still busy
> being written back can honestly report a full batch scanned while
> freeing nothing, and retrying immediately within the same synchronous
> reclaim pass will not make any of that in-flight writeback complete
> sooner.
> 
> Tested by creating 20000 small files without an explicit sync (to let
> jbd2's normal 5-second commit timer move them onto the checkpoint list
> while their buffers are still busy being written back) and then
> triggering "echo 2 > /proc/sys/vm/drop_caches", tracing jbd2_shrink_*:
> 
>               scan_objects() calls   calls with nr_shrunk == 0
>   before             176                    176 (100%)
>   after                8                      8 (100%)
> 
> Fixes: 4ba3fcdde7e3 ("jbd2,ext4: add a shrinker to release checkpointed buffers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
> V2 -> V3:
> - Rebase onto v7.3-rc5. It already includes Max Kellermann's
>   "jbd2: bound shrinker scans by examined checkpoint buffers"
>   (15cb16496446), which independently fixes the busy-buffer
>   accounting in journal_shrink_one_cp_list()/
>   jbd2_journal_shrink_checkpoint_list() that v2 also touched. Drop
>   the now-redundant checkpoint.c changes; this revision only touches
>   journal.c, reusing the accurate nr_to_scan tracking Kellermann's
>   fix already provides.
> - Add a Fixes: tag for the commit that introduced
>   jbd2_journal_shrink_scan() without ever setting sc->nr_scanned.
> - Re-measure test data against the new baseline (176 -> 8 calls,
>   vs the old baseline's 168 -> 7).
> 
> V1 -> V2:
> - Count examined buffers, not just freed ones, in
>   journal_shrink_one_cp_list() (Sashiko AI review finding).
> - Trigger SHRINK_STOP on nr_shrunk == 0 instead of
>   sc->nr_scanned == 0.
> 
> v2: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com
> v1: https://lore.kernel.org/r/20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com
> ---
>  fs/jbd2/journal.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4fe..a61b7a59c0a0e 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1263,10 +1263,27 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
>  	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
>  
>  	nr_shrunk = jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
> +	sc->nr_scanned = sc->nr_to_scan - nr_to_scan;

Similar to your patch "ext4: fix shrinker scan budget accounting in
ext4_es_scan()", I'd tend to leave sc->nr_scanned alone. Your issue
should be resolved by simply returning SHRINK_STOP when nr_shrunk is
0, right or is there some other benefit to modifying nr_scanned?

Thanks,
Yi.
>  
>  	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
>  
> +	/*
> +	 * Give up on this reclaim pass if this call didn't manage to free
> +	 * anything. This is deliberately based on nr_shrunk, not on
> +	 * sc->nr_scanned: a checkpoint list can be full of buffers that are
> +	 * still busy being written back, in which case a call can
> +	 * legitimately scan (and correctly report through sc->nr_scanned)
> +	 * a full batch of them without freeing a single one. Retrying
> +	 * immediately within the same synchronous reclaim pass is not going
> +	 * to let any of that in-flight writeback complete any sooner, so
> +	 * there is nothing to gain from letting do_shrink_slab() keep
> +	 * calling us against the same stale freeable count until its
> +	 * one-shot scan budget for this priority level is exhausted.
> +	 */
> +	if (nr_shrunk == 0)
> +		return SHRINK_STOP;
> +
>  	return nr_shrunk;
>  }
>  
> 
> ---
> base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
> change-id: 20260928-fix-jbd2-shrink-scan-nr-scanned-c3098cd901e2
> 
> Best regards,

