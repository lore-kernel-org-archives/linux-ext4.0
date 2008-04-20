From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Sun, 20 Apr 2008 21:04:23 +0200
Message-ID: <200804202104.24037.rjw@sisk.pl>
References: <200804191522.54334.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:55207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbYDTTEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Apr 2008 15:04:01 -0400
In-Reply-To: <200804191522.54334.rjw@sisk.pl>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I've just got the following traces from 2.6.25-git2 on HP nx6325 (64-bit).
I think they are related to the hang I described yesterday:

[12844.066757] BUG: unable to handle kernel paging request at ffffffffffffffff
[12844.066765] IP: [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.066775] PGD 203067 PUD 204067 PMD 0 
[12844.066778] Oops: 0000 [1] SMP DEBUG_PAGEALLOC
[12844.066782] CPU 1 
[12844.066784] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet rfkill_input snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter cpufreq_conservative ip6_tables x_tables cpufreq_ondemand cpufreq_userspace ipv6 cpufreq_powersave powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class rfcomm input_polldev l2cap fan ssb thermal pcmcia joydev snd_hda_intel snd_pcm rtc_cmos yenta_socket usbhid rtc_core hci_usb processor rsrc_nonstatic snd_timer shpchp psmouse i2c_piix4 sdhci ohci1394 battery pcmcia_core snd_page_alloc snd_hwdep tifm_7xx1 pci_hot
 plug serio_raw ide_cd_mod ac button i2c_core backlight output ieee1394 tifm_core mmc_core rtc_lib ff_memless bluetooth snd soundcore firmware_class k8temp cdrom tg3 sg ohci_hcd ehci_hcd usbcore edd ext3 jbd atiixp ide_core
[12844.066854] Pid: 13078, comm: kio_file Tainted: G   M     2.6.25 #401
[12844.066857] RIP: 0010:[<ffffffff802a7b3c>]  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.066861] RSP: 0018:ffff810064c5dc08  EFLAGS: 00010286
[12844.066863] RAX: ffffffffffffffff RBX: ffff8100f0bd7e10 RCX: 0000000000000012
[12844.066866] RDX: ffffffffffffffff RSI: ffff810064c5dd08 RDI: ffff810053304000
[12844.066868] RBP: ffff810064c5dc58 R08: 0000000000000003 R09: 0000000000000001
[12844.066871] R10: 0000000000000000 R11: 0000000000000246 R12: ffff810053304000
[12844.066873] R13: ffff810064c5dd08 R14: 000000005b3d8b1c R15: 000000000000001a
[12844.066876] FS:  00007f08e0719700(0000) GS:ffff81007782d480(0000) knlGS:0000000000000000
[12844.066879] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12844.066881] CR2: ffffffffffffffff CR3: 000000006a4f2000 CR4: 00000000000006a0
[12844.066884] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12844.066886] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12844.066889] Process kio_file (pid: 13078, threadinfo ffff810064c5c000, task ffff81005a8c8000)
[12844.066891] Stack:  ffff81000cdde000 000000000000001a ffff8100504a3000 000000000e310f76
[12844.066897]  ffffffffffffffff ffff810068c941c0 ffff810064c5de38 ffff8100533050c8
[12844.066901]  0000000000000000 ffff810064c5de38 ffff810064c5dca8 ffffffff8029e236
[12844.066905] Call Trace:
[12844.066919]  [<ffffffff8029e236>] do_lookup+0x2c/0x1b2
[12844.066930]  [<ffffffff802a04b4>] __link_path_walk+0x8e6/0xdbd
[12844.066955]  [<ffffffffa004deb4>] ? :ext3:ext3_xattr_get_acl_default+0x18/0x1a
[12844.066961]  [<ffffffff802b0869>] ? generic_getxattr+0x4e/0x5c
[12844.066973]  [<ffffffff802a09ec>] path_walk+0x61/0xc3
[12844.066981]  [<ffffffff802a0cd2>] do_path_lookup+0x15d/0x1d9
[12844.066991]  [<ffffffff802a161a>] __user_walk_fd+0x41/0x5c
[12844.067000]  [<ffffffff8029a252>] vfs_lstat_fd+0x24/0x5a
[12844.067007]  [<ffffffff8030b30d>] ? _atomic_dec_and_lock+0x3d/0x5c
[12844.067013]  [<ffffffff802abe02>] ? mntput_no_expire+0x20/0x8b
[12844.067019]  [<ffffffff8029dfe8>] ? path_put+0x2c/0x30
[12844.067021]  [<ffffffff802b128d>] ? sys_getxattr+0x60/0x75
[12844.067021]  [<ffffffff8029a2aa>] sys_newlstat+0x22/0x3c
[12844.067021]  [<ffffffff8020bf1b>] system_call_after_swapgs+0x7b/0x80
[12844.067021] 
[12844.067021] 
[12844.067021] Code: f6 43 04 10 75 06 f0 ff 03 48 89 d8 fe 43 08 eb 31 fe 43 08 48 8b 45 d0 48 8b 00 48 89 45 d0 48 8b 45 d0 48 85 c0 74 18 48 89 c2 <48> 8b 00 48 8d 5a e8 44 39 73 30 0f 18 08 75 d9 e9 6a ff ff ff 
[12844.067021] RIP  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.067021]  RSP <ffff810064c5dc08>
[12844.067021] CR2: ffffffffffffffff
[12844.067021] ---[ end trace 02645136ff144df9 ]---
[12844.112513] BUG: unable to handle kernel paging request at ffffffffffffffff
[12844.112521] IP: [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.112530] PGD 203067 PUD 204067 PMD 0 
[12844.112533] Oops: 0000 [2] SMP DEBUG_PAGEALLOC
[12844.112537] CPU 1 
[12844.112539] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet rfkill_input snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter cpufreq_conservative ip6_tables x_tables cpufreq_ondemand cpufreq_userspace ipv6 cpufreq_powersave powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class rfcomm input_polldev l2cap fan ssb thermal pcmcia joydev snd_hda_intel snd_pcm rtc_cmos yenta_socket usbhid rtc_core hci_usb processor rsrc_nonstatic snd_timer shpchp psmouse i2c_piix4 sdhci ohci1394 battery pcmcia_core snd_page_alloc snd_hwdep tifm_7xx1 pci_hot
 plug serio_raw ide_cd_mod ac button i2c_core backlight output ieee1394 tifm_core mmc_core rtc_lib ff_memless bluetooth snd soundcore firmware_class k8temp cdrom tg3 sg ohci_hcd ehci_hcd usbcore edd ext3 jbd atiixp ide_core
