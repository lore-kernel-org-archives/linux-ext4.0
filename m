From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: 2.6.23-rc9: Oops in cache_alloc_refill()  mm/slab.c
Date: Fri, 05 Oct 2007 15:06:43 -0700
Message-ID: <1191622003.3861.17.camel@localhost.localdomain>
References: <4705113A.7030908@bull.net>
	 <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
	 <47063EF3.4050302@bull.net>
	 <1191596057.6106.106.camel@dyn9047017100.beaverton.ibm.com>
	 <1191616252.3861.5.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42741 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634AbXJEWHJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2007 18:07:09 -0400
In-Reply-To: <1191616252.3861.5.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

-------- Forwarded Message --------
From: Valerie Clement <valerie.clement@bull.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc9: Oops in cache_alloc_refill() mm/slab.c
Date: 	Thu, 04 Oct 2007 18:13:46 +0200
While running ffsb tests on my ext4 filesystem, I got an Oops in 
cache_alloc_refill().
I turned on SLAB debugging and here is the message I got:

slab: Internal list corruption detected in cache 'buffer_head'(30), 
slabp ffff81007e100100(1515870810). Hexdump:

=======================>

slabp->inuse counter looks corrupted (1515870810), it should not greater
than cachep->num looks valid (30)


000: 5a 5a 5a 5a 5a 5a 5a 5a b8 23 34 7e 00 81 ff ff
010: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
020: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
030: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
040: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
050: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
060: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a a5
070: c0 88 56 63 c5 56 41 d8 f1 37 4a 80 ff ff ff ff
080: c0 88 56 63 c5 56 41 d8 80 33 53 7d 00 81 ff ff
090: e8 25 60 7d 00 81 ff ff 68 cb 3b 01 00 81 ff ff
0a0: 18 68 50 7d 00 81 ff ff
------------[ cut here ]------------
kernel BUG at /home/clementv/src/linux-2.6.23-rc9/mm/slab.c:2923!
invalid opcode: 0000 [1] SMP
CPU 2
Modules linked in: qla2xxx
Pid: 4041, comm: ffsb Not tainted 2.6.23-rc9 #2
RIP: 0010:[<ffffffff802758b6>]  [<ffffffff802758b6>] check_slabp+0xb5/0xc1
RSP: 0018:ffff8100774bb958  EFLAGS: 00010096
RAX: 0000000000000001 RBX: ffff81007e100100 RCX: 0000000000006d20
RDX: 00000000ffffffff RSI: 0000000000000046 RDI: ffff81007e347280
RBP: 00000000000000a8 R08: 0000000000000005 R09: ffffffff8060bb10
R10: 00000000000ae468 R11: 0000000500000002 R12: 00000000000000a8
R13: ffff81007e347280 R14: ffff81007e347280 R15: 0000000000000002
FS:  0000000041802950(0063) GS:ffff81007e0c4728(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000005f83d00c CR3: 0000000078149000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ffsb (pid: 4041, threadinfo ffff8100774ba000, task ffff81007dbdc7a0)
Stack:  000000000000000d 000000000000000e ffff81007e100100 ffff81007e342398
  ffff81007e078488 ffffffff80277069 0000000000008050 ffff81007e347280
  0000000000008050 0000000000000246 ffffffff80299539 fffffffffffff000
Call Trace:
  [<ffffffff80277069>] cache_alloc_refill+0xc8/0x23f
  [<ffffffff80299539>] alloc_buffer_head+0x14/0x45
  [<ffffffff802774cd>] kmem_cache_alloc+0x94/0xe9
  [<ffffffff80299539>] alloc_buffer_head+0x14/0x45
  [<ffffffff80299cf7>] alloc_page_buffers+0x38/0xd5
  [<ffffffff80299da8>] create_empty_buffers+0x14/0x9b
  [<ffffffff8029a875>] __block_prepare_write+0x7c/0x45b
  [<ffffffff802f6e29>] ext4_get_block+0x0/0x139
  [<ffffffff8029ac6e>] block_prepare_write+0x1a/0x25
  [<ffffffff802f8340>] ext4_prepare_write+0xaf/0x175
  [<ffffffff802576c2>] generic_file_buffered_write+0x288/0x631
  [<ffffffff80257daa>] __generic_file_aio_write_nolock+0x33f/0x3a9
  [<ffffffff8022b7d5>] enqueue_entity+0x17c/0x1a3
  [<ffffffff80257e75>] generic_file_aio_write+0x61/0xc1
  [<ffffffff8022c512>] __check_preempt_curr_fair+0x56/0x76
  [<ffffffff802f4022>] ext4_file_write+0x16/0x91
  [<ffffffff8027c4f4>] do_sync_write+0xc9/0x10c
  [<ffffffff8027d50a>] file_move+0x1d/0x4c
  [<ffffffff80245992>] autoremove_wake_function+0x0/0x2e
  [<ffffffff8027b216>] do_filp_open+0x2a/0x38
  [<ffffffff80275f7a>] poison_obj+0x26/0x30
  [<ffffffff8027cc34>] vfs_write+0xad/0x136
  [<ffffffff8027d171>] sys_write+0x45/0x6e
  [<ffffffff8020b32e>] system_call+0x7e/0x83


=============>

The stack track shows ext4_new_block(), is the problem repeatable? Does away without
multiple block allocation patch?

Mingming
