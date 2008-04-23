From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Wed, 23 Apr 2008 10:50:56 +0200
Message-ID: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	 <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>
	 <200804220254.45251.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
	 <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
	 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
	 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jiri Slaby" <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	"David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.249]:57592 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754554AbYDWIu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 04:50:59 -0400
Received: by rv-out-0506.google.com with SMTP id k29so1460185rvb.1
        for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 01:50:56 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/4/22, Linus Torvalds <torvalds@linux-foundation.org>:
>
>
>  On Tue, 22 Apr 2008, Zdenek Kabelac wrote:
>  >
>  > Unsure how it is related to my orginal Oops post - but now when I'=
ve
>  > debug pagealloc enabled this appeared in my log after resume - sho=
uld
>  > I open new bug for this - or could this be part of the problem I'v=
e
>  > experienced later?
>  >
>  > (Note - now I'm running commit: 8a81f2738f10ca817c975cec893aa58497=
e873b2
>  >
>  >  sd 0:0:0:0: [sda] Starting disk
>  >  mmc0: new SD card at address 5a61
>  >  mmc mmc0:5a61: parent mmc0 is sleeping, will not add
>  >  ------------[ cut here ]------------
>  >  WARNING: at drivers/base/power/main.c:78 device_pm_add+0x6c/0xf0(=
)
>
>
> This is unrelated to the other issue, I think.
>

Hi

This time I've got slightly larger mess with some other oopses - I'm
not sure if they are just a consequence of the PM bad commit - or they
are a separate issue ?

Is there actually some patch I should test from those posted in the lis=
t ?

Here goes the oops log:

(SPIN LOCK already disabled is my personal trace ooops which is just
checking if the spin_lock_irq is already called with disabled irq - in
this place probably irqsave version should be used instead, otherwice
it's not properly restored)

 PM: Syncing filesystems ... done.
 Freezing user space processes ... (elapsed 0.46 seconds) done.
 Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
 Suspending console(s)
 drm_sysfs_suspend
 ACPI: PCI interrupt for device 0000:00:02.0 disabled
 sd 0:0:0:0: [sda] Synchronizing SCSI cache
 sd 0:0:0:0: [sda] Stopping disk
 mmc0: card 5a61 removed
 MMC: killing requests for dead queue
 ACPI: PCI interrupt for device 0000:15:00.2 disabled
 ACPI: PCI interrupt for device 0000:00:1f.1 disabled
 ACPI: PCI interrupt for device 0000:00:1d.7 disabled
 ACPI: PCI interrupt for device 0000:00:1d.2 disabled
 ACPI: PCI interrupt for device 0000:00:1d.1 disabled
 ACPI: PCI interrupt for device 0000:00:1d.0 disabled
 ACPI: PCI interrupt for device 0000:00:1b.0 disabled
 ACPI: PCI interrupt for device 0000:00:1a.7 disabled
 ACPI: PCI interrupt for device 0000:00:1a.1 disabled
 ACPI: PCI interrupt for device 0000:00:1a.0 disabled
 ACPI: PCI interrupt for device 0000:00:19.0 disabled
 ACPI: Preparing to enter system sleep state S3
 Disabling non-boot CPUs ...
 kvm: disabling virtualization on CPU1
 CPU 1 is now offline
 lockdep: fixing up alternatives.
 SMP alternatives: switching to UP code
 CPU1 is down
 Extended CMOS year: 2000
  hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
 x86: PAT support disabled.
 Extended CMOS year: 2000
 Enabling non-boot CPUs ...
 lockdep: fixing up alternatives.
 SMP alternatives: switching to SMP code
 Booting processor 1/1 ip 6000
 Initializing CPU#1
 Calibrating delay using timer specific routine.. 4390.79 BogoMIPS (lpj=
=3D7314872)
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 4096K
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
 x86: PAT support disabled.
 SPIN IRQ ALREADY DISABLED
 Pid: 0, comm: swapper Not tainted 2.6.25 #57

 Call Trace:
  [_spin_lock_irq+126/128] _spin_lock_irq+0x7e/0x80
  [lock_ipi_call_lock+16/32] lock_ipi_call_lock+0x10/0x20
 CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
[start_secondary+68/206] start_secondary+0x44/0xce
  stepping 0a

 kvm: enabling virtualization on CPU1
 CPU1 is up
 ACPI: EC: missing OBF confirmation, don't expect it any longer.
 ACPI: EC: missing write data confirmation, don't expect it any longer.
 ACPI: \_SB_.GDCK - docking
 ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
 ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 20
 usb usb3: root hub lost power or was reset
 ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
 usb usb4: root hub lost power or was reset
 ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 22
 ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
 ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
 usb usb5: root hub lost power or was reset
 ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
 usb usb6: root hub lost power or was reset
 ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
 usb usb7: root hub lost power or was reset
 ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
 ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
 ata4.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
 ata4.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
 ata4.00: configured for UDMA/33
 ACPI: PCI Interrupt 0000:15:00.2[C] -> GSI 18 (level, low) -> IRQ 18
 sd 0:0:0:0: [sda] Starting disk
 mmc0: new SD card at address 5a61
 mmc mmc0:5a61: parent mmc0 is sleeping, will not add
 ------------[ cut here ]------------
 WARNING: at drivers/base/power/main.c:78 device_pm_add+0x6c/0xf0()
 Modules linked in: nls_iso8859_2 nls_cp852 vfat fat i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc
binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput kvm_intel kvm
snd_hda_intel snd_seq_oss arc4 snd_seq_midi_event ecb snd_seq
crypto_blkcipher cryptomgr snd_seq_device crypto_algapi snd_pcm_oss
iwl3945 snd_mixer_oss snd_pcm mac80211 video thinkpad_acpi psmouse
snd_timer backlight i2c_i801 rtc_cmos snd rtc_core iTCO_wdt evdev
i2c_core cfg80211 soundcore nvram snd_page_alloc e1000e output
mmc_block serio_raw rtc_lib iTCO_vendor_support sdhci mmc_core ac
battery intel_agp button uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: microcode]
 Pid: 1090, comm: kmmcd Not tainted 2.6.25 #57

 Call Trace:
  [warn_on_slowpath+95/144] warn_on_slowpath+0x5f/0x90
  [device_pm_add+24/240] ? device_pm_add+0x18/0xf0
  [device_pm_add+108/240] device_pm_add+0x6c/0xf0
  [device_add+1092/1376] device_add+0x444/0x560
  [_end+509508458/2109230024] :mmc_core:mmc_add_card+0xa2/0x140
  [_end+509515815/2109230024] :mmc_core:mmc_attach_sd+0x17f/0x860
  [_end+509507064/2109230024] ? :mmc_core:mmc_rescan+0x0/0x1c0
  [_end+509507433/2109230024] :mmc_core:mmc_rescan+0x171/0x1c0
  [run_workqueue+246/560] run_workqueue+0xf6/0x230
  [worker_thread+167/288] worker_thread+0xa7/0x120
  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
  [worker_thread+0/288] ? worker_thread+0x0/0x120
  [kthread+73/144] kthread+0x49/0x90
  [child_rip+10/18] child_rip+0xa/0x12
  [restore_args+0/48] ? restore_args+0x0/0x30
  [kthread+0/144] ? kthread+0x0/0x90
  [child_rip+0/18] ? child_rip+0x0/0x12

 ---[ end trace ca143223eefdc828 ]---
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000=
050
 IP: [klist_del+29/128] klist_del+0x1d/0x80
 PGD 0
 Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
 CPU 0
 Modules linked in: nls_iso8859_2 nls_cp852 vfat fat i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc
binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput kvm_intel kvm
snd_hda_intel snd_seq_oss arc4 snd_seq_midi_event ecb snd_seq
crypto_blkcipher cryptomgr snd_seq_device crypto_algapi snd_pcm_oss
iwl3945 snd_mixer_oss snd_pcm mac80211 video thinkpad_acpi psmouse
snd_timer backlight i2c_i801 rtc_cmos snd rtc_core iTCO_wdt evdev
i2c_core cfg80211 soundcore nvram snd_page_alloc e1000e output
mmc_block serio_raw rtc_lib iTCO_vendor_support sdhci mmc_core ac
battery intel_agp button uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: microcode]
 Pid: 1090, comm: kmmcd Not tainted 2.6.25 #57
 RIP: 0010:[klist_del+29/128]  [klist_del+29/128] klist_del+0x1d/0x80
 RSP: 0000:ffff81007c4f5d00  EFLAGS: 00010286
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000003
 RDX: 0000000000000008 RSI: ffffffffa006f308 RDI: 0000000000000000
 RBP: ffff81007c4f5d20 R08: 0000000000000001 R09: 0000000000000000
 R10: 0000000000000001 R11: ffff8100712cbc78 R12: ffff81007126aaa8
 R13: ffffffffa006f260 R14: ffff81007c4f5df0 R15: ffff81007126ab20
 FS:  0000000000000000(0000) GS:ffffffff8148c000(0000) knlGS:0000000000=
