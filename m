From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [next-20130204] hard LOCKUP on cpu 5, 3, 4, 2
Date: Wed, 13 Feb 2013 00:14:26 -0500
Message-ID: <1360732466.3634.3.camel@thor.lan>
References: <1360730753.3642.38.camel@thor.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-QJIQyHD0w7iMy3I2+nJF"
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Alasdair Kergon <agk@redhat.com>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:37819 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3BMFOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2013 00:14:42 -0500
In-Reply-To: <1360730753.3642.38.camel@thor.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-QJIQyHD0w7iMy3I2+nJF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2013-02-12 at 23:45 -0500, Peter Hurley wrote:
> Got this message log (excerpted below) while building a kernel on
> next-20130204.
> 
> The build was taking place on an ext4 fs which is device-mapped on
> stripped fakeraid.

Happened directly on boot on a lockdep next-20130204 kernel. Log
attached.

> [I have no idea what gvfs was doing.]
> 
> Besides the obvious hard lockups in the fs, the IPIs failed to trigger
> stack dumps for any of the other CPUs [thus +cc x86]. I'm building the
> NMI selftest in now.
> 
> [ 2635.021602] ------------[ cut here ]------------
> [ 2635.021602] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:245 watchdog_overflow_callback+0x9f/0xd0()
> [ 2635.021602] Hardware name: Precision WorkStation T5400  
> [ 2635.021602] Watchdog detected hard LOCKUP on cpu 5
> [ 2635.021602] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_device snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_page_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh lpc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_dj dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 nouveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit[ 2656.019995] INFO: rcu_preempt detected stalls on CPUs/tasks
 :
> [ 2656.020000] 	5: (0 ticks this GP) idle=cfd/140000000000001/0 last_accelerate: e84a/fccd, nonlazy_posted: 0, ..
> [ 2656.020000] 	(detected by 1, t=5252 jiffies, g=99488, c=99487, q=215)
> [ 2656.020000] sending NMI to all CPUs:
> [ 2656.020036] NMI backtrace for cpu 2
> [ 2656.020053] CPU 2 
> [ 2656.020060] Pid: 3116, comm: gvfs-afc-volume Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon #20130204+pcipatch Dell Inc. Precision WorkStation T5400  /0RW203
> [ 2656.020065] RIP: 0010:[<ffffffff8104554d>]  [<ffffffff8104554d>] __ticket_spin_lock+0x1d/0x30
> [ 2656.020076] RSP: 0018:ffff8802a0989c28  EFLAGS: 00000297
> [ 2656.020080] RAX: 0000000000000042 RBX: 0000000000010e10 RCX: ffff8802a0989db8
> [ 2656.020083] RDX: 0000000000000043 RSI: 0000000000000000 RDI: ffff8802afc90e10
> [ 2656.020085] RBP: ffff8802a0989c28 R08: 0000000000000000 R09: 8d8d9adfc58cdaff
> [ 2656.020088] R10: 8080808080808080 R11: 0000000000000000 R12: ffff8800b88cb020
> [ 2656.020090] R13: 0000000000000041 R14: 00000000ffffff9c R15: ffff8802a0989db8
> [ 2656.020093] FS:  00007faef9388700(0000) GS:ffff8802afc80000(0000) knlGS:0000000000000000
> [ 2656.020096] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 2656.020099] CR2: 00002aaaab01d8c0 CR3: 0000000285a32000 CR4: 00000000000007e0
> [ 2656.020102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2656.020104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 2656.020107] Process gvfs-afc-volume (pid: 3116, threadinfo ffff8802a0988000, task ffff8802a0f64530)
> [ 2656.020109] Stack:
> [ 2656.020112]  ffff8802a0989c48 ffffffff810895f5 ffff8802a0989c58 ffff8802a0989db8
> [ 2656.020120]  ffff8802a0989ca8 ffffffff811a17d5 ffff8802a0989c88 0000000000008b97
> [ 2656.020128]  ffff8802a0989cb8 ffffffff81098929 ffff8802a0989c88 ffff8802a0989db8
> [ 2656.020136] Call Trace:
> [ 2656.020144]  [<ffffffff810895f5>] lg_local_lock+0x35/0x40
> [ 2656.020151]  [<ffffffff811a17d5>] path_init+0x205/0x430
> [ 2656.020156]  [<ffffffff81098929>] ? update_curr+0x99/0x1a0
> [ 2656.020160]  [<ffffffff811a1a33>] path_lookupat+0x33/0x760
> [ 2656.020166]  [<ffffffff8101dd29>] ? sched_clock+0x9/0x10
> [ 2656.020170]  [<ffffffff811a2194>] filename_lookup+0x34/0xc0
> [ 2656.020175]  [<ffffffff811a505e>] user_path_at_empty+0x8e/0x110
> [ 2656.020181]  [<ffffffff816f14b2>] ? _raw_spin_lock_irqsave+0x42/0x60
> [ 2656.020186]  [<ffffffff81084c50>] ? lock_hrtimer_base.isra.21+0x30/0x60
> [ 2656.020190]  [<ffffffff81085055>] ? hrtimer_try_to_cancel+0x55/0x120
> [ 2656.020194]  [<ffffffff811a50f1>] user_path_at+0x11/0x20
> [ 2656.020198]  [<ffffffff8119a502>] vfs_fstatat+0x52/0xb0
> [ 2656.020203]  [<ffffffff8119a59b>] vfs_stat+0x1b/0x20
> [ 2656.020206]  [<ffffffff8119a7da>] sys_newstat+0x1a/0x40
> [ 2656.020210]  [<ffffffff810856b4>] ? hrtimer_start_range_ns+0x14/0x20
> [ 2656.020214]  [<ffffffff81085f16>] ? sys_nanosleep+0x66/0x80
> [ 2656.020219]  [<ffffffff816f9059>] system_call_fastpath+0x16/0x1b
> [ 2656.020222] Code: ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 b8 00 01 00 00 48
> 
> <snipped - full log attached>
> 


