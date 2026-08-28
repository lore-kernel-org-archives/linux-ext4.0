Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDCC364950;
	Fri, 28 Aug 2026 02:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787885332; cv=none; b=W9uJtyrBTATYh0shmY+pYlH3cSFjy3OwD+Mme0iaPu++BIlPgz/8byxg+7hBSKaYYMBI7j4Jp74POfGei6tEYzbtDuJO2EkUEObXCOPvFOZHwr8kE/FJqZhvGIW2sctwfhnT9rXSF8x11dCd0q3q26e+swOGpxWiCJVflIniwsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787885332; c=relaxed/simple;
	bh=a534VKCJpgJHYaSDX+fqzyy3bXd9xWPq0gq8LxDR/xQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JzKApvNMZIIipb39ZHQmd7BEzoGmzzLhLs3KV0kRUAzVPir2WNAxbsTs28pN+PzOhGjzeahopDAvgmwv2l9WKA5Twlb3hXdFhw+6gJvWqfN4+PRCcXTmoZgHRigOiAJ+prXzoSelzKjMi1q/zyB9DYd+cB4KQKhM4edfgdTuci4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BXg8ers9; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BXg8ers9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787885320; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DuRxDoDziUk9uWatqTDIUUsjQ7S9vnzkdYkPkz7h+kU=;
	b=BXg8ers9Cef8TM5Cuh2A4b2cIBWOMGiJygfhvyEBSlnvjD6rjl8YuaFSWgAxB3peZ6e3Az5TH/ByUuFAdofYdH5Kw5zrNtpwV8iGdvsVfagVkweX+kZeTPicWxydCMnLhZFxwwGFg4hfF/Ahbkk0rQwdphwxGOmAc1Y4L61rkPE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X9l4CfN_1787885318;
Received: from 30.221.131.225(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X9l4CfN_1787885318 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 10:48:39 +0800
Message-ID: <3d3a1fdc-9d65-4524-9957-a872595e3621@linux.alibaba.com>
Date: Fri, 28 Aug 2026 10:48:38 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
References: <20260827125158.4030598-1-senozhatsky@chromium.org>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260827125158.4030598-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/8/27 20:50, Sergey Senozhatsky wrote:
> We observe the following ABBA deadlock (casefolding enabled):
>
>  INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
>  task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
>  Call Trace:
>   <TASK>
>   __schedule+0xc2c/0xe60
>   schedule+0x40/0xe0
>   jbd2_journal_wait_updates+0x8f/0xf0
>   jbd2_journal_commit_transaction+0x321/0x1850
>   kjournald2+0xa9/0x230
>   kthread+0x226/0x2a0
>   ret_from_fork+0x101/0x1e0
>   ret_from_fork_asm+0x1a/0x30
>
>  INFO: task Thread-10:4161 blocked for more than 720 seconds.
>  task:Thread-10       state:D stack:0     pid:4161  tgid:3848  ppid:540
>  Call Trace:
>   <TASK>
>   __schedule+0xc2c/0xe60
>   schedule+0x40/0xe0
>   wait_transaction_locked+0x8c/0xd0
>   start_this_handle+0x252/0x870
>   jbd2__journal_start+0x120/0x280
>   __ext4_journal_start_sb+0x11a/0x250
>   ext4_evict_inode+0x208/0x760
>   iput+0x222/0x5c0
>   dput+0x293/0x690
>   ____fput+0x145/0x2b0
>   task_work_run+0x7a/0xb0
>   exit_to_user_mode_loop+0xc0/0xd0
>   do_syscall_64+0x14b/0xf10
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
>  NMI backtrace for cpu 0
>  CPU: 0 UID: 1010216 PID: 4160 Comm: Thread-7
>  RIP: 0010:d_walk+0x0/0x290
> [..]
>  Call Trace:
>  <TASK>
>   shrink_dcache_parent+0xb2/0x100
>   d_invalidate+0x50/0x110
>   ext4_rmdir+0x3a2/0x3d0
>   vfs_rmdir+0x9d/0x1d0
>   do_rmdir+0xf0/0x330
>   __x64_sys_unlinkat+0x34/0x50
>   do_syscall_64+0x61/0xf10
>
> The problem is that ext4_rmdir() calls d_invalidate() before stopping
> the jbd2 transaction handle.  Because d_invalidate() traverses child
> dentries it can encounter dying or in-use dentries.  If a concurrent
> thread executing __dentry_kill() on a child dentry invokes ext4_evict_inode(),
> it requests a new transaction handle via ext4_journal_start(), which
> waits for all running handles to close.  However, the thread executing
> ext4_rmdir() still holds its active transaction handle while looping
> in shrink_dcache_parent() waiting for the dying child dentry to complete
> eviction.
>
> Stop transaction handle in ext4_rmdir() before calling d_invalidate().
>
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Co-developed-by: Sarthak Kukreti <sarthakkukreti@google.com>
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Looks good!

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/namei.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a6386c1d237f..231a274b814e 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3209,19 +3209,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
>  	ext4_fc_track_unlink(handle, dentry);
>  	retval = ext4_mark_inode_dirty(handle, dir);
>  
> +end_rmdir:
> +	brelse(bh);
> +	if (handle)
> +		ext4_journal_stop(handle);
> +
>  	/* VFS negative dentries are incompatible with Encoding and
>  	 * Case-insensitiveness. Eventually we'll want avoid
>  	 * invalidating the dentries here, alongside with returning the
>  	 * negative dentries at ext4_lookup(), when it is better
>  	 * supported by the VFS for the CI case.
>  	 */
> -	if (IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
> +	if (!retval && IS_ENABLED(CONFIG_UNICODE) && IS_CASEFOLDED(dir))
>  		d_invalidate(dentry);
>  
> -end_rmdir:
> -	brelse(bh);
> -	if (handle)
> -		ext4_journal_stop(handle);
>  	return retval;
>  }
>  


