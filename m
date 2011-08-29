From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: ext4 lockdep trace (3.1.0rc3)
Date: Mon, 29 Aug 2011 13:47:06 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1108291343460.9183@trent.utfs.org>
References: <20110826214930.GA21818@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110826214930.GA21818@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 26 Aug 2011 at 17:49, Dave Jones wrote:
> just hit this while building a kernel.  Laptop wedged for a few seconds
> during the final link, and this was in the log when it unwedged.

Though I did not notice the "wedged" phase (wasn't around all the time 
when this powerpc laptop was doing lots of disk i/o), this happened here 
too with -rc4:

  http://nerdbynature.de/bits/3.1-rc4/lockdep/

Thanks,
Christian.

[  846.243801] =================================
[  846.246812] [ INFO: inconsistent lock state ]
[  846.248299] 3.1.0-rc4-dirty #1
[  846.249753] ---------------------------------
[  846.251196] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
[  846.252656] kswapd0/17 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  846.254096]  (&sb->s_type->i_mutex_key#4){+.+.?.}, at: [<c013854c>] ext4_evict_inode+0x2c/0x3e8
[  846.255624] {RECLAIM_FS-ON-W} state was registered at:
[  846.257094]   [<c0069dd0>] lockdep_trace_alloc+0xac/0xe4
[  846.258589]   [<c00bed40>] kmem_cache_alloc+0x44/0x134
[  846.260088]   [<c00dcdac>] __d_alloc+0x3c/0x16c
[  846.261570]   [<c00dcf94>] d_alloc+0x24/0x8c
[  846.263045]   [<c00cf7dc>] d_alloc_and_lookup+0x30/0x90
[  846.264533]   [<c00cfdec>] do_lookup+0x2c4/0x398
[  846.266010]   [<c00d1b24>] path_lookupat+0x19c/0x818
[  846.267493]   [<c00d21d4>] do_path_lookup+0x34/0xac
[  846.268944]   [<c00d2454>] kern_path+0x2c/0x58
[  846.270365]   [<c00e6038>] do_mount+0xfc/0x7a0
[  846.271766]   [<c00e677c>] sys_mount+0xa0/0xf8
[  846.273154]   [<c02b9f84>] devtmpfs_mount+0x50/0xc0
[  846.274496]   [<c0515f20>] prepare_namespace+0x170/0x1ac
[  846.275796]   [<c0515234>] kernel_init+0x114/0x134
[  846.277075]   [<c000f850>] kernel_thread+0x4c/0x68
[  846.278339] irq event stamp: 1233731
[  846.279554] hardirqs last  enabled at (1233731): [<c0090330>] free_hot_cold_page+0x12c/0x254
[  846.280821] hardirqs last disabled at (1233730): [<c0090294>] free_hot_cold_page+0x90/0x254
[  846.282083] softirqs last  enabled at (1233144): [<c000f34c>] call_do_softirq+0x14/0x24
[  846.283330] softirqs last disabled at (1233129): [<c000f34c>] call_do_softirq+0x14/0x24
[  846.284535] 
[  846.284537] other info that might help us debug this:
[  846.286914]  Possible unsafe locking scenario:
[  846.286917] 
[  846.289328]        CPU0
[  846.290526]        ----
[  846.291715]   lock(&sb->s_type->i_mutex_key);
[  846.292928]   <Interrupt>
[  846.294082]     lock(&sb->s_type->i_mutex_key);
[  846.295248] 
[  846.295250]  *** DEADLOCK ***
[  846.295253] 
[  846.298561] 2 locks held by kswapd0/17:
[  846.299655]  #0:  (shrinker_rwsem){++++..}, at: [<c0099350>] shrink_slab+0x78/0x2b0
[  846.300820]  #1:  (&type->s_umount_key#26){+++++.}, at: [<c00c6a58>] grab_super_passive+0x5c/0xdc
[  846.302019] 
[  846.302021] stack backtrace:
[  846.304264] Call Trace:
[  846.305388] [ef8fdbf0] [c0009360] show_stack+0x70/0x1bc (unreliable)
[  846.306541] [ef8fdc30] [c00694a0] print_usage_bug+0x224/0x2b8
[  846.307678] [ef8fdc60] [c0069a88] mark_lock+0x554/0x678
[  846.308800] [ef8fdc90] [c006bfec] __lock_acquire+0x72c/0x18a0
[  846.309907] [ef8fdd40] [c006d700] lock_acquire+0x50/0x70
[  846.311017] [ef8fdd60] [c03fe700] mutex_lock_nested+0x68/0x2bc
[  846.312131] [ef8fddb0] [c013854c] ext4_evict_inode+0x2c/0x3e8
[  846.313250] [ef8fddd0] [c00e0038] evict+0xc0/0x1a8
[  846.314369] [ef8fddf0] [c00e06fc] dispose_list+0x44/0x64
[  846.315492] [ef8fde00] [c00e0874] prune_icache_sb+0x158/0x330
[  846.316614] [ef8fde40] [c00c6c20] prune_super+0x148/0x1ac
[  846.317738] [ef8fde60] [c00994b4] shrink_slab+0x1dc/0x2b0
[  846.318865] [ef8fdec0] [c009a12c] kswapd+0x578/0x8e0
[  846.319998] [ef8fdf90] [c0052d2c] kthread+0x84/0x88
-- 
BOFH excuse #15:

temporary routing anomaly
