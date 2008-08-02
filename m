From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [BUG] 2.6.27-rc1 in ext3_find_entry
Date: Sat, 02 Aug 2008 10:51:31 +0100
Message-ID: <48942E23.7070402@tuffmail.co.uk>
References: <48932F07.9090407@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-pm@lists.osdl.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754122AbYHBJvn@vger.kernel.org>
In-Reply-To: <48932F07.9090407@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alan Jenkins wrote:
> ...followed by several secondary BUGs; most happened as I tried to open
> new Konsole instances.  My computer soon became unusable - X restarted
> and then froze, but it responded to SysRQs.  It may just have been all
> my processes dying, but there was more disk activity than I expected.
>
> Strictly speaking I was running v2.6.26-8042-gce6fce4, with a two-line
> patch to fix a different problem (see
> <http://bugzilla.kernel.org/show_bug.cgi?id=11178>).
>
> In case it matters, this happened some time after a series of maybe 3
> suspend/resume cycles in quick succession.  As you can see it happened
> in the middle of running git; I forget exactly what I was doing.
>
> I checked kerneloops and didn't see a duplicate, so here it is.
>   

It happened again.  I didn't get any BUG in ext3 this time; just a
disabling stream of BUGs in copy_page_c.  They started a few seconds
after resume.  So I'm now confident that this is triggered by suspend to
ram.

I first noticed it after running an ls command (ls /var/cache/polipo),
which was Killed.  I was running polipo at the time; it wouldn't have
been the first access to this directory.  However it was probably the
first access to this directory after the computer was woken from suspend
to ram.

I had the same two-line PCI patch applied.  This time it was atop a
genuine descendant of v2.6.27-rc1, viz v2.6.27-rc1-156-g94ad374.

I've put the full trace showing all the BUGs at
<http://www-student.cs.york.ac.uk/~aj504/dmesg-suspend-BUG-copy_page_c.txt>. 
Here's a truncated trace showing the suspend and the first BUG.

[19273.773409] skge eth0: disabling interface
[19273.853172] skge 0000:02:03.0: PCI INT A disabled
[19275.510499] PM: Syncing filesystems ... done.
[19275.510526] PM: Preparing system for mem sleep
[19275.510532] Freezing user space processes ... (elapsed 0.00 seconds) done.
[19275.511327] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[19275.511360] PM: Entering mem sleep
[19275.511362] Suspending console(s) (use no_console_suspend to debug)
[19275.523120] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[19275.836981] sd 2:0:0:0: [sdb] Stopping disk
[19276.469751] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[19276.469825] sd 0:0:0:0: [sda] Stopping disk
[19276.470121] ACPI handle has no context!
[19276.470403] parport_pc 00:09: disabled
[19276.470625] serial 00:08: disabled
[19276.534091] ata2: port disabled. ignoring.
[19276.534128] ata_piix 0000:00:1f.1: PCI INT A disabled
[19276.534222] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[19276.547395] uhci_hcd 0000:00:1d.3: PCI INT D disabled
[19276.547420] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[19276.547446] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[19276.547471] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[19276.560715] HDA Intel 0000:00:1b.0: PCI INT A disabled
[19276.574126] PM: suspend devices took 1.066 seconds
[19276.574668] ACPI: Preparing to enter system sleep state S3
[19276.575075] Disabling non-boot CPUs ...
[19276.683075] CPU 1 is now offline
[19276.683079] SMP alternatives: switching to UP code
[19276.688552] CPU0 attaching NULL sched-domain.
[19276.688555] CPU1 attaching NULL sched-domain.
[19276.696410] CPU0 attaching NULL sched-domain.
[19276.696575] CPU1 is down
[19276.696575] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[19276.697176] Back to C!
[19276.697498] Enabling non-boot CPUs ...
[19276.697627] SMP alternatives: switching to SMP code
[19276.703219] Booting processor 1/1 ip 6000
[19276.706834] Initializing CPU#1
[19276.793495] Calibrating delay using timer specific routine.. <6>4259.62 BogoMIPS (lpj=7096994)
[19276.793502] CPU: L1 I cache: 32K, L1 D cache: 32K
[19276.793503] CPU: L2 cache: 4096K
[19276.793505] CPU: Physical Processor ID: 0
[19276.793506] CPU: Processor Core ID: 1
[19276.794311] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[19276.798560] CPU1: Intel(R) Core(TM)2 CPU          6420  @ 2.13GHz stepping 06
[19276.798579] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[19276.818613] CPU0 attaching NULL sched-domain.
[19276.818292] Switched to high resolution mode on CPU 1
[19276.830517] CPU0 attaching sched-domain:
[19276.830520]  domain 0: span 0-1 level MC
[19276.830523]   groups: 0 1
[19276.830527] CPU1 attaching sched-domain:
[19276.830528]  domain 0: span 0-1 level MC
[19276.830530]   groups: 1 0
[19276.827924] CPU1 is up
[19276.827926] ACPI: Waking up from system sleep state S3
[19276.828612] ACPI: Unable to turn cooling device [ffff88007f01b560] 'off'
[19276.840091] pcieport-driver 0000:00:01.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
[19276.840109] pcieport-driver 0000:00:01.0: setting latency timer to 64
[19276.851192] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[19276.851196] pci 0000:00:02.0: setting latency timer to 64
[19276.864532] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x10b)
[19276.864546] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xfdff8004)
[19276.864551] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[19276.864556] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[19276.864571] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[19276.864576] HDA Intel 0000:00:1b.0: setting latency timer to 64
[19276.945969] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[19276.945973] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[19276.946003] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[19276.946007] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[19276.946036] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[19276.946040] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[19276.946069] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[19276.946074] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[19276.957853] ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
[19276.957857] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[19276.957863] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[19276.957874] ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[19276.957890] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xfdfff000)
[19276.957935] pci 0000:00:1e.0: setting latency timer to 64
[19276.957982] ata_piix 0000:00:1f.1: restoring config space at offset 0x8 (was 0xf001, writing 0xfa01)
[19276.957993] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2880005)
[19276.958003] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[19276.958007] ata_piix 0000:00:1f.1: setting latency timer to 64
[19276.959000] ata2: port disabled. ignoring.
[19276.971206] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[19276.971231] ahci 0000:00:1f.2: setting latency timer to 64
[19276.972141] serial 00:08: activated
[19276.972895] parport_pc 00:09: activated
[19277.071585] sd 0:0:0:0: [sda] Starting disk
[19277.293856] ata4: SATA link down (SStatus 0 SControl 300)
[19277.293870] ata5: SATA link down (SStatus 0 SControl 300)
[19277.291563] ata6: SATA link down (SStatus 0 SControl 300)
[19278.467149] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[19278.475737] ata3.00: configured for UDMA/133
[19278.475785] sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[19278.475803] sd 2:0:0:0: [sdb] Write Protect is off
[19278.475805] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[19278.475834] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[19278.880782] ata1.01: ACPI cmd ef/03:44:00:00:00:b0 filtered out
[19278.880784] ata1.01: ACPI cmd ef/03:44:00:00:00:b0 filtered out
[19278.880786] ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[19278.887448] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[19278.887450] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[19278.887452] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[19278.900854] ata1.00: configured for UDMA/100
[19278.914052] ata1.01: configured for UDMA/44
[19278.933166] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[19278.933195] sd 0:0:0:0: [sda] Write Protect is off
[19278.933197] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[19278.933227] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[19278.933255] sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
[19278.933271] sd 0:0:0:0: [sda] Write Protect is off
[19278.933274] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[19278.933302] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[19279.089136] sd 2:0:0:0: [sdb] Starting disk
[19279.098597] pci 0000:00:02.0: setting latency timer to 64
[19279.100104] PM: resume devices took 2.266 seconds
[19279.100119] PM: Finishing wakeup.
[19279.100120] Restarting tasks ... done.
[19280.171174] skge 0000:02:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[19280.171221] skge 1.13 addr 0xfdcfc000 irq 16 chip Yukon-Lite rev 9
[19280.172144] skge eth0: addr 00:01:6c:07:60:b1
[19280.184329] skge eth0: enabling interface
[19280.187923] ADDRCONF(NETDEV_UP): eth0: link is not ready
[19280.236437] BUG: unable to handle kernel paging request at ffff88004fb28000
[19280.236560] IP: [<ffffffff80323215>] copy_page_c+0x5/0x10
[19280.236645] PGD 202063 PUD 8067 PMD 803c85370cfc01e3 
[19280.236679] Oops: 0009 [1] SMP 
[19280.236681] CPU 0 
[19280.236682] Modules linked in: skge nls_iso8859_1 nls_cp437 vfat fat nls_base usb_storage libusual af_packet i915 drm binfmt_misc ppdev kvm ipv6 ac acpi_cpufreq video output sbs sbshc cpufreq_userspace cpufreq_powersave cpufreq_stats container cpufreq_conservative battery iptable_filter ip_tables x_tables ext2 coretemp it87 hwmon_vid lp fuse snd_hda_intel snd_pcm snd_timer snd_hwdep fan sr_mod snd sg cdrom thermal parport_pc parport soundcore pcspkr processor button floppy evdev ext3 jbd mbcache sd_mod ata_generic pata_acpi usbhid hid iTCO_wdt iTCO_vendor_support ata_piix ahci ehci_hcd libata uhci_hcd shpchp usbcore snd_page_alloc pci_hotplug intel_agp raid456 async_xor async_memcpy async_tx xor raid1 raid0 md_mod dm_mod [last unloaded: skge]
[19280.236714] Pid: 13614, comm: hald-runner Not tainted 2.6.27-rc1-00158-ga65b7e9 #22
[19280.236716] RIP: 0010:[<ffffffff80323215>]  [<ffffffff80323215>] copy_page_c+0x5/0x10
[19280.236719] RSP: 0000:ffff880059407db0  EFLAGS: 00010286
[19280.236720] RAX: ffff880000000000 RBX: 0000000000000000 RCX: 0000000000000200
[19280.236722] RDX: 6db6db6db6db6db7 RSI: ffff88004fb28000 RDI: ffff88005b7de000
[19280.236724] RBP: ffff88005e95e6d8 R08: 0000000000000000 R09: 0000000000000000
[19280.236725] R10: 0000000000000001 R11: 0000000000000246 R12: 000000000005b7de
[19280.236727] R13: ffffe200014b4cf0 R14: ffffe2000116f0c0 R15: 00007f495b6244f8
[19280.236729] FS:  00007f495b5f6780(0000) GS:ffffffff805c8480(0000) knlGS:0000000000000000
[19280.236731] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[19280.236732] CR2: ffff88004fb28000 CR3: 00000000594d6000 CR4: 00000000000006e0
[19280.236734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[19280.236736] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[19280.236738] Process hald-runner (pid: 13614, threadinfo ffff880059406000, task ffff880064d49230)
[19280.236739] Stack:  ffffffff80283e04 ffffe20000000000 ffff880064eb8c78 ffff880068f9b400
[19280.236742]  ffffe20001403890 ffffffff80454d45 800000004fb28045 0000000000000001
[19280.236744]  ffffe200014b4cf0 00007f495b6244f8 ffff88005ea84120 ffff880068f9b400
[19280.236746] Call Trace:
[19280.236751]  [<ffffffff80283e04>] ? do_wp_page+0x124/0x660
[19280.236755]  [<ffffffff80454d45>] ? _spin_lock+0x5/0x10
[19280.236757]  [<ffffffff80285e85>] ? handle_mm_fault+0x735/0x910
[19280.236760]  [<ffffffff80320d51>] ? __up_read+0x21/0xb0
[19280.236762]  [<ffffffff80454e6b>] ? _spin_lock_irqsave+0x2b/0x40
[19280.236765]  [<ffffffff80457965>] ? do_page_fault+0x505/0xb20
[19280.236768]  [<ffffffff80323f4d>] ? __put_user_4+0x1d/0x30
[19280.236770]  [<ffffffff80454e6b>] ? _spin_lock_irqsave+0x2b/0x40
[19280.236772]  [<ffffffff8045517a>] ? error_exit+0x0/0x70
[19280.236773] 
[19280.236774] 
[19280.236774] Code: 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 b9 00 02 00 00 <f3> 48 a5 c3 0f 1f 80 00 00 00 00 eb ee 0f 1f 84 00 00 00 00 00 
[19280.236788] RIP  [<ffffffff80323215>] copy_page_c+0x5/0x10
[19280.236791]  RSP <ffff880059407db0>
[19280.236792] CR2: ffff88004fb28000
[19280.236801] ---[ end trace 95d4021d02cf84be ]---
[19280.236802] note: hald-runner[13614] exited with preempt_count 2
