From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Sat, 21 Jun 2008 15:02:50 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806211446110.19212@diagnostix.dwd.de>
References: <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
 <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu>
 <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker>
 <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de>
 <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker>
 <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu>
 <Pine.LNX.4.64.0806200805520.3383@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:55417 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbYFUPCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Jun 2008 11:02:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by node2.dwd.de (Postfix) with ESMTP id 3E8344A46B7
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 15:02:53 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node2.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 32631-16 for <linux-ext4@vger.kernel.org>;
	Sat, 21 Jun 2008 15:02:53 +0000 (UTC)
In-Reply-To: <Pine.LNX.4.64.0806200805520.3383@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 20 Jun 2008, Holger Kiehl wrote:

> On Thu, 19 Jun 2008, Theodore Tso wrote:
>
>> I have a
>> suspicion that the problem may have been introduced by the delayed
>> allocation code, but I don't have hard evidence.  When you rerun your
>> benchmark (which seems to be the closest thing we have to a
>> reproduction case), it would be interesting to know if the problem
>> goes away with -o nodelalloc (again, it would localize where we need
>> to look).
>> 
> Ok I will do thats soon as I have a system available.
>
No, with nodelalloc the problem does not occur. I can now very reliably
repoduce the problem if I run the benchmark for 5 minutes and then unmount
the filesystem and remount it. Anything else I can do to find the problem?

During testing on a newly setup system (used the same kernel 2.6.26-rc5+ext4-
patch-queue) I have hit two oopses:

------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:1931!
invalid opcode: 0000 [1] SMP 
CPU 3 
Modules linked in: w83627hf lm85 hwmon_vid bonding ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables binfmt_misc sg floppy ohci_hcd i2c_amd756 k8temp i2c_core button usbcore
Pid: 242, comm: pdflush Not tainted 2.6.26-rc5 #4
RIP: 0010:[<ffffffff802dd1c5>]  [<ffffffff802dd1c5>] ext4_normal_writepage+0x27/0xd8
RSP: 0018:ffff81007f329c20  EFLAGS: 00010246
RAX: 0a0000000001002d RBX: ffffe20006f658c8 RCX: 00000000ffffffe8
RDX: 0000000000004278 RSI: ffff81007f329e50 RDI: ffffe20006f658c8
RBP: ffff81007f329e50 R08: ffff81027ff054c0 R09: ffff81007f329b60
R10: 0000000000000040 R11: 0000000000000040 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fbc99d8b6f0(0000) GS:ffff81027ff0e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f64c0d43488 CR3: 00000001efa65000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process pdflush (pid: 242, threadinfo ffff81007f328000, task ffff81007fbc3d30)
Stack:  0000000000000000 ffff810149bc41d0 ffff81007f329e50 ffffffff8026179a
  ffffe20006f658c8 ffffffff80261f57 ffff810149bc41d0 ffffffff80261790
  ffff810149bc41d0 0000000180241154 ffff8101ff6caea0 ffffffffffffffff
Call Trace:
  [<ffffffff8026179a>] ? __writepage+0xa/0x27
  [<ffffffff80261f57>] ? write_cache_pages+0x1bb/0x30d
  [<ffffffff80261790>] ? __writepage+0x0/0x27
  [<ffffffff802620ec>] ? do_writepages+0x27/0x2d
  [<ffffffff8029f66e>] ? __writeback_single_inode+0x16f/0x35e
  [<ffffffff8029fc8b>] ? sync_sb_inodes+0x283/0x3b8
  [<ffffffff802a0014>] ? writeback_inodes+0x89/0xde
  [<ffffffff80262620>] ? background_writeout+0x8f/0xc9
  [<ffffffff80262c74>] ? pdflush+0x122/0x1c9
  [<ffffffff80262591>] ? background_writeout+0x0/0xc9
  [<ffffffff80262b52>] ? pdflush+0x0/0x1c9
  [<ffffffff8023e3e7>] ? kthread+0x47/0x73
  [<ffffffff8022ae3a>] ? schedule_tail+0x27/0x5c
  [<ffffffff8020bf78>] ? child_rip+0xa/0x12
  [<ffffffff8023e3a0>] ? kthread+0x0/0x73
  [<ffffffff8020bf6e>] ? child_rip+0x0/0x12


Code: 3e 8c fc ff 55 48 89 f5 53 48 89 fb 48 83 ec 08 48 8b 47 18 48 8b 00 48 8b 50 68 48 8b 07 a8 01 75 04 0f 0b eb fe f6 c4 08 75 04 <0f> 0b eb fe 48 89 d0 81 e2 ff 0f 00 00 48 8b 77 10 48 c1 f8 0c 
RIP  [<ffffffff802dd1c5>] ext4_normal_writepage+0x27/0xd8
  RSP <ffff81007f329c20>
