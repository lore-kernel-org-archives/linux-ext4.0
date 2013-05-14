From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] xfstest269 causes deadlock on linux-3.9.0 (ext4)
Date: Tue, 14 May 2013 23:37:55 +0200
Message-ID: <20130514213755.GA10769@quack.suse.cz>
References: <51908CF4.2000703@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395Ab3ENVh7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 May 2013 17:37:59 -0400
Content-Disposition: inline
In-Reply-To: <51908CF4.2000703@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Mon 13-05-13 15:49:24, Akira Fujita wrote:
> I ran into the deaclock with xfs_test 269 on linux-3.9.0.
> It seems happen between jbd2_log_wait_commit, sleep_on_buffer
> and writeback_indoes (Please see ps log below).
> Once it occurs we can't touch FS anymore.
> In my case 300 - 1000 trials to occur. Is this known issue?
> 
> The following kernels seems to have same problem:
> - linux-3.5-rc5
> - linux-3.8.5
> - linux-3.9-rc7
> And now I'm trying it on linux-3.10-rc1.
> 
> # ./check generic/269
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 mcds1 3.9.0
> MKFS_OPTIONS  -- /dev/sda12
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda12 /mnt/mp2
> 
> 
> # ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:16,comm
>   PID   TID CLS RTPRIO  NI PRI PSR %CPU STAT WCHAN            COMMAND
>     1     1 TS       -   0  19   0  0.0 Ss   poll_schedule_ti init
>     2     2 TS       -   0  19   0  0.0 S    kthreadd         kthreadd
>     3     3 TS       -   0  19   0  0.0 S    smpboot_thread_f ksoftirqd/0
> ...
>  2391  2391 TS       -   0  19   2  0.1 D    jbd2_log_wait_co flush-8:0
> ...
> 22647 22647 TS       -   0  19   3  0.0 S    worker_thread    kworker/3:1
> 22655 22655 TS       -   0  19   0  0.0 S    hrtimer_nanoslee sleep
> 22657 22657 TS       -   0  19   2  0.0 R+   -                ps
> 25330 25330 TS       -   0  19   0  0.0 S    worker_thread    kworker/0:0
> 28963 28963 TS       -   0  19   1  0.0 S+   wait             loop_xfstests.s
> 28964 28964 TS       -   0  19   1  0.0 S+   wait             check
> 29180 29180 TS       -   0  19   3  0.0 S    kjournald2       jbd2/sda11-8
> 29181 29181 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
> 29199 29199 TS       -   0  19   3  0.0 S+   wait             269
> 29391 29391 TS       -   0  19   0  0.6 D    sleep_on_buffer  jbd2/sda12-8
> 29392 29392 TS       - -20  39   3  0.0 S<   rescuer_thread   ext4-dio-unwrit
> 29394 29394 TS       -   0  19   0  0.0 S    wait             fsstress
> 29505 29505 TS       -   0  19   3  0.0 D    writeback_inodes fsstress
> 
> # df -T /dev/sda11 /dev/sda12
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sda11    ext4     9857264     22308   9327564   1% /mnt/mp1
> /dev/sda12    ext4      499656    499656         0 100% /mnt/mp2
  Thanks for report. No I don't think this problem has been reported
before. Seeing that sda12 is out of space and fsstress hangs in
writeback_inodes(), I suspect we have some deadlock in ENOSPC recovery path
when we want to flush data to disk to reduce delalloc uncertainty. Can you
run 'echo w >/proc/sysrq-trigger' when the deadlock happens and post your
dmesg here? Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
