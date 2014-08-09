From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: fuzz testing an ext4fs file system under a 32 bit Linux user
 mode linux guest let task jbd2/ubda hang
Date: Sat, 09 Aug 2014 20:45:43 +0200
Message-ID: <53E66C57.8010303@gmx.de>
References: <53DE3E92.3060304@gmx.de> <20140803184210.GV24826@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	UML devel <user-mode-linux-devel@lists.sourceforge.net>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57364 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaHISps (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 14:45:48 -0400
In-Reply-To: <20140803184210.GV24826@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/03/2014 08:42 PM, Theodore Ts'o wrote:
> On Sun, Aug 03, 2014 at 03:52:18PM +0200, Toralf F=C3=B6rster wrote:
>> Hello,
>>
>> fuzzying a 32 bit stable Gentoo x86 linux with trinity (and without =
excluding the munmap syscall but it might be independed from this) give=
s within a 32 bit user mode linux guest :
>=20
> The problem with these sorts of trinity bug reports is that we have n=
o
> idea which syscall or set of syscalls might have corrupted kernel
> state to the point where the kernel started malfunctioning.
>=20
> Sometimes, a trinity induced bug is obvious, when it causes a system
> call to immediately access an illegal memory location.  But if it
> causes some more subtle corruption, possibly in a completely unrelate=
d
> subsystem, figuring out what actually happened can be close to
> impossible.
>=20
> So there's not much I can do with this sort of bug report.  If you ca=
n
> easily repeat it, and you can dump out the system call stream, we
> might be able to make a smaller reproduction case, at which point
> trying to debug this sort of failure would be tractable.
>=20
> Cheers,
>=20
> 						- Ted
>=20
ok, fair enough.


BTW may I just ask, if the following (same 32 bit system, host and UML =
guest are both at v3.16, 4 trinity childs hammering victims files in a =
ramdisk within the uML guest) matches the above too ? Or does the BUG o=
utput here more helpful data ? :


Kernel panic - not syncing: BUG!
CPU: 0 PID: 105 Comm: kworker/u2:2 Not tainted 3.16.0 #2
Workqueue: writeback bdi_writeback_workfn (flush-98:0)
Stack:
 085be12e 085be12e 00000003 086e8547 0000000c 000002b3 85177cc4 85177c7=
4
 085015c3 00000000 85177c48 85177c9c 084fd6dd 085c9dc0 08727180 085bae4=
a
 85177ca8 00000000 0000000c 000002b3 85177cc4 85177d10 0818ec0f 085bae4=
a
Call Trace:
 [<085015c3>] dump_stack+0x26/0x28
 [<084fd6dd>] panic+0x8f/0x1a9
 [<0818ec0f>] mpage_release_unused_pages+0x11f/0x1b0
 [<0819395a>] ext4_writepages+0x42a/0x640
 [<080d87e5>] do_writepages+0x25/0x50
 [<0812fd2c>] __writeback_single_inode+0x3c/0xf0
 [<08130064>] writeback_sb_inodes+0x1d4/0x320
 [<08130214>] __writeback_inodes_wb+0x64/0xa0
 [<08130501>] wb_writeback+0xf1/0x190
 [<081308a2>] bdi_writeback_workfn+0xa2/0x2d0
 [<08504c56>] ? _raw_spin_unlock_irq+0x16/0x20
 [<0809e30c>] ? finish_task_switch.constprop.52+0x3c/0x90
 [<08091474>] process_one_work+0x184/0x2f0
 [<080918da>] worker_thread+0x2fa/0x540
 [<08504c3c>] ? _raw_spin_unlock_irqrestore+0x1c/0x20
 [<08502d65>] ? schedule+0x55/0x60
 [<080915e0>] ? worker_thread+0x0/0x540
 [<080971b6>] kthread+0xd6/0xe0
 [<0805f68b>] new_thread_handler+0x6b/0x90



--=20
Toralf

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