000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000050 CR3: 0000000001001000 CR4: 00000000000026e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kmmcd (pid: 1090, threadinfo ffff81007c4f4000, task ffff81007c=
028000)
 Stack:  ffff81007c4f5d10 0000000000000050 ffff81007126a970 ffffffffa00=
6f260
  ffff81007c4f5d50 ffffffff812012fe ffff81007c4f5d50 ffff81007126a970
  00000000fffffff0 ffff81007126ab68 ffff81007c4f5db0 ffffffff8120016e
 Call Trace:
  [bus_remove_device+158/208] bus_remove_device+0x9e/0xd0
  [device_add+1358/1376] device_add+0x54e/0x560
  [_end+509508458/2109230024] :mmc_core:mmc_add_card+0xa2/0x140
  [_end+509515815/2109230024] :mmc_core:mmc_attach_sd+0x17f/0x860
  [_end+509507064/2109230024] ? :mmc_core:mmc_rescan+0x0/0x1c0
  [_end+509507433/2109230024] :mmc_core:mmc_rescan+0x171/0x1c0
  [run_workqueue+246/560] run_workqueue+0xf6/0x230
  [worker_thread+167/288] worker_thread+0xa7/0x120
  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
  [worker_thread+0/288] ? worker_thread+0x0/0x120
  [kthread+73/144] kthread+0x49/0x90
  [child_rip+10/18] child_rip+0xa/0x12
  [restore_args+0/48] ? restore_args+0x0/0x30
  [kthread+0/144] ? kthread+0x0/0x90
  [child_rip+0/18] ? child_rip+0x0/0x12


 Code: 8b 28 41 0f 95 c7 eb 87 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec
