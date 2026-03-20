Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C3A6FC5;
	Fri, 20 Mar 2026 02:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974877; cv=none; b=nnQ5A+BgHRiv1nW6vcnd2VrgkVN63uypu139xNH0M7wUhkQ9XphSL8sL7hA0J19RDBTiQwzWnCTPPCpz2ZS4QHq5W80UrbO/s8lqIffbnSmwwZwuhNBFlrMKPzsSc4Lk0kGA6as8vLVAIcJfT4+gcLHGQuuj8GMjtZte0zPkzEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974877; c=relaxed/simple;
	bh=5sDgx/ZVtGv4newKhl43zVMUOjyRE/Fvs3dDeL7Jd7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYTHMIjZOtf37w4kleJ/9gssooEC4WxLXz0cPlu//eV459PgMl19bw0hr1vezL1N+oE8Jx8hCiO5X4IXCVE9B/pOD25SA/ngABWBov8JqVJC+Sr+i0kPhzQ9USmvBJdGW9jX4ssDzsFIhfWDCcc5/nkYh06lVUcOZFAnfEBvB3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jvSAqOW9; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jvSAqOW9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773974866; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4Ip+RIOBCQEjYNw1VYfwJ1MDIzy6WlZYhjDTZX3ZfaI=;
	b=jvSAqOW9lwjrNhjw5BCn2HXswQpZaq3gKqNcn+Q9en0wdMLOIMPVMyTpdCk0NeO0Zf72496N7/pDLNWKkIkWrSVE3U6s0FSwECyXRzElW9FQvrLQZD4Yf/HaG6qd0YVYoD5oZ8SGLrAotssRaxxEMHSyVziWsgjO7j8fvIJa5Ss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.K9PgI_1773974865;
