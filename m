From: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: [uml-devel] Ext4 in user mode linux hang
Date: Thu, 18 Nov 2010 19:35:14 +0100
Message-ID: <AANLkTin==wLEtuw8Kb-i48X06PeEJpewCXPORbM1xA1G@mail.gmail.com>
References: <4CE565D1.602@czol.eu>
	<alpine.LFD.2.00.1011181852270.15886@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <ondra@czol.eu>,
	linux-ext4@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50063 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760103Ab0KRSfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 13:35:15 -0500
Received: by gxk23 with SMTP id 23so2059939gxk.19
        for <linux-ext4@vger.kernel.org>; Thu, 18 Nov 2010 10:35:15 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1011181852270.15886@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/11/18 Lukas Czerner <lczerner@redhat.com>:
> On Thu, 18 Nov 2010, Ond=F8ej Kunc wrote:
>
>> Hi,
>>
>> I've recently tested ext4 in user mode linux VM. I compiled linux 2.=
6.36(from
>> debian source package). I configured kernel this way ... only disabl=
ed modules
>> (to work with default debootstraped debian). Then I created this scr=
ipt:

Can you reproduce this on a vanilla kernel?

>> #!/bin/bash
>> DD=3D"dd if=3D/dev/zero bs=3D1k"
>> for i in `seq 1 1000`; do
>> =A0 =A0 =A0 =A0 A=3D$(($RANDOM%50000))
>> =A0 =A0 =A0 =A0 $DD count=3D$A of=3Dfrag_$A
>> =A0 =A0 =A0 =A0 for i in `seq 1 100`; do
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 A=3D$(($RANDOM%50000))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rm -f frag_$A
>> =A0 =A0 =A0 =A0 done
>> done
>>
>>
>> This script I'had run on mounted ext4 partition (/dev/ubda -> /mnt/t=
est). It's
>> purpose is creating fragmented filesystem to test e4defrag. But afte=
r some
>> time it hungs the whole virtual system. All processes which want to =
write to
>> /mnt/test are still in D state. I issued sysrq t via uml_mconsole an=
d in that
>> output I found traces below.
>>
>> Ondra
>
> I did not look at the traces closely, but did you tried another
> filesystem ? My experience with UML is that it is always broken so th=
e
> problem might as well be somewhere else.
>
> -Lukas
>
>>
>>
>>
>> flush-98:16 =A0 D 0000000041a0d8b3 =A0 =A0 0 =A0 811 =A0 =A0 =A02 0x=
00000000
>> 67c57d80 60276e90 69857980 6002a1ed 69857990 60013597 67c578c0 69856=
000
>> =A0 =A0 =A0 =A069856000 67c578c0 698579f0 601d3181 69857a10 601d74a0=
 698579f0 69856000
>> =A0 =A0 =A0 =A0ffffffff00000a57 62e09800 00000000 69ab1480 69856000 =
69857a58 69857aa0
>> 6012274e
>> Call Trace:
>> 69857958: =A0[<6002a1ed>] dequeue_task+0x39/0x48
>> 69857968: =A0[<60013597>] _switch_to+0x5e/0xae
>> 69857998: =A0[<601d3181>] schedule+0x274/0x2ae
>> 698579f8: =A0[<6012274e>] start_this_handle+0x2f4/0x395
>> 69857a50: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>> 69857aa8: =A0[<6012297c>] jbd2__journal_start+0xb9/0xf7
>> 69857af8: =A0[<601229c8>] jbd2_journal_start+0xe/0x10
>> 69857b08: =A0[<6010abe5>] ext4_journal_start_sb+0xe0/0x125
>> 69857b28: =A0[<600fa802>] ext4_meta_trans_blocks+0x5b/0xaf
>> 69857b68: =A0[<60100a43>] ext4_da_writepages+0x249/0x479
>> 69857c58: =A0[<6005b042>] do_writepages+0x1c/0x25
>> 69857c68: =A0[<600908bc>] writeback_single_inode+0x93/0x1d4
>> 69857c98: =A0[<60090c4e>] writeback_sb_inodes+0xa1/0xfe
>> 69857cf8: =A0[<60091364>] writeback_inodes_wb+0xc5/0xe4
>> 69857d00: =A0[<60042f76>] wake_bit_function+0x0/0x2e
>> 69857d48: =A0[<600914f2>] wb_writeback+0x16f/0x1de
>> 69857da8: =A0[<601d3189>] schedule+0x27c/0x2ae
>> 69857df8: =A0[<60091674>] wb_do_writeback+0x113/0x130
>> 69857e08: =A0[<601d3400>] schedule_timeout+0x13e/0x15c
>> 69857e78: =A0[<6009171a>] bdi_writeback_thread+0x89/0x13f
>> 69857eb0: =A0[<60091691>] bdi_writeback_thread+0x0/0x13f
>> 69857ed0: =A0[<60091691>] bdi_writeback_thread+0x0/0x13f
>> 69857ee8: =A0[<60042c99>] kthread+0x91/0x99
>> 69857f48: =A0[<60021329>] run_kernel_thread+0x41/0x4a
>> 69857f58: =A0[<60042c08>] kthread+0x0/0x99
>> 69857f98: =A0[<60021310>] run_kernel_thread+0x28/0x4a
>> 69857fc8: =A0[<6001350f>] new_thread_handler+0x71/0x9b
>>
>> jbd2/ubdb-8 =A0 D 0000000041a0d8b3 =A0 =A0 0 =A04542 =A0 =A0 =A02 0x=
00000000
>> 6838d640 60276e90 68275ca0 6002a1ed 68275cb0 60013597 6838d180 68274=
000
>> =A0 =A0 =A0 =A068274000 6838d180 68275d10 601d3181 68fd7470 601d74a0=
 68275d10 68274000
