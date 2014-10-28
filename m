From: Johan Hovold <johan@kernel.org>
Subject: NULL derefs after failed suspend (i915, pm, ext4, slub)
Date: Tue, 28 Oct 2014 15:29:10 +0100
Message-ID: <20141028142910.GU2006@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Vetter <daniel.vetter@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi, 

I have had some problems with crashes involving suspend-to-disk after
updating to v3.16.

Below is a log with 3.16.6 from a failed suspend attempt after which I
get a NULL deref in ext4 code.

A couple of weeks ago I got something similar, with backtraces from 
ext4 (ext4_alloc_inode) and NULL-derefs in vfs (vfs_get_attr_nosec) when
trying to do IO after resuming from suspend. That was with 3.16.3 and I
was hoping that whatever it was would have been fixed in 3.16.6 (there
were some ext4 error handling patches in there). I only got photos of
those oopses but it involved kmem_cache_alloc (slub) and a NULL-deref in
vfs_get_attr_nosec. I can put the photos up somewhere. That time I also
got back to X and could issue a dmesg in an xterm, but any process trying
to do IO died.

Something similar happened with 3.16.1 but unfortunately I do not have
any logs from that.

I also have experienced occasional hangs during suspend, but I believe I
have seen this with older kernels as well so not sure if related. Seems
to be more frequent with 3.16.

This is my main machine so not keen on trying to bisect this on it.

It's an i7-4770 on an Intel DH87MC using the integrated HD Graphics 4600.

I'm CCing the Intel graphics guys due to some errors drm errors in the
logs, and reports of other people having problems involving suspend and
this driver.

Note that there was nothing obviously i915 related in the 3.16.3 oops
but I see now that it occurred soon after

	video LNXVIDEO:00: Restoring backlight state

just like it does below.

[137452.181187] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[137452.183960] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
[138715.329101] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[138715.331798] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization

I get the above occasionally when coming out of dpms-off and my
secondary monitor fails to power up. But here's the suspend attempt:

[148288.654477] s2disk.sh (24636): drop_caches: 3
[148288.654667] PM: Syncing filesystems ... done.
[148288.836275] Freezing user space processes ... (elapsed 0.000 seconds) done.
[148288.837641] PM: Preallocating image memory... done (allocated 1668895 pages)
[148289.299805] PM: Allocated 6675580 kbytes in 0.46 seconds (14512.13 MB/s)
[148289.299806] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[148289.301127] Suspending console(s) (use no_console_suspend to debug)
[148289.331656] PM: freeze of devices complete after 30.513 msecs
[148289.331925] PM: late freeze of devices complete after 0.267 msecs
[148289.332470] PM: noirq freeze of devices complete after 0.544 msecs
[148289.332471] Disabling non-boot CPUs ...
[148289.332488] intel_pstate CPU 1 exiting
[148289.333592] kvm: disabling virtualization on CPU1
[148289.333598] smpboot: CPU 1 is now offline
[148289.333979] intel_pstate CPU 2 exiting
[148289.335092] kvm: disabling virtualization on CPU2
[148289.335099] smpboot: CPU 2 is now offline
[148289.335370] intel_pstate CPU 3 exiting
[148289.336487] kvm: disabling virtualization on CPU3
[148289.336492] smpboot: CPU 3 is now offline
[148289.336757] intel_pstate CPU 4 exiting
[148289.337871] kvm: disabling virtualization on CPU4
[148289.338128] smpboot: CPU 4 is now offline
[148289.338344] intel_pstate CPU 5 exiting
[148289.339436] kvm: disabling virtualization on CPU5
[148289.339441] smpboot: CPU 5 is now offline
[148289.339608] intel_pstate CPU 6 exiting
[148289.340828] kvm: disabling virtualization on CPU6
[148289.340853] smpboot: CPU 6 is now offline
[148289.341407] intel_pstate CPU 7 exiting
[148289.342605] kvm: disabling virtualization on CPU7
[148289.342651] smpboot: CPU 7 is now offline
[148289.342943] PM: Creating hibernation image:
[148289.644672] PM: Need to copy 1665588 pages

Suspend has failed, resuming:

