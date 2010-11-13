From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Strange bug
Date: Sat, 13 Nov 2010 15:18:10 -0600
Message-ID: <4CDF0092.1030001@sandeen.net>
References: <loom.20101113T101254-909@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Mariusz Bialonczyk <manio@skyboo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 64-131-28-21.usfamily.net ([64.131.28.21]:45907 "EHLO
	mail.sandeen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab0KMVrB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Nov 2010 16:47:01 -0500
In-Reply-To: <loom.20101113T101254-909@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/13/10 3:18 AM, Mariusz Bialonczyk wrote:
> Hello
> I'd like to share the bug report which i had on yesterday's git kernel.
> After some time of normal work i've suddenly got this:
> Nov 12 23:19:34 draco kernel: [  997.220385] ------------[ cut 
> here ]------------
> Nov 12 23:19:34 draco kernel: [  997.220452] kernel BUG at fs/ext4/page-
> io.c:146!

https://patchwork.kernel.org/patch/307282/

-Eric

> Nov 12 23:19:34 draco kernel: [  997.220513] invalid opcode: 0000 [#1] SMP 
> Nov 12 23:19:34 draco kernel: [  997.220559] last sysfs file: /sys/devices/
> platform/it87.656/fan1_input
> Nov 12 23:19:34 draco kernel: [  997.220559] CPU 0 
> Nov 12 23:19:34 draco kernel: [  997.220559] Modules linked in: nvidia(P) 
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_REDIRECT 
> ipt_REJECT xt_limit xt_state xt_mark xt_tcpudp iptable_mangle ipt
> able_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables 
> x_tables tun ipv6 it87 hwmon_vid w1_therm snd_pcm_oss snd_mixer_oss 
> nf_conntrack_ftp nf_conntrack loop cx88_dvb videobuf_dvb stb6100 dvb_c
> ore stv0900 tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple 
> tuner_types mt20xx tea5761 cx8802 cx8800 cx88xx v4l2_common snd_emu10k1 
> snd_rawmidi snd_ac97_codec ftdi_sio ac97_bus snd_pcm snd_timer sn
> d_page_alloc ide_cd_mod videodev snd_util_mem tveeprom v4l1_compat snd_hwdep 
> cdrom videobuf_dma_sg usb_storage ch341 snd btcx_risc videobuf_core k10temp 
> i2c_piix4 ds249
> 0 wire [last unloaded: nvidia]
> Nov 12 23:19:34 draco kernel: [  997.220559] 
> Nov 12 23:19:34 draco kernel: [  997.220559] Pid: 5498, comm: zsh Tainted: 
> P            2.6.37-rc1-00057-gc3e1500-dirty #1 M4A785TD-V EVO/System Product 
> Name
> Nov 12 23:19:34 draco kernel: [  997.220559] RIP: 0010:[<ffffffff810f65a9>]  
> [<ffffffff810f65a9>] ext4_init_io_end+0x3c/0x72
> Nov 12 23:19:34 draco kernel: [  997.220559] RSP: 0018:ffff8801374118e8  
> EFLAGS: 00010246
> Nov 12 23:19:34 draco kernel: [  997.220559] RAX: 0000000000000000 RBX: 
> ffff880127bad830 RCX: 0000000000000000
> Nov 12 23:19:34 draco kernel: [  997.220559] RDX: ffffea000437c2a0 RSI: 
> 000000000000000c RDI: ffffffff81738120
> Nov 12 23:19:34 draco kernel: [  997.220559] RBP: ffff8801374118f8 R08: 
> ffff88013f4f56e0 R09: dead000000200200
> Nov 12 23:19:34 draco kernel: [  997.220559] R10: dead000000100100 R11: 
> 0000000000000044 R12: ffff8801278d34e8
> Nov 12 23:19:34 draco kernel: [  997.220559] R13: ffff880137411a78 R14: 
> ffff88011f18ab08 R15: ffffea000437c2a0
> Nov 12 23:19:34 draco kernel: [  997.220559] FS:  00007f1ee6f32700(0000) 
> GS:ffff8800afc00000(0000) knlGS:0000000000000000
> Nov 12 23:19:34 draco kernel: [  997.220559] CS:  0010 DS: 0000 ES: 0000 CR0: 
> 000000008005003b
> Nov 12 23:19:34 draco kernel: [  997.220559] CR2: 00007f1ee6f3f000 CR3: 
> 000000013f474000 CR4: 00000000000006f0
> Nov 12 23:19:34 draco kernel: [  997.220559] DR0: 0000000000000000 DR1: 
> 0000000000000000 DR2: 0000000000000000
> Nov 12 23:19:34 draco kernel: [  997.220559] DR3: 0000000000000000 DR6: 
> 00000000ffff0ff0 DR7: 0000000000000400
> Nov 12 23:19:34 draco kernel: [  997.220559] Process zsh (pid: 5498, threadinfo 
> ffff880137410000, task ffff880121670850)
> Nov 12 23:19:34 draco kernel: [  997.220559] Stack:
> Nov 12 23:19:34 draco kernel: [  997.220559]  ffff880122c862d0 ffffea000437c2a0 
> ffff880137411978 ffffffff810f6751
> Nov 12 23:19:34 draco kernel: [  997.220559]  ffff8801374119d8 ffff880137411c78 
> 0000004827bad960 ffffea000437c2a0
> Nov 12 23:19:34 draco kernel: [  997.220559]  ffff880122c862d0 ffff880127bad830 
> 0000100037411bd8 0000000000000020
> Nov 12 23:19:34 draco kernel: [  997.220559] Call Trace:
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810f6751>] 
> ext4_bio_write_page+0x172/0x304
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810f2206>] 
> mpage_da_submit_io+0x36a/0x3ed
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810efc8c>] ? 
> ext4_mark_iloc_dirty+0x495/0x529
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810f5a14>] 
> mpage_da_map_and_submit+0x372/0x3ae
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff8111b402>] ? 
> jbd2_journal_start+0xe/0x10
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810f61f9>] 
> ext4_da_writepages+0x34d/0x4af
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81066d76>] do_writepages
> +0x1c/0x25
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81061589>] 
> __filemap_fdatawrite_range+0x4b/0x4d
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81061bd9>] 
> filemap_fdatawrite_range+0xe/0x10
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81119863>] 
> jbd2_journal_begin_ordered_truncate+0x68/0x8b
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810f535d>] 
> ext4_evict_inode+0x257/0x29b
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff8109ae1b>] evict
> +0x22/0x93
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff8109b7be>] iput
> +0x200/0x237
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81097f7d>] dentry_iput
> +0x95/0xa5
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff8109807b>] d_kill
> +0x3d/0x5d
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff810986e3>] dput
> +0x119/0x126
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81093b0a>] sys_renameat
> +0x1b5/0x258
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81081c76>] ? 
> free_pages_and_swap_cache+0x8b/0xa8
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff811f156d>] ? 
> cpumask_any_but+0x29/0x36
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81079996>] ? remove_vma
> +0x57/0x5f
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff8107aa5c>] ? do_munmap
> +0x30b/0x32d
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81093bc3>] sys_rename
> +0x16/0x18
> Nov 12 23:19:34 draco kernel: [  997.220559]  [<ffffffff81001eab>] 
> system_call_fastpath+0x16/0x1b
> Nov 12 23:19:34 draco kernel: [  997.220559] Code: e8 1f 01 f9 ff 48 85 c0 49 
> 89 c4 74 4c 31 c0 b9 1a 01 00 00 4c 89 e7 f3 ab 48 89 df e8 23 43 fa ff 48 85 
> c0 49 89 44 24 10 75 04 <0f> 0b eb fe 49 8d 44 24 40 49 c7 44 24 38 00 09 00 00 
> 49 c7 44 
> Nov 12 23:19:34 draco kernel: [  997.220559] RIP  [<ffffffff810f65a9>] 
> ext4_init_io_end+0x3c/0x72
> Nov 12 23:19:34 draco kernel: [  997.220559]  RSP <ffff8801374118e8>
> Nov 12 23:19:34 draco kernel: [  997.256518] ---[ end trace 
> 03ab35d0fed84b8a ]---
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

