From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 xfstests-bld results for 3.8-rc6 on Pandaboard ES
Date: Mon, 11 Feb 2013 16:16:00 -0500
Message-ID: <20130211211600.GB14005@thunk.org>
References: <20130207220536.GA16092@wallace>
 <20130208035547.GA19703@gmail.com>
 <20130211013523.GD10801@thunk.org>
 <5119149C.1030602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47918 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab3BKVQH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 16:16:07 -0500
Content-Disposition: inline
In-Reply-To: <5119149C.1030602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 11, 2013 at 09:56:12AM -0600, Eric Sandeen wrote:
> 
> So the superset of failing tests seems to be:
> 
> 223 270 274 280
> 

Here is the results of running these failing tests with the dev ranch.
There is a regression; test 270 is failing with a kernel regression
with dioread_nolock.

					- Ted

[    0.000000] Linux version 3.8.0-rc3-00060-g17f71a7 (tytso@closure) (gcc version 4.7.2 (Debian 4.7.2-4) ) #848 SMP Mon Feb 11 15:27:06 EST 2013
FSTESTCFG is "all"
FSTESTSET is "223 270 274 280"
BEGIN TEST: Ext4 4k block Mon Feb 11 15:28:24 EST 2013
Ran: 223 270 274 280
Failures: 274 280
END TEST: Ext4 4k block Mon Feb 11 15:31:26 EST 2013
BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Mon Feb 11 15:31:42 EST 2013
Ran: 270 280
Failures: 270 280
END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Mon Feb 11 15:38:27 EST 2013
BEGIN TEST: Ext4 4k block w/ no journal Mon Feb 11 15:38:29 EST 2013
Ran: 223 270 274
Failures: 274
END TEST: Ext4 4k block w/ no journal Mon Feb 11 15:41:11 EST 2013
BEGIN TEST: Ext4 1k block Mon Feb 11 15:41:24 EST 2013
Ran: 223 270 274 280
Failures: 274 280
END TEST: Ext4 1k block Mon Feb 11 15:43:31 EST 2013
BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Mon Feb 11 15:43:34 EST 2013
Ran: 223 270 274 280
Failures: 223 270 274 280
END TEST: Ext4 4k block w/nodelalloc and no flex_bg Mon Feb 11 15:45:41 EST 2013
BEGIN TEST: Ext4 4k block w/metadata_csum Mon Feb 11 15:45:43 EST 2013
Ran: 223 270 274 280
Failures: 274 280
END TEST: Ext4 4k block w/metadata_csum Mon Feb 11 15:47:40 EST 2013
BEGIN TEST: Ext4 4k block w/dioread_nolock Mon Feb 11 15:47:40 EST 2013

FAILURE: kernel crash while running test 270:
270 72s ...[ 1223.638696] BUG: unable to handle kernel NULL pointer dereference at   (null)
[ 1223.641433] IP: [<c016fd26>] cwq_activate_delayed_work+0x1a/0x33
[ 1223.641433] *pdpt = 0000000008f17001 *pde = 0000000000000000 
[ 1223.641433] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[ 1223.641433] Modules linked in:
[ 1223.641433] Pid: 662, comm: kworker/u:2 Not tainted 3.8.0-rc3-00060-g17f71a7 #848 Bochs Bochs
[ 1223.641433] EIP: 0060:[<c016fd26>] EFLAGS: 00010046 CPU: 1
[ 1223.641433] EIP is at cwq_activate_delayed_work+0x1a/0x33
[ 1223.641433] EAX: 00000000 EBX: def7ddf0 ECX: 00001200 EDX: 00001200
[ 1223.641433] ESI: 00000000 EDI: 00000000 EBP: deb31e94 ESP: deb31e8c
[ 1223.641433]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 1223.641433] CR0: 8005003b CR2: 00000000 CR3: 08f16000 CR4: 000006f0
[ 1223.641433] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1223.641433] DR6: ffff0ff0 DR7: 00000400
[ 1223.641433] Process kworker/u:2 (pid: 662, ti=deb30000 task=deafc2a0 task.ti=deb30000)
[ 1223.641433] Stack:
[ 1223.641433]  de548200 00000006 deb31ea4 c016fd74 def7fe70 00000006 deb31efc c01712c9
[ 1223.641433]  deafc710 de57ce80 de57ce80 0019a806 c0e4a3b8 c027aa0d c0e4a388 de548200
[ 1223.641433]  c0e4a2c0 c0e4a3f0 de831940 c139c5e8 c0f2ea18 00000000 c0a768d9 00000000
[ 1223.641433] Call Trace:
[ 1223.641433]  [<c016fd74>] cwq_dec_nr_in_flight+0x35/0x69
[ 1223.641433]  [<c01712c9>] process_one_work+0x2ce/0x330
[ 1223.641433]  [<c027aa0d>] ? ext4_end_bio+0x1ce/0x1ce
[ 1223.641433]  [<c01715ae>] worker_thread+0xff/0x18d
[ 1223.641433]  [<c01714af>] ? rescuer_thread+0x15e/0x15e
[ 1223.641433]  [<c0174d7f>] kthread+0x79/0x7e
[ 1223.641433]  [<c019c55a>] ? trace_hardirqs_on+0xb/0xd
[ 1223.641433]  [<c0811937>] ret_from_kernel_thread+0x1b/0x28
[ 1223.641433]  [<c0174d06>] ? __kthread_parkme+0x59/0x59
[ 1223.641433] Code: c6 04 89 75 f0 75 c7 eb e6 89 19 58 5b 5e 5f 5d c3 55 89 e5 56 53 3e 8d 74 26 00 89 c3 e8 d1 f2 ff ff 89 c6 89 d8 e8 17 f9 ff ff <8b> 16 31 c9 89 d8 83 c2 08 e8 81 ff ff ff 0f ba 33 01 ff 46 4c
[ 1223.641433] EIP: [<c016fd26>] cwq_activate_delayed_work+0x1a/0x33 SS:ESP 0068:deb31e8c
[ 1223.641433] CR2: 0000000000000000
[ 1223.641433] ---[ end trace 5257cdc8eade6bdb ]---


