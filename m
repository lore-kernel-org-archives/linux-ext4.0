From: Wolfgang Walter <linux@stwm.de>
Subject: Re: JBD2: Spotted dirty metadata buffer....
Date: Mon, 28 Nov 2016 12:26:38 +0100
Message-ID: <10283498.RxsF1TCk0q@stwm.de>
References: <1744886.OgPgGFoXj7@stwm.de> <11848279.gFnWiZMlh7@stwm.de> <6EBBE85C-8A87-4D8B-9897-3D67D4B6D732@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6EBBE85C-8A87-4D8B-9897-3D67D4B6D732@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am Mittwoch, 23. November 2016, 16:40:07 schrieb Andreas Dilger:
> On Nov 23, 2016, at 3:43 AM, Wolfgang Walter <linux@stwm.de> wrote:
> > Am Dienstag, 22. November 2016, 16:02:53 schrieben Sie:
> >> On Nov 22, 2016, at 6:56 AM, Wolfgang Walter <linux@stwm.de> wrote:
> >>> Am Montag, 21. November 2016, 17:49:36 schrieben Sie:
> >>>> On Nov 21, 2016, at 8:28 AM, Wolfgang Walter <linux@stwm.de> wrote:
> >>>>> Hello,

[snip]

> Stepping back a bit - does this problem only happen with an external
> journal device, or does it also happen with an internal journal?
> 

So I tried that this weekend. I got again these messages 

JBD2: Spotted dirty metadata buffer (dev = dm-22, blocknr = 241763277). There's a risk of filesystem corruption in case of system crash.

So this also happens with an internal journal.

I think it has something to do with data=journal + writing fast a lot of data and removing and/or moving a files at the same time.

I then tried it again with an internal journal but without the option journal_async_commit. I got these messages again. This time though, after some time running, the rsync got stuck in D state. I waited more than an hour but it did not recover. According to iostat there was no IO any more. I couldn't access the filesystem any more, ls -l oder touch got stuck in D state, too. I didn't get any kernel message, though. top reported the whole time one cpu (and always the same one) with about 100% wa time. No process but top itself seemed to be active.

I never had that with external journal + journal_async_commit. When I run bonnie++ and copied large amount of data with dd at the same time I got some problems. But then the filesystem recovered every time, and I got messages like that one:

INFO: task dd:16705 blocked for more than 120 seconds.
      Tainted: G            E   4.8.8-debian64.all+1.1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
dd              D ffff9d70dfc18700     0 16705  16503 0x00000004
 ffff9d686ab53000 ffff9d70d2897080 ffff9d713fffbb80 024280ca8d8d1e9c
 ffff9d70af8ac000 ffff9d70af8aba58 ffff9d90a94840ec ffff9d686ab53000
 00000000ffffffff ffff9d90a94840f0 ffffffff8e7ee6f1 ffff9d90a94840e8
Call Trace:
 [<ffffffff8e7ee6f1>] ? schedule+0x31/0x80
 [<ffffffff8e7ee98a>] ? schedule_preempt_disabled+0xa/0x10
 [<ffffffff8e7f0574>] ? __mutex_lock_slowpath+0xb4/0x130
 [<ffffffff8e7f060b>] ? mutex_lock+0x1b/0x30
 [<ffffffffc042e32f>] ? __jbd2_log_wait_for_space+0x7f/0x1e0 [jbd2]
 [<ffffffffc0428384>] ? add_transaction_credits+0x284/0x2a0 [jbd2]
 [<ffffffff8e2eb31f>] ? add_timer+0x12f/0x220
 [<ffffffffc04284ff>] ? start_this_handle+0x10f/0x420 [jbd2]
 [<ffffffffc0428c99>] ? jbd2__journal_start+0xe9/0x1f0 [jbd2]
 [<ffffffffc0530595>] ? ext4_setattr+0x205/0x880 [ext4]
 [<ffffffff8e4226d9>] ? notify_change+0x229/0x430
 [<ffffffff8e401cf2>] ? do_truncate+0x72/0xc0
 [<ffffffff8e412fa8>] ? path_openat+0x388/0x14d0
 [<ffffffff8e415371>] ? do_filp_open+0x91/0x100
 [<ffffffff8e3b92cc>] ? handle_mm_fault+0xd1c/0x14b0
 [<ffffffff8e4031d7>] ? do_sys_open+0x127/0x210
 [<ffffffff8e7f2ab6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8

INFO: task bonnie++:19693 blocked for more than 120 seconds.
      Tainted: G            E   4.8.8-debian64.all+1.1 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bonnie++        D ffff9d70dfad8700     0 19693  16248 0x00000000
ffff9d70b0287040 ffff9d70d289c0c0 ffffffff8e2c7266 ffff9d70b18e4000
ffff9d70b18e4000 ffff9d70b18e3aa0 ffff9d90a94840ec ffff9d70b0287040
  00000000ffffffff ffff9d90a94840f0 ffffffff8e7ee6f1 ffff9d90a94840e8
 Call Trace:
  [<ffffffff8e2c7266>] ? mutex_optimistic_spin+0x176/0x1c0
  [<ffffffff8e7ee6f1>] ? schedule+0x31/0x80
  [<ffffffff8e7ee98a>] ? schedule_preempt_disabled+0xa/0x10
  [<ffffffff8e7f0574>] ? __mutex_lock_slowpath+0xb4/0x130
  [<ffffffff8e7f060b>] ? mutex_lock+0x1b/0x30
  [<ffffffffc042e32f>] ? __jbd2_log_wait_for_space+0x7f/0x1e0 [jbd2]
  [<ffffffffc0428384>] ? add_transaction_credits+0x284/0x2a0 [jbd2]
  [<ffffffffc04284ff>] ? start_this_handle+0x10f/0x420 [jbd2]
  [<ffffffffc0428c99>] ? jbd2__journal_start+0xe9/0x1f0 [jbd2]
  [<ffffffffc052e2b5>] ? ext4_write_begin+0x125/0x4f0 [ext4]
  [<ffffffff8e37f0f3>] ? generic_perform_write+0xd3/0x1d0
  [<ffffffff8e381a46>] ? __generic_file_write_iter+0x196/0x1e0
  [<ffffffffc05231b6>] ? ext4_file_write_iter+0x196/0x3d0 [ext4]
  [<ffffffff8e40365b>] ? __vfs_write+0xeb/0x160
  [<ffffffff8e4047f3>] ? vfs_write+0xb3/0x1a0
  [<ffffffff8e405bf2>] ? SyS_write+0x52/0xc0
  [<ffffffff8e7f2ab6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8

But there was IO both on the filesystem and the journal (the devices of the filesystem is slower then the device the journal sits on).


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