[12844.112608] Pid: 13080, comm: kio_file Tainted: G   M  D  2.6.25 #401
[12844.112610] RIP: 0010:[<ffffffff802a7b3c>]  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.112614] RSP: 0018:ffff81006409dc08  EFLAGS: 00010286
[12844.112617] RAX: ffffffffffffffff RBX: ffff8100f0bd7e10 RCX: 0000000000000012
[12844.112620] RDX: ffffffffffffffff RSI: ffff81006409dd08 RDI: ffff810053304320
[12844.112622] RBP: ffff81006409dc58 R08: 0000000000000003 R09: 0000000000000001
[12844.112625] R10: 0000000000000000 R11: 0000000000000246 R12: ffff810053304320
[12844.112627] R13: ffff81006409dd08 R14: 00000000c93d6a90 R15: 0000000000000019
[12844.112630] FS:  00007f08e0719700(0000) GS:ffff81007782d480(0000) knlGS:0000000000000000
[12844.112633] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[12844.112635] CR2: ffffffffffffffff CR3: 0000000064052000 CR4: 00000000000006a0
[12844.112638] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[12844.112640] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[12844.112643] Process kio_file (pid: 13080, threadinfo ffff81006409c000, task ffff81005d0788e0)
[12844.112645] Stack:  ffff810035bfd000 0000000000000019 ffff8100504a2000 0000000011c4a621
[12844.112651]  ffffffffffffffff ffff8100769c41c0 ffff81006409de38 ffff810053305cc8
[12844.112655]  0000000000000000 ffff81006409de38 ffff81006409dca8 ffffffff8029e236
[12844.112659] Call Trace:
[12844.112673]  [<ffffffff8029e236>] do_lookup+0x2c/0x1b2
[12844.112683]  [<ffffffff802a04b4>] __link_path_walk+0x8e6/0xdbd
[12844.112707]  [<ffffffffa004deb4>] ? :ext3:ext3_xattr_get_acl_default+0x18/0x1a
[12844.112714]  [<ffffffff802b0869>] ? generic_getxattr+0x4e/0x5c
[12844.112726]  [<ffffffff802a09ec>] path_walk+0x61/0xc3
[12844.112734]  [<ffffffff802a0cd2>] do_path_lookup+0x15d/0x1d9
[12844.112744]  [<ffffffff802a161a>] __user_walk_fd+0x41/0x5c
[12844.112752]  [<ffffffff8029a252>] vfs_lstat_fd+0x24/0x5a
[12844.112759]  [<ffffffff8030b30d>] ? _atomic_dec_and_lock+0x3d/0x5c
[12844.112765]  [<ffffffff802abe02>] ? mntput_no_expire+0x20/0x8b
[12844.112771]  [<ffffffff8029dfe8>] ? path_put+0x2c/0x30
[12844.112777]  [<ffffffff802b128d>] ? sys_getxattr+0x60/0x75
[12844.112785]  [<ffffffff8029a2aa>] sys_newlstat+0x22/0x3c
[12844.112802]  [<ffffffff8020bf1b>] system_call_after_swapgs+0x7b/0x80
[12844.112814] 
[12844.112815] 
[12844.112816] Code: f6 43 04 10 75 06 f0 ff 03 48 89 d8 fe 43 08 eb 31 fe 43 08 48 8b 45 d0 48 8b 00 48 89 45 d0 48 8b 45 d0 48 85 c0 74 18 48 89 c2 <48> 8b 00 48 8d 5a e8 44 39 73 30 0f 18 08 75 d9 e9 6a ff ff ff 
[12844.112841] RIP  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[12844.112844]  RSP <ffff81006409dc08>
[12844.112846] CR2: ffffffffffffffff
[12844.112849] ---[ end trace 02645136ff144df9 ]---
[12877.045189] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[12877.882177] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=43194 PROTO=2 
[12887.026920] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
[12901.622330] Machine check events logged
[12938.158203] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=45263 PROTO=2 
[12939.885172] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
[12959.627487] ACPI: Transitioning device [C352] to D0
[12959.627497] ACPI: Unable to turn cooling device [ffff810077859c80] 'on'
[12998.650198] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=47341 PROTO=2 
[13001.353794] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
[13005.057167] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC= SRC=192.168.100.119 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[13017.810755] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
[13025.971847] BUG: unable to handle kernel paging request at ffff81f0210de4c8
[13025.971855] IP: [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[13025.971865] PGD 0 
[13025.971867] Oops: 0000 [3] SMP DEBUG_PAGEALLOC
[13025.971871] CPU 1 
[13025.971873] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet rfkill_input snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter cpufreq_conservative ip6_tables x_tables cpufreq_ondemand cpufreq_userspace ipv6 cpufreq_powersave powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class rfcomm input_polldev l2cap fan ssb thermal pcmcia joydev snd_hda_intel snd_pcm rtc_cmos yenta_socket usbhid rtc_core hci_usb processor rsrc_nonstatic snd_timer shpchp psmouse i2c_piix4 sdhci ohci1394 battery pcmcia_core snd_page_alloc snd_hwdep tifm_7xx1 pci_hot
 plug serio_raw ide_cd_mod ac button i2c_core backlight output ieee1394 tifm_core mmc_core rtc_lib ff_memless bluetooth snd soundcore firmware_class k8temp cdrom tg3 sg ohci_hcd ehci_hcd usbcore edd ext3 jbd atiixp ide_core
[13025.971941] Pid: 13061, comm: kmail Tainted: G   M  D  2.6.25 #401
[13025.971944] RIP: 0010:[<ffffffff802a7b3c>]  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[13025.971949] RSP: 0018:ffff8100501efd28  EFLAGS: 00010282
[13025.971951] RAX: ffff81f0210de4c8 RBX: ffff81002032a898 RCX: 0000000000000012
[13025.971954] RDX: ffff81f0210de4c8 RSI: ffff8100501efe98 RDI: ffff810063823ed8
[13025.971956] RBP: ffff8100501efd78 R08: ffff8100501efe88 R09: 0000000000000000
[13025.971959] R10: ffff8100395fce50 R11: 0000000000000206 R12: ffff810063823ed8
[13025.971961] R13: ffff8100501efe98 R14: 0000000048eb1dd0 R15: 0000000000000011
[13025.971964] FS:  00007f59b8083700(0000) GS:ffff81007782d480(0000) knlGS:0000000000000000
[13025.971967] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13025.971969] CR2: ffff81f0210de4c8 CR3: 0000000077066000 CR4: 00000000000006a0
[13025.971972] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[13025.971974] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[13025.971977] Process kmail (pid: 13061, threadinfo ffff8100501ee000, task ffff810055896000)
[13025.971979] Stack:  ffff8100501efe88 0000000000000011 ffff810064c5c01f ffffffff802a0cd2
[13025.971985]  ffff81f0210de4c8 ffff8100501efe88 ffff8100501efe88 ffff810063823ed8
[13025.971989]  ffff8100501efe98 ffff8100501efe88 ffff8100501efdb8 ffffffff8029e411
[13025.971993] Call Trace:
[13025.972002]  [<ffffffff802a0cd2>] ? do_path_lookup+0x15d/0x1d9
[13025.972011]  [<ffffffff8029e411>] __lookup_hash+0x55/0x117
[13025.972019]  [<ffffffff8029e50b>] lookup_hash+0x38/0x43
[13025.972025]  [<ffffffff802a1bc5>] open_namei+0xf1/0x694
[13025.972030]  [<ffffffff802a0cd2>] ? do_path_lookup+0x15d/0x1d9
[13025.972038]  [<ffffffff8030b30d>] ? _atomic_dec_and_lock+0x3d/0x5c
[13025.972049]  [<ffffffff8029575d>] do_filp_open+0x28/0x4b
[13025.972061]  [<ffffffff80295488>] ? get_unused_fd_flags+0x80/0x114
[13025.972069]  [<ffffffff802957d1>] do_sys_open+0x51/0xd2
[13025.972077]  [<ffffffff8029587b>] sys_open+0x1b/0x1d
[13025.972082]  [<ffffffff8020bf1b>] system_call_after_swapgs+0x7b/0x80
[13025.972094] 
[13025.972095] 
[13025.972096] Code: f6 43 04 10 75 06 f0 ff 03 48 89 d8 fe 43 08 eb 31 fe 43 08 48 8b 45 d0 48 8b 00 48 89 45 d0 48 8b 45 d0 48 85 c0 74 18 48 89 c2 <48> 8b 00 48 8d 5a e8 44 39 73 30 0f 18 08 75 d9 e9 6a ff ff ff 
[13025.972120] RIP  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[13025.972124]  RSP <ffff8100501efd28>
[13025.972126] CR2: ffff81f0210de4c8
[13025.972134] ---[ end trace 02645136ff144df9 ]---
[13064.772991] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
[13101.953964] general protection fault: 0000 [4] SMP DEBUG_PAGEALLOC
[13101.953971] CPU 1 
[13101.953973] Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet rfkill_input snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter cpufreq_conservative ip6_tables x_tables cpufreq_ondemand cpufreq_userspace ipv6 cpufreq_powersave powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcipher b43 rfkill mac80211 cfg80211 led_class rfcomm input_polldev l2cap fan ssb thermal pcmcia joydev snd_hda_intel snd_pcm rtc_cmos yenta_socket usbhid rtc_core hci_usb processor rsrc_nonstatic snd_timer shpchp psmouse i2c_piix4 sdhci ohci1394 battery pcmcia_core snd_page_alloc snd_hwdep tifm_7xx1 pci_hot
 plug serio_raw ide_cd_mod ac button i2c_core backlight output ieee1394 tifm_core mmc_core rtc_lib ff_memless bluetooth snd soundcore firmware_class k8temp cdrom tg3 sg ohci_hcd ehci_hcd usbcore edd ext3 jbd atiixp ide_core