20 4c 89 65 f0 48 89 5d e8 4c 89 6d f8 49 89 fc 48 8b 1f 48 89 df <4c>
8b 6b 50 e8 9a 40 01 00 49 8d 7c 24 18 48 c7 c6 20 a4 2d 81
 RIP  [klist_del+29/128] klist_del+0x1d/0x80
  RSP <ffff81007c4f5d00>
 CR2: 0000000000000050
 ---[ end trace ca143223eefdc828 ]---
 ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
 ata1.00: configured for UDMA/100
 ata1.00: configured for UDMA/100
 ata1: EH complete
 sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
 sd 0:0:0:0: [sda] Write Protect is off
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
 Restarting tasks ... <6>usb 3-2: USB disconnect, address 2

Apr 23 10:25:37 localhost hald[2469]: forcibly attempting to lazy
unmount /dev/mmcblk0p1 as enclosing drive was disconnected
Apr 23 10:25:37 localhost gnome-power-manager: (kabi) Probuzen=C3=AD po=
=C4=8D=C3=ADta=C4=8De
Apr 23 10:25:37 localhost kernel: [19631.081098] done.
Apr 23 10:25:38 localhost hald: unmounted /dev/mmcblk0p1 from
'/media/disk' on behalf of uid 0

 input: Virtual ThinkFinger Keyboard as /devices/virtual/input/input17
 usb 1-4: new high speed USB device using ehci_hcd and address 4
 usb 1-4: configuration #1 chosen from 1 choice
 hub 1-4:1.0: USB hub found
 hub 1-4:1.0: 4 ports detected
 usb 1-4: New USB device found, idVendor=3D04b3, idProduct=3D4485
 usb 1-4: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D=
