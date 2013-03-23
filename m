From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/3] ext4: undegister es_shrinker if mount failed
Date: Sat, 23 Mar 2013 10:31:46 +0800
Message-ID: <514D1412.1090405@gmail.com>
References: <1363969123-16852-1-git-send-email-dmonakhov@openvz.org> <1363969123-16852-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55750 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422859Ab3CWCby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Mar 2013 22:31:54 -0400
Received: by mail-pa0-f43.google.com with SMTP id rl6so198111pac.2
        for <linux-ext4@vger.kernel.org>; Fri, 22 Mar 2013 19:31:54 -0700 (PDT)
In-Reply-To: <1363969123-16852-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/23/2013 12:18 AM, Dmitry Monakhov wrote:
> Otherwise destroyed ext_sb_info will be part of global shinker list and result in
> following OOPS:
> 
> JBD2: corrupted journal superblock
> JBD2: recovery failed
> EXT4-fs (dm-2): error loading journal
> general protection fault: 0000 [#1] SMP
> Modules linked in: fuse acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel microcode sg button sd_mod crc_t10dif ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_\
> mod
> CPU 1
> Pid: 2758, comm: mount Not tainted 3.8.0-rc3+ #136                  /DH55TC
> RIP: 0010:[<ffffffff811bfb2d>]  [<ffffffff811bfb2d>] unregister_shrinker+0xad/0xe0
> RSP: 0000:ffff88011d5cbcd8  EFLAGS: 00010207
> RAX: 6b6b6b6b6b6b6b6b RBX: 6b6b6b6b6b6b6b53 RCX: 0000000000000006
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000246
> RBP: ffff88011d5cbce8 R08: 0000000000000002 R09: 0000000000000001
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88011cd3f848
> R13: ffff88011cd3f830 R14: ffff88011cd3f000 R15: 0000000000000000
> FS:  00007f7b721dd7e0(0000) GS:ffff880121a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fffa6f75038 CR3: 000000011bc1c000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process mount (pid: 2758, threadinfo ffff88011d5ca000, task ffff880116aacb80)
> Stack:
> ffff88011cd3f000 ffffffff8209b6c0 ffff88011d5cbd18 ffffffff812482f1
> 00000000000003f3 00000000ffffffea ffff880115f4c200 0000000000000000
> ffff88011d5cbda8 ffffffff81249381 ffff8801219d8bf8 ffffffff00000000
> Call Trace:
> [<ffffffff812482f1>] deactivate_locked_super+0x91/0xb0
> [<ffffffff81249381>] mount_bdev+0x331/0x340
> [<ffffffff81376730>] ? ext4_alloc_flex_bg_array+0x180/0x180
> [<ffffffff81362035>] ext4_mount+0x15/0x20
> [<ffffffff8124869a>] mount_fs+0x9a/0x2e0
> [<ffffffff81277e25>] vfs_kern_mount+0xc5/0x170
> [<ffffffff81279c02>] do_new_mount+0x172/0x2e0
> [<ffffffff8127aa56>] do_mount+0x376/0x380
> [<ffffffff8127ab98>] sys_mount+0x138/0x150
> [<ffffffff818ffed9>] system_call_fastpath+0x16/0x1b
> 
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c7e1509..8196ca2 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4008,6 +4008,7 @@ failed_mount_wq:
>  		sbi->s_journal = NULL;
>  	}
>  failed_mount3:
> +	ext4_es_unregister_shrinker(sb);
>  	del_timer(&sbi->s_err_report);
>  	if (sbi->s_flex_groups)
>  		ext4_kvfree(sbi->s_flex_groups);
> 

Thanks for fixing it.  One thing I concerned is that we could go to
failed_mount3 but ext4_es_register_shrinker() isn't called yet.  So I
think maybe we need to register es_shrinker before initializing some
per-cpu counters.

Thanks,
						- Zheng

>From 596eee1f5caf23084d9b43c47b327206bd8c7ee5 Mon Sep 17 00:00:00 2001
From: Zheng Liu <wenqing.lz@taobao.com>
Date: Sat, 23 Mar 2013 10:26:55 +0800
Subject: [PATCH] register es shrinker before initializing per-cpu counters

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d1ee6a8..80d96bf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3694,6 +3694,9 @@ static int ext4_fill_super(struct super_block *sb,
void *data, int silent)
 	sbi->s_err_report.function = print_daily_error_info;
 	sbi->s_err_report.data = (unsigned long) sb;

+	/* Register extent status tree shrinker */
+	ext4_es_register_shrinker(sb);
+
 	err = percpu_counter_init(&sbi->s_freeclusters_counter,
 			ext4_count_free_clusters(sb));
 	if (!err) {
@@ -3719,9 +3722,6 @@ static int ext4_fill_super(struct super_block *sb,
void *data, int silent)
 	sbi->s_max_writeback_mb_bump = 128;
 	sbi->s_extent_max_zeroout_kb = 32;

-	/* Register extent status tree shrinker */
-	ext4_es_register_shrinker(sb);
