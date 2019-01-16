Return-Path: <SRS0=njA7=PY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40165 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729532AbfAPStC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jan 2019 13:49:02 -0500
Received: by mail-lj1-f193.google.com with SMTP id n18-v6so6347653lji.7
        for <linux-ext4@vger.kernel.org>; Wed, 16 Jan 2019 10:48:59 -0800 (PST)
MIME-Version: 1.0
References: <CAAQ4vX2wrzxzP6=bP9Bbt89Hvs_JRJuZxSQGfPw2vUrtOqh3UA@mail.gmail.com>
 <20180913223252.GD30588@thunk.org> <CAAQ4vX2nujND+s7mK-3EztS+MtLeNsNgmd=kwFQmVSa1ABjrKQ@mail.gmail.com>
 <CAAQ4vX3a5RrD_Dt7tFJ23cof=FAK3fd5jrF+c45YujbjwNcKmw@mail.gmail.com> <20181019001849.GC2407@thunk.org>
In-Reply-To: <20181019001849.GC2407@thunk.org>
From: Nathan Peterson <nathan@uwgrads.com>
Date: Wed, 16 Jan 2019 10:48:46 -0800
Message-ID: <CAAQ4vX2Sh1+rA3Ov1rvy3YO2seVaZ2AkbAOZAhzOx+KqX9-NTA@mail.gmail.com>
Subject: Re: Unable to mount an ext4 RAID6 array
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Long overdue update.  I confirmed(thanks to Ted) it was indeed a HW
issue.  Long story short, that issue is resolved and I am able to run
e2fsck.

The next issue I ran into was lack of swapfile space.  This was
causing the e2fsck to fail during the check(as expected).

I resolved this(so far) by increasing the swapfile size to 50GB.
sudo e2fsck -y -C 0 /dev/mapper/enc6 is the command I sent and it has
been running for 38days straight.
Currently the swapfile size is at 13.2GB and growing.

           Version : 1.2
     Creation Time : Sun Nov 26 23:03:26 2017
        Raid Level : raid6
        Array Size : 42975741952 (40984.86 GiB 44007.16 GB)
     Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
      Raid Devices : 13
     Total Devices : 13
       Persistence : Superblock is persistent

     Intent Bitmap : Internal

       Update Time : Sun Jan  6 09:21:27 2019
             State : clean
    Active Devices : 13
   Working Devices : 13
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : bitmap

ps -eo comm,tty | grep fsck
e2fsck          ?

ps -ef | grep fsck
root      1890     1  0  2018 ?        00:00:00 sudo e2fsck -y -C 0
/dev/mapper/enc6
root      1891  1890  0  2018 ?        02:01:24 e2fsck -y -C 0 /dev/mapper/enc6

These are found in the dmesg log and are rare occurrence:
[Jan16 00:14] INFO: task mandb:25013 blocked for more than 120 seconds.
[  +0.000001]       Tainted: G           OE    4.15.0-42-generic #45-Ubuntu
[  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  +0.000000] mandb           D    0 25013  25009 0x00000000
[  +0.000002] Call Trace:
[  +0.000005]  __schedule+0x291/0x8a0
[  +0.000002]  ? blk_queue_bio+0x32a/0x450
[  +0.000002]  ? bit_wait+0x60/0x60
[  +0.000001]  schedule+0x2c/0x80
[  +0.000002]  io_schedule+0x16/0x40
[  +0.000001]  bit_wait_io+0x11/0x60
[  +0.000001]  __wait_on_bit+0x4c/0x90
[  +0.000001]  ? submit_bio+0x73/0x140
[  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
[  +0.000003]  ? bit_waitqueue+0x40/0x40
[  +0.000001]  __wait_on_buffer+0x32/0x40
[  +0.000003]  __ext4_get_inode_loc+0x1b5/0x410
[  +0.000001]  ext4_iget+0x92/0xb90
[  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
[  +0.000001]  ext4_iget_normal+0x30/0x40
[  +0.000002]  ext4_lookup+0xf0/0x210
[  +0.000001]  path_openat+0xd30/0x1770
[  +0.000001]  ? pipe_wait+0xc0/0xc0
[  +0.000002]  do_filp_open+0x9b/0x110
[  +0.000001]  ? user_path_at_empty+0x36/0x40
[  +0.000001]  ? user_path_at_empty+0x36/0x40
[  +0.000002]  ? __check_object_size+0xaf/0x1b0
[  +0.000002]  ? __alloc_fd+0x46/0x170
[  +0.000002]  do_sys_open+0x1bb/0x2c0
[  +0.000001]  ? do_sys_open+0x1bb/0x2c0
[  +0.000002]  ? __put_cred+0x3d/0x50
[  +0.000001]  ? SyS_access+0x13d/0x230
[  +0.000002]  SyS_openat+0x14/0x20
[  +0.000002]  do_syscall_64+0x73/0x130
[  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
[  +0.000002] RIP: 0033:0x7f28799c9cdd
[  +0.000000] RSP: 002b:00007ffcf9ce33c8 EFLAGS: 00000287 ORIG_RAX:
0000000000000101
[  +0.000001] RAX: ffffffffffffffda RBX: 00007ffcf9ce3670 RCX: 00007f28799c9cdd
[  +0.000001] RDX: 0000000000080000 RSI: 00007ffcf9ce3450 RDI: 00000000ffffff9c
[  +0.000001] RBP: 00007ffcf9ce3430 R08: 0000000000000000 R09: 00007ffcf9ce365f
[  +0.000000] R10: 0000000000000000 R11: 0000000000000287 R12: 0000000000000007
[  +0.000001] R13: 0000000000000000 R14: 00007ffcf9ce3450 R15: 0000000000000000


My question, Is it possible to see the progress or at least know this
is going somewhere positive?

Thanks
-Nathan

On Thu, Oct 18, 2018 at 5:18 PM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> Hi,
>
> Sorry I didn't get back to you sooner.  This e-mail thread got lost in
> my inbox, so thanks for pinging me about it.
>
> These lines in the logs clearly show that it is a hardware problem.
> It could be an issue with the SATA controller, or cables, or even
> something in the motherboard.
>
> [  +0.000006] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000004] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000005] ata1: hard resetting link
> [  +5.634542] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001809] ata1.00: configured for UDMA/133
> [  +0.000003] ata1: EH complete
> [Sep13 19:47] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
>
> The following article (found via Google) on Serverfault might be
> helpful:
>
> https://serverfault.com/questions/749433/hard-resetting-link-exception-emask-0x50-sact-0x0-serr-0x4090800-action-0xe-froz
>
> Good luck,
>
>                                         - Ted
