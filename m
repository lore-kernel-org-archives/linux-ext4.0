Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B070878F4A;
	Tue, 17 Mar 2026 06:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729128; cv=none; b=O33+7kPO239qSD5u0+q4reb6eqakHCUY60kr4Gd3qmZqh6idJ/DCTpCjYIRTDRXyrlk24375uZ8HRF137sgaKMwi7LliP4MGd2ibGsm8A+TkY2akDayBO5mOPJVC3auMstXch0K7fPeUdAl8QO1Q7RH80n3oVV2LITArKs4C2Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729128; c=relaxed/simple;
	bh=SmzjEUPZwsFE/pJKO4SYDQENZOpI/eAx5M56KVBI4RI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDDlivTQilQMgaQgM5fr99AzEhRQMyUoQy1JGzwvcseobDHC5ugtlP0R4XKG5OMV/1AGqrAOVal9hI/IOTcc/UX+VPuJjrYDKhYHvN18LL2sKoRCprvlgT0v2y7E3LMXfUO19DIQl2bNsmnZDIYKvJh5eS7ggHXRWhAern9A0OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=J6A1EVCb; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="J6A1EVCb"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773729122; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iKgmgUZ2NdT5cBd3dYW90T1ooVdZfeIB6q4PDhYYig8=;
	b=J6A1EVCbpAqcls+jAXP8bAROcI/KvS9AKfMLrVeqJpOCyudEyUjphQJYwoxLJ0GuarhCs5U4LSZ6bW1ooXiNj5QAMO6/6xNX+uywAianECpYQb/gdz8gLOmjDNrvDFhWyXXWozYiDD1duF8MMuSsft+OMCQ3Zp1+egOs0efUMvI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.9zd3i_1773729121;
Received: from 30.221.130.194(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X.9zd3i_1773729121 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 14:32:02 +0800
Message-ID: <5e747089-7fc8-4230-b9e2-65e479fcebab@linux.alibaba.com>
Date: Tue, 17 Mar 2026 14:32:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix possible NULL pointer dereference in
 ext4_group_desc_free()
To: Zqiang <qiang.zhang@linux.dev>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com
References: <20260316082025.9574-1-qiang.zhang@linux.dev>
 <e275a80b-df14-4d05-9334-b10d2e57fbbc@linux.alibaba.com>
 <584a552d5b5cf7554f4a1c607e62f308436ff3eb@linux.dev>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <584a552d5b5cf7554f4a1c607e62f308436ff3eb@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 3/17/26 7:33 AM, Zqiang wrote:
>> On 3/16/26 4:20 PM, Zqiang wrote:
>>
>>> This can happen if the kvmalloc_objs() fails and sbi->s_group_desc pointer
>>>  is NULL in the ext4_group_desc_init(), and then the ext4_group_desc_free()
>>>  is called, leading to a NULL group_desc pointer dereference.
>>>
>>>  This commit therefore adds a NULL check for sbi->s_group_desc before
>>>  accessing its internal members.
>>>
>>>  Signed-off-by: Zqiang <qiang.zhang@linux.dev>
>>>  ---
>>>  fs/ext4/super.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>>  diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>>>  index 43f680c750ae..c4307dc04687 100644
>>>  --- a/fs/ext4/super.c
>>>  +++ b/fs/ext4/super.c
>>>  @@ -1256,9 +1256,11 @@ static void ext4_group_desc_free(struct ext4_sb_info *sbi)
>>>  
>>>  rcu_read_lock();
>>>  group_desc = rcu_dereference(sbi->s_group_desc);
>>>  - for (i = 0; i < sbi->s_gdb_count; i++)
>>>
>> In ext4_group_desc_init(), s_gdb_count is only assigned after kvmalloc_array
>> allocation succeeds. Therefore, when kvmalloc_array fails, the
>> brelse(group_desc[i]) in ext4_group_desc_free() will not actually be
>> executed,
>> and thus this NULL pointer dereference issue will not be triggered.
>
> Thanks for replay, got it, sorry for make noise.
>
> Just then, I find that warning may be trigger:
>
> the kvfree() is called in RCU read critical section, if
> the sbi->s_group_desc pointer comes from vmalloc(),
> the vfree() is called to release it, but the might_sleep()
> is called in the vfree(), this may be trigger warnings in
> rcu_sleep_check() when the enable CONFIG_DEBUG_ATOMIC_SLEEP.

Indeed, vfree triggers the following warning: ```
===========================================================================
EXT4-fs (vdc): unmounting filesystem
c478da00-c52c-4dd4-81c1-d4f93e12ab50. BUG: sleeping function called from
invalid context at mm/vmalloc.c:3441 in_atomic(): 0, irqs_disabled(): 0,
non_block: 0, pid: 457, name: umount preempt_count: 0, expected: 0 RCU
nest depth: 1, expected: 0 CPU: 0 UID: 0 PID: 457 Comm: umount Tainted:
G W 6.19.0-rc4-g4f5e8e6f0123-dirty #10 PREEMPT(none) Tainted: [W]=WARN
Call Trace: <TASK> dump_stack_lvl+0x55/0x70 __might_resched+0x116/0x160
vfree+0x38/0x60 ext4_put_super+0x1ac/0x490
generic_shutdown_super+0x81/0x180 kill_block_super+0x1a/0x40
ext4_kill_sb+0x22/0x40 deactivate_locked_super+0x35/0xb0
cleanup_mnt+0x101/0x170 task_work_run+0x5c/0xa0
exit_to_user_mode_loop+0xe2/0x460 do_syscall_64+0x1de/0x1f0
entry_SYSCALL_64_after_hwframe+0x76/0x7e
===========================================================================
``` And ext4_mb_init_backend, ext4_mb_release, ext4_flex_groups_free
have similar issues.Indeed, vfree triggers the following warning:

===========================================================================
EXT4-fs (vdc): unmounting filesystem c478da00-c52c-4dd4-81c1-d4f93e12ab50.
BUG: sleeping function called from invalid context at mm/vmalloc.c:3441
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 457, name: umount
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
CPU: 0 UID: 0 PID: 457 Comm: umount Tainted: G W
               6.19.0-rc4-g4f5e8e6f0123-dirty #10 PREEMPT(none)
Tainted: [W]=WARN
Call Trace:
 <TASK>
 dump_stack_lvl+0x55/0x70
 __might_resched+0x116/0x160
 vfree+0x38/0x60
 ext4_put_super+0x1ac/0x490
 generic_shutdown_super+0x81/0x180
 kill_block_super+0x1a/0x40
 ext4_kill_sb+0x22/0x40
 deactivate_locked_super+0x35/0xb0
 cleanup_mnt+0x101/0x170
 task_work_run+0x5c/0xa0
 exit_to_user_mode_loop+0xe2/0x460
 do_syscall_64+0x1de/0x1f0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
===========================================================================

And ext4_mb_init_backend, ext4_mb_release, ext4_flex_groups_free have
similar issues.

> May be use rcu_access_pointer() to access sbi->s_group_desc
> is enough.
>
Yes, these are all initialization or teardown paths and cannot run
concurrently with
online resize, so using rcu_access_pointer() seems sufficient.

Also, should we add might_sleep() to kvfree() to prevent similar issues?


Cheers,
Baokun

