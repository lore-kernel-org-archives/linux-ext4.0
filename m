Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778BE391E46;
	Thu, 16 Apr 2026 08:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776329635; cv=none; b=FjxZeg3LP0nm+8GWCht1jLNPRectXpCn6WW0JhWHGn6EtwCi38KaceQt5JYId7NWUhPhvF1dLEe+0ltTuBDGHU6Ug/pbPU1ZBrYmBl9gacGCVLE9QOaifZBjhjbOm2MkgtJsr+CeK5RM0lE8G7TBxT6AYMflw2htFb9nao2ioRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776329635; c=relaxed/simple;
	bh=OPVTPRZGR0iXXQJeWObQcKNhY7i2HwdtEW8TVPVEu/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WSOYEN2zlbpqgenxZorgikFvnvX4M+ExHq1WepEvTyAlH8dwg+0wp8Ji/dx3S7s6G0ik0PYtfHkuEEW8EYUVN6EjQXJCunJq2Fcyqdo8sNw1CrgnTvDV0QjjA5NYox/7FeYlWCokgqKXPkTqkIyCFrr69FCF7B3y7h+FEGtr1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fxBcx1zyZzKHMVq;
	Thu, 16 Apr 2026 16:53:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 47FBF4058F;
	Thu, 16 Apr 2026 16:53:48 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with SMTP id _Ch0CgBH9b6ao+BpkVljAg--.3631S3;
	Thu, 16 Apr 2026 16:53:48 +0800 (CST)
Message-ID: <669739fd-688a-44e0-9ee7-1378960f1f65@huaweicloud.com>
Date: Thu, 16 Apr 2026 16:53:46 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ext4: add mb_stats_clear for mballoc statistics
To: Baolin Liu <liubaolin12138@163.com>, tytso@mit.edu,
 adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangguanyu@vivo.com, Baolin Liu <liubaolin@kylinos.cn>
References: <20260414100212.95209-1-liubaolin12138@163.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260414100212.95209-1-liubaolin12138@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBH9b6ao+BpkVljAg--.3631S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF48Kr1rtFyUKw4DJrWkJFb_yoW7Ar1rpF
	sxJa4UCF1UX3WxuFs3Wa18W3ZYvw40k3yUWr4avw1S9FZIqryftF92qFy0vFy5ArW8J3Wk
	X3WYv3yDGr40937anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 4/14/2026 6:02 PM, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> Add a write-only mb_stats_clear sysfs knob to reset ext4 mballoc
> runtime statistics.This makes it easier to inspect allocator
> activity for a specific workload instead of using counters
> accumulated since mount.
> 
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>

