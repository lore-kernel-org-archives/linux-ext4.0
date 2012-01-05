From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] jbd2: jbd2_journal_stop needs an exclusive control
 to synchronize around t_update operations
Date: Wed, 4 Jan 2012 22:12:40 -0500
Message-ID: <20120105031240.GC24494@thunk.org>
References: <20111216201915.4a012154.toshi.okajima@jp.fujitsu.com>
 <CAGBYx2YZ4M8QwwOcnLAaf+934WAcZoNS_pPrw8j3Nkr3=6fA5g@mail.gmail.com>
 <4EF066F0.5010809@jp.fujitsu.com>
 <20111222203639.4200538e.toshi.okajima@jp.fujitsu.com>
 <20111222205650.fe9d1b36.toshi.okajima@jp.fujitsu.com>
 <20120103153245.GE31457@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	adilger.kernel@dilger.ca, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56998 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757852Ab2AEDMs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 22:12:48 -0500
Content-Disposition: inline
In-Reply-To: <20120103153245.GE31457@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 03, 2012 at 04:32:45PM +0100, Jan Kara wrote:
>   Thanks for the analysis. Actually, you fix adds unnecessary overhead.
> The problem really is the wrong ordering of prepare_to_wait() and t_updates
> check. So attached patch should fix the issue as well without introducing
> the overhead.

Thanks, applied.

						- Ted


> From 1cd5b8178893f3f186ce93eb1f47664a1a3e81fc Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 3 Jan 2012 16:13:29 +0100
> Subject: [PATCH] jbd2: Fix hung processes in jbd2_journal_lock_updates()
> 
> Toshiyuki Okajima found out that when running
> 
> for ((i=0; i < 100000; i++)); do
>         if ((i%2 == 0)); then
>                 chattr +j /mnt/file
>         else
>                 chattr -j /mnt/file
>         fi
>         echo "0" >> /mnt/file
> done
> 
> process sometimes hangs indefinitely in jbd2_journal_lock_updates().
> 
> Toshiyuki identified that the following race happens:
> 
> jbd2_journal_lock_updates()            |jbd2_journal_stop()
> ---------------------------------------+---------------------------------------
>  write_lock(&journal->j_state_lock)    |    .
>  ++journal->j_barrier_count            |    .
>  spin_lock(&tran->t_handle_lock)       |    .
>  atomic_read(&tran->t_updates) //not 0 |
>                                        | atomic_dec_and_test(&tran->t_updates)
>                                        |    // t_updates = 0
>                                        | wake_up(&journal->j_wait_updates)
>  prepare_to_wait()                     |    // no process is woken up.
>  spin_unlock(&tran->t_handle_lock)     |
>  write_unlock(&journal->j_state_lock)  |
>  schedule() // never return            |
> 
> We fix the problem by first calling prepare_to_wait() and only after that
> checking t_updates in jbd2_journal_lock_updates().
> 
> Reported-and-analyzed-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
