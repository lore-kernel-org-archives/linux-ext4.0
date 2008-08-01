From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [BUG] 2.6.27-rc1 in ext3_find_entry
Date: Fri, 01 Aug 2008 16:43:03 +0100
Message-ID: <48932F07.9090407@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:6332 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYHAPmy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 11:42:54 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1137630ika.5
        for <linux-ext4@vger.kernel.org>; Fri, 01 Aug 2008 08:42:52 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

...followed by several secondary BUGs; most happened as I tried to open
new Konsole instances.  My computer soon became unusable - X restarted
and then froze, but it responded to SysRQs.  It may just have been all
my processes dying, but there was more disk activity than I expected.

Strictly speaking I was running v2.6.26-8042-gce6fce4, with a two-line
patch to fix a different problem (see
<http://bugzilla.kernel.org/show_bug.cgi?id=11178>).

In case it matters, this happened some time after a series of maybe 3
suspend/resume cycles in quick succession.  As you can see it happened
in the middle of running git; I forget exactly what I was doing.

I checked kerneloops and didn't see a duplicate, so here it is.


[  228.358397] BUG: unable to handle kernel paging request at ffff88004fc00006
[  228.358405] IP: [<ffffffffa0153230>] ext3_find_entry+0x190/0x620 [ext3]
[  228.358423] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.358428] Oops: 0000 [1] SMP 
[  228.358431] CPU 0 
[  228.358433] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.358490] Pid: 8258, comm: git Not tainted 2.6.26 #21
[  228.358493] RIP: 0010:[<ffffffffa0153230>]  [<ffffffffa0153230>] ext3_find_entry+0x190/0x620 [ext3]
[  228.358503] RSP: 0018:ffff88005968faf8  EFLAGS: 00010216
[  228.358506] RAX: ffff88004fc00007 RBX: ffff88004fc00000 RCX: 000000000000000c
[  228.358508] RDX: ffff880050142ac8 RSI: ffff88005968fa98 RDI: ffff880001002680
[  228.358510] RBP: ffff880050102690 R08: 0000000000000000 R09: ffff88004fc01000
[  228.358513] R10: 0000000000000007 R11: 0000000000000007 R12: 0000000000000001
[  228.358515] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
[  228.358518] FS:  00002b9c5b2b34a0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.358520] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.358523] CR2: ffff88004fc00006 CR3: 000000005956e000 CR4: 00000000000026e0
[  228.358525] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.358528] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.358530] Process git (pid: 8258, threadinfo ffff88005968e000, task ffff880059769230)
[  228.358532] Stack:  ffff880053c7b460 ffffffff802c59ba ffff88005968fc58 ffff880050105680
[  228.358537]  ffff88007cb56400 0000000000000000 0000000160f02850 ffff880050142ac8
[  228.358542]  ffff88005010572c ffff88005010565c 000000000001600a ffff88007cb56400
[  228.358546] Call Trace:
[  228.358552]  [<ffffffff802c59ba>] ? __find_get_block+0x9a/0x1a0
[  228.358558]  [<ffffffff8024f4c0>] ? bit_waitqueue+0x10/0xc0
[  228.358561]  [<ffffffff8024f5b8>] ? wake_up_bit+0x18/0x40
[  228.358571]  [<ffffffffa0155164>] ? ext3_lookup+0x54/0x100 [ext3]
[  228.358576]  [<ffffffff80452ef5>] ? _spin_lock+0x5/0x10
[  228.358580]  [<ffffffff802b3398>] ? d_alloc+0x168/0x1d0
[  228.358584]  [<ffffffff802a8217>] ? do_lookup+0x1b7/0x250
[  228.358587]  [<ffffffff802aa2fd>] ? __link_path_walk+0x74d/0xdd0
[  228.358591]  [<ffffffff802aa9d4>] ? path_walk+0x54/0xb0
[  228.358594]  [<ffffffff802aaafa>] ? do_path_lookup+0x7a/0x160
[  228.358597]  [<ffffffff802a9925>] ? getname+0xe5/0x1f0
[  228.358601]  [<ffffffff802ab744>] ? user_path_at+0x44/0x80
[  228.358604]  [<ffffffff802a3325>] ? cp_new_stat+0xe5/0x100
[  228.358607]  [<ffffffff802a3640>] ? vfs_lstat_fd+0x20/0x60
[  228.358610]  [<ffffffff802a36a7>] ? sys_newlstat+0x27/0x50
[  228.358614]  [<ffffffff8020c44a>] ? system_call_fastpath+0x16/0x1b
[  228.358616] 
[  228.358617] 
[  228.358618] Code: 66 83 f8 ff 74 0d 0f b7 c0 85 c0 7e 68 48 63 d0 48 89 d1 48 01 cb 49 39 d9 0f 86 04 03 00 00 49 01 d0 4a 8d 04 13 49 39 c1 72 c7 <0f> b6 43 06 41 39 c3 75 be 8b 03 85 c0 74 b8 48 8b 74 24 40 48 
[  228.358654] RIP  [<ffffffffa0153230>] ext3_find_entry+0x190/0x620 [ext3]
[  228.358664]  RSP <ffff88005968faf8>
[  228.358666] CR2: ffff88004fc00006
[  228.358676] ---[ end trace c66316e93d39a7ca ]---
[  228.360623] BUG: unable to handle kernel paging request at ffff88004fc01000
[  228.360627] IP: [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.360633] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.360637] Oops: 0002 [2] SMP 
[  228.360640] CPU 0 
[  228.360642] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.360698] Pid: 4626, comm: syslogd Tainted: G      D   2.6.26 #21
[  228.360700] RIP: 0010:[<ffffffff80322885>]  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.360704] RSP: 0000:ffff88007aea9db0  EFLAGS: 00010286
[  228.360706] RAX: ffff880000000000 RBX: 0000000000000000 RCX: 0000000000000200
[  228.360709] RDX: 6db6db6db6db6db7 RSI: ffff880079216000 RDI: ffff88004fc01000
[  228.360711] RBP: ffff88007f234990 R08: 0000000000000000 R09: 0000000000000000
[  228.360713] R10: 0000000000000001 R11: 0000000000000246 R12: 000000000004fc01
[  228.360716] R13: ffffe20001b9f158 R14: ffffe20001a7f4d0 R15: 00007f98e65b0774
[  228.360718] FS:  00007f98e65b06e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.360721] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.360723] CR2: ffff88004fc01000 CR3: 0000000037588000 CR4: 00000000000026e0
[  228.360726] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.360728] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.360731] Process syslogd (pid: 4626, threadinfo ffff88007aea8000, task ffff88007a939230)
[  228.360733] Stack:  ffffffff80283c44 ffff880059769840 ffff880037906000 ffff88007e2e1a00
[  228.360738]  ffffe20001172038 ffff880001024f30 8000000079216065 0000000000000001
[  228.360742]  ffffe20001b9f158 00007f98e65b0774 ffff88007e44fd80 ffff88007e2e1a00
[  228.360746] Call Trace:
[  228.360750]  [<ffffffff80283c44>] ? do_wp_page+0x124/0x640
[  228.360753]  [<ffffffff80285c35>] ? handle_mm_fault+0x735/0x910
[  228.360757]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.360760]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.360764]  [<ffffffff80451be9>] ? mutex_lock+0x9/0x20
[  228.360767]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.360769] 
[  228.360770] 
[  228.360771] Code: 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 0f 1f 84 00 00 00 00 00 
[  228.360807] RIP  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.360811]  RSP <ffff88007aea9db0>
[  228.360812] CR2: ffff88004fc01000
[  228.360814] ---[ end trace c66316e93d39a7ca ]---
[  228.360817] note: syslogd[4626] exited with preempt_count 2
[  228.368774] BUG: unable to handle kernel paging request at ffff88004fc02000
[  228.368779] IP: [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.368785] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.368789] Oops: 0002 [3] SMP 
[  228.368793] CPU 0 
[  228.368795] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.368859] Pid: 8260, comm: udevd Tainted: G      D   2.6.26 #21
[  228.368861] RIP: 0010:[<ffffffff80322885>]  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.368866] RSP: 0000:ffff880062365db0  EFLAGS: 00010286
[  228.368868] RAX: ffff880000000000 RBX: 0000000000000000 RCX: 0000000000000200
[  228.368871] RDX: 6db6db6db6db6db7 RSI: ffff88005c74d000 RDI: ffff88004fc02000
[  228.368873] RBP: ffff88003774c018 R08: 0000000000000000 R09: 0000000000000000
[  228.368876] R10: 0000000000000001 R11: 00007fc07347bca0 R12: 000000000004fc02
[  228.368878] R13: ffffe20000c2c4a0 R14: ffffe200014398d8 R15: 0000000000613040
[  228.368881] FS:  00007fc073b15780(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.368885] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.368887] CR2: ffff88004fc02000 CR3: 0000000059430000 CR4: 00000000000026e0
[  228.368889] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.368892] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.368895] Process udevd (pid: 8260, threadinfo ffff880062364000, task ffff880059769840)
[  228.368897] Stack:  ffffffff80283c44 ffffe20000000000 ffff880059597738 ffff880066179380
[  228.368902]  ffffe20001172070 0000000001014fb8 800000005c74d065 0000000000000001
[  228.368908]  ffffe20000c2c4a0 0000000000613040 ffff880037a5e098 ffff880066179380
[  228.368912] Call Trace:
[  228.368916]  [<ffffffff80283c44>] ? do_wp_page+0x124/0x640
[  228.368919]  [<ffffffff80285c35>] ? handle_mm_fault+0x735/0x910
[  228.368924]  [<ffffffff8031fccd>] ? rb_insert_color+0x8d/0x110
[  228.368928]  [<ffffffff802520ce>] ? enqueue_hrtimer+0x6e/0xf0
[  228.368931]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.368935]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.368939]  [<ffffffff8023e162>] ? do_setitimer+0x162/0x390
[  228.368942]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.368945]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.368947] 
[  228.368948] 
[  228.368949] Code: 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 0f 1f 84 00 00 00 00 00 
[  228.368990] RIP  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.368994]  RSP <ffff880062365db0>
[  228.368995] CR2: ffff88004fc02000
[  228.368997] ---[ end trace c66316e93d39a7ca ]---
[  228.369000] note: udevd[8260] exited with preempt_count 2
[  228.398123] BUG: unable to handle kernel paging request at ffff88004fc03000
[  228.398129] IP: [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.398135] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.398140] Oops: 0002 [4] SMP 
[  228.398143] CPU 0 
[  228.398145] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.398203] Pid: 8261, comm: git Tainted: G      D   2.6.26 #21
[  228.398205] RIP: 0010:[<ffffffff80322885>]  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.398210] RSP: 0000:ffff88007e79fd80  EFLAGS: 00010286
[  228.398212] RAX: ffff880000000000 RBX: 0000000000000001 RCX: 0000000000000200
[  228.398214] RDX: 6db6db6db6db6db7 RSI: ffff8800772cb000 RDI: ffff88004fc03000
[  228.398216] RBP: ffff880059476d20 R08: 0000000000000000 R09: 0000000000000000
[  228.398219] R10: 0000000000000001 R11: 0000000000000206 R12: ffffffff806294e0
[  228.398221] R13: ffff880066179380 R14: 00002ace748a7b48 R15: ffffe200011720a8
[  228.398224] FS:  0000000000000000(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.398227] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.398229] CR2: ffff88004fc03000 CR3: 0000000059430000 CR4: 00000000000026e0
[  228.398231] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.398234] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.398236] Process git (pid: 8261, threadinfo ffff88007e79e000, task ffff880059612a70)
[  228.398238] Stack:  ffffffff802839bf 0000000000000094 0000000000000096 0000000000000094
[  228.398243]  ffff88006203d1f8 0000000001000006 0000000000000200 ffffe20000000001
[  228.398248]  0000000000000096 00002ace748a7000 ffffe20001a11c68 ffffffff80452ef5
[  228.398251] Call Trace:
[  228.398256]  [<ffffffff802839bf>] ? __do_fault+0x35f/0x4c0
[  228.398261]  [<ffffffff80452ef5>] ? _spin_lock+0x5/0x10
[  228.398264]  [<ffffffff802856df>] ? handle_mm_fault+0x1df/0x910
[  228.398267]  [<ffffffff8028aefb>] ? mmap_region+0x28b/0x4e0
[  228.398270]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.398273]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.398276]  [<ffffffff8028b890>] ? do_mmap_pgoff+0x3a0/0x3c0
[  228.398279]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.398283]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  228.398286]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.398288] 
[  228.398289] 
[  228.398291] Code: 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 0f 1f 84 00 00 00 00 00 
[  228.398326] RIP  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  228.398330]  RSP <ffff88007e79fd80>
[  228.398332] CR2: ffff88004fc03000
[  228.398342] ---[ end trace c66316e93d39a7ca ]---
[  228.398345] note: git[8261] exited with preempt_count 2
[  228.413940] BUG: unable to handle kernel paging request at ffff88004fc04000
[  228.413945] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.413951] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.413954] Oops: 0002 [5] SMP 
[  228.413957] CPU 0 
[  228.413958] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.414005] Pid: 8266, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.414007] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.414010] RSP: 0000:ffff8800620d7cc0  EFLAGS: 00010246
[  228.414012] RAX: 0000000000000000 RBX: ffffe200011720e0 RCX: 0000000000000200
[  228.414014] RDX: 0000000000000000 RSI: ffffe200011720e0 RDI: ffff88004fc04000
[  228.414015] RBP: 00000000011720e0 R08: 0000000000000000 R09: 0000000000000000
[  228.414017] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  228.414019] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.414021] FS:  00002b93090186e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.414023] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.414025] CR2: ffff88004fc04000 CR3: 00000000622b3000 CR4: 00000000000026e0
[  228.414026] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.414028] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.414030] Process cc1 (pid: 8266, threadinfo ffff8800620d6000, task ffff880059768000)
[  228.414032] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.414036]  0000000180274188 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.414039]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.414042] Call Trace:
[  228.414047]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.414050]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.414054]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.414057]  [<ffffffff8028aefb>] ? mmap_region+0x28b/0x4e0
[  228.414060]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.414062]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.414065]  [<ffffffff8028b890>] ? do_mmap_pgoff+0x3a0/0x3c0
[  228.414067]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.414070]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  228.414072]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.414074]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.414076] 
[  228.414076] 
[  228.414077] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.414104] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.414107]  RSP <ffff8800620d7cc0>
[  228.414108] CR2: ffff88004fc04000
[  228.414118] ---[ end trace c66316e93d39a7ca ]---
[  228.414121] note: cc1[8266] exited with preempt_count 1
[  228.426060] BUG: unable to handle kernel paging request at ffff88004fc05000
[  228.426065] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.426071] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.426074] Oops: 0002 [6] SMP 
[  228.426077] CPU 1 
[  228.426079] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.426125] Pid: 8276, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.426127] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.426130] RSP: 0000:ffff880059697cc0  EFLAGS: 00010246
[  228.426131] RAX: 0000000000000000 RBX: ffffe20001172118 RCX: 0000000000000200
[  228.426133] RDX: 0000000000000000 RSI: ffffe20001172118 RDI: ffff88004fc05000
[  228.426135] RBP: 0000000001172118 R08: 0000000000000000 R09: 0000000000000000
[  228.426137] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  228.426138] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.426141] FS:  00002b11a12376e0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  228.426143] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.426144] CR2: ffff88004fc05000 CR3: 0000000073cdc000 CR4: 00000000000026a0
[  228.426146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.426148] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.426150] Process cc1 (pid: 8276, threadinfo ffff880059696000, task ffff880059611e50)
[  228.426151] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.426156]  0000000180274188 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.426159]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.426162] Call Trace:
[  228.426166]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.426169]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.426172]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.426175]  [<ffffffff8028aefb>] ? mmap_region+0x28b/0x4e0
[  228.426178]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.426181]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.426183]  [<ffffffff8028b890>] ? do_mmap_pgoff+0x3a0/0x3c0
[  228.426185]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.426188]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  228.426191]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.426193]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.426194] 
[  228.426195] 
[  228.426196] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.426223] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.426225]  RSP <ffff880059697cc0>
[  228.426227] CR2: ffff88004fc05000
[  228.426239] ---[ end trace c66316e93d39a7ca ]---
[  228.426241] note: cc1[8276] exited with preempt_count 1
[  228.452270] BUG: unable to handle kernel paging request at ffff88004fc06000
[  228.452275] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.452281] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.452284] Oops: 0002 [7] SMP 
[  228.452287] CPU 1 
[  228.452288] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.452334] Pid: 8288, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.452336] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.452340] RSP: 0000:ffff88007e79fcc0  EFLAGS: 00010246
[  228.452341] RAX: 0000000000000000 RBX: ffffe20001172150 RCX: 0000000000000200
[  228.452343] RDX: 0000000000000000 RSI: ffffe20001172150 RDI: ffff88004fc06000
[  228.452345] RBP: 0000000001172150 R08: 0000000000000000 R09: 0000000000000000
[  228.452347] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  228.452348] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.452351] FS:  00002ad029c516e0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  228.452353] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.452354] CR2: ffff88004fc06000 CR3: 0000000037a5e000 CR4: 00000000000026a0
[  228.452356] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.452358] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.452360] Process cc1 (pid: 8288, threadinfo ffff88007e79e000, task ffff880059611e50)
[  228.452361] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.452366]  0000000180274188 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.452369]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.452372] Call Trace:
[  228.452376]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.452379]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.452383]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.452386]  [<ffffffff8028aefb>] ? mmap_region+0x28b/0x4e0
[  228.452389]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.452391]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.452394]  [<ffffffff8028b890>] ? do_mmap_pgoff+0x3a0/0x3c0
[  228.452396]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.452399]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  228.452401]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.452403]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.452405] 
[  228.452406] 
[  228.452407] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.452433] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.452436]  RSP <ffff88007e79fcc0>
[  228.452437] CR2: ffff88004fc06000
[  228.452447] ---[ end trace c66316e93d39a7ca ]---
[  228.452449] note: cc1[8288] exited with preempt_count 1
[  228.467102] BUG: unable to handle kernel paging request at ffff88004fc07000
[  228.467106] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.467112] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.467115] Oops: 0002 [8] SMP 
[  228.467117] CPU 0 
[  228.467119] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.467164] Pid: 8301, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.467166] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.467169] RSP: 0000:ffff88006233dcc0  EFLAGS: 00010246
[  228.467171] RAX: 0000000000000000 RBX: ffffe20001172188 RCX: 0000000000000200
[  228.467173] RDX: 0000000000000000 RSI: ffffe20001172188 RDI: ffff88004fc07000
[  228.467175] RBP: 0000000001172188 R08: 0000000000000000 R09: 0000000000000000
[  228.467177] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  228.467178] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.467181] FS:  00002b7162d606e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.467183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.467184] CR2: ffff88004fc07000 CR3: 000000007e363000 CR4: 00000000000026e0
[  228.467186] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.467188] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.467190] Process cc1 (pid: 8301, threadinfo ffff88006233c000, task ffff8800622c1e50)
[  228.467192] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.467196]  0000000180274188 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.467199]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.467202] Call Trace:
[  228.467206]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.467209]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.467213]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.467216]  [<ffffffff802a3325>] ? cp_new_stat+0xe5/0x100
[  228.467219]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.467222]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.467225]  [<ffffffff802b3599>] ? dput+0xb9/0x180
[  228.467227]  [<ffffffff802b8811>] ? mntput_no_expire+0x21/0x150
[  228.467229]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.467231]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.467233] 
[  228.467234] 
[  228.467235] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.467261] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.467264]  RSP <ffff88006233dcc0>
[  228.467265] CR2: ffff88004fc07000
[  228.467275] ---[ end trace c66316e93d39a7ca ]---
[  228.467277] note: cc1[8301] exited with preempt_count 1
[  228.736448] BUG: unable to handle kernel paging request at ffff88004fc08000
[  228.736454] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.736462] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.736466] Oops: 0002 [9] SMP 
[  228.736469] CPU 1 
[  228.736471] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.736531] Pid: 8320, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.736533] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.736538] RSP: 0000:ffff88005974bcc0  EFLAGS: 00010246
[  228.736540] RAX: 0000000000000000 RBX: ffffe200011721c0 RCX: 0000000000000200
[  228.736542] RDX: 0000000000000000 RSI: ffffe200011721c0 RDI: ffff88004fc08000
[  228.736545] RBP: 00000000011721c0 R08: 0000000000000000 R09: 0000000000000000
[  228.736547] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[  228.736549] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.736552] FS:  00002aabc952a6e0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  228.736555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.736557] CR2: ffff88004fc08000 CR3: 0000000057006000 CR4: 00000000000026a0
[  228.736559] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.736562] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.736565] Process cc1 (pid: 8320, threadinfo ffff88005974a000, task ffff880059610c20)
[  228.736567] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.736572]  0000000180274188 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.736576]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.736580] Call Trace:
[  228.736585]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.736590]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.736594]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.736597]  [<ffffffff8028aefb>] ? mmap_region+0x28b/0x4e0
[  228.736601]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.736605]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.736608]  [<ffffffff8028b890>] ? do_mmap_pgoff+0x3a0/0x3c0
[  228.736610]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.736615]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  228.736617]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.736620]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.736622] 
[  228.736623] 
[  228.736624] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.736660] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.736663]  RSP <ffff88005974bcc0>
[  228.736665] CR2: ffff88004fc08000
[  228.736681] ---[ end trace c66316e93d39a7ca ]---
[  228.736684] note: cc1[8320] exited with preempt_count 1
[  228.754545] BUG: unable to handle kernel paging request at ffff88004fc09000
[  228.754550] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.754555] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.754559] Oops: 0002 [10] SMP 
[  228.754561] CPU 0 
[  228.754563] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.754608] Pid: 8331, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.754610] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.754613] RSP: 0000:ffff88005974bcc0  EFLAGS: 00010246
[  228.754615] RAX: 0000000000000000 RBX: ffffe200011721f8 RCX: 0000000000000200
[  228.754617] RDX: 0000000000000000 RSI: ffffe200011721f8 RDI: ffff88004fc09000
[  228.754619] RBP: 00000000011721f8 R08: 0000000000000000 R09: 0000000000000000
[  228.754620] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  228.754622] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.754624] FS:  00002b32574a66e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.754626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.754628] CR2: ffff88004fc09000 CR3: 0000000059794000 CR4: 00000000000026e0
[  228.754630] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.754632] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.754634] Process cc1 (pid: 8331, threadinfo ffff88005974a000, task ffff8800620ab690)
[  228.754635] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.754639]  00000001802aa5fd 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.754643]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.754646] Call Trace:
[  228.754650]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.754653]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.754656]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.754659]  [<ffffffff802a3325>] ? cp_new_stat+0xe5/0x100
[  228.754663]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.754665]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.754668]  [<ffffffff802a35ae>] ? sys_newfstat+0x2e/0x50
[  228.754670]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.754671] 
[  228.754672] 
[  228.754673] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.754699] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.754702]  RSP <ffff88005974bcc0>
[  228.754704] CR2: ffff88004fc09000
[  228.754713] ---[ end trace c66316e93d39a7ca ]---
[  228.754715] note: cc1[8331] exited with preempt_count 1
[  228.817159] BUG: unable to handle kernel paging request at ffff88004fc0a000
[  228.817163] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.817170] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.817173] Oops: 0002 [11] SMP 
[  228.817175] CPU 0 
[  228.817177] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.817224] Pid: 8342, comm: make Tainted: G      D   2.6.26 #21
[  228.817225] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.817229] RSP: 0000:ffff880062095cc0  EFLAGS: 00010246
[  228.817231] RAX: 0000000000000000 RBX: ffffe20001172230 RCX: 0000000000000200
[  228.817232] RDX: 0000000000000000 RSI: ffffe20001172230 RDI: ffff88004fc0a000
[  228.817234] RBP: 0000000001172230 R08: 0000000000000000 R09: 0000000000000000
[  228.817236] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
[  228.817238] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.817240] FS:  00002b2e02ad7f90(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.817242] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.817243] CR2: ffff88004fc0a000 CR3: 000000007b728000 CR4: 00000000000026e0
[  228.817245] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.817247] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.817249] Process make (pid: 8342, threadinfo ffff880062094000, task ffff8800620aa460)
[  228.817251] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.817255]  00000001802b97fc 0000000000100000 ffffffff80598200 0000004400004000
[  228.817258]  0000000000000003 0000000000000000 001280d2377141e8 ffffffff80599658
[  228.817261] Call Trace:
[  228.817265]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.817268]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.817271]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.817275]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.817277]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.817280]  [<ffffffff802a0186>] ? vfs_read+0x126/0x180
[  228.817282]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.817285]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.817286] 
[  228.817287] 
[  228.817288] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.817314] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.817317]  RSP <ffff880062095cc0>
[  228.817319] CR2: ffff88004fc0a000
[  228.817328] ---[ end trace c66316e93d39a7ca ]---
[  228.817330] note: make[8342] exited with preempt_count 1
[  228.815504] BUG: unable to handle kernel paging request at ffff88004fc0c000
[  228.815507] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.815511] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.815514] Oops: 0002 [12] SMP 
[  228.815516] CPU 1 
[  228.815517] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.815559] Pid: 8343, comm: make Tainted: G      D   2.6.26 #21
[  228.815561] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.815564] RSP: 0000:ffff88006a0a1cc0  EFLAGS: 00010246
[  228.815566] RAX: 0000000000000000 RBX: ffffe200011722a0 RCX: 0000000000000200
[  228.815568] RDX: 0000000000000000 RSI: ffffe200011722a0 RDI: ffff88004fc0c000
[  228.815569] RBP: 00000000011722a0 R08: 0000000000000001 R09: ffffffffffffffff
[  228.815571] R10: 0000000000000000 R11: 0000000000000020 R12: 0000000000000000
[  228.815573] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.815575] FS:  00002b023ed5bf90(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  228.815577] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  228.815579] CR2: ffff88004fc0c000 CR3: 0000000037a5e000 CR4: 00000000000026a0
[  228.815580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.815582] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.815584] Process make (pid: 8343, threadinfo ffff88006a0a0000, task ffff8800620ac2b0)
[  228.815586] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.815590]  00000001802b97fc 0000000000100000 ffffffff80598200 0000004400008000
[  228.815593]  0000000000000003 0000000000000000 001280d266343128 ffffffff80599658
[  228.815596] Call Trace:
[  228.815598]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.815602]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.815604]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.815606]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.815609]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.815611]  [<ffffffff802a0186>] ? vfs_read+0x126/0x180
[  228.815613]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.815615]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.815617] 
[  228.815617] 
[  228.815618] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.815645] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.815647]  RSP <ffff88006a0a1cc0>
[  228.815649] CR2: ffff88004fc0c000
[  228.815650] ---[ end trace c66316e93d39a7ca ]---
[  228.815652] note: make[8343] exited with preempt_count 1
[  228.827154] BUG: unable to handle kernel paging request at ffff88004fc0b000
[  228.827159] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.827164] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  228.827168] Oops: 0002 [13] SMP 
[  228.827170] CPU 0 
[  228.827171] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  228.827216] Pid: 8347, comm: cc1 Tainted: G      D   2.6.26 #21
[  228.827218] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.827221] RSP: 0000:ffff8800623c9cc0  EFLAGS: 00010246
[  228.827223] RAX: 0000000000000000 RBX: ffffe20001172268 RCX: 0000000000000200
[  228.827225] RDX: 0000000000000000 RSI: ffffe20001172268 RDI: ffff88004fc0b000
[  228.827226] RBP: 0000000001172268 R08: 0000000000000000 R09: 0000000000000000
[  228.827228] R10: 0000000000000001 R11: 0000000000000a08 R12: 0000000000000000
[  228.827230] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  228.827232] FS:  00002b6b9b0a86e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  228.827234] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  228.827236] CR2: ffff88004fc0b000 CR3: 000000007b728000 CR4: 00000000000026e0
[  228.827238] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  228.827239] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  228.827241] Process cc1 (pid: 8347, threadinfo ffff8800623c8000, task ffff8800620ab690)
[  228.827243] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  228.827247]  0000000180274188 0000000000100000 ffffffff80598200 000000447c6925d8
[  228.827250]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  228.827253] Call Trace:
[  228.827257]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  228.827261]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  228.827264]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  228.827267]  [<ffffffff802907bc>] ? free_pages_and_swap_cache+0x8c/0xb0
[  228.827270]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.827272]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  228.827275]  [<ffffffff80289392>] ? remove_vma+0x52/0x70
[  228.827277]  [<ffffffff8028a263>] ? do_munmap+0x273/0x2d0
[  228.827279]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.827282]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  228.827284]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  228.827287]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  228.827288] 
[  228.827289] 
[  228.827290] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  228.827316] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  228.827319]  RSP <ffff8800623c9cc0>
[  228.827320] CR2: ffff88004fc0b000
[  228.827329] ---[ end trace c66316e93d39a7ca ]---
[  228.827331] note: cc1[8347] exited with preempt_count 1
[  244.207596] BUG: unable to handle kernel paging request at ffff88004fc0d000
[  244.207603] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  244.207611] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  244.207616] Oops: 0002 [14] SMP 
[  244.207619] CPU 0 
[  244.207621] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  244.207683] Pid: 7797, comm: konsole Tainted: G      D   2.6.26 #21
[  244.207685] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  244.207690] RSP: 0000:ffff8800596cbcc0  EFLAGS: 00010246
[  244.207692] RAX: 0000000000000000 RBX: ffffe200011722d8 RCX: 0000000000000200
[  244.207695] RDX: 0000000000000000 RSI: ffffe200011722d8 RDI: ffff88004fc0d000
[  244.207697] RBP: 00000000011722d8 R08: 0000000000000000 R09: 0000000000000000
[  244.207699] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000000000
[  244.207702] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  244.207705] FS:  00007fdf59d9e6f0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  244.207708] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  244.207710] CR2: ffff88004fc0d000 CR3: 000000005959a000 CR4: 00000000000026e0
[  244.207712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  244.207715] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  244.207717] Process konsole (pid: 7797, threadinfo ffff8800596ca000, task ffff88005976bca0)
[  244.207720] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  244.207725]  0000000100000001 0000000000100000 ffffffff80598200 0000004480597fc0
[  244.207730]  0000000000000003 0000000000000000 001280d200000000 ffffffff80599658
[  244.207734] Call Trace:
[  244.207739]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  244.207744]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  244.207748]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  244.207752]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  244.207756]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  244.207759]  [<ffffffff8028abb8>] ? do_brk+0x208/0x2c0
[  244.207762]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  244.207766]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  244.207769]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  244.207772]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  244.207774] 
[  244.207775] 
[  244.207776] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  244.207812] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  244.207816]  RSP <ffff8800596cbcc0>
[  244.207817] CR2: ffff88004fc0d000
[  244.207830] ---[ end trace c66316e93d39a7ca ]---
[  244.207833] note: konsole[7797] exited with preempt_count 1
[  244.209384] BUG: scheduling while atomic: konsole/7797/0x10000001
[  244.209387] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  244.209451] Pid: 7797, comm: konsole Tainted: G      D   2.6.26 #21
[  244.209453] 
[  244.209453] Call Trace:
[  244.209459]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  244.209464]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  244.209468]  [<ffffffff803c06db>] skb_dequeue+0x5b/0x80
[  244.209473]  [<ffffffff80430010>] unix_release_sock+0x130/0x250
[  244.209477]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  244.209480]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  244.209484]  [<ffffffff802b364c>] dput+0x16c/0x180
[  244.209488]  [<ffffffff802a0a88>] __fput+0x148/0x1e0
[  244.209492]  [<ffffffff8029d834>] filp_close+0x54/0x90
[  244.209496]  [<ffffffff8023bab1>] put_files_struct+0xb1/0xd0
[  244.209499]  [<ffffffff8023d0cd>] do_exit+0x1dd/0x910
[  244.209502]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  244.209505]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  244.209508]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  244.209511]  [<ffffffff803bcca6>] sock_alloc_send_skb+0x196/0x1f0
[  244.209515]  [<ffffffff80232040>] default_wake_function+0x0/0x10
[  244.209518]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209521]  [<ffffffff803c0564>] skb_queue_tail+0x24/0x60
[  244.209524]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  244.209527]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  244.209531]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  244.209535]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  244.209539]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  244.209542]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209545]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  244.209549]  [<ffffffff8028abb8>] do_brk+0x208/0x2c0
[  244.209552]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209555]  [<ffffffff80320472>] __up_write+0x22/0x130
[  244.209558]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209561]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  244.209563] 
[  244.209724] BUG: scheduling while atomic: konsole/7797/0x10000001
[  244.209727] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  244.209790] Pid: 7797, comm: konsole Tainted: G      D   2.6.26 #21
[  244.209792] 
[  244.209792] Call Trace:
[  244.209796]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  244.209800]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  244.209803]  [<ffffffff803c06db>] skb_dequeue+0x5b/0x80
[  244.209806]  [<ffffffff80430010>] unix_release_sock+0x130/0x250
[  244.209810]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  244.209813]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  244.209816]  [<ffffffff802b364c>] dput+0x16c/0x180
[  244.209819]  [<ffffffff802a0a88>] __fput+0x148/0x1e0
[  244.209823]  [<ffffffff8029d834>] filp_close+0x54/0x90
[  244.209825]  [<ffffffff8023bab1>] put_files_struct+0xb1/0xd0
[  244.209829]  [<ffffffff8023d0cd>] do_exit+0x1dd/0x910
[  244.209831]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  244.209834]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  244.209838]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  244.209840]  [<ffffffff803bcca6>] sock_alloc_send_skb+0x196/0x1f0
[  244.209843]  [<ffffffff80232040>] default_wake_function+0x0/0x10
[  244.209847]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209850]  [<ffffffff803c0564>] skb_queue_tail+0x24/0x60
[  244.209853]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  244.209856]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  244.209859]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  244.209863]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  244.209867]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  244.209870]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209873]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  244.209876]  [<ffffffff8028abb8>] do_brk+0x208/0x2c0
[  244.209879]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209883]  [<ffffffff80320472>] __up_write+0x22/0x130
[  244.209886]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.209889]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  244.209891] 
[  244.210287] BUG: scheduling while atomic: konsole/7797/0x10000001
[  244.210290] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  244.210353] Pid: 7797, comm: konsole Tainted: G      D   2.6.26 #21
[  244.210356] 
[  244.210356] Call Trace:
[  244.210360]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  244.210364]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  244.210367]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.210371]  [<ffffffff80371bda>] tty_ldisc_deref+0x1a/0x70
[  244.210375]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  244.210378]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  244.210382]  [<ffffffff80451be9>] mutex_lock+0x9/0x20
[  244.210386]  [<ffffffff8036cf04>] release_dev+0x294/0x590
[  244.210390]  [<ffffffff802b2118>] d_kill+0x48/0x70
[  244.210393]  [<ffffffff8036d211>] tty_release+0x11/0x20
[  244.210397]  [<ffffffff802a0a01>] __fput+0xc1/0x1e0
[  244.210400]  [<ffffffff8029d834>] filp_close+0x54/0x90
[  244.210403]  [<ffffffff8023bab1>] put_files_struct+0xb1/0xd0
[  244.210406]  [<ffffffff8023d0cd>] do_exit+0x1dd/0x910
[  244.210409]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  244.210412]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  244.210415]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  244.210418]  [<ffffffff803bcca6>] sock_alloc_send_skb+0x196/0x1f0
[  244.210421]  [<ffffffff80232040>] default_wake_function+0x0/0x10
[  244.210424]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.210427]  [<ffffffff803c0564>] skb_queue_tail+0x24/0x60
[  244.210430]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  244.210433]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  244.210437]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  244.210441]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  244.210445]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  244.210448]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.210451]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  244.210454]  [<ffffffff8028abb8>] do_brk+0x208/0x2c0
[  244.210456]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.210460]  [<ffffffff80320472>] __up_write+0x22/0x130
[  244.210463]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  244.210466]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  244.210468] 
[  249.856359] BUG: unable to handle kernel paging request at ffff88004fc0e000
[  249.856366] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.856374] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  249.856378] Oops: 0002 [15] SMP 
[  249.856382] CPU 1 
[  249.856384] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  249.856446] Pid: 8357, comm: konsole Tainted: G      D   2.6.26 #21
[  249.856448] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.856453] RSP: 0000:ffff88006a0a1cc0  EFLAGS: 00010246
[  249.856455] RAX: 0000000000000000 RBX: ffffe20001172310 RCX: 0000000000000200
[  249.856458] RDX: 0000000000000000 RSI: ffffe20001172310 RDI: ffff88004fc0e000
[  249.856460] RBP: 0000000001172310 R08: 0000000000000000 R09: 0000000000000000
[  249.856462] R10: 0000000000000001 R11: 00007fdf533acdd0 R12: 0000000000000000
[  249.856464] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  249.856468] FS:  00007fdf59d9e6f0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  249.856470] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  249.856472] CR2: ffff88004fc0e000 CR3: 0000000062336000 CR4: 00000000000026a0
[  249.856475] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  249.856477] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  249.856480] Process konsole (pid: 8357, threadinfo ffff88006a0a0000, task ffff880059613080)
[  249.856482] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  249.856488]  000000016a0a1d28 0000000000100000 ffffffff80598200 000000440000000e
[  249.856492]  0000000000000003 0000000000000000 001280d201289040 ffffffff80599658
[  249.856496] Call Trace:
[  249.856502]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  249.856507]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  249.856511]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  249.856515]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  249.856519]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  249.856523]  [<ffffffff802a64ae>] ? pipe_ioctl+0x9e/0xb0
[  249.856526]  [<ffffffff802ad1ef>] ? vfs_ioctl+0x2f/0xa0
[  249.856529]  [<ffffffff802ad4c3>] ? do_vfs_ioctl+0x263/0x2d0
[  249.856532]  [<ffffffff802a01d4>] ? vfs_read+0x174/0x180
[  249.856535]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  249.856538]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  249.856540] 
[  249.856541] 
[  249.856542] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  249.856578] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.856582]  RSP <ffff88006a0a1cc0>
[  249.856583] CR2: ffff88004fc0e000
[  249.856595] ---[ end trace c66316e93d39a7ca ]---
[  249.856598] note: konsole[8357] exited with preempt_count 1
[  249.856601] BUG: scheduling while atomic: konsole/8357/0x10000001
[  249.856603] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  249.856659] Pid: 8357, comm: konsole Tainted: G      D   2.6.26 #21
[  249.856661] 
[  249.856662] Call Trace:
[  249.856666]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  249.856671]  [<ffffffff8023aafe>] printk+0x4e/0x60
[  249.856675]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  249.856678]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  249.856681]  [<ffffffff804520b9>] down_read+0x9/0x20
[  249.856685]  [<ffffffff80268eab>] acct_collect+0x3b/0x1d0
[  249.856688]  [<ffffffff8023d075>] do_exit+0x185/0x910
[  249.856691]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  249.856694]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  249.856696]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  249.856701]  [<ffffffff8022c60a>] __wake_up_common+0x5a/0x90
[  249.856704]  [<ffffffff8022dbfa>] __wake_up_sync+0x4a/0x80
[  249.856707]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.856710]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.856713]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  249.856717]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  249.856720]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  249.856723]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.856726]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  249.856729]  [<ffffffff802a64ae>] pipe_ioctl+0x9e/0xb0
[  249.856732]  [<ffffffff802ad1ef>] vfs_ioctl+0x2f/0xa0
[  249.856735]  [<ffffffff802ad4c3>] do_vfs_ioctl+0x263/0x2d0
[  249.856737]  [<ffffffff802a01d4>] vfs_read+0x174/0x180
[  249.856740]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.856743]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.856745] 
[  249.862396] BUG: scheduling while atomic: konsole/8357/0x10000001
[  249.862400] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  249.862471] Pid: 8357, comm: konsole Tainted: G      D   2.6.26 #21
[  249.862473] 
[  249.862473] Call Trace:
[  249.862481]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  249.862486]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  249.862489]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  249.862493]  [<ffffffff80284da4>] unmap_vmas+0x934/0x960
[  249.862497]  [<ffffffff8028942b>] exit_mmap+0x7b/0x100
[  249.862501]  [<ffffffff80237626>] mmput+0x26/0xc0
[  249.862503]  [<ffffffff8023b873>] exit_mm+0xf3/0x110
[  249.862506]  [<ffffffff8023d0ac>] do_exit+0x1bc/0x910
[  249.862509]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  249.862512]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  249.862515]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  249.862519]  [<ffffffff8022c60a>] __wake_up_common+0x5a/0x90
[  249.862522]  [<ffffffff8022dbfa>] __wake_up_sync+0x4a/0x80
[  249.862526]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.862529]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.862534]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  249.862537]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  249.862541]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  249.862545]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.862548]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  249.862552]  [<ffffffff802a64ae>] pipe_ioctl+0x9e/0xb0
[  249.862555]  [<ffffffff802ad1ef>] vfs_ioctl+0x2f/0xa0
[  249.862558]  [<ffffffff802ad4c3>] do_vfs_ioctl+0x263/0x2d0
[  249.862562]  [<ffffffff802a01d4>] vfs_read+0x174/0x180
[  249.862564]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.862567]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.862570] 
[  249.862874] BUG: scheduling while atomic: konsole/8357/0x10000001
[  249.862877] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  249.862940] Pid: 8357, comm: konsole Tainted: G      D   2.6.26 #21
[  249.862942] 
[  249.862942] Call Trace:
[  249.862947]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  249.862950]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  249.862954]  [<ffffffff803c06db>] skb_dequeue+0x5b/0x80
[  249.862959]  [<ffffffff80430010>] unix_release_sock+0x130/0x250
[  249.862963]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  249.862966]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  249.862970]  [<ffffffff802b364c>] dput+0x16c/0x180
[  249.862973]  [<ffffffff802a0a88>] __fput+0x148/0x1e0
[  249.862978]  [<ffffffff8029d834>] filp_close+0x54/0x90
[  249.862981]  [<ffffffff8023bab1>] put_files_struct+0xb1/0xd0
[  249.862984]  [<ffffffff8023d0cd>] do_exit+0x1dd/0x910
[  249.862987]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  249.862990]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  249.862993]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  249.862996]  [<ffffffff8022c60a>] __wake_up_common+0x5a/0x90
[  249.863000]  [<ffffffff8022dbfa>] __wake_up_sync+0x4a/0x80
[  249.863003]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.863006]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.863009]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  249.863014]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  249.863017]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  249.863020]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.863023]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  249.863026]  [<ffffffff802a64ae>] pipe_ioctl+0x9e/0xb0
[  249.863029]  [<ffffffff802ad1ef>] vfs_ioctl+0x2f/0xa0
[  249.863032]  [<ffffffff802ad4c3>] do_vfs_ioctl+0x263/0x2d0
[  249.863035]  [<ffffffff802a01d4>] vfs_read+0x174/0x180
[  249.863037]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.863040]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.863043] 
[  249.870253] BUG: scheduling while atomic: konsole/8357/0x10000001
[  249.870258] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  249.870334] Pid: 8357, comm: konsole Tainted: G      D   2.6.26 #21
[  249.870337] 
[  249.870337] Call Trace:
[  249.870345]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  249.870350]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  249.870354]  [<ffffffff80371c09>] tty_ldisc_deref+0x49/0x70
[  249.870359]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  249.870362]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  249.870366]  [<ffffffff80451be9>] mutex_lock+0x9/0x20
[  249.870370]  [<ffffffff8036cf04>] release_dev+0x294/0x590
[  249.870374]  [<ffffffff802b2118>] d_kill+0x48/0x70
[  249.870378]  [<ffffffff8036d211>] tty_release+0x11/0x20
[  249.870382]  [<ffffffff802a0a01>] __fput+0xc1/0x1e0
[  249.870386]  [<ffffffff8029d834>] filp_close+0x54/0x90
[  249.870389]  [<ffffffff8023bab1>] put_files_struct+0xb1/0xd0
[  249.870392]  [<ffffffff8023d0cd>] do_exit+0x1dd/0x910
[  249.870395]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  249.870399]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  249.870402]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  249.870406]  [<ffffffff8022c60a>] __wake_up_common+0x5a/0x90
[  249.870410]  [<ffffffff8022dbfa>] __wake_up_sync+0x4a/0x80
[  249.870413]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.870416]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  249.870420]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  249.870425]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  249.870429]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  249.870432]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.870435]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  249.870439]  [<ffffffff802a64ae>] pipe_ioctl+0x9e/0xb0
[  249.870442]  [<ffffffff802ad1ef>] vfs_ioctl+0x2f/0xa0
[  249.870445]  [<ffffffff802ad4c3>] do_vfs_ioctl+0x263/0x2d0
[  249.870448]  [<ffffffff802a01d4>] vfs_read+0x174/0x180
[  249.870451]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  249.870454]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  249.870456] 
[  251.305711] BUG: unable to handle kernel paging request at ffff88004fc0f000
[  251.305719] IP: [<ffffffff80322885>] copy_page_c+0x5/0x10
[  251.305727] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  251.305731] Oops: 0002 [16] SMP 
[  251.305735] CPU 1 
[  251.305737] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  251.305798] Pid: 6914, comm: kio_file Tainted: G      D   2.6.26 #21
[  251.305800] RIP: 0010:[<ffffffff80322885>]  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  251.305805] RSP: 0000:ffff880073f9bdb0  EFLAGS: 00010286
[  251.305807] RAX: ffff880000000000 RBX: 0000000000000000 RCX: 0000000000000200
[  251.305809] RDX: 6db6db6db6db6db7 RSI: ffff88006ea15000 RDI: ffff88004fc0f000
[  251.305811] RBP: ffff88006d888608 R08: 0000000000000000 R09: 0000000000000000
[  251.305814] R10: 0000000000000001 R11: 00007fdf533ab410 R12: 000000000004fc0f
[  251.305816] R13: ffffe200017f67e0 R14: ffffe20001833498 R15: 00007fdf583de8a0
[  251.305819] FS:  00007fdf59d9e6f0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  251.305822] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  251.305824] CR2: ffff88004fc0f000 CR3: 000000006d883000 CR4: 00000000000026a0
[  251.305826] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  251.305829] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  251.305832] Process kio_file (pid: 6914, threadinfo ffff880073f9a000, task ffff88007ae41230)
[  251.305834] Stack:  ffffffff80283c44 ffff880000000000 ffff88006d8afbd0 ffff88007e2e1040
[  251.305839]  ffffe20001172348 0000000000000001 800000006ea15045 0000000000000001
[  251.305843]  ffffe200017f67e0 00007fdf583de8a0 ffff88006d8b6ef0 ffff88007e2e1040
[  251.305847] Call Trace:
[  251.305852]  [<ffffffff80283c44>] ? do_wp_page+0x124/0x640
[  251.305856]  [<ffffffff80285c35>] ? handle_mm_fault+0x735/0x910
[  251.305860]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  251.305863]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  251.305867]  [<ffffffff802a01d4>] ? vfs_read+0x174/0x180
[  251.305870]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  251.305873]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  251.305875] 
[  251.305876] 
[  251.305877] Code: 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 0f 1f 84 00 00 00 00 00 
[  251.305912] RIP  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  251.305916]  RSP <ffff880073f9bdb0>
[  251.305918] CR2: ffff88004fc0f000
[  251.305928] ---[ end trace c66316e93d39a7ca ]---
[  251.305931] note: kio_file[6914] exited with preempt_count 2
[  282.104694] BUG: unable to handle kernel paging request at ffff88004fc10000
[  282.104700] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.104708] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  282.104711] Oops: 0002 [17] SMP 
[  282.104714] CPU 1 
[  282.104715] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  282.104765] Pid: 8422, comm: basename Tainted: G      D   2.6.26 #21
[  282.104767] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.104770] RSP: 0000:ffff88006d8a5cc0  EFLAGS: 00010246
[  282.104772] RAX: 0000000000000000 RBX: ffffe20001172380 RCX: 0000000000000200
[  282.104774] RDX: 0000000000000000 RSI: ffffe20001172380 RDI: ffff88004fc10000
[  282.104775] RBP: 0000000001172380 R08: 0000000000000000 R09: 0000000000000000
[  282.104777] R10: 0000000000000001 R11: 0000000000000203 R12: 0000000000000000
[  282.104779] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  282.104781] FS:  00007f1baf7306e0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  282.104783] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  282.104785] CR2: ffff88004fc10000 CR3: 0000000074785000 CR4: 00000000000026a0
[  282.104787] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  282.104788] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  282.104790] Process basename (pid: 8422, threadinfo ffff88006d8a4000, task ffff880059614ed0)
[  282.104792] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  282.104796]  0000000180274188 0000000000100000 ffffffff80598200 000000448031e1ed
[  282.104799]  0000000000000003 0000000000000000 001280d20000015a ffffffff80599658
[  282.104802] Call Trace:
[  282.104807]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  282.104811]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  282.104814]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  282.104818]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.104820]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  282.104823]  [<ffffffff80289392>] ? remove_vma+0x52/0x70
[  282.104826]  [<ffffffff8028a263>] ? do_munmap+0x273/0x2d0
[  282.104828]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.104831]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  282.104833]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.104836]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  282.104837] 
[  282.104838] 
[  282.104839] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  282.104866] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.104869]  RSP <ffff88006d8a5cc0>
[  282.104870] CR2: ffff88004fc10000
[  282.104879] ---[ end trace c66316e93d39a7ca ]---
[  282.104881] note: basename[8422] exited with preempt_count 1
[  282.104883] BUG: scheduling while atomic: basename/8422/0x10000001
[  282.104885] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  282.104926] Pid: 8422, comm: basename Tainted: G      D   2.6.26 #21
[  282.104928] 
[  282.104928] Call Trace:
[  282.104932]  [<ffffffff80451366>] thread_return+0x3d5/0x50f
[  282.104936]  [<ffffffff8023aafe>] printk+0x4e/0x60
[  282.104938]  [<ffffffff80234e2c>] __cond_resched+0x1c/0x50
[  282.104941]  [<ffffffff80451521>] _cond_resched+0x31/0x40
[  282.104943]  [<ffffffff804520b9>] down_read+0x9/0x20
[  282.104947]  [<ffffffff80268eab>] acct_collect+0x3b/0x1d0
[  282.104949]  [<ffffffff8023d075>] do_exit+0x185/0x910
[  282.104951]  [<ffffffff8022dc73>] __wake_up+0x43/0x70
[  282.104953]  [<ffffffff804538a8>] oops_end+0x98/0xa0
[  282.104956]  [<ffffffff80455dce>] do_page_fault+0x7be/0xb20
[  282.104960]  [<ffffffff802b300a>] __d_lookup+0x12a/0x130
[  282.104962]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  282.104964]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.104966]  [<ffffffff80279ce4>] get_page_from_freelist+0x354/0x4f0
[  282.104970]  [<ffffffff8027a178>] __alloc_pages_internal+0xd8/0x4a0
[  282.104972]  [<ffffffff80285ae0>] handle_mm_fault+0x5e0/0x910
[  282.104974]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  282.104976]  [<ffffffff80455b15>] do_page_fault+0x505/0xb20
[  282.104979]  [<ffffffff80289392>] remove_vma+0x52/0x70
[  282.104981]  [<ffffffff8028a263>] do_munmap+0x273/0x2d0
[  282.104983]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  282.104985]  [<ffffffff80320472>] __up_write+0x22/0x130
[  282.104987]  [<ffffffff8045301b>] _spin_lock_irqsave+0x2b/0x40
[  282.104990]  [<ffffffff8045332a>] error_exit+0x0/0x70
[  282.104991] 
[  282.119244] BUG: unable to handle kernel paging request at ffff88004fc1e000
[  282.119248] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.119254] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  282.119257] Oops: 0002 [18] SMP 
[  282.119260] CPU 0 
[  282.119261] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  282.119313] Pid: 8424, comm: dirname Tainted: G      D   2.6.26 #21
[  282.119314] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.119318] RSP: 0000:ffff88006d8b5cc0  EFLAGS: 00010246
[  282.119320] RAX: 0000000000000000 RBX: ffffe20001172690 RCX: 0000000000000200
[  282.119322] RDX: 0000000000000000 RSI: ffffe20001172690 RDI: ffff88004fc1e000
[  282.119324] RBP: 0000000001172690 R08: 0000000000000001 R09: ffffffffffffffff
[  282.119326] R10: 0000000000000000 R11: 0000000000000020 R12: 0000000000000000
[  282.119328] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  282.119331] FS:  00007f99174a36e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  282.119333] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  282.119335] CR2: ffff88004fc1e000 CR3: 000000006db14000 CR4: 00000000000026e0
[  282.119337] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  282.119339] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  282.119341] Process dirname (pid: 8424, threadinfo ffff88006d8b4000, task ffff88005976f330)
[  282.119343] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  282.119347]  0000000180274188 0000000000100000 ffffffff80598200 00000044370922d8
[  282.119351]  0000000000000003 0000000000000000 001280d2806294e0 ffffffff80599658
[  282.119354] Call Trace:
[  282.119358]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  282.119361]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  282.119364]  [<ffffffff80452ef5>] ? _spin_lock+0x5/0x10
[  282.119367]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  282.119370]  [<ffffffff80452ef5>] ? _spin_lock+0x5/0x10
[  282.119374]  [<ffffffff802990de>] ? add_partial+0x4e/0x90
[  282.119376]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.119379]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  282.119381]  [<ffffffff8028ac5d>] ? do_brk+0x2ad/0x2c0
[  282.119384]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.119387]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  282.119389]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.119392]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  282.119394] 
[  282.119394] 
[  282.119395] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  282.119426] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.119430]  RSP <ffff88006d8b5cc0>
[  282.119431] CR2: ffff88004fc1e000
[  282.119433] ---[ end trace c66316e93d39a7ca ]---
[  282.119435] note: dirname[8424] exited with preempt_count 1
[  282.124795] BUG: unable to handle kernel paging request at ffff88004fc1f000
[  282.124799] IP: [<ffffffff80322885>] copy_page_c+0x5/0x10
[  282.124805] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  282.124808] Oops: 0002 [19] SMP 
[  282.124811] CPU 0 
[  282.124813] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  282.124866] Pid: 8427, comm: bash Tainted: G      D   2.6.26 #21
[  282.124867] RIP: 0010:[<ffffffff80322885>]  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  282.124871] RSP: 0000:ffff880059587db0  EFLAGS: 00010286
[  282.124873] RAX: ffff880000000000 RBX: 0000000000000000 RCX: 0000000000000200
[  282.124875] RDX: 6db6db6db6db6db7 RSI: ffff8800546c6000 RDI: ffff88004fc1f000
[  282.124877] RBP: ffff88006a27ed48 R08: 0000000000000000 R09: 0000000000000000
[  282.124879] R10: 0000000000000001 R11: 0000000000000246 R12: 000000000004fc1f
[  282.124881] R13: ffffe20001b9d8d8 R14: ffffe20001277b50 R15: 00007f75f52eb180
[  282.124884] FS:  00007f75f59206e0(0000) GS:ffffffff805c6480(0000) knlGS:0000000000000000
[  282.124886] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  282.124888] CR2: ffff88004fc1f000 CR3: 000000006a0b1000 CR4: 00000000000026e0
[  282.124890] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  282.124892] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  282.124894] Process bash (pid: 8427, threadinfo ffff880059586000, task ffff88005976e100)
[  282.124896] Stack:  ffffffff80283c44 ffffe20000000000 ffff88007b753540 ffff88007ab58d00
[  282.124901]  ffffe200011726c8 0000000080452ef5 80000000546c6045 0000000000000001
[  282.124905]  ffffe20001b9d8d8 00007f75f52eb180 ffff88007e3df758 ffff88007ab58d00
[  282.124909] Call Trace:
[  282.124912]  [<ffffffff80283c44>] ? do_wp_page+0x124/0x640
[  282.124915]  [<ffffffff80285c35>] ? handle_mm_fault+0x735/0x910
[  282.124919]  [<ffffffff803203c1>] ? __up_read+0x21/0xb0
[  282.124922]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.124925]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  282.124928]  [<ffffffff803235bd>] ? __put_user_4+0x1d/0x30
[  282.124930]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.124933]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  282.124935] 
[  282.124936] 
[  282.124936] Code: 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 0f 1f 84 00 00 00 00 00 
[  282.124968] RIP  [<ffffffff80322885>] copy_page_c+0x5/0x10
[  282.124971]  RSP <ffff880059587db0>
[  282.124972] CR2: ffff88004fc1f000
[  282.124974] ---[ end trace c66316e93d39a7ca ]---
[  282.124977] note: bash[8427] exited with preempt_count 2
[  282.168762] BUG: unable to handle kernel paging request at ffff88004fc11000
[  282.168768] IP: [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.168774] PGD 202063 PUD 8067 PMD 800000004fc03000 
[  282.168777] Oops: 0002 [20] SMP 
[  282.168779] CPU 1 
[  282.168781] Modules linked in: skge af_packet i915 drm binfmt_misc kvm_intel ppdev kvm ipv6 acpi_cpufreq ac video output cpufreq_userspace sbs sbshc cpufreq_powersave cpufreq_stats cpufreq_conservative container battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm sr_mod snd_timer cdrom snd_hwdep sg fan snd floppy thermal parport_pc parport soundcore button processor evdev pcspkr ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid ahci iTCO_wdt iTCO_vendor_support ehci_hcd ata_piix uhci_hcd snd_page_alloc libata usbcore shpchp pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[  282.168829] Pid: 8419, comm: bash Tainted: G      D   2.6.26 #21
[  282.168830] RIP: 0010:[<ffffffff80322837>]  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.168834] RSP: 0000:ffff88007a9ddcc0  EFLAGS: 00010246
[  282.168835] RAX: 0000000000000000 RBX: ffffe200011723b8 RCX: 0000000000000200
[  282.168837] RDX: 0000000000000000 RSI: ffffe200011723b8 RDI: ffff88004fc11000
[  282.168839] RBP: 00000000011723b8 R08: 0000000000000000 R09: 0000000000000000
[  282.168841] R10: 0000000000000001 R11: 0000000000000206 R12: 0000000000000000
[  282.168843] R13: 0000000000000001 R14: ffff880000000000 R15: 6db6db6db6db6db7
[  282.168845] FS:  00007f75f59206e0(0000) GS:ffff88007f009580(0000) knlGS:0000000000000000
[  282.168847] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  282.168849] CR2: ffff88004fc11000 CR3: 0000000059585000 CR4: 00000000000026a0
[  282.168851] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  282.168853] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  282.168855] Process bash (pid: 8419, threadinfo ffff88007a9dc000, task ffff880059613080)
[  282.168856] Stack:  ffffffff80279ce4 0010000000000000 0000000000000001 ffffffff806294e0
[  282.168860]  00000001802aa5fd 0000000000100000 ffffffff80598200 0000004400000001
[  282.168864]  0000000000000003 0000000000000000 001280d23721b600 ffffffff80599658
[  282.168867] Call Trace:
[  282.168871]  [<ffffffff80279ce4>] ? get_page_from_freelist+0x354/0x4f0
[  282.168875]  [<ffffffff8027a178>] ? __alloc_pages_internal+0xd8/0x4a0
[  282.168878]  [<ffffffff80285ae0>] ? handle_mm_fault+0x5e0/0x910
[  282.168882]  [<ffffffff802a3325>] ? cp_new_stat+0xe5/0x100
[  282.168885]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.168887]  [<ffffffff80455b15>] ? do_page_fault+0x505/0xb20
[  282.168890]  [<ffffffff8028abb8>] ? do_brk+0x208/0x2c0
[  282.168893]  [<ffffffff802b8811>] ? mntput_no_expire+0x21/0x150
[  282.168895]  [<ffffffff8045301b>] ? _spin_lock_irqsave+0x2b/0x40
[  282.168898]  [<ffffffff80320472>] ? __up_write+0x22/0x130
[  282.168900]  [<ffffffff8045332a>] ? error_exit+0x0/0x70
[  282.168902] 
[  282.168903] 
[  282.168903] Code: ff ff ff 90 48 83 c7 01 e8 57 ff ff ff 85 c0 75 03 48 f7 1b 5b c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 b9 00 02 00 00 31 c0 <f3> 48 ab c3 0f 1f 44 00 00 eb ee 0f 1f 84 00 00 00 00 00 0f 1f 
[  282.168930] RIP  [<ffffffff80322837>] clear_page_c+0x7/0x10
[  282.168933]  RSP <ffff88007a9ddcc0>
[  282.168934] CR2: ffff88004fc11000
[  282.168942] ---[ end trace c66316e93d39a7ca ]---
[  282.168944] note: bash[8419] exited with preempt_count 1


