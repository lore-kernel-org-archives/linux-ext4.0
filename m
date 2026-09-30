Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBB91E1E16;
	Wed, 30 Sep 2026 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790732736; cv=none; b=MKjjeEuQM582pRkixSNbhGE382fTpZY3xrRVcEMKmL716ZXHYbnTWUuHCPug8bproNFCPJOUIosBp8JBGwgNNNxmcmxLAlIsrl019biwi6zchDduu2FoNdt/dico9Rc6F0wGt83zd6PMQOSFFa5+iKjO7DcB5d7BB4ykNxvLPdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790732736; c=relaxed/simple;
	bh=x6drF3W3qXwfuliwgwhdjNfR7CtzZbW4vshVRgGjIzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+oy0LXcaxMbeQ6e6BeuV4HAvHIZ1x/4tAOuacWzYNqUlBMvbr0GBe/jzPc69f00QfZl7tZabkxybMBaX/d25KT+OJHkrnfELuZRLlPG4ZJcV37bi4tdUoUU+t5u7zFeTm2lAeZ7lgFoDyT9yjqp7T1/GbzbiShCkltIu/nyec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hvdCK1jxMzYQtmt;
	Wed, 30 Sep 2026 09:45:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 62B244056D;
	Wed, 30 Sep 2026 09:45:29 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgC31Ce3abxqKzjCCA--.51766S3;
	Wed, 30 Sep 2026 09:45:29 +0800 (CST)
Message-ID: <f8e677df-4896-415d-9795-e15362be6b92@huaweicloud.com>
Date: Wed, 30 Sep 2026 09:45:26 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huawei.com>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260929-fix-ext4-es-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260929-fix-ext4-es-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC31Ce3abxqKzjCCA--.51766S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKFy3Jry5uF1DCF48WFyfZwb_yoW3trW3pF
	ZxC345tr4rXa1q9ws7XFn7Wryakw48CrWUGr9I9ryFkF1FgFyftF47KryjvF1Yy3y8Xr4j
	vw4qgr1Du34jva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/29/2026 10:20 AM, Qiliang Yuan wrote:
> The extents_status shrinker's count_objects() callback,
> ext4_es_count(), reports the number of shrinkable extent_status
> objects via a percpu counter. do_shrink_slab() reads this count
> exactly once per invocation and derives a one-shot scan budget
> (total_scan) from it, then repeatedly calls scan_objects() in
> fixed-size batches until that budget is exhausted.
> 
> ext4_es_scan() never updates sc->nr_scanned, even though
> include/linux/shrinker.h documents that "the callee should track
> its actual progress" in that field. Because sc->nr_scanned defaults
> to sc->nr_to_scan before every call, do_shrink_slab() always
> believes a full batch was examined, regardless of what __es_shrink()
> actually did. When __es_shrink() makes no progress and returns having
> examined nothing, do_shrink_slab() has no way to tell "there was
> nothing to scan" from "a full batch was scanned and none of it was
> freeable". It keeps calling scan_objects() until the original,
> one-shot total_scan budget is drained, even though nothing in this
> reclaim pass can make further progress.
> 
> Make __es_shrink() report the number of extent_status objects it
> actually examined through a new nr_scanned output parameter, derived
> from the existing per-extent nr_to_scan counter that es_reclaim_extents()
> already decrements as it walks the tree. Have ext4_es_scan() copy this
> value into sc->nr_scanned, and return SHRINK_STOP once nr_scanned comes
> back as zero.
> 
> nr_scanned can come back as zero for more than one reason:
> sbi->s_es_list can be genuinely empty, every inode walked this call
> can have been momentarily skipped (precached, or lock contended), or
> every inode walked can have had nothing currently shrinkable
> (es_reclaim_extents() returns immediately without touching nr_to_scan
> whenever an inode's shrinkable extent count is zero, independent of
> locking). Treat all of these the same rather than only returning
> SHRINK_STOP for a genuinely empty list: retrying instead, on the
> assumption that the other cases are transient, leaves
> do_shrink_slab()'s own scan budget undecremented whenever nr_scanned
> stays zero, so it never terminates.
> 
> Tested by fallocate(2)-ing 10000 4K files (to populate the shrinker
> with reclaimable unwritten extents without also exercising the
> extent_status "referenced" second-chance path, which needs a
> separate two-pass accounting of its own) and triggering
> "echo 2 > /proc/sys/vm/drop_caches", while tracing the
> ext4_es_shrink* tracepoints:
> 
>                       total scan_objects()   calls with
>                       calls                  nr_shrunk == 0
>   before this patch   429                    189 (44%)
>   after this patch    165                    1 (0.6%)
>   after (rerun)        242                    1 (0.4%)
> 
> nr_skipped stayed at 0 throughout every run, confirming the wasted
> calls came from the stale one-shot budget racing ahead of the real
> list state, not from the existing precached/trylock skip paths.
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Hi, Qiliang!

