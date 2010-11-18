From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: Ext4 in user mode linux hang
Date: Thu, 18 Nov 2010 18:55:08 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011181852270.15886@dhcp-lab-213.englab.brq.redhat.com>
References: <4CE565D1.602@czol.eu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571127323-1161085935-1290102911=:15886"
Cc: user-mode-linux-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
To: =?ISO-8859-2?Q?Ond=F8ej_Kunc?= <ondra@czol.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab0KRRzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Nov 2010 12:55:21 -0500
In-Reply-To: <4CE565D1.602@czol.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571127323-1161085935-1290102911=:15886
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Thu, 18 Nov 2010, Ondøej Kunc wrote:

> Hi,
> 
> I've recently tested ext4 in user mode linux VM. I compiled linux 2.6.36(from
> debian source package). I configured kernel this way ... only disabled modules
> (to work with default debootstraped debian). Then I created this script:
> 
> #!/bin/bash
> DD="dd if=/dev/zero bs=1k"
> for i in `seq 1 1000`; do
>         A=$(($RANDOM%50000))
>         $DD count=$A of=frag_$A
>         for i in `seq 1 100`; do
>                 A=$(($RANDOM%50000))
>                 rm -f frag_$A
>         done
> done
> 
> 
> This script I'had run on mounted ext4 partition (/dev/ubda -> /mnt/test). It's
> purpose is creating fragmented filesystem to test e4defrag. But after some
> time it hungs the whole virtual system. All processes which want to write to
> /mnt/test are still in D state. I issued sysrq t via uml_mconsole and in that
> output I found traces below.
> 
> Ondra

I did not look at the traces closely, but did you tried another
filesystem ? My experience with UML is that it is always broken so the
problem might as well be somewhere else.

-Lukas