--=-QJIQyHD0w7iMy3I2+nJF
Content-Disposition: attachment; filename="hard_lockup.next-20130204+lockdep.log"
Content-Type: text/x-log; name="hard_lockup.next-20130204+lockdep.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[   21.620002] ------------[ cut here ]------------
[   21.620002] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:245 watchdog_overflow_callback+0x9f/0xd0()
[   21.620002] Hardware name: Precision WorkStation T5400  
[   21.620002] Watchdog detected hard LOCKUP on cpu 0
[   21.620002] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   21.620002] Pid: 1286, comm: blkid Not tainted 3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch
[   21.620002] Call Trace:
[   21.620002]  <NMI>  [<ffffffff8105ecdf>] warn_slowpath_common+0x7f/0xc0
[   21.620002]  [<ffffffff8105edd6>] warn_slowpath_fmt+0x46/0x50
[   21.620002]  [<ffffffff8110f4b0>] ? touch_nmi_watchdog+0x80/0x80
[   21.620002]  [<ffffffff8110f54f>] watchdog_overflow_callback+0x9f/0xd0
[   21.620002]  [<ffffffff81151e90>] ? perf_event_task_disable+0x90/0x90
[   21.620002]  [<ffffffff811561ed>] __perf_event_overflow+0x9d/0x310
[   21.620002]  [<ffffffff8102c979>] ? x86_perf_event_set_period+0xd9/0x160
[   21.620002]  [<ffffffff8102bd45>] ? x86_perf_event_update+0x55/0xb0
[   21.620002]  [<ffffffff811577a4>] perf_event_overflow+0x14/0x20
[   21.620002]  [<ffffffff81031e3e>] intel_pmu_handle_irq+0x1be/0x370
[   21.620002]  [<ffffffff81799d9d>] perf_event_nmi_handler+0x1d/0x20
[   21.620002]  [<ffffffff817992ee>] nmi_handle.isra.2+0xae/0x1f0
[   21.620002]  [<ffffffff81799245>] ? nmi_handle.isra.2+0x5/0x1f0
[   21.620002]  [<ffffffff81799538>] do_nmi+0x108/0x380
[   21.620002]  [<ffffffff817987c1>] end_repeat_nmi+0x1e/0x2e
[   21.620002]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.620002]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.620002]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.620002]  <<EOE>>  [<ffffffff813acd76>] delay_tsc+0x36/0xf0
[   21.620002]  [<ffffffff813acc7f>] __delay+0xf/0x20
[   21.620002]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   21.620002]  [<ffffffff8179718f>] _raw_spin_lock_irq+0x4f/0x60
[   21.620002]  [<ffffffff813792dd>] ? blk_queue_bio+0x1bd/0x560
[   21.620002]  [<ffffffff813792dd>] blk_queue_bio+0x1bd/0x560
[   21.620002]  [<ffffffff81376a52>] generic_make_request+0xc2/0x110
[   21.620002]  [<ffffffff81376b19>] submit_bio+0x79/0x160
[   21.620002]  [<ffffffff81205585>] ? bio_alloc_bioset+0x65/0x120
[   21.620002]  [<ffffffff811ff743>] submit_bh+0x123/0x210
[   21.620002]  [<ffffffff81201285>] block_read_full_page+0x205/0x3a0
[   21.620002]  [<ffffffff812068b0>] ? I_BDEV+0x10/0x10
[   21.620002]  [<ffffffff8116f205>] ? __lru_cache_add+0x75/0xd0
[   21.620002]  [<ffffffff81206cf8>] blkdev_readpage+0x18/0x20
[   21.620002]  [<ffffffff8116daba>] __do_page_cache_readahead+0x36a/0x370
[   21.620002]  [<ffffffff8116d868>] ? __do_page_cache_readahead+0x118/0x370
[   21.620002]  [<ffffffff81122009>] ? delayacct_end+0x89/0xa0
[   21.620002]  [<ffffffff8116dbf9>] force_page_cache_readahead+0x79/0xb0
[   21.620002]  [<ffffffff8116e123>] page_cache_sync_readahead+0x43/0x50
[   21.620002]  [<ffffffff81162a00>] generic_file_aio_read+0x580/0x700
[   21.620002]  [<ffffffff81206aa4>] blkdev_aio_read+0x54/0x80
[   21.620002]  [<ffffffff811c6e27>] do_sync_read+0x77/0xa0
[   21.620002]  [<ffffffff811c7589>] vfs_read+0xa9/0x180
[   21.620002]  [<ffffffff811c76b2>] sys_read+0x52/0xa0
[   21.620002]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   21.620002] ---[ end trace 159623cd3fb284bb ]---
[   48.427997] BUG: soft lockup - CPU#1 stuck for 23s! [dmsetup_env:1305]
[   48.428000] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   48.428000] irq event stamp: 0
[   48.428000] hardirqs last  enabled at (0): [<          (null)>]           (null)
[   48.428000] hardirqs last disabled at (0): [<ffffffff8105cc2b>] copy_process.part.23+0x61b/0x16b0
[   48.428000] softirqs last  enabled at (0): [<ffffffff8105cc2b>] copy_process.part.23+0x61b/0x16b0
[   48.428000] softirqs last disabled at (0): [<          (null)>]           (null)
[   48.428000] CPU 1 
[   48.428000] Pid: 1305, comm: dmsetup_env Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch Dell Inc. Precision WorkStation T5400  /0RW203
[   48.428000] RIP: 0010:[<ffffffff8179bd7e>]  [<ffffffff8179bd7e>] sub_preempt_count+0x2e/0xa0
[   48.428000] RSP: 0018:ffff8802932bbe48  EFLAGS: 00000202
[   48.428000] RAX: ffff8802932bbfd8 RBX: ffffffff817980b7 RCX: 0000000000000000
[   48.428000] RDX: 00000036d4e59ccc RSI: 0000000000000000 RDI: 0000000000000001
[   48.428000] RBP: ffff8802932bbe48 R08: 0000000000000002 R09: 0000000000000000
[   48.428000] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8802932bbdb8
[   48.428000] R13: ffff880292a9a100 R14: ffff8802932ba000 R15: ffff8802932bbfd8
[   48.428000] FS:  00007fe33496d700(0000) GS:ffff8802afc40000(0000) knlGS:0000000000000000
[   48.428000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   48.428000] CR2: 0000000001cc3768 CR3: 000000029ede1000 CR4: 00000000000007e0
[   48.428000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   48.428000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   48.428000] Process dmsetup_env (pid: 1305, threadinfo ffff8802932ba000, task ffff880292a9a100)
[   48.428000] Stack:
[   48.428000]  ffff8802932bbe88 ffffffff813acdd9 ffff8802932bbfd8 ffffffff81c053c8
[   48.428000]  0000000019760b91 0000000094a1ec46 0000000000001000 0000000001cc2760
[   48.428000]  ffff8802932bbe98 ffffffff813acc7f ffff8802932bbed8 ffffffff813b51a5
[   48.428000] Call Trace:
[   48.428000]  [<ffffffff813acdd9>] delay_tsc+0x99/0xf0
[   48.428000]  [<ffffffff813acc7f>] __delay+0xf/0x20
[   48.428000]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   48.428000]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[   48.428000]  [<ffffffff811e18d1>] ? sys_getcwd+0xa1/0x1f0
[   48.428000]  [<ffffffff81797a75>] ? _raw_spin_unlock+0x35/0x60
[   48.428000]  [<ffffffff811e18d1>] sys_getcwd+0xa1/0x1f0
[   48.428000]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   48.428000] Code: 66 90 44 8b 0d 14 5f 6f 00 55 48 89 e5 45 85 c9 75 19 65 48 8b 04 25 30 c8 00 00 39 b8 44 e0 ff ff 7c 19 81 ff fe 00 00 00 76 36 <65> 48 8b 04 25 30 c8 00 00 29 b8 44 e0 ff ff 5d c3 e8 cc 31 c1 
[   21.576007] ------------[ cut here ]------------
[   21.576007] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:245 watchdog_overflow_callback+0x9f/0xd0()
[   21.576007] Hardware name: Precision WorkStation T5400  
[   21.576007] Watchdog detected hard LOCKUP on cpu 6
[   21.576007] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   21.576007] Pid: 1289, comm: dmraid Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch
[   21.576007] Call Trace:
[   21.576007]  <NMI>  [<ffffffff8105ecdf>] warn_slowpath_common+0x7f/0xc0
[   21.576007]  [<ffffffff8105edd6>] warn_slowpath_fmt+0x46/0x50
[   21.576007]  [<ffffffff8110f4b0>] ? touch_nmi_watchdog+0x80/0x80
[   21.576007]  [<ffffffff8110f54f>] watchdog_overflow_callback+0x9f/0xd0
[   21.576007]  [<ffffffff81151e90>] ? perf_event_task_disable+0x90/0x90
[   21.576007]  [<ffffffff811561ed>] __perf_event_overflow+0x9d/0x310
[   21.576007]  [<ffffffff8102c979>] ? x86_perf_event_set_period+0xd9/0x160
[   21.576007]  [<ffffffff8102bd45>] ? x86_perf_event_update+0x55/0xb0
[   21.576007]  [<ffffffff811577a4>] perf_event_overflow+0x14/0x20
[   21.576007]  [<ffffffff81031e3e>] intel_pmu_handle_irq+0x1be/0x370
[   21.576007]  [<ffffffff81799d9d>] perf_event_nmi_handler+0x1d/0x20
[   21.576007]  [<ffffffff817992ee>] nmi_handle.isra.2+0xae/0x1f0
[   21.576007]  [<ffffffff81799245>] ? nmi_handle.isra.2+0x5/0x1f0
[   21.576007]  [<ffffffff81799538>] do_nmi+0x108/0x380
[   21.576007]  [<ffffffff817987c1>] end_repeat_nmi+0x1e/0x2e
[   21.576007]  [<ffffffff81022a70>] ? native_read_tsc+0x10/0x20
[   21.576007]  [<ffffffff81022a70>] ? native_read_tsc+0x10/0x20
[   21.576007]  [<ffffffff81022a70>] ? native_read_tsc+0x10/0x20
[   21.576007]  <<EOE>>  <IRQ>  [<ffffffff813acd76>] ? delay_tsc+0x36/0xf0
[   21.576007]  [<ffffffff813acc7f>] __delay+0xf/0x20
[   21.576007]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   21.576007]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[   21.576007]  [<ffffffff811ddd6e>] ? dentry_path_raw+0x2e/0x70
[   21.576007]  [<ffffffff811ddd6e>] dentry_path_raw+0x2e/0x70
[   21.576007]  [<ffffffff810ee7a7>] cgroup_path+0x57/0x100
[   21.576007]  [<ffffffff8139c95b>] cfq_completed_request+0xbb/0x9b0
[   21.576007]  [<ffffffff8139c902>] ? cfq_completed_request+0x62/0x9b0
[   21.576007]  [<ffffffff814b6204>] ? mix_pool_bytes.constprop.16+0x44/0x1a0
[   21.576007]  [<ffffffff813b512c>] ? do_raw_spin_lock+0x4c/0x120
[   21.576007]  [<ffffffff813b529d>] ? do_raw_spin_unlock+0x5d/0xb0
[   21.576007]  [<ffffffff81370342>] elv_completed_request+0x62/0x70
[   21.576007]  [<ffffffff813742c7>] __blk_put_request+0x37/0x1a0
[   21.576007]  [<ffffffff81378091>] blk_finish_request+0xf1/0x3a0
[   21.576007]  [<ffffffff813780c1>] ? blk_finish_request+0x121/0x3a0
[   21.576007]  [<ffffffff81378392>] blk_end_bidi_request+0x52/0x80
[   21.576007]  [<ffffffff81378400>] blk_end_request+0x10/0x20
[   21.576007]  [<ffffffff81514fab>] scsi_io_completion+0xfb/0x6c0
[   21.576007]  [<ffffffff813b529d>] ? do_raw_spin_unlock+0x5d/0xb0
[   21.576007]  [<ffffffff8150a9ad>] scsi_finish_command+0xbd/0x120
[   21.576007]  [<ffffffff81514dbe>] scsi_softirq_done+0x13e/0x150
[   21.576007]  [<ffffffff8137ec13>] blk_done_softirq+0x93/0xb0
[   21.576007]  [<ffffffff8106861f>] __do_softirq+0xff/0x420
[   21.576007]  [<ffffffff810cdf8d>] ? trace_hardirqs_off+0xd/0x10
[   21.576007]  [<ffffffff817a153c>] call_softirq+0x1c/0x30
[   21.576007]  [<ffffffff8101d495>] do_softirq+0xa5/0xe0
[   21.576007]  [<ffffffff81068b05>] irq_exit+0xc5/0xd0
[   21.576007]  [<ffffffff8103eca5>] smp_call_function_single_interrupt+0x35/0x40
[   21.576007]  [<ffffffff817a0ff2>] call_function_single_interrupt+0x72/0x80
[   21.576007]  <EOI>  [<ffffffff811dd5e6>] ? prepend_path+0x56/0x1f0
[   21.576007]  [<ffffffff811dd5c8>] ? prepend_path+0x38/0x1f0
[   21.576007]  [<ffffffff811dd7dc>] path_with_deleted+0x5c/0xa0
[   21.576007]  [<ffffffff811dde6f>] d_path+0xbf/0x100
[   21.576007]  [<ffffffff811ee361>] seq_path+0x51/0xd0
[   21.576007]  [<ffffffff8120e2f0>] show_vfsmnt+0x70/0x150
[   21.576007]  [<ffffffff811e8fd6>] m_show+0x16/0x20
[   21.576007]  [<ffffffff811edd3e>] seq_read+0x24e/0x3c0
[   21.576007]  [<ffffffff811c7589>] vfs_read+0xa9/0x180
[   21.576007]  [<ffffffff811c76b2>] sys_read+0x52/0xa0
[   21.576007]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   21.576007] ---[ end trace 159623cd3fb284bc ]---
[   21.176006] ------------[ cut here ]------------
[   21.176006] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:245 watchdog_overflow_callback+0x9f/0xd0()
[   21.176006] Hardware name: Precision WorkStation T5400  
[   21.176006] Watchdog detected hard LOCKUP on cpu 2
[   21.176006] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb[   21.176006] ------------[ cut here ]------------
[   21.176006] WARNING: at /home/peter/src/kernels/next/net/core/skbuff.c:576 skb_release_head_state+0xed/0x100()
[   21.176006] Hardware name: Precision WorkStation T5400  
[   21.176006] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   21.176006] Pid: 751, comm: mount.ntfs-3g Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch
[   21.176006] Call Trace:
[   21.176006]  <NMI>  [<ffffffff8105ecdf>] warn_slowpath_common+0x7f/0xc0
[   21.176006]  [<ffffffff8105ed3a>] warn_slowpath_null+0x1a/0x20
[   21.176006]  [<ffffffff8164aecd>] skb_release_head_state+0xed/0x100
[   21.176006]  [<ffffffff8164b5c6>] __kfree_skb+0x16/0xa0
[   21.176006]  [<ffffffff8164c6f0>] consume_skb+0x30/0x160
[   21.176006]  [<ffffffffa024574d>] tg3_poll_work+0x99d/0xf20 [tg3]
[   21.176006]  [<ffffffff810cdf8d>] ? trace_hardirqs_off+0xd/0x10
[   21.176006]  [<ffffffff817972aa>] ? _raw_write_unlock_irqrestore+0x4a/0x90
[   21.176006]  [<ffffffff811c2913>] ? create_object+0x253/0x310
[   21.176006]  [<ffffffff810cdf8d>] ? trace_hardirqs_off+0xd/0x10
[   21.176006]  [<ffffffffa024e53f>] tg3_poll+0x7f/0x3c0 [tg3]
[   21.176006]  [<ffffffff81676a52>] netpoll_poll_dev+0x1c2/0x3b0
[   21.176006]  [<ffffffff81676e8b>] netpoll_send_skb_on_dev+0x24b/0x3f0
[   21.176006]  [<ffffffff816773f8>] netpoll_send_udp+0x298/0x3c0
[   21.176006]  [<ffffffffa022da77>] write_msg+0xc7/0x110 [netconsole]
[   21.176006]  [<ffffffff81060122>] call_console_drivers.constprop.18+0x92/0x1d0
[   21.176006]  [<ffffffff81061095>] console_unlock+0x2b5/0x440
[   21.176006]  [<ffffffff810615ee>] vprintk_emit+0x27e/0x5a0
[   21.176006]  [<ffffffff810cdf8d>] ? trace_hardirqs_off+0xd/0x10
[   21.176006]  [<ffffffff8110f54f>] ? watchdog_overflow_callback+0x9f/0xd0
[   21.176006]  [<ffffffff8178760b>] printk+0x61/0x63
[   21.176006]  [<ffffffff810e2d8e>] print_modules+0x12e/0x160
[   21.176006]  [<ffffffff8105ecda>] warn_slowpath_common+0x7a/0xc0
[   21.176006]  [<ffffffff8105edd6>] warn_slowpath_fmt+0x46/0x50
[   21.176006]  [<ffffffff8110f4b0>] ? touch_nmi_watchdog+0x80/0x80
[   21.176006]  [<ffffffff8110f54f>] watchdog_overflow_callback+0x9f/0xd0
[   21.176006]  [<ffffffff81151e90>] ? perf_event_task_disable+0x90/0x90
[   21.176006]  [<ffffffff811561ed>] __perf_event_overflow+0x9d/0x310
[   21.176006]  [<ffffffff8102c979>] ? x86_perf_event_set_period+0xd9/0x160
[   21.176006]  [<ffffffff8102bd45>] ? x86_perf_event_update+0x55/0xb0
[   21.176006]  [<ffffffff811577a4>] perf_event_overflow+0x14/0x20
[   21.176006]  [<ffffffff81031e3e>] intel_pmu_handle_irq+0x1be/0x370
[   21.176006]  [<ffffffff81799d9d>] perf_event_nmi_handler+0x1d/0x20
[   21.176006]  [<ffffffff817992ee>] nmi_handle.isra.2+0xae/0x1f0
[   21.176006]  [<ffffffff81799245>] ? nmi_handle.isra.2+0x5/0x1f0
[   21.176006]  [<ffffffff81799538>] do_nmi+0x108/0x380
[   21.176006]  [<ffffffff817987c1>] end_repeat_nmi+0x1e/0x2e
[   21.176006]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.176006]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.176006]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.176006]  <<EOE>>  [<ffffffff813acd76>] delay_tsc+0x36/0xf0
[   21.176006]  [<ffffffff813acc7f>] __delay+0xf/0x20
[   21.176006]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   21.176006]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[   21.176006]  [<ffffffff811ddd6e>] ? dentry_path_raw+0x2e/0x70
[   21.176006]  [<ffffffff811ddd6e>] dentry_path_raw+0x2e/0x70
[   21.176006]  [<ffffffff810ee7a7>] cgroup_path+0x57/0x100
[   21.176006]  [<ffffffff8139afc6>] cfq_insert_request+0xa6/0x630
[   21.176006]  [<ffffffff8139af6d>] ? cfq_insert_request+0x4d/0x630
[   21.176006]  [<ffffffff813b1d6c>] ? list_sort+0x19c/0x230
[   21.176006]  [<ffffffff81376b19>] ? submit_bio+0x79/0x160
[   21.176006]  [<ffffffff81379017>] ? blk_flush_plug_list+0x1a7/0x260
[   21.176006]  [<ffffffff8136fee6>] __elv_add_request+0x1b6/0x3b0
[   21.176006]  [<ffffffff81379045>] blk_flush_plug_list+0x1d5/0x260
[   21.176006]  [<ffffffff813790e8>] blk_finish_plug+0x18/0x50
[   21.176006]  [<ffffffff8116da1c>] __do_page_cache_readahead+0x2cc/0x370
[   21.176006]  [<ffffffff8116d868>] ? __do_page_cache_readahead+0x118/0x370
[   21.176006]  [<ffffffff810d34ed>] ? trace_hardirqs_on+0xd/0x10
[   21.176006]  [<ffffffff8116dc51>] ra_submit+0x21/0x30
[   21.176006]  [<ffffffff8116dd6e>] ondemand_readahead+0x10e/0x3d0
[   21.176006]  [<ffffffff8116e0b8>] page_cache_async_readahead+0x88/0xb0
[   21.176006]  [<ffffffff81160d25>] ? find_get_page+0x5/0x230
[   21.176006]  [<ffffffff811629cb>] generic_file_aio_read+0x54b/0x700
[   21.176006]  [<ffffffff81206aa4>] blkdev_aio_read+0x54/0x80
[   21.176006]  [<ffffffff811c6e27>] do_sync_read+0x77/0xa0
[   21.176006]  [<ffffffff811c7589>] vfs_read+0xa9/0x180
[   21.176006]  [<ffffffff811c783a>] sys_pread64+0x9a/0xb0
[   21.176006]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   21.176006] ---[ end trace 159623cd3fb284bd ]---

