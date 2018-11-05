Return-Path: <SRS0=Yxos=NQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from relay.sw.ru ([185.231.240.75]:38356 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbeKEOtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Nov 2018 09:49:19 -0500
Subject: Re: [LKP] [ext4 resize] 1ee5ee5ec3: WARNING:at_fs/buffer.c:#__brelse
To: kernel test robot <rong.a.chen@intel.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, lkp@01.org
References: <20181105051011.GR24195@shao2-debian>
From: Vasily Averin <vvs@virtuozzo.com>
Message-ID: <1cd8dca2-a677-42ef-a558-c8a9b8e084da@virtuozzo.com>
Date: Mon, 5 Nov 2018 08:31:20 +0300
MIME-Version: 1.0
In-Reply-To: <20181105051011.GR24195@shao2-debian>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/5/18 8:10 AM, kernel test robot wrote:
> FYI, we noticed the following commit (built with gcc-7):
> 
> commit: 1ee5ee5ec39e53af9bcd215f4d127b21d579f700 ("[PATCH 3/7] ext4 resize: missing brelse() in case success in add_new_gdb()")
yes, you're right, this patch was wrong and it was dropped in v2 version of patch set.

> url: https://github.com/0day-ci/linux/commits/Vasily-Averin/ext4-resize-long-lived-errors/20181029-235050
> base: https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git dev
> 
> in testcase: xfstests
> with following parameters:
> 
> 	disk: 4HDD
> 	fs: ext4
> 	test: ext4-run
> 
> test-description: xfstests is a regression test suite for xfs and other files ystems.
> test-url: git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu IvyBridge -smp 2 -m 2G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 
> 
> +----------------------------------+------------+------------+
> |                                  | 36943dd65f | 1ee5ee5ec3 |
> +----------------------------------+------------+------------+
> | boot_successes                   | 8          | 6          |
> | boot_failures                    | 16         | 23         |
> | BUG:kernel_hang_in_test_stage    | 16         | 23         |
> | WARNING:at_fs/buffer.c:#__brelse | 0          | 13         |
> | RIP:__brelse                     | 0          | 13         |
> | RIP:_raw_spin_unlock_irqrestore  | 0          | 9          |
> | RIP:native_safe_halt             | 0          | 12         |
> | RIP:___bpf_prog_run              | 0          | 2          |
> | RIP:do_syscall_64                | 0          | 2          |
> +----------------------------------+------------+------------+
> 
> 
> 
> [ 3803.071979] WARNING: CPU: 1 PID: 22511 at fs/buffer.c:1143 __brelse+0x1d/0x20
> [ 3803.074213] Modules linked in: loop dm_mod sr_mod cdrom sg ata_generic pata_acpi crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ppdev pcbc aesni_intel crypto_simd cryptd glue_helper snd_pcm snd_timer snd soundcore ata_piix pcspkr serio_raw libata i2c_piix4 floppy parport_pc parport ip_tables
> [ 3803.080055] CPU: 1 PID: 22511 Comm: resize2fs Not tainted 4.19.0-rc6-00024-g1ee5ee5 #1
> [ 3803.082218] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> [ 3803.084455] RIP: 0010:__brelse+0x1d/0x20
> [ 3803.085596] Code: 00 00 e8 56 ff ff ff 31 c0 c3 0f 1f 00 0f 1f 44 00 00 8b 47 60 85 c0 74 05 f0 ff 4f 60 c3 48 c7 c7 b0 0d 2f 82 e8 63 d1 dc ff <0f> 0b c3 0f 1f 44 00 00 55 53 65 ff 05 d2 54 d5 7e 48 c7 c3 00 fe
> [ 3803.089725] RSP: 0018:ffffc90000bb3c90 EFLAGS: 00010282
> [ 3803.091018] RAX: 0000000000000000 RBX: ffff88007b7c2e00 RCX: 0000000000000000
> [ 3803.092572] RDX: ffff880060b1ef40 RSI: ffff880060b16898 RDI: ffff880060b16898
> [ 3803.094134] RBP: ffff880013a9b000 R08: 0000000000000000 R09: 00000000000004b8
> [ 3803.095788] R10: ffff88007e8cde10 R11: ffffffff82f8afcd R12: ffff880013a9b388
> [ 3803.097383] R13: 00000000fffffffb R14: 0000000000000000 R15: ffff88007b7c2e00
> [ 3803.098937] FS:  00007f66516b6780(0000) GS:ffff880060b00000(0000) knlGS:0000000000000000
> [ 3803.101114] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3803.102470] CR2: 000055c94d9c5e18 CR3: 0000000017b24000 CR4: 00000000001406e0
> [ 3803.104035] Call Trace:
> [ 3803.104941]  __jbd2_journal_remove_checkpoint+0x50/0x170
> [ 3803.106277]  jbd2_log_do_checkpoint+0x45d/0x4e0
> [ 3803.107448]  ? jbd2_journal_flush+0x90/0x1b0
> [ 3803.108707]  jbd2_journal_flush+0x90/0x1b0
> [ 3803.109851]  ext4_ioctl+0x101d/0x1540
> [ 3803.110914]  ? do_filp_open+0xaf/0x110
> [ 3803.111970]  do_vfs_ioctl+0xa5/0x6e0
> [ 3803.113012]  ksys_ioctl+0x70/0x80
> [ 3803.114010]  __x64_sys_ioctl+0x16/0x20
> [ 3803.115083]  do_syscall_64+0x5b/0x180
> [ 3803.116144]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 3803.117391] RIP: 0033:0x7f665093fdd7
> [ 3803.118425] Code: 00 00 00 48 8b 05 c1 80 2b 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 91 80 2b 00 f7 d8 64 89 01 48
> [ 3803.122509] RSP: 002b:00007fffee31c5c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [ 3803.124572] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f665093fdd7
> [ 3803.126131] RDX: 00007fffee31c710 RSI: 0000000040086610 RDI: 0000000000000005
> [ 3803.127660] RBP: 000055c94d9ba0e0 R08: 0000000000000001 R09: 0000000000000029
> [ 3803.129197] R10: 0000000000000075 R11: 0000000000000246 R12: 000055c94d9ba080
> [ 3803.130731] R13: 0000000000000000 R14: 000055c94d9bd580 R15: 00007fffee31c710
> [ 3803.132266] ---[ end trace 372e51e2ec3d21dc ]---
> 
> 
> To reproduce:
> 
>         git clone https://github.com/intel/lkp-tests.git
>         cd lkp-tests
>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
> 
> 
> 
> Thanks,
> Rong Chen
> 