Looks good to me!

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
>  fs/ext4/ext4.h    |  1 +
>  fs/ext4/mballoc.c | 31 +++++++++++++++++++++++++++++++
>  fs/ext4/sysfs.c   | 24 ++++++++++++++++++++++++
>  3 files changed, 56 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7617e2d454ea..3a32e1a515dd 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2995,6 +2995,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
>  extern const struct seq_operations ext4_mb_seq_groups_ops;
>  extern const struct seq_operations ext4_mb_seq_structs_summary_ops;
>  extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
> +extern void ext4_mb_stats_clear(struct ext4_sb_info *sbi);
>  extern int ext4_mb_init(struct super_block *);
>  extern void ext4_mb_release(struct super_block *);
>  extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bb58eafb87bc..382c91586b26 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3219,6 +3219,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
>  	}
>  	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
>  	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
> +	seq_printf(seq, "\tblocks_allocated: %u\n",
> +		   atomic_read(&sbi->s_bal_allocated));
>  
>  	seq_printf(seq, "\tgroups_scanned: %u\n",
>  		   atomic_read(&sbi->s_bal_groups_scanned));
> @@ -4721,6 +4723,35 @@ static void ext4_mb_collect_stats(struct ext4_allocation_context *ac)
>  		trace_ext4_mballoc_prealloc(ac);
>  }
>  
> +void ext4_mb_stats_clear(struct ext4_sb_info *sbi)
> +{
> +	int i;
> +
> +	atomic_set(&sbi->s_bal_reqs, 0);
> +	atomic_set(&sbi->s_bal_success, 0);
> +	atomic_set(&sbi->s_bal_allocated, 0);
> +	atomic_set(&sbi->s_bal_groups_scanned, 0);
> +
> +	for (i = 0; i < EXT4_MB_NUM_CRS; i++) {
> +		atomic64_set(&sbi->s_bal_cX_hits[i], 0);
> +		atomic64_set(&sbi->s_bal_cX_groups_considered[i], 0);
> +		atomic_set(&sbi->s_bal_cX_ex_scanned[i], 0);
> +		atomic64_set(&sbi->s_bal_cX_failed[i], 0);
> +	}
> +
> +	atomic_set(&sbi->s_bal_ex_scanned, 0);
> +	atomic_set(&sbi->s_bal_goals, 0);
> +	atomic_set(&sbi->s_bal_stream_goals, 0);
> +	atomic_set(&sbi->s_bal_len_goals, 0);
> +	atomic_set(&sbi->s_bal_2orders, 0);
> +	atomic_set(&sbi->s_bal_breaks, 0);
> +	atomic_set(&sbi->s_mb_lost_chunks, 0);
> +	atomic_set(&sbi->s_mb_buddies_generated, 0);
> +	atomic64_set(&sbi->s_mb_generation_time, 0);
> +	atomic_set(&sbi->s_mb_preallocated, 0);
> +	atomic_set(&sbi->s_mb_discarded, 0);
> +}
> +
>  /*
>   * Called on failure; free up any blocks from the inode PA for this
>   * context.  We don't need this for MB_GROUP_PA because we only change
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 923b375e017f..a5bd88a99f22 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -41,6 +41,7 @@ typedef enum {
>  	attr_pointer_atomic,
>  	attr_journal_task,
>  	attr_err_report_sec,
> +	attr_mb_stats_clear,
>  } attr_id_t;
>  
>  typedef enum {
> @@ -161,6 +162,25 @@ static ssize_t err_report_sec_store(struct ext4_sb_info *sbi,
>  	return count;
>  }
>  
> +static ssize_t mb_stats_clear_store(struct ext4_sb_info *sbi,
> +				    const char *buf, size_t count)
> +{
> +	int val;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	ret = kstrtoint(skip_spaces(buf), 0, &val);
> +	if (ret)
> +		return ret;
> +	if (val != 1)
> +		return -EINVAL;
> +
> +	ext4_mb_stats_clear(sbi);
> +	return count;
> +}
> +
>  static ssize_t journal_task_show(struct ext4_sb_info *sbi, char *buf)
>  {
>  	if (!sbi->s_journal)
> @@ -251,6 +271,7 @@ EXT4_ATTR_OFFSET(mb_best_avail_max_trim_order, 0644, mb_order,
>  EXT4_ATTR_OFFSET(err_report_sec, 0644, err_report_sec, ext4_sb_info, s_err_report_sec);
>  EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
>  EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
> +EXT4_ATTR(mb_stats_clear, 0200, mb_stats_clear);
>  EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
>  EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
>  EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
> @@ -301,6 +322,7 @@ static struct attribute *ext4_attrs[] = {
>  	ATTR_LIST(inode_readahead_blks),
>  	ATTR_LIST(inode_goal),
>  	ATTR_LIST(mb_stats),
> +	ATTR_LIST(mb_stats_clear),
>  	ATTR_LIST(mb_max_to_scan),
>  	ATTR_LIST(mb_min_to_scan),
>  	ATTR_LIST(mb_order2_req),
> @@ -561,6 +583,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
>  		return trigger_test_error(sbi, buf, len);
>  	case attr_err_report_sec:
>  		return err_report_sec_store(sbi, buf, len);
> +	case attr_mb_stats_clear:
> +		return mb_stats_clear_store(sbi, buf, len);
>  	default:
>  		return ext4_generic_attr_store(a, sbi, buf, len);
>  	}