---[ end trace 82357a26b61bf3d2 ]---
------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:1931!
invalid opcode: 0000 [2] SMP 
CPU 3 
Modules linked in: w83627hf lm85 hwmon_vid bonding ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables binfmt_misc sg floppy ohci_hcd i2c_amd756 k8temp i2c_core button usbcore
Pid: 7896, comm: dir_check Tainted: G      D   2.6.26-rc5 #4
RIP: 0010:[<ffffffff802dd1c5>]  [<ffffffff802dd1c5>] ext4_normal_writepage+0x27/0xd8
RSP: 0018:ffff810172ee1d78  EFLAGS: 00010246
RAX: 0a0000000001002d RBX: ffffe200063cd890 RCX: 00000000ffffffe8
RDX: 0000000000004278 RSI: ffff810172ee1eb8 RDI: ffffe200063cd890
RBP: ffff810172ee1eb8 R08: ffff81027ff054c0 R09: ffff810172ee1cb8
R10: ffff810250e6ac80 R11: ffff810250e6a080 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f3778d0e6f0(0000) GS:ffff81027ff0e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3778d25000 CR3: 000000027ecd8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dir_check (pid: 7896, threadinfo ffff810172ee0000, task ffff81017f0fa6f0)
Stack:  0000000000000000 ffff81024ed0c8c0 ffff810172ee1eb8 ffffffff8026179a
  ffffe200063cd890 ffffffff80261f57 ffff81024ed0c8c0 ffffffff80261790
  ffff81024ed0c8c0 0000000500000000 ffff8101ff6caea0 0007ffffffffffff
Call Trace:
  [<ffffffff8026179a>] ? __writepage+0xa/0x27
  [<ffffffff80261f57>] ? write_cache_pages+0x1bb/0x30d
  [<ffffffff80261790>] ? __writepage+0x0/0x27
  [<ffffffff8028ea23>] ? fasync_helper+0x47/0xc8
  [<ffffffff80286f15>] ? cp_new_stat+0xe9/0xfc
  [<ffffffff802921b3>] ? __posix_lock_file+0x43d/0x44e
  [<ffffffff802620ec>] ? do_writepages+0x27/0x2d
  [<ffffffff8025c44f>] ? __filemap_fdatawrite_range+0x4a/0x55
  [<ffffffff802568c8>] ? audit_syscall_exit+0x2ee/0x30c
  [<ffffffff802a28e1>] ? do_fsync+0x2f/0x87
  [<ffffffff80270af7>] ? sys_msync+0x107/0x178
  [<ffffffff8020b2d2>] ? tracesys+0xd5/0xda


Code: 3e 8c fc ff 55 48 89 f5 53 48 89 fb 48 83 ec 08 48 8b 47 18 48 8b 00 48 8b 50 68 48 8b 07 a8 01 75 04 0f 0b eb fe f6 c4 08 75 04 <0f> 0b eb fe 48 89 d0 81 e2 ff 0f 00 00 48 8b 77 10 48 c1 f8 0c 
RIP  [<ffffffff802dd1c5>] ext4_normal_writepage+0x27/0xd8
  RSP <ffff810172ee1d78>
---[ end trace 82357a26b61bf3d2 ]---
SysRq : Show Blocked State
   task                        PC stack   pid father
dir_check     D ffff810181e03eb8     0  7873      1
  ffff8101eea3dc48 0000000000000082 0000000000000096 ffff81007ec39ec0
  ffffffff80600cc0 0000000000000000 ffff81027ff8a658 ffff8101eea21bd0
  ffff81007f395370 ffff8101eea21e08 000000017ff8a640 ffff8101eea21e08
Call Trace:
  [<ffffffff80224a67>] __wake_up+0x38/0x4f
  [<ffffffff8025b87d>] sync_page+0x0/0x41
  [<ffffffff804660f0>] io_schedule+0x2d/0x39
  [<ffffffff8025b8b9>] sync_page+0x3c/0x41
  [<ffffffff804663d4>] __wait_on_bit+0x41/0x70
  [<ffffffff8025bb32>] wait_on_page_bit+0x6b/0x71
  [<ffffffff8023e724>] wake_bit_function+0x0/0x23
  [<ffffffff8026940b>] do_wp_page+0x46a/0x4ba
  [<ffffffff8026aac1>] handle_mm_fault+0x62d/0x6a3
  [<ffffffff80299236>] mntput_no_expire+0x27/0x11e
  [<ffffffff8021ed0c>] do_page_fault+0x435/0x825
  [<ffffffff802921b3>] __posix_lock_file+0x43d/0x44e
  [<ffffffff8029260e>] fcntl_setlk+0x285/0x296
  [<ffffffff802568c8>] audit_syscall_exit+0x2ee/0x30c
  [<ffffffff80467699>] error_exit+0x0/0x51

Holger