[13101.954037] Pid: 13254, comm: preload Tainted: G   M  D  2.6.25 #401
[13101.954040] RIP: 0010:[<ffffffff802a7b3c>]  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[13101.954049] RSP: 0018:ffff810034a85c08  EFLAGS: 00010282
[13101.954051] RAX: fff0810023444c98 RBX: ffff81002010bed8 RCX: 0000000000000012
[13101.954054] RDX: fff0810023444c98 RSI: ffff810034a85d08 RDI: ffff810071be34b0
[13101.954057] RBP: ffff810034a85c58 R08: ffff810034a85e38 R09: 3239312f726f6c6f
[13101.954059] R10: 746e692f32393178 R11: 0000000000000246 R12: ffff810071be34b0
[13101.954062] R13: ffff810034a85d08 R14: 0000000045515a03 R15: 000000000000000e
[13101.954065] FS:  00007f235d3b96f0(0000) GS:ffff81007782d480(0000) knlGS:0000000000000000
[13101.954067] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[13101.954070] CR2: 000000000084b000 CR3: 000000005d068000 CR4: 00000000000006a0
[13101.954072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[13101.954075] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[13101.954078] Process preload (pid: 13254, threadinfo ffff810034a84000, task ffff8100597a31c0)
[13101.954080] Stack:  ffff810071be34b0 000000000000000e ffff810075dbf026 ffffffffa0045289
[13101.954085]  fff0810023444c98 ffff8100769c41ed ffff810034a85e38 ffff810071be4cc8
[13101.954090]  ffff8100769ce804 ffff810034a85e38 ffff810034a85ca8 ffffffff8029e236
[13101.954094] Call Trace:
[13101.954116]  [<ffffffffa0045289>] ? :ext3:ext3_lookup+0xa3/0xd0
[13101.954127]  [<ffffffff8029e236>] do_lookup+0x2c/0x1b2
[13101.954137]  [<ffffffff802a04b4>] __link_path_walk+0x8e6/0xdbd
[13101.954148]  [<ffffffff80273df4>] ? generic_file_aio_read+0x4eb/0x55c
[13101.954161]  [<ffffffff802a09ec>] path_walk+0x61/0xc3
[13101.954170]  [<ffffffff802a0cd2>] do_path_lookup+0x15d/0x1d9
[13101.954180]  [<ffffffff802a161a>] __user_walk_fd+0x41/0x5c
[13101.954189]  [<ffffffff8029a33d>] vfs_stat_fd+0x27/0x5d
[13101.954199]  [<ffffffff8022e6ba>] ? hrtick_set+0xdf/0xe8
[13101.954208]  [<ffffffff80442a93>] ? thread_return+0x69/0xad
[13101.954219]  [<ffffffff8029a3dc>] sys_newstat+0x22/0x3c
[13101.954225]  [<ffffffff802976e3>] ? vfs_read+0x11f/0x134
[13101.954233]  [<ffffffff80297a33>] ? sys_read+0x47/0x6f
[13101.954242]  [<ffffffff8020bf1b>] system_call_after_swapgs+0x7b/0x80
[13101.954254] 
[13101.954255] 
[13101.954257] Code: f6 43 04 10 75 06 f0 ff 03 48 89 d8 fe 43 08 eb 31 fe 43 08 48 8b 45 d0 48 8b 00 48 89 45 d0 48 8b 45 d0 48 85 c0 74 18 48 89 c2 <48> 8b 00 48 8d 5a e8 44 39 73 30 0f 18 08 75 d9 e9 6a ff ff ff 
[13101.954282] RIP  [<ffffffff802a7b3c>] __d_lookup+0xf1/0x117
[13101.954286]  RSP <ffff810034a85c08>
[13101.954295] ---[ end trace 02645136ff144df9 ]---
[13119.333166] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=51666 PROTO=2 
[13120.837389] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
[13179.516270] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:01:00:17:9a:f3:b5:75:08:00 SRC=62.121.83.254 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0xC0 TTL=1 ID=59251 PROTO=2 
[13187.109038] SFW2-INext-DROP-DEFLT IN=wlan0 OUT= MAC=01:00:5e:00:00:fb:00:13:8f:3a:0b:96:08:00 SRC=192.168.100.1 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 

Moreover, I got a general protection fault in shrink_dcache_sb(), but I hadn't
been able to write down the exact address before it was wiped away from the
screed.
