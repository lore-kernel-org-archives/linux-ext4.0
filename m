From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: 2.6.23-rc9: Oops in cache_alloc_refill()  mm/slab.c
Date: Mon, 08 Oct 2007 16:12:44 +0200
Message-ID: <470A3ADC.3000403@bull.net>
References: <4705113A.7030908@bull.net>	 <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>	 <47063EF3.4050302@bull.net>	 <1191596057.6106.106.camel@dyn9047017100.beaverton.ibm.com>	 <1191616252.3861.5.camel@localhost.localdomain> <1191622003.3861.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34987 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXJHONC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2007 10:13:02 -0400
In-Reply-To: <1191622003.3861.17.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Mingming Cao wrote:
> kernel BUG at /home/clementv/src/linux-2.6.23-rc9/mm/slab.c:2923!
> invalid opcode: 0000 [1] SMP
> CPU 2
> Modules linked in: qla2xxx
> Pid: 4041, comm: ffsb Not tainted 2.6.23-rc9 #2
> RIP: 0010:[<ffffffff802758b6>]  [<ffffffff802758b6>] check_slabp+0xb5=
/0xc1
> RSP: 0018:ffff8100774bb958  EFLAGS: 00010096
> RAX: 0000000000000001 RBX: ffff81007e100100 RCX: 0000000000006d20
> RDX: 00000000ffffffff RSI: 0000000000000046 RDI: ffff81007e347280
> RBP: 00000000000000a8 R08: 0000000000000005 R09: ffffffff8060bb10
> R10: 00000000000ae468 R11: 0000000500000002 R12: 00000000000000a8
> R13: ffff81007e347280 R14: ffff81007e347280 R15: 0000000000000002
> FS:  0000000041802950(0063) GS:ffff81007e0c4728(0000) knlGS:000000000=
0000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000005f83d00c CR3: 0000000078149000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process ffsb (pid: 4041, threadinfo ffff8100774ba000, task ffff81007d=
bdc7a0)
> Stack:  000000000000000d 000000000000000e ffff81007e100100 ffff81007e=
342398
>   ffff81007e078488 ffffffff80277069 0000000000008050 ffff81007e347280
>   0000000000008050 0000000000000246 ffffffff80299539 fffffffffffff000
> Call Trace:
>   [<ffffffff80277069>] cache_alloc_refill+0xc8/0x23f
>   [<ffffffff80299539>] alloc_buffer_head+0x14/0x45
>   [<ffffffff802774cd>] kmem_cache_alloc+0x94/0xe9
>   [<ffffffff80299539>] alloc_buffer_head+0x14/0x45
>   [<ffffffff80299cf7>] alloc_page_buffers+0x38/0xd5
>   [<ffffffff80299da8>] create_empty_buffers+0x14/0x9b
>   [<ffffffff8029a875>] __block_prepare_write+0x7c/0x45b
>   [<ffffffff802f6e29>] ext4_get_block+0x0/0x139
>   [<ffffffff8029ac6e>] block_prepare_write+0x1a/0x25
>   [<ffffffff802f8340>] ext4_prepare_write+0xaf/0x175
>   [<ffffffff802576c2>] generic_file_buffered_write+0x288/0x631
>   [<ffffffff80257daa>] __generic_file_aio_write_nolock+0x33f/0x3a9
>   [<ffffffff8022b7d5>] enqueue_entity+0x17c/0x1a3
>   [<ffffffff80257e75>] generic_file_aio_write+0x61/0xc1
>   [<ffffffff8022c512>] __check_preempt_curr_fair+0x56/0x76
>   [<ffffffff802f4022>] ext4_file_write+0x16/0x91
>   [<ffffffff8027c4f4>] do_sync_write+0xc9/0x10c
>   [<ffffffff8027d50a>] file_move+0x1d/0x4c
>   [<ffffffff80245992>] autoremove_wake_function+0x0/0x2e
>   [<ffffffff8027b216>] do_filp_open+0x2a/0x38
>   [<ffffffff80275f7a>] poison_obj+0x26/0x30
>   [<ffffffff8027cc34>] vfs_write+0xad/0x136
>   [<ffffffff8027d171>] sys_write+0x45/0x6e
>   [<ffffffff8020b32e>] system_call+0x7e/0x83
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
>=20
> The stack track shows ext4_new_block(), is the problem repeatable? Do=
es away without
> multiple block allocation patch?

The oops was not easily reproductible. I'd got it twice while testing=20
the mballoc feature with the uninit_groups option but the running tests=
=20
were different.
Since I made the change I sent friday to Aneesh (in the=20
uninitialized-block-groups patch), I could not reproduce it.
Could the oops be related to this other problem I found ?

   Val=E9rie