Received: from 30.221.129.199(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X.K9PgI_1773974865 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 10:47:45 +0800
Message-ID: <4f2ee7d7-0812-49b0-a7d7-81cb833119d1@linux.alibaba.com>
Date: Fri, 20 Mar 2026 10:47:43 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix the might_sleep() warnings in kvfree()
To: Zqiang <qiang.zhang@linux.dev>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, libaokun@linux.alibaba.com
References: <20260319094545.19291-1-qiang.zhang@linux.dev>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260319094545.19291-1-qiang.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/19/26 5:45 PM, Zqiang wrote:
> Use the kvfree() in the RCU read critical section can trigger
> the following warnings:
>
> EXT4-fs (vdb): unmounting filesystem cd983e5b-3c83-4f5a-a136-17b00eb9d018.
>
> WARNING: suspicious RCU usage
>
> ./include/linux/rcupdate.h:409 Illegal context switch in RCU read-side critical section!
>
> other info that might help us debug this:
>
> rcu_scheduler_active = 2, debug_locks = 1
>
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xbb/0xd0
>  dump_stack+0x14/0x20
>  lockdep_rcu_suspicious+0x15a/0x1b0
>  __might_resched+0x375/0x4d0
>  ? put_object.part.0+0x2c/0x50
>  __might_sleep+0x108/0x160
>  vfree+0x58/0x910
>  ? ext4_group_desc_free+0x27/0x270
>  kvfree+0x23/0x40
>  ext4_group_desc_free+0x111/0x270
>  ext4_put_super+0x3c8/0xd40
>  generic_shutdown_super+0x14c/0x4a0
>  ? __pfx_shrinker_free+0x10/0x10
>  kill_block_super+0x40/0x90
>  ext4_kill_sb+0x6d/0xb0
>  deactivate_locked_super+0xb4/0x180
>  deactivate_super+0x7e/0xa0
>  cleanup_mnt+0x296/0x3e0
>  __cleanup_mnt+0x16/0x20
>  task_work_run+0x157/0x250
>  ? __pfx_task_work_run+0x10/0x10
>  ? exit_to_user_mode_loop+0x6a/0x550
>  exit_to_user_mode_loop+0x102/0x550
>  do_syscall_64+0x44a/0x500
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> BUG: sleeping function called from invalid context at mm/vmalloc.c:3441
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 556, name: umount
> preempt_count: 1, expected: 0
> CPU: 3 UID: 0 PID: 556 Comm: umount
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xbb/0xd0
>  dump_stack+0x14/0x20
>  __might_resched+0x275/0x4d0
>  ? put_object.part.0+0x2c/0x50
>  __might_sleep+0x108/0x160
>  vfree+0x58/0x910
>  ? ext4_group_desc_free+0x27/0x270
>  kvfree+0x23/0x40
>  ext4_group_desc_free+0x111/0x270
>  ext4_put_super+0x3c8/0xd40
>  generic_shutdown_super+0x14c/0x4a0
>  ? __pfx_shrinker_free+0x10/0x10
>  kill_block_super+0x40/0x90
>  ext4_kill_sb+0x6d/0xb0
>  deactivate_locked_super+0xb4/0x180
>  deactivate_super+0x7e/0xa0
>  cleanup_mnt+0x296/0x3e0
>  __cleanup_mnt+0x16/0x20
>  task_work_run+0x157/0x250
>  ? __pfx_task_work_run+0x10/0x10
>  ? exit_to_user_mode_loop+0x6a/0x550
>  exit_to_user_mode_loop+0x102/0x550
>  do_syscall_64+0x44a/0x500
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The above scenarios occur in initialization failures and teardown
> paths, there are no parallel operations on the resources released
> by kvfree(), this commit therefore remove rcu_read_lock/unlock() and
> use rcu_access_pointer() instead of rcu_dereference() operations.
>
> Fixes: 7c990728b99e ("ext4: fix potential race between s_flex_groups online resizing and access")
> Fixes: df3da4ea5a0f ("ext4: fix potential race between s_group_info online resizing and access")
> Signed-off-by: Zqiang <qiang.zhang@linux.dev>

Looks good, feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/mballoc.c | 10 +++-------
>  fs/ext4/super.c   |  8 ++------
>  2 files changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..e96513cc6151 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3580,9 +3580,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  	rcu_read_unlock();
>  	iput(sbi->s_buddy_cache);
>  err_freesgi:
> -	rcu_read_lock();
> -	kvfree(rcu_dereference(sbi->s_group_info));
> -	rcu_read_unlock();
> +	kvfree(rcu_access_pointer(sbi->s_group_info));
>  	return -ENOMEM;
>  }
>  
> @@ -3897,7 +3895,8 @@ void ext4_mb_release(struct super_block *sb)
>  		WARN_ON_ONCE(!list_empty(&sbi->s_discard_list));
>  	}
>  
> -	if (sbi->s_group_info) {
> +	group_info = rcu_access_pointer(sbi->s_group_info);
> +	if (group_info) {
>  		for (i = 0; i < ngroups; i++) {
>  			cond_resched();
>  			grinfo = ext4_get_group_info(sb, i);
> @@ -3915,12 +3914,9 @@ void ext4_mb_release(struct super_block *sb)
>  		num_meta_group_infos = (ngroups +
>  				EXT4_DESC_PER_BLOCK(sb) - 1) >>
>  			EXT4_DESC_PER_BLOCK_BITS(sb);
> -		rcu_read_lock();
> -		group_info = rcu_dereference(sbi->s_group_info);
>  		for (i = 0; i < num_meta_group_infos; i++)
>  			kfree(group_info[i]);
>  		kvfree(group_info);
> -		rcu_read_unlock();
>  	}
>  	ext4_mb_avg_fragment_size_destroy(sbi);
>  	ext4_mb_largest_free_orders_destroy(sbi);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 43f680c750ae..0b2fa7bd787f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1254,12 +1254,10 @@ static void ext4_group_desc_free(struct ext4_sb_info *sbi)
>  	struct buffer_head **group_desc;
>  	int i;
>  
> -	rcu_read_lock();
> -	group_desc = rcu_dereference(sbi->s_group_desc);
> +	group_desc = rcu_access_pointer(sbi->s_group_desc);
>  	for (i = 0; i < sbi->s_gdb_count; i++)
>  		brelse(group_desc[i]);
>  	kvfree(group_desc);
> -	rcu_read_unlock();
>  }
>  
>  static void ext4_flex_groups_free(struct ext4_sb_info *sbi)
> @@ -1267,14 +1265,12 @@ static void ext4_flex_groups_free(struct ext4_sb_info *sbi)
>  	struct flex_groups **flex_groups;
>  	int i;
>  
> -	rcu_read_lock();
> -	flex_groups = rcu_dereference(sbi->s_flex_groups);
> +	flex_groups = rcu_access_pointer(sbi->s_flex_groups);
>  	if (flex_groups) {
>  		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
>  			kvfree(flex_groups[i]);
>  		kvfree(flex_groups);
>  	}
> -	rcu_read_unlock();
>  }
>  
>  static void ext4_put_super(struct super_block *sb)
