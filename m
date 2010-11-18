From: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [uml-devel] Ext4 in user mode linux hang
Date: Thu, 18 Nov 2010 20:55:54 +0100
Message-ID: <AANLkTi=nKeWcyxZ_mwgO4pQsa=og0TztmdsQ0vyTvvDO@mail.gmail.com>
References: <4CE565D1.602@czol.eu>
	<alpine.LFD.2.00.1011181852270.15886@dhcp-lab-213.englab.brq.redhat.com>
	<AANLkTin==wLEtuw8Kb-i48X06PeEJpewCXPORbM1xA1G@mail.gmail.com>
	<4CE57F35.60505@czol.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net
To: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <ondra@czol.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54219 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0KRTzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 14:55:55 -0500
Received: by gyh4 with SMTP id 4so2137102gyh.19
        for <linux-ext4@vger.kernel.org>; Thu, 18 Nov 2010 11:55:54 -0800 (PST)
In-Reply-To: <4CE57F35.60505@czol.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/11/18 Ond=F8ej Kunc <ondra@czol.eu>:
> Hi,
>
> on vanilla kernel (2.6.36 from kernel.org) ... it fails too(so it is =
not
> debian specific), traces from sysrq t (via uml_mconsole)

Does it only happen with ext4?

> (only processess in D state):
>
> jbd2/ubdb-8 =A0 D 00000000405068b3 =A0 =A0 0 =A0 580 =A0 =A0 =A02 0x0=
0000000
> 66aea608 660214c8 66021038 60284440 66041cb0 60013597 66aea140 660400=
00
> =A0 =A0 =A0 66040000 66aea140 66041d10 601d3381 679ac2d0 66bcb8a8 660=
41d10
> 66040000
> =A0 =A0 =A0 00000000 66bcb800 67453a80 1000014a0 66040000 67453b18 66=
041e50
> 60122f6f
> Call Trace:
> 66041c88: =A0[<60013597>] _switch_to+0x5e/0xae
> 66041cb8: =A0[<601d3381>] schedule+0x274/0x2ae
> 66041d18: =A0[<60122f6f>] jbd2_journal_commit_transaction+0x16c/0xe59
> 66041d98: =A0[<600245e3>] switch_threads+0x2d/0x3d
> 66041de0: =A0[<60042f46>] autoremove_wake_function+0x0/0x34
> 66041e58: =A0[<6012635c>] kjournald2+0xb8/0x1bb
> 66041e90: =A0[<60042f46>] autoremove_wake_function+0x0/0x34
> 66041eb0: =A0[<601262a4>] kjournald2+0x0/0x1bb
> 66041ed0: =A0[<601262a4>] kjournald2+0x0/0x1bb
> 66041ee8: =A0[<60042c9d>] kthread+0x91/0x99
> 66041f48: =A0[<60021329>] run_kernel_thread+0x41/0x4a
> 66041f58: =A0[<60042c0c>] kthread+0x0/0x99
> 66041f98: =A0[<60021310>] run_kernel_thread+0x28/0x4a
> 66041fc8: =A0[<6001350f>] new_thread_handler+0x71/0x9b
>
> flush-98:16 =A0 D 00000000405068b3 =A0 =A0 0 =A0 609 =A0 =A0 =A02 0x0=
0000000
> 660214c8 608dec08 608de778 60284440 6613b9d0 60013597 66021000 6613a0=
00
> =A0 =A0 =A0 6613a000 66021000 6613ba30 601d3381 6613b9f0 6002a34f 661=
3ba30
> 6613a000
> =A0 =A0 =A0 76800000767 66021000 63474428 00000002 0000ffff 63474440 =
6613ba90
> 601d45a2
> Call Trace:
> 6613b9a8: =A0[<60013597>] _switch_to+0x5e/0xae
> 6613b9d8: =A0[<601d3381>] schedule+0x274/0x2ae
> 6613b9e8: =A0[<6002a34f>] wake_up_process+0x10/0x12
> 6613ba38: =A0[<601d45a2>] rwsem_down_failed_common+0xb8/0xd8
> 6613ba98: =A0[<601d45d5>] rwsem_down_write_failed+0x13/0x15
> 6613baa8: =A0[<60027bbb>] call_rwsem_down_write_failed+0x13/0x20
> 6613bae8: =A0[<601d3db5>] down_write+0x1c/0x1e
> 6613baf8: =A0[<6010053a>] mpage_da_map_blocks+0x308/0x359
> 6613bb68: =A0[<60100ce7>] ext4_da_writepages+0x2f7/0x479
> 6613bc58: =A0[<6005b236>] do_writepages+0x1c/0x25
> 6613bc68: =A0[<60090ab0>] writeback_single_inode+0x93/0x1d4
> 6613bc98: =A0[<60090e42>] writeback_sb_inodes+0xa1/0xfe
> 6613bcf8: =A0[<60091558>] writeback_inodes_wb+0xc5/0xe4
> 6613bd00: =A0[<60042f7a>] wake_bit_function+0x0/0x2e
> 6613bd48: =A0[<600916e6>] wb_writeback+0x16f/0x1de
> 6613bda8: =A0[<601d3389>] schedule+0x27c/0x2ae
> 6613bdf8: =A0[<60091868>] wb_do_writeback+0x113/0x130
> 6613be08: =A0[<601d3600>] schedule_timeout+0x13e/0x15c
> 6613be78: =A0[<6009190e>] bdi_writeback_thread+0x89/0x13f
> 6613beb0: =A0[<60091885>] bdi_writeback_thread+0x0/0x13f
> 6613bed0: =A0[<60091885>] bdi_writeback_thread+0x0/0x13f
> 6613bee8: =A0[<60042c9d>] kthread+0x91/0x99
> 6613bf48: =A0[<60021329>] run_kernel_thread+0x41/0x4a
> 6613bf58: =A0[<60042c0c>] kthread+0x0/0x99
> 6613bf98: =A0[<60021310>] run_kernel_thread+0x28/0x4a
> 6613bfc8: =A0[<6001350f>] new_thread_handler+0x71/0x9b
>
> dd =A0 =A0 =A0 =A0 =A0 =A0D 00000000405068b3 =A0 =A0 0 18357 =A0 =A09=
22 0x00000000
> 608dec08 60276e98 6087b8c0 6002a1ed 6087b8d0 60013597 608de740 6087a0=
00
> =A0 =A0 =A0 6087a000 608de740 6087b930 601d3381 6087b930 601d7480 608=
7b930
> 6087a000
> =A0 =A0 =A0 816087b920 66bcb800 00000000 67453a80 6087a000 6087b998 6=
087b9e0
> 60122942
> Call Trace:
> 6087b898: =A0[<6002a1ed>] dequeue_task+0x39/0x48
> 6087b8a8: =A0[<60013597>] _switch_to+0x5e/0xae
> 6087b8d8: =A0[<601d3381>] schedule+0x274/0x2ae
> 6087b938: =A0[<60122942>] start_this_handle+0x2f4/0x395
> 6087b990: =A0[<60042f46>] autoremove_wake_function+0x0/0x34
> 6087b9e8: =A0[<60122b70>] jbd2__journal_start+0xb9/0xf7
> 6087ba38: =A0[<60122bbc>] jbd2_journal_start+0xe/0x10
> 6087ba48: =A0[<6010add9>] ext4_journal_start_sb+0xe0/0x125
> 6087ba78: =A0[<60015daf>] buffer_op+0xab/0xc7
> 6087baa8: =A0[<600ffbf6>] ext4_da_write_begin+0xc1/0x1b4
> 6087bb28: =A0[<60054e94>] generic_file_buffered_write+0x124/0x27e
> 6087bbc8: =A0[<60088a92>] file_update_time+0x3b/0xfe
> 6087bc18: =A0[<60056828>] __generic_file_aio_write+0x380/0x3bf
> 6087bcd8: =A0[<600568bf>] generic_file_aio_write+0x58/0xa2
> 6087bd18: =A0[<600f80fb>] ext4_file_write+0x92/0xa3
> 6087bd48: =A0[<60077c1b>] do_sync_write+0xd1/0x10e
> 6087bdb8: =A0[<60015daf>] buffer_op+0xab/0xc7
> 6087be68: =A0[<600785ef>] vfs_write+0xb5/0x169
> 6087bea8: =A0[<6007875c>] sys_write+0x45/0x6c
> 6087bee8: =A0[<60015ab8>] handle_syscall+0x58/0x70
> 6087bf08: =A0[<60024ecb>] userspace+0x2dd/0x38a
> 6087bfc8: =A0[<60013497>] fork_handler+0x62/0x69
>
> Dne 18.11.2010 19:35, richard -rw- weinberger napsal(a):
>>
>> 2010/11/18 Lukas Czerner<lczerner@redhat.com>:
>>
>>>
>>> On Thu, 18 Nov 2010, Ond=F8ej Kunc wrote:
>>>
>>>
>>>>
>>>> Hi,
>>>>
>>>> I've recently tested ext4 in user mode linux VM. I compiled linux
>>>> 2.6.36(from
>>>> debian source package). I configured kernel this way ... only disa=
bled
>>>> modules
>>>> (to work with default debootstraped debian). Then I created this s=
cript:
>>>>
>>
>> Can you reproduce this on a vanilla kernel?
>>
>>
>>>>
>>>> #!/bin/bash
>>>> DD=3D"dd if=3D/dev/zero bs=3D1k"
>>>> for i in `seq 1 1000`; do
>>>> =A0 =A0 =A0 =A0 A=3D$(($RANDOM%50000))
>>>> =A0 =A0 =A0 =A0 $DD count=3D$A of=3Dfrag_$A
>>>> =A0 =A0 =A0 =A0 for i in `seq 1 100`; do
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 A=3D$(($RANDOM%50000))
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rm -f frag_$A
>>>> =A0 =A0 =A0 =A0 done
>>>> done
>>>>
>>>>
>>>> This script I'had run on mounted ext4 partition (/dev/ubda ->
>>>> =A0/mnt/test). It's
>>>> purpose is creating fragmented filesystem to test e4defrag. But af=
ter
>>>> some
>>>> time it hungs the whole virtual system. All processes which want t=
o
>>>> write to
>>>> /mnt/test are still in D state. I issued sysrq t via uml_mconsole =
and in
>>>> that
>>>> output I found traces below.
>>>>
>>>> Ondra
>>>>
>>>
>>> I did not look at the traces closely, but did you tried another
>>> filesystem ? My experience with UML is that it is always broken so =
the
>>> problem might as well be somewhere else.
>>>
>>> -Lukas
>>>
>>>
>>>>
>>>>
>>>> flush-98:16 =A0 D 0000000041a0d8b3 =A0 =A0 0 =A0 811 =A0 =A0 =A02 =
0x00000000
>>>> 67c57d80 60276e90 69857980 6002a1ed 69857990 60013597 67c578c0 698=
56000
>>>> =A0 =A0 =A0 =A069856000 67c578c0 698579f0 601d3181 69857a10 601d74=
a0 698579f0
>>>> 69856000
>>>> =A0 =A0 =A0 =A0ffffffff00000a57 62e09800 00000000 69ab1480 6985600=
0 69857a58
>>>> 69857aa0
>>>> 6012274e
>>>> Call Trace:
>>>> 69857958: =A0[<6002a1ed>] dequeue_task+0x39/0x48
>>>> 69857968: =A0[<60013597>] _switch_to+0x5e/0xae
>>>> 69857998: =A0[<601d3181>] schedule+0x274/0x2ae
>>>> 698579f8: =A0[<6012274e>] start_this_handle+0x2f4/0x395
>>>> 69857a50: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>>>> 69857aa8: =A0[<6012297c>] jbd2__journal_start+0xb9/0xf7
>>>> 69857af8: =A0[<601229c8>] jbd2_journal_start+0xe/0x10
>>>> 69857b08: =A0[<6010abe5>] ext4_journal_start_sb+0xe0/0x125
>>>> 69857b28: =A0[<600fa802>] ext4_meta_trans_blocks+0x5b/0xaf
>>>> 69857b68: =A0[<60100a43>] ext4_da_writepages+0x249/0x479
>>>> 69857c58: =A0[<6005b042>] do_writepages+0x1c/0x25
>>>> 69857c68: =A0[<600908bc>] writeback_single_inode+0x93/0x1d4
>>>> 69857c98: =A0[<60090c4e>] writeback_sb_inodes+0xa1/0xfe
>>>> 69857cf8: =A0[<60091364>] writeback_inodes_wb+0xc5/0xe4
>>>> 69857d00: =A0[<60042f76>] wake_bit_function+0x0/0x2e
>>>> 69857d48: =A0[<600914f2>] wb_writeback+0x16f/0x1de
>>>> 69857da8: =A0[<601d3189>] schedule+0x27c/0x2ae
>>>> 69857df8: =A0[<60091674>] wb_do_writeback+0x113/0x130
>>>> 69857e08: =A0[<601d3400>] schedule_timeout+0x13e/0x15c
>>>> 69857e78: =A0[<6009171a>] bdi_writeback_thread+0x89/0x13f
>>>> 69857eb0: =A0[<60091691>] bdi_writeback_thread+0x0/0x13f
>>>> 69857ed0: =A0[<60091691>] bdi_writeback_thread+0x0/0x13f
>>>> 69857ee8: =A0[<60042c99>] kthread+0x91/0x99
>>>> 69857f48: =A0[<60021329>] run_kernel_thread+0x41/0x4a
>>>> 69857f58: =A0[<60042c08>] kthread+0x0/0x99
>>>> 69857f98: =A0[<60021310>] run_kernel_thread+0x28/0x4a
>>>> 69857fc8: =A0[<6001350f>] new_thread_handler+0x71/0x9b
>>>>
>>>> jbd2/ubdb-8 =A0 D 0000000041a0d8b3 =A0 =A0 0 =A04542 =A0 =A0 =A02 =
0x00000000
>>>> 6838d640 60276e90 68275ca0 6002a1ed 68275cb0 60013597 6838d180 682=
74000
>>>> =A0 =A0 =A0 =A068274000 6838d180 68275d10 601d3181 68fd7470 601d74=
a0 68275d10
>>>> 68274000
>>>> =A0 =A0 =A0 =A000000000 62e09800 69ab1480 1000077f1 68274000 69ab1=
518 68275e50
>>>> 60122d7b
>>>> Call Trace:
>>>> 68275c78: =A0[<6002a1ed>] dequeue_task+0x39/0x48
>>>> 68275c88: =A0[<60013597>] _switch_to+0x5e/0xae
>>>> 68275cb8: =A0[<601d3181>] schedule+0x274/0x2ae
>>>> 68275d18: =A0[<60122d7b>] jbd2_journal_commit_transaction+0x16c/0x=
e59
>>>> 68275d98: =A0[<600245e3>] switch_threads+0x2d/0x3d
>>>> 68275de0: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>>>> 68275df8: =A0[<600222bb>] set_signals+0x1c/0x2e
>>>> 68275e18: =A0[<60043094>] finish_wait+0x64/0x6f
>>>> 68275e58: =A0[<60126168>] kjournald2+0xb8/0x1bb
>>>> 68275e90: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>>>> 68275eb0: =A0[<601260b0>] kjournald2+0x0/0x1bb
>>>> 68275ed0: =A0[<601260b0>] kjournald2+0x0/0x1bb
>>>> 68275ee8: =A0[<60042c99>] kthread+0x91/0x99
>>>> 68275f48: =A0[<60021329>] run_kernel_thread+0x41/0x4a
>>>> 68275f58: =A0[<60042c08>] kthread+0x0/0x99
>>>> 68275f98: =A0[<60021310>] run_kernel_thread+0x28/0x4a
>>>> 68275fc8: =A0[<6001350f>] new_thread_handler+0x71/0x9b
>>>>
>>>> dd =A0 =A0 =A0 =A0 =A0 =A0D 0000000041a0d8b3 =A0 =A0 0 =A04952 =A0=
 4593 0x00000000