[   21.176006]  snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   21.176006] Pid: 751, comm: mount.ntfs-3g Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch
[   21.176006] Call Trace:
[   21.176006]  <NMI>  [<ffffffff8105ecdf>] warn_slowpath_common+0x7f/0xc0
[   21.176006]  [<ffffffff8105edd6>] warn_slowpath_fmt+0x46/0x50
[   21.176006]  [<ffffffff8110f4b0>] ? touch_nmi_watchdog+0x80/0x80
[   21.176006]  [<ffffffff8110f54f>] watchdog_overflow_callback+0x9f/0xd0
[   21.176006]  [<ffffffff81151e90>] ? perf_event_task_disable+0x90/0x90
[   21.176006]  [<ffffffff811561ed>] __perf_event_overflow+0x9d/0x310
[   21.176006]  [<ffffffff8102c979>] ? x86_perf_event_set_period+0xd9/0x160
[   21.176006]  [<ffffffff8102bd45>] ? x86_perf_event_update+0x55/0xb0
[   21.176006]  [<ffffffff811577a4>] perf_event_overflow+0x14/0x20
[   21.176006]  [<ffffffff81031e3e>] intel_pmu_handle_irq+0x1be/0x370
[   21.176006]  [<ffffffff81799d9d>] perf_event_nmi_handler+0x1d/0x20
[   21.176006]  [<ffffffff817992ee>] nmi_handle.isra.2+0xae/0x1f0
[   21.176006]  [<ffffffff81799245>] ? nmi_handle.isra.2+0x5/0x1f0
[   21.176006]  [<ffffffff81799538>] do_nmi+0x108/0x380
[   21.176006]  [<ffffffff817987c1>] end_repeat_nmi+0x1e/0x2e
[   21.176006]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.176006]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.176006]  [<ffffffff81022a66>] ? native_read_tsc+0x6/0x20
[   21.176006]  <<EOE>>  [<ffffffff813acd76>] delay_tsc+0x36/0xf0
[   21.176006]  [<ffffffff813acc7f>] __delay+0xf/0x20
[   21.176006]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   21.176006]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[   21.176006]  [<ffffffff811ddd6e>] ? dentry_path_raw+0x2e/0x70
[   21.176006]  [<ffffffff811ddd6e>] dentry_path_raw+0x2e/0x70
[   21.176006]  [<ffffffff810ee7a7>] cgroup_path+0x57/0x100
[   21.176006]  [<ffffffff8139afc6>] cfq_insert_request+0xa6/0x630
[   21.176006]  [<ffffffff8139af6d>] ? cfq_insert_request+0x4d/0x630
[   21.176006]  [<ffffffff813b1d6c>] ? list_sort+0x19c/0x230
[   21.176006]  [<ffffffff81376b19>] ? submit_bio+0x79/0x160
[   21.176006]  [<ffffffff81379017>] ? blk_flush_plug_list+0x1a7/0x260
[   21.176006]  [<ffffffff8136fee6>] __elv_add_request+0x1b6/0x3b0
[   21.176006]  [<ffffffff81379045>] blk_flush_plug_list+0x1d5/0x260
[   21.176006]  [<ffffffff813790e8>] blk_finish_plug+0x18/0x50
[   21.176006]  [<ffffffff8116da1c>] __do_page_cache_readahead+0x2cc/0x370
[   21.176006]  [<ffffffff8116d868>] ? __do_page_cache_readahead+0x118/0x370
[   21.176006]  [<ffffffff810d34ed>] ? trace_hardirqs_on+0xd/0x10
[   21.176006]  [<ffffffff8116dc51>] ra_submit+0x21/0x30
[   21.176006]  [<ffffffff8116dd6e>] ondemand_readahead+0x10e/0x3d0
[   21.176006]  [<ffffffff8116e0b8>] page_cache_async_readahead+0x88/0xb0
[   21.176006]  [<ffffffff81160d25>] ? find_get_page+0x5/0x230
[   21.176006]  [<ffffffff811629cb>] generic_file_aio_read+0x54b/0x700
[   21.176006]  [<ffffffff81206aa4>] blkdev_aio_read+0x54/0x80
[   21.176006]  [<ffffffff811c6e27>] do_sync_read+0x77/0xa0
[   21.176006]  [<ffffffff811c7589>] vfs_read+0xa9/0x180
[   21.176006]  [<ffffffff811c783a>] sys_pread64+0x9a/0xb0
[   21.176006]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   21.176006] ---[ end trace 159623cd3fb284be ]---
[   76.427997] BUG: soft lockup - CPU#1 stuck for 23s! [dmsetup_env:1305]
[   76.428000] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   76.428000] irq event stamp: 0
[   76.428000] hardirqs last  enabled at (0): [<          (null)>]           (null)
[   76.428000] hardirqs last disabled at (0): [<ffffffff8105cc2b>] copy_process.part.23+0x61b/0x16b0
[   76.428000] softirqs last  enabled at (0): [<ffffffff8105cc2b>] copy_process.part.23+0x61b/0x16b0
[   76.428000] softirqs last disabled at (0): [<          (null)>]           (null)
[   76.428000] CPU 1 
[   76.428000] Pid: 1305, comm: dmsetup_env Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch Dell Inc. Precision WorkStation T5400  /0RW203
[   76.428000] RIP: 0010:[<ffffffff813b6d73>]  [<ffffffff813b6d73>] debug_smp_processor_id+0x33/0xf0
[   76.428000] RSP: 0018:ffff8802932bbe28  EFLAGS: 00000202
[   76.428000] RAX: 0000000000000001 RBX: ffff8802932ba000 RCX: 0000000000000000
[   76.428000] RDX: 000000000000c7c6 RSI: 0000000000000000 RDI: 0000000000000001
[   76.428000] RBP: ffff8802932bbe48 R08: 0000000000000002 R09: 0000000000000000
[   76.428000] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   76.428000] R13: 0000000000000000 R14: 0000000000010002 R15: 0000000000000000
[   76.428000] FS:  00007fe33496d700(0000) GS:ffff8802afc40000(0000) knlGS:0000000000000000
[   76.428000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   76.428000] CR2: 0000000001cc3768 CR3: 000000029ede1000 CR4: 00000000000007e0
[   76.428000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.428000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   76.428000] Process dmsetup_env (pid: 1305, threadinfo ffff8802932ba000, task ffff880292a9a100)
[   76.428000] Stack:
[   76.428000]  0000000000000202 ffffffff81c053c8 00000000338e3431 0000000094a1ec46
[   76.428000]  ffff8802932bbe88 ffffffff813acd68 000000000000c7c6 ffffffff81c053c8
[   76.428000]  00000000338e3431 0000000094a1ec46 0000000000001000 0000000001cc2760
[   76.428000] Call Trace:
[   76.428000]  [<ffffffff813acd68>] delay_tsc+0x28/0xf0
[   76.428000]  [<ffffffff813acc7f>] __delay+0xf/0x20
[   76.428000]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   76.428000]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[   76.428000]  [<ffffffff811e18d1>] ? sys_getcwd+0xa1/0x1f0
[   76.428000]  [<ffffffff81797a75>] ? _raw_spin_unlock+0x35/0x60
[   76.428000]  [<ffffffff811e18d1>] sys_getcwd+0xa1/0x1f0
[   76.428000]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   76.428000] Code: 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 65 48 8b 1c 25 30 c8 00 00 8b 83 44 e0 ff ff 65 44 8b 24 25 1c b0 00 00 85 c0 74 11 44 89 e0 <48> 8b 5d e8 4c 8b 65 f0 4c 8b 6d f8 c9 c3 9c 58 66 66 90 66 90 
[   21.384005] ------------[ cut here ]------------
[   21.384005] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:245 watchdog_overflow_callback+0x9f/0xd0()
[   21.384005] Hardware name: Precision WorkStation T5400  
[   21.384005] Watchdog detected hard LOCKUP on cpu 3
[   21.384005] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[   21.384005] Pid: 1160, comm: blkid Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch
[   21.384005] Call Trace:
[   21.384005]  <NMI>  [<ffffffff8105ecdf>] warn_slowpath_common+0x7f/0xc0
[   21.384005]  [<ffffffff8105edd6>] warn_slowpath_fmt+0x46/0x50
[   21.384005]  [<ffffffff8110f4b0>] ? touch_nmi_watchdog+0x80/0x80
[   21.384005]  [<ffffffff8110f54f>] watchdog_overflow_callback+0x9f/0xd0
[   21.384005]  [<ffffffff81151e90>] ? perf_event_task_disable+0x90/0x90
[   21.384005]  [<ffffffff811561ed>] __perf_event_overflow+0x9d/0x310
[   21.384005]  [<ffffffff8102c979>] ? x86_perf_event_set_period+0xd9/0x160
[   21.384005]  [<ffffffff8102bd45>] ? x86_perf_event_update+0x55/0xb0
[   21.384005]  [<ffffffff811577a4>] perf_event_overflow+0x14/0x20
[   21.384005]  [<ffffffff81031e3e>] intel_pmu_handle_irq+0x1be/0x370
[   21.384005]  [<ffffffff81799d9d>] perf_event_nmi_handler+0x1d/0x20
[   21.384005]  [<ffffffff817992ee>] nmi_handle.isra.2+0xae/0x1f0
[   21.384005]  [<ffffffff81799245>] ? nmi_handle.isra.2+0x5/0x1f0
[   21.384005]  [<ffffffff81799538>] do_nmi+0x108/0x380
[   21.384005]  [<ffffffff817987c1>] end_repeat_nmi+0x1e/0x2e
[   21.384005]  [<ffffffff813acdbd>] ? delay_tsc+0x7d/0xf0
[   21.384005]  [<ffffffff813acdbd>] ? delay_tsc+0x7d/0xf0
[   21.384005]  [<ffffffff813acdbd>] ? delay_tsc+0x7d/0xf0
[   21.384005]  <<EOE>>  [<ffffffff813acc7f>] __delay+0xf/0x20
[   21.384005]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[   21.384005]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[   21.384005]  [<ffffffff811ddd6e>] ? dentry_path_raw+0x2e/0x70
[   21.384005]  [<ffffffff811ddd6e>] dentry_path_raw+0x2e/0x70
[   21.384005]  [<ffffffff810ee7a7>] cgroup_path+0x57/0x100
[   21.384005]  [<ffffffff8139afc6>] cfq_insert_request+0xa6/0x630
[   21.384005]  [<ffffffff8139af6d>] ? cfq_insert_request+0x4d/0x630
[   21.384005]  [<ffffffff813b1d6c>] ? list_sort+0x19c/0x230
[   21.384005]  [<ffffffff81376b19>] ? submit_bio+0x79/0x160
[   21.384005]  [<ffffffff81379017>] ? blk_flush_plug_list+0x1a7/0x260
[   21.384005]  [<ffffffff8136fee6>] __elv_add_request+0x1b6/0x3b0
[   21.384005]  [<ffffffff81379045>] blk_flush_plug_list+0x1d5/0x260
[   21.384005]  [<ffffffff813790e8>] blk_finish_plug+0x18/0x50
[   21.384005]  [<ffffffff8116da1c>] __do_page_cache_readahead+0x2cc/0x370
[   21.384005]  [<ffffffff8116d868>] ? __do_page_cache_readahead+0x118/0x370
[   21.384005]  [<ffffffff81122009>] ? delayacct_end+0x89/0xa0
[   21.384005]  [<ffffffff8116dbf9>] force_page_cache_readahead+0x79/0xb0
[   21.384005]  [<ffffffff8116e123>] page_cache_sync_readahead+0x43/0x50
[   21.384005]  [<ffffffff81162a00>] generic_file_aio_read+0x580/0x700
[   21.384005]  [<ffffffff81206aa4>] blkdev_aio_read+0x54/0x80
[   21.384005]  [<ffffffff811c6e27>] do_sync_read+0x77/0xa0
[   21.384005]  [<ffffffff811c7589>] vfs_read+0xa9/0x180
[   21.384005]  [<ffffffff811c76b2>] sys_read+0x52/0xa0
[   21.384005]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[   21.384005] ---[ end trace 159623cd3fb284bf ]---
[  104.427996] BUG: soft lockup - CPU#1 stuck for 23s! [dmsetup_env:1305]
[  104.428000] Modules linked in: kvm(+) lp ppdev gpio_ich snd_ctxfi(+) snd_pcm dcdbas snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq dm_multipath scsi_dh snd_timer snd_seq_device microcode btusb snd bluetooth soundcore snd_page_alloc psmouse lpc_ich serio_raw parport_pc parport i5400_edac mac_hid edac_core i5k_amb shpchp netconsole configfs dm_mirror dm_region_hash dm_log hid_logitech_dj hid_generic usbhid hid tg3 e1000e ptp pps_core nouveau ttm drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi firewire_core crc_itu_t video wmi usb_storage
[  104.428000] irq event stamp: 0
[  104.428000] hardirqs last  enabled at (0): [<          (null)>]           (null)
[  104.428000] hardirqs last disabled at (0): [<ffffffff8105cc2b>] copy_process.part.23+0x61b/0x16b0
[  104.428000] softirqs last  enabled at (0): [<ffffffff8105cc2b>] copy_process.part.23+0x61b/0x16b0
[  104.428000] softirqs last disabled at (0): [<          (null)>]           (null)
[  104.428000] CPU 1 
[  104.428000] Pid: 1305, comm: dmsetup_env Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon+lockdep #20130204+pcipatch Dell Inc. Precision WorkStation T5400  /0RW203
[  104.428000] RIP: 0010:[<ffffffff813acdc2>]  [<ffffffff813acdc2>] delay_tsc+0x82/0xf0
[  104.428000] RSP: 0018:ffff8802932bbe58  EFLAGS: 00000206
[  104.428000] RAX: 0000005758aec3e4 RBX: 0000000000000001 RCX: 0000000000000000
[  104.428000] RDX: 0000005758aec3e4 RSI: 0000000000000000 RDI: 0000000000000001
[  104.428000] RBP: ffff8802932bbe88 R08: 0000000000000002 R09: 0000000000000000
[  104.428000] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff817980b7
[  104.428000] R13: 0000000000000001 R14: ffff8802932bbdb8 R15: ffff880292a9a100
[  104.428000] FS:  00007fe33496d700(0000) GS:ffff8802afc40000(0000) knlGS:0000000000000000
[  104.428000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.428000] CR2: 0000000001cc3768 CR3: 000000029ede1000 CR4: 00000000000007e0
[  104.428000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  104.428000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  104.428000] Process dmsetup_env (pid: 1305, threadinfo ffff8802932ba000, task ffff880292a9a100)
[  104.428000] Stack:
[  104.428000]  ffffffff813acd49 ffffffff81c053c8 000000004da7088d 0000000094a1ec46
[  104.428000]  0000000000001000 0000000001cc2760 ffff8802932bbe98 ffffffff813acc7f
[  104.428000]  ffff8802932bbed8 ffffffff813b51a5 ffff8802932bbec8 ffffffff81c053c8
[  104.428000] Call Trace:
[  104.428000]  [<ffffffff813acd49>] ? delay_tsc+0x9/0xf0
[  104.428000]  [<ffffffff813acc7f>] __delay+0xf/0x20
[  104.428000]  [<ffffffff813b51a5>] do_raw_spin_lock+0xc5/0x120
[  104.428000]  [<ffffffff81797133>] _raw_spin_lock+0x43/0x50
[  104.428000]  [<ffffffff811e18d1>] ? sys_getcwd+0xa1/0x1f0
[  104.428000]  [<ffffffff81797a75>] ? _raw_spin_unlock+0x35/0x60
[  104.428000]  [<ffffffff811e18d1>] sys_getcwd+0xa1/0x1f0
[  104.428000]  [<ffffffff817a0159>] system_call_fastpath+0x16/0x1b
[  104.428000] Code: 84 24 38 e0 ff ff a8 08 75 5b f3 90 bf 01 00 00 00 e8 43 f0 3e 00 e8 8e 9f 00 00 41 39 c7 75 4c 0f 1f 00 0f ae e8 e8 9e 5c c7 ff <66> 90 48 89 c3 44 29 e8 44 39 f0 bf 01 00 00 00 72 bc e8 77 ef 


--=-QJIQyHD0w7iMy3I2+nJF--