0
 usb 3-2: new full speed USB device using uhci_hcd and address 3

Apr 23:25:38 localhost console-kit-daemon[2472]: WARNING: Couldn't
read /proc/16639/environ: Failed to open file '/proc/16639/environ':
No such file or directory
usb 3-2: configuration #1 chosen from 1 choice
usb 3-2: New USB device found, idVendor=3D0483, idProduct=3D2016
usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 3-2: Product: Biometric Coprocessor
usb 3-2: Manufacturer: STMicroelectronics
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
BUG kmalloc-4096: Padding overwritten. 0x0000000000000000-0x00000000fff=
fffff
-----------------------------------------------------------------------=
------

INFO: Slab 0xffffe20000c09c00 used=3D7 fp=3D0x0000000000000000 flags=3D=
0x2200000004083
Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57

Call Trace:
 [slab_err+167/192] slab_err+0xa7/0xc0
 [__free_pages_ok+420/1216] ? __free_pages_ok+0x1a4/0x4c0
 [kernel_map_pages+168/368] ? kernel_map_pages+0xa8/0x170
 [add_partial+33/112] ? add_partial+0x21/0x70
 [slab_pad_check+287/368] slab_pad_check+0x11f/0x170
 [check_slab+34/112] check_slab+0x22/0x70
 [__slab_free+458/944] __slab_free+0x1ca/0x3b0
 [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
 [kfree+180/304] kfree+0xb4/0x130
 [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
 [skb_release_data+133/208] skb_release_data+0x85/0xd0
 [skb_release_all+158/240] skb_release_all+0x9e/0xf0
 [__kfree_skb+17/160] __kfree_skb+0x11/0xa0
 [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x940
 [kfree_skb+23/64] kfree_skb+0x17/0x40
 [_end+510638598/2109230024] :iwl3945:iwl3945_rx_queue_reset+0xae/0x130
 [_end+510662510/2109230024] :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
 [_end+510613961/2109230024] :iwl3945:__iwl3945_up+0x91/0x640
 [_end+510616880/2109230024] :iwl3945:iwl3945_mac_start+0x568/0x790
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
 [_end+510327174/2109230024] :mac80211:ieee80211_open+0x13e/0x590
 [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
 [dev_open+121/176] dev_open+0x79/0xb0
 [dev_change_flags+153/464] dev_change_flags+0x99/0x1d0
 [do_setlink+524/928] do_setlink+0x20c/0x3a0
 [_read_unlock+48/96] ? _read_unlock+0x30/0x60
 [rtnl_setlink+269/336] rtnl_setlink+0x10d/0x150
 [rtnetlink_rcv_msg+397/576] rtnetlink_rcv_msg+0x18d/0x240
 [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
 [netlink_rcv_skb+137/176] netlink_rcv_skb+0x89/0xb0
 [rtnetlink_rcv+41/64] rtnetlink_rcv+0x29/0x40
 [netlink_unicast+709/736] netlink_unicast+0x2c5/0x2e0
 [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
 [netlink_sendmsg+498/752] netlink_sendmsg+0x1f2/0x2f0
 [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
 [sock_sendmsg+295/320] sock_sendmsg+0x127/0x140
 [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
 [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
 [sys_sendmsg+393/800] sys_sendmsg+0x189/0x320
 [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

 Padding 0xffff8100201a0000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
 Padding 0xffff8100201a0010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
 Padding 0xffff8100201a0020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
=2E.......... a lots of these .......
 Padding 0xffff8100201a7190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
 Padding 0xffff8100201a71a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b a5 kkkkkkkkkkkkkkk=A5
 Padding 0xffff8100201a71b0:  cc cc cc cc cc cc cc cc 00 00 1a 20 00
81 ff ff =CC=CC=CC=CC=CC=CC=CC=CC......=FF=FF
 Padding 0xffff8100201a71c0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73
05 00 00 =CDp..=FF=FF=FF=FF....s...
 Padding 0xffff8100201a71d0:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff
ff ff ff =B6TX.....=D5q&.=FF=FF=FF=FF
 Padding 0xffff8100201a71e0:  00 00 00 00 7c 05 00 00 97 54 58 00 01
00 00 00 ....|....TX.....
 Padding 0xffff8100201a71f0:  5a 5a 5a 5a 5a 5a 5a 5a
       ZZZZZZZZ
=46IX kmalloc-4096: Restoring 0xffff8100201a0000-0xffff8100201a7e16=3D0=
x5a

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
BUG kmalloc-4096: Redzone overwritten
-----------------------------------------------------------------------=
------

INFO: 0xffff8100201a2048-0xffff8100201a204f. First byte 0x5a instead of=
 0xcc
INFO: Allocated in 0x5a5a5a5a5a5a5a5a age=3D11936128522583413382
cpu=3D1515870810 pid=3D1515870810
INFO: Freed in 0x5a5a5a5a5a5a5a5a age=3D11936128522583413382
cpu=3D1515870810 pid=3D1515870810
INFO: Slab 0xffffe20000c09c00 used=3D7 fp=3D0x0000000000000000 flags=3D=
0x2200000004083
INFO: Object 0xffff8100201a1048 @offset=3D4168 fp=3D0x5a5a5a5a5a5a5a5a

Bytes b4 0xffff8100201a1038:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a1048:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a1058:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a1068:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a1078:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a1088:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a1098:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a10a8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xffff8100201a10b8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a ZZZZZZZZZZZZZZZZ
 Redzone 0xffff8100201a2048:  5a 5a 5a 5a 5a 5a 5a 5a
       ZZZZZZZZ
 Padding 0xffff8100201a2088:  5a 5a 5a 5a 5a 5a 5a 5a
       ZZZZZZZZ
Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57

Call Trace:
 [print_trailer+330/448] print_trailer+0x14a/0x1c0
 [check_bytes_and_report+293/384] check_bytes_and_report+0x125/0x180
 [check_object+102/624] check_object+0x66/0x270
 [__slab_free+683/944] __slab_free+0x2ab/0x3b0
 [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
 [kfree+180/304] kfree+0xb4/0x130
 [skb_release_data+133/208] ? skb_release_data+0x85/0xd0
 [skb_release_data+133/208] skb_release_data+0x85/0xd0
 [skb_release_all+158/240] skb_release_all+0x9e/0xf0
 [__kfree_skb+17/160] __kfree_skb+0x11/0xa0
 [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x940
 [kfree_skb+23/64] kfree_skb+0x17/0x40
 [_end+510638598/2109230024] :iwl3945:iwl3945_rx_queue_reset+0xae/0x130
 [_end+510662510/2109230024] :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
 [_end+510613961/2109230024] :iwl3945:__iwl3945_up+0x91/0x640
 [_end+510616880/2109230024] :iwl3945:iwl3945_mac_start+0x568/0x790
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
 [_end+510327174/2109230024] :mac80211:ieee80211_open+0x13e/0x590
 [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
 [dev_open+121/176] dev_open+0x79/0xb0
 [dev_change_flags+153/464] dev_change_flags+0x99/0x1d0
 [do_setlink+524/928] do_setlink+0x20c/0x3a0
 [_read_unlock+48/96] ? _read_unlock+0x30/0x60
 [rtnl_setlink+269/336] rtnl_setlink+0x10d/0x150
 [rtnetlink_rcv_msg+397/576] rtnetlink_rcv_msg+0x18d/0x240
 [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
 [netlink_rcv_skb+137/176] netlink_rcv_skb+0x89/0xb0
 [rtnetlink_rcv+41/64] rtnetlink_rcv+0x29/0x40
 [netlink_unicast+709/736] netlink_unicast+0x2c5/0x2e0
 [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
 [netlink_sendmsg+498/752] netlink_sendmsg+0x1f2/0x2f0
 [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
 [sock_sendmsg+295/320] sock_sendmsg+0x127/0x140
 [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
 [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
 [sys_sendmsg+393/800] sys_sendmsg+0x189/0x320
 [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

=46IX kmalloc-4096: Restoring 0xffff8100201a2048-0xffff8100201a204f=3D0=
xcc

general protection fault: 0000 [2] PREEMPT SMP DEBUG_PAGEALLOC
CPU 1
Modules linked in: nls_iso8859_2 nls_cp852 vfat fat i915 drm
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state
nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables
bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 sunrpc
binfmt_misc dm_mirror dm_log dm_multipath dm_mod uinput kvm_intel kvm
snd_hda_intel snd_seq_oss arc4 snd_seq_midi_event ecb snd_seq
crypto_blkcipher cryptomgr snd_seq_device crypto_algapi snd_pcm_oss
iwl3945 snd_mixer_oss snd_pcm mac80211 video thinkpad_acpi psmouse
snd_timer backlight i2c_i801 rtc_cmos snd rtc_core iTCO_wdt evdev
i2c_core cfg80211 soundcore nvram snd_page_alloc e1000e output
mmc_block serio_raw rtc_lib iTCO_vendor_support sdhci mmc_core ac
battery intel_agp button uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: microcode]
Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57
RIP: 0010:[put_page+14/256]  [put_page+14/256] put_page+0xe/0x100
RSP: 0018:ffff81007c3bb5f8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: 5a5a5a5a5a5a5a5a RCX: 0000000000000000
RDX: ffff8100201a5d28 RSI: 00000000201a516c RDI: 5a5a5a5a5a5a5a5a
RBP: ffff81007c3bb618 R08: ffff81007d355bd0 R09: ffff81006a96b0d8
R10: ffffe200027f8820 R11: ffff81006a96b000 R12: ffff81006a96b3c0
R13: ffff81007d352ba0 R14: ffff81007d351f00 R15: ffff81007d355bd0
=46S:  00007f59fb63e780(0000) GS:ffff81007e02e190(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003a6cf6ade0 CR3: 0000000073960000 CR4: 00000000000026a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process NetworkManager (pid: 2621, threadinfo ffff81007c3ba000, task
ffff81007245c000)
Stack:  0000000000000001 ffff81006a96b3c0 ffff81007d352ba0 ffff81007d35=
1f00
 ffff81007c3bb638 ffffffff812671fb ffff81006a96b3c0 00000000000000b1
 ffff81007c3bb658 ffffffff81267bee ffff81007d351f00 ffff81006a96b3c0
Call Trace:
 [skb_release_data+171/208] skb_release_data+0xab/0xd0
 [skb_release_all+158/240] skb_release_all+0x9e/0xf0
 [__kfree_skb+17/160] __kfree_skb+0x11/0xa0
 [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x940
 [kfree_skb+23/64] kfree_skb+0x17/0x40
 [_end+510638598/2109230024] :iwl3945:iwl3945_rx_queue_reset+0xae/0x130
 [_end+510662510/2109230024] :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
 [_end+510613961/2109230024] :iwl3945:__iwl3945_up+0x91/0x640
 [_end+510616880/2109230024] :iwl3945:iwl3945_mac_start+0x568/0x790
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
 [_end+510327174/2109230024] :mac80211:ieee80211_open+0x13e/0x590
 [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
 [dev_open+121/176] dev_open+0x79/0xb0
 [dev_change_flags+153/464] dev_change_flags+0x99/0x1d0
 [do_setlink+524/928] do_setlink+0x20c/0x3a0
 [_read_unlock+48/96] ? _read_unlock+0x30/0x60
 [rtnl_setlink+269/336] rtnl_setlink+0x10d/0x150
 [rtnetlink_rcv_msg+397/576] rtnetlink_rcv_msg+0x18d/0x240
 [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
 [netlink_rcv_skb+137/176] netlink_rcv_skb+0x89/0xb0
 [rtnetlink_rcv+41/64] rtnetlink_rcv+0x29/0x40
 [netlink_unicast+709/736] netlink_unicast+0x2c5/0x2e0
 [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
 [netlink_sendmsg+498/752] netlink_sendmsg+0x1f2/0x2f0
 [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
 [sock_sendmsg+295/320] sock_sendmsg+0x127/0x140
 [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
 [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
 [sys_sendmsg+393/800] sys_sendmsg+0x189/0x320
 [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80


Code: ff 41 54 9d eb e4 48 8b 47 10 0f 1f 00 e9 62 ff ff ff 66 66 2e
0f 1f 84 00 00 00 00 00 55 48 89 e5 41 56 41 55 41 54 53 48 89 fb <48>
8b 07 f6 c4 40 75 26 8b 4f 08 85 c9 75 0b 0f 0b eb fe 0f 1f
RIP  [put_page+14/256] put_page+0xe/0x100
 RSP <ffff81007c3bb5f8>
---[ end trace ca143223eefdc828 ]---
SPIN IRQ ALREADY DISABLED
Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57

Call Trace:
 [_spin_lock_irq+126/128] _spin_lock_irq+0x7e/0x80
 [exit_signals+85/304] exit_signals+0x55/0x130
 [do_exit+133/2192] do_exit+0x85/0x890
 [rotate_reclaimable_page+211/240] ? rotate_reclaimable_page+0xd3/0xf0
 [do_unblank_screen+29/368] ? do_unblank_screen+0x1d/0x170
 [oops_end+136/144] oops_end+0x88/0x90
 [die+94/144] die+0x5e/0x90
 [do_general_protection+344/368] do_general_protection+0x158/0x170
 [error_exit+0/169] error_exit+0x0/0xa9
 [put_page+14/256] ? put_page+0xe/0x100
 [skb_release_data+171/208] ? skb_release_data+0xab/0xd0
 [skb_release_all+158/240] ? skb_release_all+0x9e/0xf0
 [__kfree_skb+17/160] ? __kfree_skb+0x11/0xa0
 [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x940
 [kfree_skb+23/64] ? kfree_skb+0x17/0x40
 [_end+510638598/2109230024] ? :iwl3945:iwl3945_rx_queue_reset+0xae/0x1=
30
 [_end+510662510/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
 [_end+510613961/2109230024] ? :iwl3945:__iwl3945_up+0x91/0x640
 [_end+510616880/2109230024] ? :iwl3945:iwl3945_mac_start+0x568/0x790
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
 [_end+510327174/2109230024] ? :mac80211:ieee80211_open+0x13e/0x590
 [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
 [dev_open+121/176] ? dev_open+0x79/0xb0
 [dev_change_flags+153/464] ? dev_change_flags+0x99/0x1d0
 [do_setlink+524/928] ? do_setlink+0x20c/0x3a0
 [_read_unlock+48/96] ? _read_unlock+0x30/0x60
 [rtnl_setlink+269/336] ? rtnl_setlink+0x10d/0x150
 [rtnetlink_rcv_msg+397/576] ? rtnetlink_rcv_msg+0x18d/0x240
 [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
 [netlink_rcv_skb+137/176] ? netlink_rcv_skb+0x89/0xb0
 [rtnetlink_rcv+41/64] ? rtnetlink_rcv+0x29/0x40
 [netlink_unicast+709/736] ? netlink_unicast+0x2c5/0x2e0
 [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
 [netlink_sendmsg+498/752] ? netlink_sendmsg+0x1f2/0x2f0
 [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
 [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
 [sys_sendmsg+393/800] ? sys_sendmsg+0x189/0x320
 [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x8=
0

note: NetworkManager[2621] exited with preempt_count 1
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():1, irqs_disabled():0
INFO: lockdep is turned off.
Pid: 2621, comm: NetworkManager Tainted: G      D  2.6.25 #57

Call Trace:
 [__debug_show_held_locks+35/48] ? __debug_show_held_locks+0x23/0x30
 [__might_sleep+209/256] __might_sleep+0xd1/0x100
 [down_read+32/112] down_read+0x20/0x70
 [futex_wake+60/304] futex_wake+0x3c/0x130
 [sprintf+104/112] ? sprintf+0x68/0x70
 [do_futex+159/3440] do_futex+0x9f/0xd70
 [_spin_unlock_irqrestore+133/144] ? _spin_unlock_irqrestore+0x85/0x90
 [release_console_sem+524/544] ? release_console_sem+0x20c/0x220
 [vprintk+1008/1232] ? vprintk+0x3f0/0x4d0
 [sys_futex+180/320] sys_futex+0xb4/0x140
 [acct_collect+435/496] ? acct_collect+0x1b3/0x1f0
 [acct_collect+435/496] ? acct_collect+0x1b3/0x1f0
 [mm_release+142/160] mm_release+0x8e/0xa0
 [exit_mm+29/304] exit_mm+0x1d/0x130
 [do_exit+461/2192] do_exit+0x1cd/0x890
 [rotate_reclaimable_page+211/240] ? rotate_reclaimable_page+0xd3/0xf0
 [do_unblank_screen+29/368] ? do_unblank_screen+0x1d/0x170
 [oops_end+136/144] oops_end+0x88/0x90
 [die+94/144] die+0x5e/0x90
 [do_general_protection+344/368] do_general_protection+0x158/0x170
 [error_exit+0/169] error_exit+0x0/0xa9
 [put_page+14/256] ? put_page+0xe/0x100
 [skb_release_data+171/208] ? skb_release_data+0xab/0xd0
 [skb_release_all+158/240] ? skb_release_all+0x9e/0xf0
 [__kfree_skb+17/160] ? __kfree_skb+0x11/0xa0
 [_end+510662350/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x306/0x940
 [kfree_skb+23/64] ? kfree_skb+0x17/0x40
 [_end+510638598/2109230024] ? :iwl3945:iwl3945_rx_queue_reset+0xae/0x1=
30
 [_end+510662510/2109230024] ? :iwl3945:iwl3945_hw_nic_init+0x3a6/0x940
 [_end+510613961/2109230024] ? :iwl3945:__iwl3945_up+0x91/0x640
 [_end+510616880/2109230024] ? :iwl3945:iwl3945_mac_start+0x568/0x790
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [rb_insert_color+265/320] ? rb_insert_color+0x109/0x140
 [_end+510327174/2109230024] ? :mac80211:ieee80211_open+0x13e/0x590
 [dev_set_rx_mode+72/96] ? dev_set_rx_mode+0x48/0x60
 [dev_open+121/176] ? dev_open+0x79/0xb0
 [dev_change_flags+153/464] ? dev_change_flags+0x99/0x1d0
 [do_setlink+524/928] ? do_setlink+0x20c/0x3a0
 [_read_unlock+48/96] ? _read_unlock+0x30/0x60
 [rtnl_setlink+269/336] ? rtnl_setlink+0x10d/0x150
 [rtnetlink_rcv_msg+397/576] ? rtnetlink_rcv_msg+0x18d/0x240
 [rtnetlink_rcv_msg+0/576] ? rtnetlink_rcv_msg+0x0/0x240
 [netlink_rcv_skb+137/176] ? netlink_rcv_skb+0x89/0xb0
 [rtnetlink_rcv+41/64] ? rtnetlink_rcv+0x29/0x40
 [netlink_unicast+709/736] ? netlink_unicast+0x2c5/0x2e0
 [__alloc_skb+110/336] ? __alloc_skb+0x6e/0x150
 [netlink_sendmsg+498/752] ? netlink_sendmsg+0x1f2/0x2f0
 [_read_unlock+78/96] ? _read_unlock+0x4e/0x60
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [sock_recvmsg+313/336] ? sock_recvmsg+0x139/0x150
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [sock_sendmsg+295/320] ? sock_sendmsg+0x127/0x140
 [move_addr_to_kernel+87/96] ? move_addr_to_kernel+0x57/0x60
 [verify_iovec+60/208] ? verify_iovec+0x3c/0xd0
 [sys_sendmsg+393/800] ? sys_sendmsg+0x189/0x320
 [sys_sendto+253/288] ? sys_sendto+0xfd/0x120
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x8=
0

NetworkManager used greatest stack depth: 2928 bytes left
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: None
ACPI: \_SB_.GDCK - undocking
usb 1-4: USB disconnect, address 4
ACPI: \_SB_.GDCK - docking
usb 1-4: new high speed USB device using ehci_hcd and address 5
usb 1-4: configuration #1 chosen from 1 choice
hub 1-4:1.0: USB hub found
hub 1-4:1.0: 4 ports detected
usb 1-4: New USB device found, idVendor=3D04b3, idProduct=3D4485
usb 1-4: New USB device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
SysRq : Emergency Sync
Emergency Sync complete
SysRq : Emergency Remount R/O
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
