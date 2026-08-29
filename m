Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6721FC0;
	Sat, 29 Aug 2026 09:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787997223; cv=none; b=dBzMybc3gQSJKfSdpwmiva+R60IT61SzILML47GXnvrFsnlqOdJCmxLT0BjUMR2UfkFdO5E4PhoNCaHvvpZvxplmNMakznL0YzjM7flRsVLjK+B5wDhKC57lmn+gjgin37xGrGxZ34/wioYgixpzAT1aAEonXQNw4t14KDRryQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787997223; c=relaxed/simple;
	bh=y/3AJvrn8vqj5hYm56p+hFDhUFyt5DA7uMOcuShnznU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bF44cDRPrE6fmHsM0Dgs5OLNmgNjJdXSK/QoOQ2xV9H3kOqBI//7/AdE2IQlTAuC+z435oY+O7cNAr4U3x2lcRsuPdeiDSvWRgJ0B3zAgm6qn+yUBBQaEtqURt4gDmyg9fv22CzvVGbHYJwh13Q3uL63TEh6jSJB0ercWL88nFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hX9YB6bdlzYQtwC;
	Sat, 29 Aug 2026 17:53:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id EACF940577;
	Sat, 29 Aug 2026 17:53:36 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBXR0YerJJqEm1XEA--.46628S3;
	Sat, 29 Aug 2026 17:53:36 +0800 (CST)
Message-ID: <916789eb-394b-4e65-9a7c-51a1f8ac737b@huaweicloud.com>
Date: Sat, 29 Aug 2026 17:53:33 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
References: <20260827125158.4030598-1-senozhatsky@chromium.org>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260827125158.4030598-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBXR0YerJJqEm1XEA--.46628S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr47KF1fJF4kWryrXw17Awb_yoWrJr48pF
	Z3KryjyrW8Zry8uF4xWr48XrW0vay0qryUJr93K340ya9aq3Z3tFnFqFyjqFy7ArW5u3Wr
	XF4jkr9Iga1Yy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
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

On 8/27/2026 8:50 PM, Sergey Senozhatsky wrote:
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

Thank you for the fix patch, this issue is quite subtle.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

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