>> =A0 =A0 =A0 =A000000000 62e09800 69ab1480 1000077f1 68274000 69ab151=
8 68275e50
>> 60122d7b
>> Call Trace:
>> 68275c78: =A0[<6002a1ed>] dequeue_task+0x39/0x48
>> 68275c88: =A0[<60013597>] _switch_to+0x5e/0xae
>> 68275cb8: =A0[<601d3181>] schedule+0x274/0x2ae
>> 68275d18: =A0[<60122d7b>] jbd2_journal_commit_transaction+0x16c/0xe5=
9
>> 68275d98: =A0[<600245e3>] switch_threads+0x2d/0x3d
>> 68275de0: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>> 68275df8: =A0[<600222bb>] set_signals+0x1c/0x2e
>> 68275e18: =A0[<60043094>] finish_wait+0x64/0x6f
>> 68275e58: =A0[<60126168>] kjournald2+0xb8/0x1bb
>> 68275e90: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>> 68275eb0: =A0[<601260b0>] kjournald2+0x0/0x1bb
>> 68275ed0: =A0[<601260b0>] kjournald2+0x0/0x1bb
>> 68275ee8: =A0[<60042c99>] kthread+0x91/0x99
>> 68275f48: =A0[<60021329>] run_kernel_thread+0x41/0x4a
>> 68275f58: =A0[<60042c08>] kthread+0x0/0x99
>> 68275f98: =A0[<60021310>] run_kernel_thread+0x28/0x4a
>> 68275fc8: =A0[<6001350f>] new_thread_handler+0x71/0x9b
>>
>> dd =A0 =A0 =A0 =A0 =A0 =A0D 0000000041a0d8b3 =A0 =A0 0 =A04952 =A0 4=
593 0x00000000
>> 6838c8c0 67c57d80 67c578f8 60284440 69b6d7a8 60013597 6838c400 69b6c=
000
>> =A0 =A0 =A0 =A069b6c000 6838c400 69b6d808 601d3181 69b6d7c8 6002a34f=
 69b6d808 69b6c000