Thank you for the patch, this overall makes sense to me, just some
suggestions below.

> ---
> V1 -> V2:
> - Correct the comment and commit message: nr_scanned == 0 is not
>   only reachable when sbi->s_es_list is genuinely empty, also when
>   every inode walked was skipped or had nothing currently
>   shrinkable. No code or test data changes.
> 
> v1: https://lore.kernel.org/r/20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com
> ---
>  fs/ext4/extents_status.c | 37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..95e0f2d453257 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -184,7 +184,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  			      struct extent_status *prealloc);
>  static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
>  static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> -		       struct ext4_inode_info *locked_ei);
> +		       struct ext4_inode_info *locked_ei, int *nr_scanned);


It looks like the locked_ei parameter is no longer used. If you are
available, could you add a patch to remove it as well?


>  static int __revise_pending(struct inode *inode, ext4_lblk_t lblk,
>  			    ext4_lblk_t len,
>  			    struct pending_reservation **prealloc);
> @@ -1670,7 +1670,7 @@ void ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  }
>  
>  static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> -		       struct ext4_inode_info *locked_ei)
> +		       struct ext4_inode_info *locked_ei, int *nr_scanned)
>  {
>  	struct ext4_inode_info *ei;
>  	struct ext4_es_stats *es_stats;
> @@ -1679,6 +1679,7 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  	int nr_to_walk;
>  	int nr_shrunk = 0;
>  	int retried = 0, nr_skipped = 0;
> +	int orig_nr_to_scan = nr_to_scan;
>  
>  	es_stats = &sbi->s_es_stats;
>  	start_time = ktime_get();
> @@ -1738,6 +1739,8 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  		nr_shrunk = es_reclaim_extents(locked_ei, &nr_to_scan);
>  
>  out:
> +	*nr_scanned = orig_nr_to_scan - nr_to_scan;
> +
>  	scan_time = ktime_to_ns(ktime_sub(ktime_get(), start_time));
>  	if (likely(es_stats->es_stats_scan_time))
>  		es_stats->es_stats_scan_time = (scan_time +
> @@ -1774,15 +1777,41 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  {
>  	struct ext4_sb_info *sbi = shrink->private_data;
>  	int nr_to_scan = sc->nr_to_scan;
> -	int ret, nr_shrunk;
> +	int ret, nr_shrunk, nr_scanned;
>  
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
>  
> -	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL);
> +	nr_shrunk = __es_shrink(sbi, nr_to_scan, NULL, &nr_scanned);
> +	sc->nr_scanned = nr_scanned;


I'm a bit concerned that modifying sc->nr_scanned here could actually
end up increasing the number of scan_objects() calls in real-world
usage. If there are other background processes running and continuously
accessing certain files, they may keep producing a small number of new
reclaimable extent caches. That would mean nr_scanned stays at a
relatively small value on each iteration and never drops to 0, so
shrinker->scan_objects() may end up going through more loops because it
can't return SHRINK_STOP. So I'd tend to leave shrinkctl->nr_scanned
alone. What do you think?


>  
>  	ret = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
>  	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
> +
> +	/*
> +	 * nr_scanned == 0 does not necessarily mean sbi->s_es_list is empty:
> +	 * es_stats_shk_cnt is a percpu counter and can report a stale/
> +	 * approximate value that is still positive after the list has
> +	 * actually drained, but nr_scanned also stays 0 when every inode
> +	 * __es_shrink() walked this call was momentarily skipped (precached,
> +	 * or lock contended) or had nothing currently shrinkable
> +	 * (es_reclaim_extents() returns without touching nr_to_scan whenever
> +	 * ei->i_es_shk_nr is 0, which can persist for a given inode
> +	 * independent of locking).
> +	 *
> +	 * Treat all of these the same and return SHRINK_STOP rather than
> +	 * only doing so for a genuinely empty list: retrying instead, on
> +	 * the assumption that the other cases are transient, does not
> +	 * decrement do_shrink_slab()'s own scan budget when nr_scanned
> +	 * stays 0, so it never terminates. Without SHRINK_STOP here,
> +	 * do_shrink_slab() also has no way to tell "nothing was there" from
> +	 * "nothing was scanned yet" and will keep calling us with the same
> +	 * stale freeable count until its scan budget for this priority
> +	 * level is exhausted one batch at a time.
> +	 */

This comment seems a bit verbose, could it be simplified a bit?

Thanks,
Yi.

> +	if (nr_scanned == 0)
> +		return SHRINK_STOP;
> +
>  	return nr_shrunk;
>  }
>  
> 
> ---
> base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
> change-id: 20260928-fix-ext4-es-scan-nr-scanned-5af70744f6cd
> 
> Best regards,