[148289.343968] Enabling non-boot CPUs ...
[148289.343991] x86: Booting SMP configuration:
[148289.343992] smpboot: Booting Node 0 Processor 1 APIC 0x2
[148289.355895] kvm: enabling virtualization on CPU1
[148289.357989] Intel pstate controlling: cpu 1
[148289.358014] CPU1 is up
[148289.358025] smpboot: Booting Node 0 Processor 2 APIC 0x4
[148289.369916] kvm: enabling virtualization on CPU2
[148289.371995] Intel pstate controlling: cpu 2
[148289.372016] CPU2 is up
[148289.372025] smpboot: Booting Node 0 Processor 3 APIC 0x6
[148289.383905] kvm: enabling virtualization on CPU3
[148289.385993] Intel pstate controlling: cpu 3
[148289.386013] CPU3 is up
[148289.386023] smpboot: Booting Node 0 Processor 4 APIC 0x1
[148289.397882] kvm: enabling virtualization on CPU4
[148289.399999] Intel pstate controlling: cpu 4
[148289.400021] CPU4 is up
[148289.400031] smpboot: Booting Node 0 Processor 5 APIC 0x3
[148289.411884] kvm: enabling virtualization on CPU5
[148289.414003] Intel pstate controlling: cpu 5
[148289.414025] CPU5 is up
[148289.414034] smpboot: Booting Node 0 Processor 6 APIC 0x5
[148289.425900] kvm: enabling virtualization on CPU6
[148289.428008] Intel pstate controlling: cpu 6
[148289.428027] CPU6 is up
[148289.428038] smpboot: Booting Node 0 Processor 7 APIC 0x7
[148289.439913] kvm: enabling virtualization on CPU7
[148289.442013] Intel pstate controlling: cpu 7
[148289.442033] CPU7 is up
[148289.448482] PM: noirq restore of devices complete after 1.144 msecs
[148289.448730] PM: early restore of devices complete after 0.234 msecs
[148289.600031] usb usb1: root hub lost power or was reset
[148289.600032] usb usb3: root hub lost power or was reset
[148289.600033] usb usb4: root hub lost power or was reset
[148289.600038] usb usb2: root hub lost power or was reset
[148289.600119] snd_hda_intel 0000:00:03.0: irq 42 for MSI/MSI-X
[148289.600187] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[148289.600264] xhci_hcd 0000:00:14.0: irq 44 for MSI/MSI-X
[148289.603105] sd 0:0:0:0: [sda] Starting disk
[148289.603119] sd 1:0:0:0: [sdb] Starting disk
[148289.603132] sd 2:0:0:0: [sdc] Starting disk
[148289.603142] sd 3:0:0:0: [sdd] Starting disk
[148289.603152] sd 4:0:0:0: [sde] Starting disk
[148289.603917] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[148289.603919] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[148289.654886] ------------[ cut here ]------------
[148289.654890] WARNING: CPU: 5 PID: 24639 at /home/johan/src/linux/linux-xi/drivers/gpu/drm/i915/intel_ddi.c:911 intel_ddi_pll_enable+0x233/0x240()
[148289.654891] WRPLL2 already enabled
[148289.654891] Modules linked in:
[148289.654893] CPU: 5 PID: 24639 Comm: kworker/u16:4 Tainted: G        W     3.16.6 #1
[148289.654894] Hardware name:                  /DH87MC, BIOS MCH8710H.86A.0154.2014.0123.1542 01/23/2014
[148289.654896] Workqueue: events_unbound async_run_entry_fn
[148289.654898]  0000000000000000 0000000000000009 ffffffff81739c03 ffff88074681baf8
[148289.654898]  ffffffff810850f6 ffff8807fadf0000 00000000b035061f 0000000000000001
[148289.654899]  0000000000046060 ffffffff81a10a48 ffffffff810851d5 ffffffff81a10a83
[148289.654900] Call Trace:
[148289.654904]  [<ffffffff81739c03>] ? dump_stack+0x49/0x6a
[148289.654906]  [<ffffffff810850f6>] ? warn_slowpath_common+0x86/0xb0
[148289.654907]  [<ffffffff810851d5>] ? warn_slowpath_fmt+0x45/0x50
[148289.654909]  [<ffffffff814445c3>] ? intel_ddi_pll_enable+0x233/0x240
[148289.654911]  [<ffffffff814208ea>] ? haswell_crtc_mode_set+0x1a/0x30
[148289.654913]  [<ffffffff8142e168>] ? __intel_set_mode+0x6a8/0x1590
[148289.654914]  [<ffffffff814335f7>] ? intel_modeset_setup_hw_state+0x817/0xd10
[148289.654917]  [<ffffffff813d4ae9>] ? drm_modeset_lock_all_crtcs+0x39/0x50
[148289.654919]  [<ffffffff81328570>] ? pci_pm_suspend_noirq+0x1b0/0x1b0
[148289.654921]  [<ffffffff813d719e>] ? __i915_drm_thaw+0x11e/0x1a0
[148289.654921]  [<ffffffff813d786f>] ? i915_resume+0x1f/0x40
[148289.654922]  [<ffffffff814749ef>] ? dpm_run_callback+0x4f/0x150
[148289.654923]  [<ffffffff814756b3>] ? device_resume+0x93/0x1d0
[148289.654924]  [<ffffffff81475804>] ? async_resume+0x14/0x40
[148289.654925]  [<ffffffff810aaabd>] ? async_run_entry_fn+0x2d/0x120
[148289.654928]  [<ffffffff8109eb58>] ? process_one_work+0x158/0x410
[148289.654929]  [<ffffffff8109f376>] ? worker_thread+0x116/0x510
[148289.654930]  [<ffffffff810c11ec>] ? __wake_up_common+0x4c/0x80
[148289.654932]  [<ffffffff8109f260>] ? init_pwq+0x160/0x160
[148289.654933]  [<ffffffff810a538c>] ? kthread+0xbc/0xe0
[148289.654934]  [<ffffffff810a0000>] ? workqueue_sysfs_register+0x110/0x150
[148289.654936]  [<ffffffff810a52d0>] ? kthread_freezable_should_stop+0x60/0x60
[148289.654938]  [<ffffffff81741aac>] ? ret_from_fork+0x7c/0xb0
[148289.654939]  [<ffffffff810a52d0>] ? kthread_freezable_should_stop+0x60/0x60
[148289.654940] ---[ end trace 0c696d0431a4573c ]---

