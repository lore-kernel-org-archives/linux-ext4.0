From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: fix xfstest generic/299 block validity failures
Date: Tue, 18 Feb 2014 16:36:15 -0500
Message-ID: <20140218213615.GA2227@wallace>
References: <20140210200414.GA2155@wallace>
 <20140212154403.GB14520@thunk.org>
 <20140218144627.GP26580@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:60160 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaBRVgT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Feb 2014 16:36:19 -0500
Received: by mail-qc0-f169.google.com with SMTP id w7so26863840qcr.0
        for <linux-ext4@vger.kernel.org>; Tue, 18 Feb 2014 13:36:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140218144627.GP26580@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
> On Wed, Feb 12, 2014 at 10:44:03AM -0500, Theodore Ts'o wrote:
> > On Mon, Feb 10, 2014 at 03:04:14PM -0500, Eric Whitney wrote:
> > > Commit a115f749c1 (ext4: remove wait for unwritten extent conversion from
> > > ext4_truncate) exposed a bug in ext4_ext_handle_uninitialized_extents().
> > > It can be triggered by xfstest generic/299 when run on a test file
> > > system created without a journal.  
> 
> Hey Eric, I'm still seeing generic/299 failures in the nojournal case,
> although instead of block validity errors, they are ENOSPC errors:
> 
> generic/299 192s ...	[05:55:05][16439.429067] EXT4-fs warning (device vdc): ext4_convert_unwritten_extents:4725: inode #15: block 692480: len 32: ext4_ext_map_blocks returned -28
> [16441.203606] EXT4-fs warning (device vdc): ext4_convert_unwritten_extents:4725: inode #14: block 258688: len 32: ext4_ext_map_blocks returned -28
> [16441.508472] EXT4-fs warning (device vdc): ext4_convert_unwritten_extents:4725: inode #14: block 257792: len 32: ext4_ext_map_blocks returned -28
> 	       .
> 	       .
> 	       .
> [16479.132762] EXT4-fs warning (device vdc): ext4_convert_unwritten_extents:4725: inode #15: block 739808: len 32: ext4_ext_map_blocks returned -28
>  [05:56:18] [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/299.out.bad)
>     --- tests/generic/299.out	2014-02-16 22:20:24.000000000 -0500
>     +++ /root/xfstests/results//generic/299.out.bad	2014-02-18 05:56:18.816438707 -0500
>     @@ -3,3 +3,5 @@
>      Run fio with random aio-dio pattern
>      
>      Start fallocate/truncate loop
>     +failed: '/root/xfstests/bin/fio /tmp/22707.fio'
>     +(see /root/xfstests/results//generic/299.full for details)
>     ...
>     (Run 'diff -u tests/generic/299.out /root/xfstests/results//generic/299.out.bad'  to see the entire diff)
> 
> 
> I'm also seeing a soft lockup warning with generic/299 when using a 1k
> block:
> 
> generic/299 192s ...	[08:26:39][25800.514234] INFO: task umount:655 blocked for more than 120 seconds.
> [25800.515135]       Not tainted 3.14.0-rc2 #1604
> [25800.515764] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [25800.516824]  e1b9ddac 00000046 c0df1b40 e1b9c000 00000ddc 00000000 00000000 00001752
> [25800.518038]  c8c563d0 e1b9dd68 c0138b9f 00000000 e1b9dd98 c018fac4 0003fb49 00000000
> [25800.519225]  f63b2140 85ba09ee 00001752 85ba081b 00001752 00000001 f63b2140 00000000
> [25800.520411] Call Trace:
> [25800.520756]  [<c0138b9f>] ? sched_clock+0x9/0xc
> [25800.521395]  [<c018fac4>] ? sched_clock_local+0x11/0xfa
> [25800.522105]  [<c018fdcd>] ? sched_clock_cpu+0xc6/0xe7
> [25800.522794]  [<c07b26f8>] schedule+0x63/0x65
> [25800.523374]  [<c07b1c4a>] schedule_timeout+0x1a/0x99
> [25800.524046]  [<c019e398>] ? mark_held_locks+0x5b/0x72
> [25800.524777]  [<c07b5623>] ? _raw_spin_unlock_irq+0x27/0x36
> [25800.525518]  [<c019e4fd>] ? trace_hardirqs_on_caller+0x14e/0x169
> [25800.526338]  [<c019e523>] ? trace_hardirqs_on+0xb/0xd
> [25800.527023]  [<c07b5628>] ? _raw_spin_unlock_irq+0x2c/0x36
> [25800.527887]  [<c07b2d2d>] __wait_for_common+0xc4/0xee
> [25800.528586]  [<c07b1c30>] ? ieee80211_assoc_success+0x95e/0x95e
> [25800.529386]  [<c018df97>] ? wake_up_state+0x11/0x11
> [25800.530044]  [<c07b2d70>] wait_for_completion+0x19/0x1c
> [25800.530748]  [<c02562bf>] writeback_inodes_sb_nr+0xc2/0xcd
> [25800.531507]  [<c07b2c9a>] ? __wait_for_common+0x31/0xee
> [25800.532222]  [<c02562e8>] writeback_inodes_sb+0x1e/0x22
> [25800.532931]  [<c0259be5>] sync_filesystem+0x3b/0x8c
> [25800.533594]  [<c0238d56>] generic_shutdown_super+0x22/0xcd
> [25800.534351]  [<c0238f9f>] kill_block_super+0x22/0x63
> [25800.535026]  [<c0239188>] deactivate_locked_super+0x25/0x42
> [25800.535788]  [<c02395cb>] deactivate_super+0x31/0x34
> [25800.536462]  [<c024e235>] mntput_no_expire+0xd5/0xf1
> [25800.537134]  [<c024efbd>] SYSC_umount+0x283/0x29a
> [25800.537793]  [<c024f0ac>] SyS_oldumount+0x1f/0x21
> [25800.538590]  [<c07bbec6>] sysenter_do_call+0x12/0x38
> [25800.539330] 1 lock held by umount/655:
> [25800.539864]  #0:  (&type->s_umount_key#19){++++++}, at: [<c02395c4>] deactivate_super+0x2a/0x34
>  [08:31:50] 311s
> 
> Have you seen either of these in your testing?
> 

Hi Ted -

We discussed the ENOSPC warnings from ext4_ext_map_blocks() in a concall a
couple of weeks ago.  They were visible in my testing both before and after
my patch on both x86-64 and ARM, and are very reproducible.  I don't believe
they're directly related to the block validity problem, although they appeared
simultaneously with it after commit a115f749c1.  In the concall, you
mentioned you were going to take a look, so I set them aside to look at a few
other problems. I'd be happy to pick that up again if you'd like - just let
me know.

(It's unclear whether it's relevant, but I'll note that I'm getting warnings
from the extent status tree debugging code (ES_AGGRESSIVE_TEST) even after my
patch when running generic/299 nojournal - an item I've made a note to come
back to.)

The 299 test failure you're seeing could be due to the version of fio you're
running.  I don't recall all the details, but when upgrading my test
environment in preparation for 3.14 I found that the current version of fio
at the time would fail.  I chose to stay with what worked for my 3.13 runs -
fio-2.1.4-8-g3e26 (commit 3e260a46ea).  It might be worth trying that to see
if you get a clean run.

I've not seen that softlockup warning on x86-64 or ARM on the 1K or any other
test case (nor any softlockup warnings at all in 3.14 through -rc3).  Also, it
did not appear during the full xfstests runs of my patch on x86-64 and ARM
prior to posting.

That's the kind of warning I'd hope to see when running generic/208 and the
umount happens late.  Unfortunately, not.

Thanks,
Eric


