From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: kernel BUG at fs/ext4/inode.c:1184!
Date: Sat, 03 Oct 2009 11:52:12 +0200
Message-ID: <4AC71ECC.2020104@infracom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger@sun.com, linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cfexch.netexchange.int.netscalibur.it ([62.196.3.49]:58640 "EHLO
	cfexch.netexchange.int.netscalibur.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131AbZJCJ63 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2009 05:58:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is 100% reproducible on current git kernel.
After hitting the BUG the machine is still alive, but some processes
refuse to start and /bin/sync stalls forever.
Last known good kernel is 2.6.32-rc2-00087-g9c1fe83.

[   74.971246] ------------[ cut here ]------------
[   74.971303] kernel BUG at fs/ext4/inode.c:1184!
[   74.971351] invalid opcode: 0000 [#1] PREEMPT
[   74.971460] last sysfs file: 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
[   74.971520] Modules linked in: rfcomm sco bridge stp llc bnep l2cap 
ipv6 radeon cpufreq_ondemand ttm cpufreq_powersave drm_kms_helper 
cpufreq_userspace drm i2c_algo_bit cpufreq_stats iptable_filter 
ip_tables snd_intel8x0 snd_ac97_codec x_tables acpi_cpufreq ac97_bus 
snd_seq_oss freq_table snd_seq_midi snd_pcm_oss snd_pcm snd_rawmidi 
ipw2200 snd_seq_midi_event pcmcia snd_mixer_oss rtc_cmos snd_seq 
snd_timer snd_seq_device libipw btusb yenta_socket wbsd video bluetooth 
snd rtc_core rsrc_nonstatic usbserial cfg80211 output mmc_core rfkill 
soundcore rtc_lib evdev pcmcia_core battery ac snd_page_alloc button 
processor ext4 jbd2 sr_mod fan ohci1394 ehci_hcd sg thermal cdrom 
ieee1394 uhci_hcd usbcore
[   74.972012]
[   74.972012] Pid: 1379, comm: flush-8:0 Tainted: G        W  
(2.6.32-rc2-00244-g90d5ffc #1) Compaq nx7010 
(PG589EA#ABZ)                                                          
[   74.972012] EIP: 0060:[<f8207bf3>] EFLAGS: 00010246 CPU: 0
[   74.972012] EIP is at ext4_da_writepages+0x1da/0x598 [ext4]
[   74.972012] EAX: 4002007d EBX: c1b0a740 ECX: 0000000e EDX: f49f4fc4
[   74.972012] ESI: f6bc9f30 EDI: 00000000 EBP: 00000000 ESP: f6bc9df8
[   74.972012]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   74.972012] Process flush-8:0 (pid: 1379, ti=f6bc9000 task=f6a34ae0 
task.ti=f6bc9000)
[   74.972012] Stack:
[   74.972012]  f49f4fc4 00000002 00000000 00000001 f49f4f28 00000009 
00000000 00008000
[   74.972012] <0> 00000001 00000001 00000001 00000000 00000000 00000000 
f69a5c00 0000000e
[   74.972012] <0> 00000000 00000000 f49f4fc4 ffffffe2 0000000e 00000000 
c1b0a740 c1b010e0
[   74.972012] Call Trace:
[   74.972012]  [<f8207a19>] ? ext4_da_writepages+0x0/0x598 [ext4]
[   74.972012]  [<c105d40a>] ? do_writepages+0x19/0x25
[   74.972012]  [<c1090b77>] ? writeback_single_inode+0xb9/0x1e9
[   74.972012]  [<c109122c>] ? writeback_inodes_wb+0x2fd/0x395
[   74.972012]  [<c10913b2>] ? wb_writeback+0xee/0x163
[   74.972012]  [<c1301825>] ? schedule_timeout+0x142/0x159
[   74.972012]  [<c109159b>] ? wb_do_writeback+0x10b/0x124
[   74.972012]  [<c10915cd>] ? bdi_writeback_task+0x19/0x79
[   74.972012]  [<c10659bb>] ? bdi_start_fn+0x0/0xa8
[   74.972012]  [<c1065a10>] ? bdi_start_fn+0x55/0xa8
[   74.972012]  [<c10659bb>] ? bdi_start_fn+0x0/0xa8
[   74.972012]  [<c10300aa>] ? kthread+0x60/0x65
[   74.972012]  [<c103004a>] ? kthread+0x0/0x65
[   74.972012]  [<c10030e3>] ? kernel_thread_helper+0x7/0x12
[   74.972012] Code: 54 24 48 39 53 10 75 12 8b 03 a8 10 74 0c f6 c4 20 
75 07 8b 7b 14 39 ef 74 0c 89 d8 e8 50 07 e5 c8 e9 aa 03 00 00 f6 c4 08 
75 04 <0f> 0b eb fe 8b 4b 0c 89 c8 8b 10 f6 c6 02 75 09 80 e6 40 0f 84
[   74.972012] EIP: [<f8207bf3>] ext4_da_writepages+0x1da/0x598 [ext4] 
SS:ESP 0068:f6bc9df8
[   74.990069] ---[ end trace 4eaa2a86a8e2da24 ]---

Looking at the logs I see also this warning before the BUG (probably 
unrelated).

[    0.002040] ------------[ cut here ]------------
[    0.002048] WARNING: at arch/x86/kernel/apic/apic.c:249 
native_apic_write_dummy+0x2a/0x35()
[    0.002051] Hardware name: Compaq nx7010 (PG589EA#ABZ)
[    0.002054] Modules linked in:
[    0.002058] Pid: 0, comm: swapper Not tainted 
2.6.32-rc2-00244-g90d5ffc #1
[    0.002061] Call Trace:
[    0.002067]  [<c10215ce>] ? warn_slowpath_common+0x41/0x71
[    0.002072]  [<c10215eb>] ? warn_slowpath_common+0x5e/0x71
[    0.002076]  [<c1021608>] ? warn_slowpath_null+0xa/0xc
[    0.002080]  [<c1010104>] ? native_apic_write_dummy+0x2a/0x35
[    0.002086]  [<c100c859>] ? intel_init_thermal+0xd9/0x180
[    0.002090]  [<c100c4c8>] ? mce_intel_feature_init+0x8/0x47
[    0.002095]  [<c1493dbb>] ? mcheck_init+0x254/0x28c
[    0.002099]  [<c1492d72>] ? init_intel+0x1fa/0x280
[    0.002103]  [<c14926ed>] ? identify_cpu+0x2e4/0x2f1
[    0.002108]  [<c10b0cc2>] ? proc_register+0x141/0x17f
[    0.002114]  [<c1475656>] ? identify_boot_cpu+0xa/0x1e
[    0.002118]  [<c147573d>] ? check_bugs+0x8/0xd2
[    0.002122]  [<c1481d90>] ? proc_sys_init+0xc/0x23
[    0.002129]  [<c14706c4>] ? start_kernel+0x25d/0x26a
[    0.002140] ---[ end trace 4eaa2a86a8e2da22 ]---

More info on request.

R