I have seen this warning before. Think it been there for a while during
resume.

[148289.655460] e1000e 0000:03:00.0: irq 45 for MSI/MSI-X
[148289.655462] e1000e 0000:03:00.0: irq 46 for MSI/MSI-X
[148289.655464] e1000e 0000:03:00.0: irq 47 for MSI/MSI-X
[148289.675880] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[148289.678551] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization

Link training again.

[148289.693926] e1000e 0000:00:19.0: irq 48 for MSI/MSI-X
[148289.804741] usb 4-6: reset SuperSpeed USB device number 2 using xhci_hcd
[148289.815764] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807f9478480
[148289.905641] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[148289.906339] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[148289.906612] ata1.00: failed to get NCQ Send/Recv Log Emask 0x1
[148289.906628] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[148289.906667] ata1.00: configured for UDMA/133
[148289.907306] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[148289.907563] ata2.00: failed to get NCQ Send/Recv Log Emask 0x1
[148289.907618] ata2.00: configured for UDMA/133
[148289.907638] usb 2-1: reset high-speed USB device number 2 using ehci-pci
[148289.907643] usb 1-1: reset high-speed USB device number 2 using ehci-pci
[148289.908628] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[148289.908995] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (unknown) succeeded
[148289.908995] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (unknown) filtered out
[148289.908996] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (unknown) filtered out
[148289.909639] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (unknown) succeeded
[148289.909640] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (unknown) filtered out
[148289.909641] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (unknown) filtered out
[148289.909899] ata5.00: configured for UDMA/133
[148289.910651] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[148289.911672] ata3.00: configured for UDMA/133
[148289.912654] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[148289.913757] ata4.00: configured for UDMA/133
[148290.066827] usb 3-5: reset low-speed USB device number 3 using xhci_hcd
[148290.344614] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fae8c660
[148290.344616] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fae8c540
[148290.344639] usb 3-5: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[148290.344641] usb 3-5: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[148290.488965] usb 3-4: reset high-speed USB device number 2 using xhci_hcd
[148290.653291] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fa96ff60
[148290.806149] usb 3-6: reset high-speed USB device number 4 using xhci_hcd
[148290.971324] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fa8acf60
[148291.222262] usb 3-11: reset low-speed USB device number 5 using xhci_hcd
[148291.505824] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fa8cede0
[148291.505826] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fa8cee40
[148291.505832] usb 3-11: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[148291.505834] usb 3-11: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[148291.603407] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[148291.747614] usb 3-4.1: reset low-speed USB device number 6 using xhci_hcd
[148292.013705] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807f9478780
[148292.013721] usb 3-4.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[148292.018708] input input18: event field not found
[148292.018711] input input18: event field not found
[148292.018712] input input18: event field not found
[148292.018714] input input18: event field not found
[148292.018715] input input18: event field not found
[148292.018717] input input18: event field not found
[148292.018718] input input18: event field not found
[148292.264817] usb 3-4.3: reset low-speed USB device number 7 using xhci_hcd
[148292.513349] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[148292.592349] usb 3-6.5: reset high-speed USB device number 11 using xhci_hcd
[148292.671846] e1000e: enp3s0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[148292.678295] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fba53ba0
[148292.740355] usb 3-6.1: reset high-speed USB device number 8 using xhci_hcd
[148292.826366] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fa8ce480
[148292.899440] usb 3-6.3: reset full-speed USB device number 9 using xhci_hcd
[148292.975598] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037a57f00
[148292.975602] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff880037a57f48
[148292.976643] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disconnected from ttyUSB1
[148292.976659] ftdi_sio 3-6.3:1.0: device disconnected
[148293.226575] usb 3-6.5.4: reset low-speed USB device number 14 using xhci_hcd
[148293.492667] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fb3b2cc0
[148293.492671] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fb3b2f60
[148293.492687] usb 3-6.5.4: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[148293.492692] usb 3-6.5.4: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[148293.553718] usb 3-6.5.3: reset full-speed USB device number 13 using xhci_hcd
[148293.629867] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807f7737c00
[148293.629871] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807f7737c48
[148293.630945] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[148293.630967] ftdi_sio 3-6.5.3:1.0: device disconnected
[148293.690816] usb 3-6.5.1: reset high-speed USB device number 12 using xhci_hcd
[148293.777950] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called with disabled ep ffff8807fb872c00
[148293.780788] PM: restore of devices complete after 4179.082 msecs
[148293.781035] ftdi_sio 3-6.5.3:1.0: FTDI USB Serial Device converter detected
[148293.781102] usb 3-6.5.3: Detected FT232RL
[148293.781107] usb 3-6.5.3: Number of endpoints 2
[148293.781112] usb 3-6.5.3: Endpoint 1 MaxPacketSize 64
[148293.781116] usb 3-6.5.3: Endpoint 2 MaxPacketSize 64
[148293.781119] usb 3-6.5.3: Setting MaxPacketSize 64
[148293.781681] usb 3-6.5.3: FTDI USB Serial Device converter now attached to ttyUSB0
[148293.781777] ftdi_sio 3-6.3:1.0: FTDI USB Serial Device converter detected
[148293.781826] usb 3-6.3: Detected FT232RL
[148293.781830] usb 3-6.3: Number of endpoints 2
[148293.781833] usb 3-6.3: Endpoint 1 MaxPacketSize 64
[148293.781837] usb 3-6.3: Endpoint 2 MaxPacketSize 64
[148293.781840] usb 3-6.3: Setting MaxPacketSize 64
[148293.782304] usb 3-6.3: FTDI USB Serial Device converter now attached to ttyUSB1
[148293.782944] Restarting tasks ... done.
[148293.785805] video LNXVIDEO:00: Restoring backlight state