>> =A0 =A0 =A0 =A000001000 6838c400 696c0838 00000001 ffffffffffffffff =
00000000 69b6d868
>> 601d43a2
>> Call Trace:
>> 69b6d780: =A0[<60013597>] _switch_to+0x5e/0xae
>> 69b6d7b0: =A0[<601d3181>] schedule+0x274/0x2ae
>> 69b6d7c0: =A0[<6002a34f>] wake_up_process+0x10/0x12
>> 69b6d810: =A0[<601d43a2>] rwsem_down_failed_common+0xb8/0xd8
>> 69b6d838: =A0[<600222bb>] set_signals+0x1c/0x2e
>> 69b6d870: =A0[<601d43e9>] rwsem_down_read_failed+0x12/0x14
>> 69b6d880: =A0[<60027b98>] call_rwsem_down_read_failed+0x14/0x24
>> 69b6d8c8: =A0[<601d3b97>] down_read+0x11/0x13
>> 69b6d8d8: =A0[<600fe1cc>] ext4_map_blocks+0x3e/0x18e
>> 69b6d938: =A0[<600ffe02>] ext4_da_get_block_prep+0x83/0x2bd
>> 69b6d958: =A0[<60095705>] alloc_buffer_head+0x18/0x6c
>> 69b6d968: =A0[<60095d31>] alloc_page_buffers+0x75/0xd1
>> 69b6d9d8: =A0[<60097105>] block_prepare_write+0x177/0x380
>> 69b6d9e8: =A0[<6005588b>] add_to_page_cache_locked+0xbf/0xe7
>> 69b6da00: =A0[<600ffd7f>] ext4_da_get_block_prep+0x0/0x2bd
>> 69b6da98: =A0[<600973f3>] __block_write_begin+0x12/0x14
>> 69b6daa8: =A0[<600ffa62>] ext4_da_write_begin+0x123/0x1b4
>> 69b6db28: =A0[<60054ca0>] generic_file_buffered_write+0x124/0x27e
>> 69b6dbc8: =A0[<6008889e>] file_update_time+0x3b/0xfe
>> 69b6dc18: =A0[<60056634>] __generic_file_aio_write+0x380/0x3bf
>> 69b6dcd8: =A0[<600566cb>] generic_file_aio_write+0x58/0xa2
>> 69b6dd18: =A0[<600f7f07>] ext4_file_write+0x92/0xa3
>> 69b6dd48: =A0[<60077a27>] do_sync_write+0xd1/0x10e
>> 69b6ddb8: =A0[<60015daf>] buffer_op+0xab/0xc7
>> 69b6de68: =A0[<600783fb>] vfs_write+0xb5/0x169
>> 69b6dea8: =A0[<60078568>] sys_write+0x45/0x6c
>> 69b6dee8: =A0[<60015ab8>] handle_syscall+0x58/0x70
>> 69b6df08: =A0[<60024ecb>] userspace+0x2dd/0x38a
>> 69b6dfc8: =A0[<60013497>] fork_handler+0x62/0x69
>>
>> bash =A0 =A0 =A0 =A0 =A0D 0000000041a0d8b3 =A0 =A0 0 =A05324 =A0 527=
1 0x00000002
>> 67e2c540 60276e90 67dcfbd0 6002a1ed 67dcfbe0 60013597 67e2c080 67dce=
000
>> =A0 =A0 =A0 =A067dce000 67e2c080 67dcfc40 601d3181 62a31000 601d74a0=
 67dcfc40 67dce000
>> =A0 =A0 =A0 =A067dcfc10 62e09800 00000000 69ab1480 67dce000 67dcfca8=
 67dcfcf0 6012274e
>> Call Trace:
>> 67dcfba8: =A0[<6002a1ed>] dequeue_task+0x39/0x48
>> 67dcfbb8: =A0[<60013597>] _switch_to+0x5e/0xae
>> 67dcfbe8: =A0[<601d3181>] schedule+0x274/0x2ae
>> 67dcfc48: =A0[<6012274e>] start_this_handle+0x2f4/0x395
>> 67dcfca0: =A0[<60042f42>] autoremove_wake_function+0x0/0x34
>> 67dcfcf8: =A0[<6012297c>] jbd2__journal_start+0xb9/0xf7
>> 67dcfd48: =A0[<601229c8>] jbd2_journal_start+0xe/0x10
>> 67dcfd58: =A0[<6010abe5>] ext4_journal_start_sb+0xe0/0x125
>> 67dcfd60: =A0[<6008424f>] filldir+0x0/0x11a
>> 67dcfdb8: =A0[<600fb08a>] ext4_dirty_inode+0x1b/0x48
>> 67dcfdd8: =A0[<60091027>] __mark_inode_dirty+0x29/0x199
>> 67dcfdf8: =A0[<60088a63>] touch_atime+0x102/0x125
>> 67dcfe38: =A0[<6008424f>] filldir+0x0/0x11a
>> 67dcfe48: =A0[<600844fd>] vfs_readdir+0x7a/0xa1
>> 67dcfe98: =A0[<6008469d>] sys_getdents+0x90/0x124
>> 67dcfee8: =A0[<60015ab8>] handle_syscall+0x58/0x70
>> 67dcff08: =A0[<60024ecb>] userspace+0x2dd/0x38a
>> 67dcffc8: =A0[<60013497>] fork_handler+0x62/0x69
>>
>>
> ---------------------------------------------------------------------=
---------
> Beautiful is writing same markup. Internet Explorer 9 supports
> standards for HTML5, CSS3, SVG 1.1, =A0ECMAScript5, and DOM L2 & L3.
> Spend less time writing and =A0rewriting code and more time creating =
great
> experiences on the web. Be a part of the beta today
> http://p.sf.net/sfu/msIE9-sfdev2dev
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel
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