>>>> 6838c8c0 67c57d80 67c578f8 60284440 69b6d7a8 60013597 6838c400 69b=
6c000
>>>> =A0 =A0 =A0 =A069b6c000 6838c400 69b6d808 601d3181 69b6d7c8 6002a3=
4f 69b6d808
>>>> 69b6c000
>>>> =A0 =A0 =A0 =A000001000 6838c400 696c0838 00000001 fffffffffffffff=
f 00000000
>>>> 69b6d868
>>>> 601d43a2
>>>> Call Trace:
>>>> 69b6d780: =A0[<60013597>] _switch_to+0x5e/0xae
>>>> 69b6d7b0: =A0[<601d3181>] schedule+0x274/0x2ae
>>>> 69b6d7c0: =A0[<6002a34f>] wake_up_process+0x10/0x12
>>>> 69b6d810: =A0[<601d43a2>] rwsem_down_failed_common+0xb8/0xd8
>>>> 69b6d838: =A0[<600222bb>] set_signals+0x1c/0x2e
>>>> 69b6d870: =A0[<601d43e9>] rwsem_down_read_failed+0x12/0x14
>>>> 69b6d880: =A0[<60027b98>] call_rwsem_down_read_failed+0x14/0x24
>>>> 69b6d8c8: =A0[<601d3b97>] down_read+0x11/0x13
>>>> 69b6d8d8: =A0[<600fe1cc>] ext4_map_blocks+0x3e/0x18e
>>>> 69b6d938: =A0[<600ffe02>] ext4_da_get_block_prep+0x83/0x2bd
>>>> 69b6d958: =A0[<60095705>] alloc_buffer_head+0x18/0x6c
>>>> 69b6d968: =A0[<60095d31>] alloc_page_buffers+0x75/0xd1
>>>> 69b6d9d8: =A0[<60097105>] block_prepare_write+0x177/0x380
>>>> 69b6d9e8: =A0[<6005588b>] add_to_page_cache_locked+0xbf/0xe7
>>>> 69b6da00: =A0[<600ffd7f>] ext4_da_get_block_prep+0x0/0x2bd
>>>> 69b6da98: =A0[<600973f3>] __block_write_begin+0x12/0x14
>>>> 69b6daa8: =A0[<600ffa62>] ext4_da_write_begin+0x123/0x1b4
>>>> 69b6db28: =A0[<60054ca0>] generic_file_buffered_write+0x124/0x27e
>>>> 69b6dbc8: =A0[<6008889e>] file_update_time+0x3b/0xfe
>>>> 69b6dc18: =A0[<60056634>] __generic_file_aio_write+0x380/0x3bf
>>>> 69b6dcd8: =A0[<600566cb>] generic_file_aio_write+0x58/0xa2
>>>> 69b6dd18: =A0[<600f7f07>] ext4_file_write+0x92/0xa3
>>>> 69b6dd48: =A0[<60077a27>] do_sync_write+0xd1/0x10e
>>>> 69b6ddb8: =A0[<60015daf>] buffer_op+0xab/0xc7
>>>> 69b6de68: =A0[<600783fb>] vfs_write+0xb5/0x169
>>>> 69b6dea8: =A0[<60078568>] sys_write+0x45/0x6c
>>>> 69b6dee8: =A0[<60015ab8>] handle_syscall+0x58/0x70
>>>> 69b6df08: =A0[<60024ecb>] userspace+0x2dd/0x38a
>>>> 69b6dfc8: =A0[<60013497>] fork_handler+0x62/0x69
>>>>
>>>> bash =A0 =A0 =A0 =A0 =A0D 0000000041a0d8b3 =A0 =A0 0 =A05324 =A0 5=
271 0x00000002
>>>> 67e2c540 60276e90 67dcfbd0 6002a1ed 67dcfbe0 60013597 67e2c080 67d=
ce000
>>>> =A0 =A0 =A0 =A067dce000 67e2c080 67dcfc40 601d3181 62a31000 601d74=
a0 67dcfc40
>>>> 67dce000
>>>> =A0 =A0 =A0 =A067dcfc10 62e09800 00000000 69ab1480 67dce000 67dcfc=
a8 67dcfcf0
>>>> 6012274e
>>>> Call Trace:
>>>> 67dcfba8: =A0[<6002a1ed>] dequeue_task+0x39/0x48
>>>> 67dcfbb8: =A0[<60013597>] _switch_to+0x5e/0xae
>>>> 67dcfbe8: =A0[<601d3181>] schedule+0x274/0x2ae
>>>> 67dcfc48: =A0[<6012274e>] start_this_handle+0x2f4/0x395
>>>> 67dcfca0: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>>>> 67dcfcf8: =A0[<6012297c>] jbd2__journal_start+0xb9/0xf7
>>>> 67dcfd48: =A0[<601229c8>] jbd2_journal_start+0xe/0x10
>>>> 67dcfd58: =A0[<6010abe5>] ext4_journal_start_sb+0xe0/0x125
>>>> 67dcfd60: =A0[<6008424f>] filldir+0x0/0x11a
>>>> 67dcfdb8: =A0[<600fb08a>] ext4_dirty_inode+0x1b/0x48
>>>> 67dcfdd8: =A0[<60091027>] __mark_inode_dirty+0x29/0x199
>>>> 67dcfdf8: =A0[<60088a63>] touch_atime+0x102/0x125
>>>> 67dcfe38: =A0[<6008424f>] filldir+0x0/0x11a
>>>> 67dcfe48: =A0[<600844fd>] vfs_readdir+0x7a/0xa1
>>>> 67dcfe98: =A0[<6008469d>] sys_getdents+0x90/0x124
>>>> 67dcfee8: =A0[<60015ab8>] handle_syscall+0x58/0x70
>>>> 67dcff08: =A0[<60024ecb>] userspace+0x2dd/0x38a
>>>> 67dcffc8: =A0[<60013497>] fork_handler+0x62/0x69
>>>>
>>>>
>>>>
>>>
>>>
>>> -------------------------------------------------------------------=
-----------
>>> Beautiful is writing same markup. Internet Explorer 9 supports
>>> standards for HTML5, CSS3, SVG 1.1, =A0ECMAScript5, and DOM L2& =A0=
L3.
>>> Spend less time writing and =A0rewriting code and more time creatin=
g great
>>> experiences on the web. Be a part of the beta today
>>> http://p.sf.net/sfu/msIE9-sfdev2dev
>>> _______________________________________________
>>> User-mode-linux-devel mailing list
>>> User-mode-linux-devel@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel
>>>
>>>
>>>
>>
>>
>>
>
>
> --
> Ond=F8ej Kunc
>
> spr=E1vce serverov=E9 farmy
> CZOL media interactive s.r.o.
> S=EDdlo: Moul=EDkova 2238/1, Praha 5, 15000
> Kancel=E1=F8e: Na Mor=E1ni 5357, Chomutov, 43001
> Telefon: +420 723 137 981
> E-mail: ondra@czol.eu
> URL: www.czol.eu, www.cz-hosting.com
>
>



--=20
Thanks,
//richard
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