And here's the NULL-deref in ext4 code (just after the backlight-restore
message again):

[148294.010462] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[148294.010503] IP: [<ffffffff8174123d>] _raw_spin_lock+0xd/0x30
[148294.010532] PGD 789f8f067 PUD 7bdc94067 PMD 0 
[148294.010556] Oops: 0002 [#1] PREEMPT SMP 
[148294.010577] Modules linked in:
[148294.010593] CPU: 2 PID: 24812 Comm: dhcpcd-run-hook Tainted: G        W     3.16.6 #1
[148294.010626] Hardware name:                  /DH87MC, BIOS MCH8710H.86A.0154.2014.0123.1542 01/23/2014
[148294.010664] task: ffff88078844c000 ti: ffff88078593c000 task.ti: ffff88078593c000
[148294.010695] RIP: 0010:[<ffffffff8174123d>]  [<ffffffff8174123d>] _raw_spin_lock+0xd/0x30
[148294.010730] RSP: 0018:ffff88078593f7f0  EFLAGS: 00010283
[148294.010752] RAX: 0000000000000100 RBX: 0000000000000000 RCX: ffff8807fba55258
[148294.010782] RDX: 0000000000000012 RSI: 0000000000000000 RDI: 0000000000000020
[148294.010811] RBP: 0000000000000020 R08: 0000000000000025 R09: 0000000000000000
[148294.010840] R10: ffff8807f9f9f800 R11: ffff88078593f888 R12: 0000000000000012
[148294.010870] R13: ffff8807fad70000 R14: ffff8807fbef2a40 R15: 0000000000000012
[148294.010900] FS:  00007f597b883700(0000) GS:ffff88081fa80000(0000) knlGS:0000000000000000
[148294.010933] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[148294.010958] CR2: 0000000000000020 CR3: 00000007faae6000 CR4: 00000000001407e0
[148294.010987] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[148294.011017] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[148294.011046] Stack:
[148294.011055]  ffffffff8120a39c ffffea0003181d00 ffff8800c6074000 ffff8807fa4d85b8
[148294.011090]  ffff88078593f880 0000000000000050 ffff8807fad70000 0000000000000012
[148294.011124]  ffff8800c6074000 0000000000000025 0000000000000012 0000000000000012
[148294.011159] Call Trace:
[148294.011172]  [<ffffffff8120a39c>] ? ext4_mb_generate_from_pa+0x6c/0xd0
[148294.011200]  [<ffffffff8120a930>] ? ext4_mb_init_cache+0x530/0x740
[148294.011227]  [<ffffffff8120b20f>] ? ext4_mb_load_buddy+0x2ff/0x390
[148294.011253]  [<ffffffff8120fca1>] ? ext4_free_blocks+0x391/0xc00
[148294.011280]  [<ffffffff8119479e>] ? __find_get_block+0x9e/0x230
[148294.011307]  [<ffffffff81203683>] ? ext4_ext_remove_space+0xb23/0x1180
[148294.011335]  [<ffffffff81217495>] ? __es_remove_extent+0x45/0x2d0
[148294.011361]  [<ffffffff81205467>] ? ext4_ext_truncate+0x97/0xc0
[148294.011387]  [<ffffffff811dd1da>] ? ext4_truncate+0x31a/0x3e0
[148294.011412]  [<ffffffff811ddbeb>] ? ext4_setattr+0x23b/0x5d0
[148294.011437]  [<ffffffff81088a2d>] ? current_fs_time+0xd/0x60
[148294.011462]  [<ffffffff8117ea0a>] ? notify_change+0x16a/0x3c0
[148294.011488]  [<ffffffff811628c7>] ? do_truncate+0x57/0x90
[148294.011512]  [<ffffffff81172749>] ? do_last.isra.60+0x799/0xca0
[148294.011537]  [<ffffffff8116f37e>] ? link_path_walk+0x27e/0x880
[148294.011563]  [<ffffffff81146bc1>] ? do_wp_page+0x331/0x770
[148294.011587]  [<ffffffff81172d1c>] ? path_openat+0xcc/0x630
[148294.011611]  [<ffffffff81079aaa>] ? __do_page_fault+0x1ba/0x4a0
[148294.011637]  [<ffffffff81173637>] ? do_filp_open+0x47/0xb0
[148294.011661]  [<ffffffff8117fe28>] ? __alloc_fd+0xc8/0x120
[148294.011685]  [<ffffffff811639c1>] ? do_sys_open+0x151/0x230
[148294.011710]  [<ffffffff81741b52>] ? system_call_fastpath+0x16/0x1b
[148294.011735] Code: 00 48 8b 3c 24 be 01 02 00 00 e9 2f 89 94 ff 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 65 ff 04 25 e0 b8 00 00 b8 00 01 00 00 <f0> 66 0f c1 07 0f b6 d4 38 c2 75 03 c3 f3 90 0f b6 07 38 d0 75 
[148294.011875] RIP  [<ffffffff8174123d>] _raw_spin_lock+0xd/0x30
[148294.011901]  RSP <ffff88078593f7f0>
[148294.011923] CR2: 0000000000000020
[148294.155386] ---[ end trace 0c696d0431a4573d ]---
[148294.155388] note: dhcpcd-run-hook[24812] exited with preempt_count 2

Same process involved in previous (3.16.3) crash, possibly just the
first IO attempt after resume.

[148364.927787] ------------[ cut here ]------------
[148364.927794] WARNING: CPU: 0 PID: 1627 at /home/johan/src/linux/linux-xi/drivers/gpu/drm/i915/intel_ddi.c:911 intel_ddi_pll_enable+0x233/0x240()
[148364.927795] WRPLL1 already enabled
[148364.927796] Modules linked in:
[148364.927798] CPU: 0 PID: 1627 Comm: X Tainted: G      D W     3.16.6 #1
[148364.927800] Hardware name:                  /DH87MC, BIOS MCH8710H.86A.0154.2014.0123.1542 01/23/2014
[148364.927801]  0000000000000000 0000000000000009 ffffffff81739c03 ffff8800d9c0fab8
[148364.927803]  ffffffff810850f6 ffff8807fadf0000 00000000b0210614 0000000000000001
[148364.927805]  0000000000046040 ffffffff81a10a41 ffffffff810851d5 ffffffff81a10a83
[148364.927807] Call Trace:
[148364.927811]  [<ffffffff81739c03>] ? dump_stack+0x49/0x6a
[148364.927815]  [<ffffffff810850f6>] ? warn_slowpath_common+0x86/0xb0
[148364.927816]  [<ffffffff810851d5>] ? warn_slowpath_fmt+0x45/0x50
[148364.927818]  [<ffffffff814445c3>] ? intel_ddi_pll_enable+0x233/0x240
[148364.927821]  [<ffffffff814208ea>] ? haswell_crtc_mode_set+0x1a/0x30
[148364.927824]  [<ffffffff8142e168>] ? __intel_set_mode+0x6a8/0x1590
[148364.927826]  [<ffffffff814316bd>] ? intel_set_mode+0xd/0x30
[148364.927829]  [<ffffffff8143262e>] ? intel_crtc_set_config+0x91e/0xe20
[148364.927832]  [<ffffffff812f9790>] ? idr_alloc+0x80/0xf0
[148364.927835]  [<ffffffff813c6b19>] ? drm_mode_set_config_internal+0x59/0xd0
[148364.927837]  [<ffffffff813ca0a6>] ? drm_mode_setcrtc+0xe6/0x580
[148364.927840]  [<ffffffff813bb054>] ? drm_ioctl+0x1c4/0x5d0
[148364.927842]  [<ffffffff813c9fc0>] ? drm_mode_setplane+0x490/0x490
[148364.927846]  [<ffffffff8117567e>] ? do_vfs_ioctl+0x7e/0x510
[148364.927848]  [<ffffffff811668b8>] ? __sb_end_write+0x28/0x60
[148364.927850]  [<ffffffff81164f5e>] ? vfs_write+0x16e/0x1f0
[148364.927852]  [<ffffffff8117f3d1>] ? __fget+0x71/0xb0
[148364.927854]  [<ffffffff81175b57>] ? SyS_ioctl+0x47/0xa0
[148364.927857]  [<ffffffff81741b52>] ? system_call_fastpath+0x16/0x1b
[148364.927859] ---[ end trace 0c696d0431a4573e ]---
[171623.048256] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[171623.051048] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
[171627.700178] [drm:ivybridge_set_fifo_underrun_reporting] *ERROR* uncleared fifo underrun on pipe B
[171627.700190] [drm:ivb_err_int_handler] *ERROR* Pipe B FIFO underrun
[173176.453287] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[173176.455989] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
[183651.742085] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[183651.744796] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization
[185745.384837] [drm:intel_dp_start_link_train] *ERROR* failed to enable link training
[185745.387535] [drm:intel_dp_complete_link_train] *ERROR* failed to start channel equalization

I haven't seen the above before I think. I try powering off the system
but all I get is:

[198956.944380] [drm:ivybridge_set_fifo_underrun_reporting] *ERROR* uncleared fifo underrun on pipe C
[198956.944392] [drm:ivb_err_int_handler] *ERROR* Pipe C FIFO underrun

Any ideas about what is going on?

Thanks,
Johan