> 
> 
> 
> flush-98:16   D 0000000041a0d8b3     0   811      2 0x00000000
> 67c57d80 60276e90 69857980 6002a1ed 69857990 60013597 67c578c0 69856000
>        69856000 67c578c0 698579f0 601d3181 69857a10 601d74a0 698579f0 69856000
>        ffffffff00000a57 62e09800 00000000 69ab1480 69856000 69857a58 69857aa0
> 6012274e
> Call Trace:
> 69857958:  [<6002a1ed>] dequeue_task+0x39/0x48
> 69857968:  [<60013597>] _switch_to+0x5e/0xae
> 69857998:  [<601d3181>] schedule+0x274/0x2ae
> 698579f8:  [<6012274e>] start_this_handle+0x2f4/0x395
> 69857a50:  [<60042f42>] autoremove_wake_function+0x0/0x34
> 69857aa8:  [<6012297c>] jbd2__journal_start+0xb9/0xf7
> 69857af8:  [<601229c8>] jbd2_journal_start+0xe/0x10
> 69857b08:  [<6010abe5>] ext4_journal_start_sb+0xe0/0x125
> 69857b28:  [<600fa802>] ext4_meta_trans_blocks+0x5b/0xaf
> 69857b68:  [<60100a43>] ext4_da_writepages+0x249/0x479
> 69857c58:  [<6005b042>] do_writepages+0x1c/0x25
> 69857c68:  [<600908bc>] writeback_single_inode+0x93/0x1d4
> 69857c98:  [<60090c4e>] writeback_sb_inodes+0xa1/0xfe
> 69857cf8:  [<60091364>] writeback_inodes_wb+0xc5/0xe4
> 69857d00:  [<60042f76>] wake_bit_function+0x0/0x2e
> 69857d48:  [<600914f2>] wb_writeback+0x16f/0x1de
> 69857da8:  [<601d3189>] schedule+0x27c/0x2ae
> 69857df8:  [<60091674>] wb_do_writeback+0x113/0x130
> 69857e08:  [<601d3400>] schedule_timeout+0x13e/0x15c
> 69857e78:  [<6009171a>] bdi_writeback_thread+0x89/0x13f
> 69857eb0:  [<60091691>] bdi_writeback_thread+0x0/0x13f
> 69857ed0:  [<60091691>] bdi_writeback_thread+0x0/0x13f
> 69857ee8:  [<60042c99>] kthread+0x91/0x99
> 69857f48:  [<60021329>] run_kernel_thread+0x41/0x4a
> 69857f58:  [<60042c08>] kthread+0x0/0x99
> 69857f98:  [<60021310>] run_kernel_thread+0x28/0x4a
> 69857fc8:  [<6001350f>] new_thread_handler+0x71/0x9b
> 
> jbd2/ubdb-8   D 0000000041a0d8b3     0  4542      2 0x00000000
> 6838d640 60276e90 68275ca0 6002a1ed 68275cb0 60013597 6838d180 68274000
>        68274000 6838d180 68275d10 601d3181 68fd7470 601d74a0 68275d10 68274000
>        00000000 62e09800 69ab1480 1000077f1 68274000 69ab1518 68275e50
> 60122d7b
> Call Trace:
> 68275c78:  [<6002a1ed>] dequeue_task+0x39/0x48
> 68275c88:  [<60013597>] _switch_to+0x5e/0xae
> 68275cb8:  [<601d3181>] schedule+0x274/0x2ae
> 68275d18:  [<60122d7b>] jbd2_journal_commit_transaction+0x16c/0xe59
> 68275d98:  [<600245e3>] switch_threads+0x2d/0x3d
> 68275de0:  [<60042f42>] autoremove_wake_function+0x0/0x34
> 68275df8:  [<600222bb>] set_signals+0x1c/0x2e
> 68275e18:  [<60043094>] finish_wait+0x64/0x6f
> 68275e58:  [<60126168>] kjournald2+0xb8/0x1bb
> 68275e90:  [<60042f42>] autoremove_wake_function+0x0/0x34
> 68275eb0:  [<601260b0>] kjournald2+0x0/0x1bb
> 68275ed0:  [<601260b0>] kjournald2+0x0/0x1bb
> 68275ee8:  [<60042c99>] kthread+0x91/0x99
> 68275f48:  [<60021329>] run_kernel_thread+0x41/0x4a
> 68275f58:  [<60042c08>] kthread+0x0/0x99
> 68275f98:  [<60021310>] run_kernel_thread+0x28/0x4a
> 68275fc8:  [<6001350f>] new_thread_handler+0x71/0x9b
> 
> dd            D 0000000041a0d8b3     0  4952   4593 0x00000000
> 6838c8c0 67c57d80 67c578f8 60284440 69b6d7a8 60013597 6838c400 69b6c000
>        69b6c000 6838c400 69b6d808 601d3181 69b6d7c8 6002a34f 69b6d808 69b6c000
>        00001000 6838c400 696c0838 00000001 ffffffffffffffff 00000000 69b6d868
> 601d43a2
> Call Trace:
> 69b6d780:  [<60013597>] _switch_to+0x5e/0xae
> 69b6d7b0:  [<601d3181>] schedule+0x274/0x2ae
> 69b6d7c0:  [<6002a34f>] wake_up_process+0x10/0x12
> 69b6d810:  [<601d43a2>] rwsem_down_failed_common+0xb8/0xd8
> 69b6d838:  [<600222bb>] set_signals+0x1c/0x2e
> 69b6d870:  [<601d43e9>] rwsem_down_read_failed+0x12/0x14
> 69b6d880:  [<60027b98>] call_rwsem_down_read_failed+0x14/0x24
> 69b6d8c8:  [<601d3b97>] down_read+0x11/0x13
> 69b6d8d8:  [<600fe1cc>] ext4_map_blocks+0x3e/0x18e
> 69b6d938:  [<600ffe02>] ext4_da_get_block_prep+0x83/0x2bd
> 69b6d958:  [<60095705>] alloc_buffer_head+0x18/0x6c
> 69b6d968:  [<60095d31>] alloc_page_buffers+0x75/0xd1
> 69b6d9d8:  [<60097105>] block_prepare_write+0x177/0x380
> 69b6d9e8:  [<6005588b>] add_to_page_cache_locked+0xbf/0xe7
> 69b6da00:  [<600ffd7f>] ext4_da_get_block_prep+0x0/0x2bd
> 69b6da98:  [<600973f3>] __block_write_begin+0x12/0x14
> 69b6daa8:  [<600ffa62>] ext4_da_write_begin+0x123/0x1b4
> 69b6db28:  [<60054ca0>] generic_file_buffered_write+0x124/0x27e
> 69b6dbc8:  [<6008889e>] file_update_time+0x3b/0xfe
> 69b6dc18:  [<60056634>] __generic_file_aio_write+0x380/0x3bf
> 69b6dcd8:  [<600566cb>] generic_file_aio_write+0x58/0xa2
> 69b6dd18:  [<600f7f07>] ext4_file_write+0x92/0xa3
> 69b6dd48:  [<60077a27>] do_sync_write+0xd1/0x10e
> 69b6ddb8:  [<60015daf>] buffer_op+0xab/0xc7
> 69b6de68:  [<600783fb>] vfs_write+0xb5/0x169
> 69b6dea8:  [<60078568>] sys_write+0x45/0x6c
> 69b6dee8:  [<60015ab8>] handle_syscall+0x58/0x70
> 69b6df08:  [<60024ecb>] userspace+0x2dd/0x38a
> 69b6dfc8:  [<60013497>] fork_handler+0x62/0x69
> 
> bash          D 0000000041a0d8b3     0  5324   5271 0x00000002
> 67e2c540 60276e90 67dcfbd0 6002a1ed 67dcfbe0 60013597 67e2c080 67dce000
>        67dce000 67e2c080 67dcfc40 601d3181 62a31000 601d74a0 67dcfc40 67dce000
>        67dcfc10 62e09800 00000000 69ab1480 67dce000 67dcfca8 67dcfcf0 6012274e
> Call Trace:
> 67dcfba8:  [<6002a1ed>] dequeue_task+0x39/0x48
> 67dcfbb8:  [<60013597>] _switch_to+0x5e/0xae
> 67dcfbe8:  [<601d3181>] schedule+0x274/0x2ae
> 67dcfc48:  [<6012274e>] start_this_handle+0x2f4/0x395
> 67dcfca0:  [<60042f42>] autoremove_wake_function+0x0/0x34
> 67dcfcf8:  [<6012297c>] jbd2__journal_start+0xb9/0xf7
> 67dcfd48:  [<601229c8>] jbd2_journal_start+0xe/0x10
> 67dcfd58:  [<6010abe5>] ext4_journal_start_sb+0xe0/0x125
> 67dcfd60:  [<6008424f>] filldir+0x0/0x11a
> 67dcfdb8:  [<600fb08a>] ext4_dirty_inode+0x1b/0x48
> 67dcfdd8:  [<60091027>] __mark_inode_dirty+0x29/0x199
> 67dcfdf8:  [<60088a63>] touch_atime+0x102/0x125
> 67dcfe38:  [<6008424f>] filldir+0x0/0x11a
> 67dcfe48:  [<600844fd>] vfs_readdir+0x7a/0xa1
> 67dcfe98:  [<6008469d>] sys_getdents+0x90/0x124
> 67dcfee8:  [<60015ab8>] handle_syscall+0x58/0x70
> 67dcff08:  [<60024ecb>] userspace+0x2dd/0x38a
> 67dcffc8:  [<60013497>] fork_handler+0x62/0x69
> 
> 
--571127323-1161085935-1290102911=:15886--
