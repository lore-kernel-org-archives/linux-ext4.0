From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15690] New: system hanged while doing "sync"
Date: Sun, 4 Apr 2010 14:20:06 GMT
Message-ID: <bug-15690-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59903 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab0DDOUR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Apr 2010 10:20:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o34EK8C7029655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 4 Apr 2010 14:20:08 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15690

           Summary: system hanged while doing "sync"
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.34-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: htmldeveloper@gmail.com
        Regression: No


System:   Lenovo R400, dual-core.

I was doing many things, among which is "sync" in one terminal, but it took too
long.   And ctrl-C does not break it, so I started a new terminal, capture the
dmesg, and restart "sync" again, again it result in blocking state, and each
"sync" seemed to generate a new calltrace in the kernel (????not sure???).

Enjoy......

[   25.141405] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control:
RX/TX
[   25.141408] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[   25.141533] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   27.560538] virbr0: no IPv6 routers present
[   36.132347] eth0: no IPv6 routers present
[   37.780776] UDF-fs: No VRS found
[   37.780780] UDF-fs: No partition found (1)
[   38.524370] ISO 9660 Extensions: Microsoft Joliet Level 3
[   38.527211] ISO 9660 Extensions: RRIP_1991A
[ 4400.465483] Monitor-Mwait will be used to enter C-3 state
[ 4400.756091] usb 3-1: new low speed USB device using uhci_hcd and address 2
[ 4401.330790] usbcore: registered new interface driver hiddev
[ 4401.345492] input: USB Optical Mouse as
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input8
[ 4401.345694] generic-usb 0003:04B3:310C.0001: input,hidraw0: USB HID v1.11
Mouse [USB Optical Mouse] on usb-0000:00:1a.0-1/input0
[ 4401.345752] usbcore: registered new interface driver usbhid
[ 4401.345757] usbhid: USB HID core driver
[ 4423.028257] thinkpad_acpi: EC reports that Thermal Table has changed
[ 6202.639345] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 6202.639352] IP: [<c012c62a>] __wake_up_common+0x1a/0x70
[ 6202.639359] *pde = 00000000 
[ 6202.639361] Oops: 0000 [#1] SMP 
[ 6202.639364] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill0/state
[ 6202.639368] Modules linked in: usbhid isofs udf crc_itu_t binfmt_misc i915
drm_kms_helper drm i2c_algo_bit ppdev tun bnep ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm lp parport
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi
snd_seq_midi_event iwlagn iwlcore snd_seq yenta_socket thinkpad_acpi mac80211
rsrc_nonstatic psmouse video intel_agp tpm_tis pcspkr snd_timer snd_seq_device
led_class pcmcia_core serio_raw iTCO_wdt iTCO_vendor_support output agpgart tpm
tpm_bios nvram cfg80211 snd soundcore snd_page_alloc ohci1394 ieee1394 e1000e
[ 6202.639422] 
[ 6202.639425] Pid: 7080, comm: updatedb.mlocat Not tainted 2.6.34-rc2 #3
7440A82/7440A82
[ 6202.639428] EIP: 0060:[<c012c62a>] EFLAGS: 00010082 CPU: 1
[ 6202.639431] EIP is at __wake_up_common+0x1a/0x70
[ 6202.639433] EAX: c3e89fb0 EBX: fffffff4 ECX: 00000001 EDX: 00000000
[ 6202.639435] ESI: 00000001 EDI: 00000296 EBP: f429dc24 ESP: f429dc08
[ 6202.639437]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 6202.639440] Process updatedb.mlocat (pid: 7080, ti=f429c000 task=f4183200
task.ti=f429c000)
[ 6202.639442] Stack:
[ 6202.639443]  f429dc3c 00000001 00000003 00000296 c3e89fac 00000001 00000296
f429dc44
[ 6202.639449] <0> c012ff07 00000000 f429dc50 00000003 c3e89fac f43ad1c0
00000000 f429dc5c
[ 6202.639455] <0> c015a59e f429dc50 c3e9c9c0 00000000 c078ccc0 f429dc68
c01b0db1 c3e9c9c0
[ 6202.639461] Call Trace:
[ 6202.639465]  [<c012ff07>] ? __wake_up+0x37/0x50
[ 6202.639469]  [<c015a59e>] ? __wake_up_bit+0x2e/0x40
[ 6202.639472]  [<c01b0db1>] ? unlock_page+0x41/0x50
[ 6202.639476]  [<c020718c>] ? __getblk+0x29c/0x340
[ 6202.639479]  [<c020b6e0>] ? bio_alloc_bioset+0x40/0xc0
[ 6202.639483]  [<c0207cd7>] ? ll_rw_block+0x127/0x130
[ 6202.639486]  [<c0207cf2>] ? __breadahead+0x12/0x40
[ 6202.639489]  [<c0260f53>] ? __ext4_get_inode_loc+0x323/0x440
[ 6202.639493]  [<c029ac7d>] ? jbd2_journal_stop+0x13d/0x2c0
[ 6202.639496]  [<c02610c9>] ? ext4_iget+0x59/0x740
[ 6202.639499]  [<c01b013b>] ? iov_iter_copy_from_user_atomic+0x5b/0x90
[ 6202.639503]  [<c02132ad>] ? inotify_d_instantiate+0x1d/0x50
[ 6202.639506]  [<c026b5c1>] ? ext4_lookup+0x81/0x100
[ 6202.639510]  [<c01f6b3e>] ? d_alloc+0xee/0x170
[ 6202.639514]  [<c01ee757>] ? do_lookup+0xa7/0x200
[ 6202.639518]  [<c01ef36b>] ? link_path_walk+0x1db/0xa70
[ 6202.639521]  [<c01efd14>] ? path_walk+0x54/0xc0
[ 6202.639524]  [<c01efdd1>] ? do_path_lookup+0x51/0x90
[ 6202.639528]  [<c01f08aa>] ? user_path_at+0x4a/0x80
[ 6202.639531]  [<c01e8518>] ? cp_new_stat64+0xe8/0x100
[ 6202.639534]  [<c01e8985>] ? vfs_fstatat+0x35/0x70
[ 6202.639537]  [<c01e8a1b>] ? vfs_lstat+0x1b/0x20
[ 6202.639540]  [<c01e8a34>] ? sys_lstat64+0x14/0x30
[ 6202.639543]  [<c0102ddc>] ? sysenter_do_call+0x12/0x28
[ 6202.639545] Code: 5d c3 8d b4 26 00 00 00 00 31 c0 5b 5e 5d c3 66 90 55 89
e5 57 56 53 83 ec 10 89 55 ec 89 4d e8 8b 50 04 83 c0 04 8d 5a f4 39 d0 <8b> 4b
0c 89 45 f0 74 3b 8d 71 f4 eb 06 90 89 f3 8d 72 f4 8b 45 
[ 6202.639577] EIP: [<c012c62a>] __wake_up_common+0x1a/0x70 SS:ESP
0068:f429dc08
[ 6202.639581] CR2: 0000000000000000
[ 6202.639584] ---[ end trace ce0e4871a41dd0eb ]---
[ 6202.752630] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 6202.752639] IP: [<c012c62a>] __wake_up_common+0x1a/0x70
[ 6202.752653] *pde = 00000000 
[ 6202.752656] Oops: 0000 [#2] SMP 
[ 6202.752659] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill0/state
[ 6202.752662] Modules linked in: usbhid isofs udf crc_itu_t binfmt_misc i915
drm_kms_helper drm i2c_algo_bit ppdev tun bnep ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm lp parport
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi
snd_seq_midi_event iwlagn iwlcore snd_seq yenta_socket thinkpad_acpi mac80211
rsrc_nonstatic psmouse video intel_agp tpm_tis pcspkr snd_timer snd_seq_device
led_class pcmcia_core serio_raw iTCO_wdt iTCO_vendor_support output agpgart tpm
tpm_bios nvram cfg80211 snd soundcore snd_page_alloc ohci1394 ieee1394 e1000e
[ 6202.752717] 
[ 6202.752720] Pid: 7094, comm: popularity-cont Tainted: G      D    2.6.34-rc2
#3 7440A82/7440A82
[ 6202.752723] EIP: 0060:[<c012c62a>] EFLAGS: 00010082 CPU: 1
[ 6202.752726] EIP is at __wake_up_common+0x1a/0x70
[ 6202.752728] EAX: c3e89f8c EBX: fffffff4 ECX: 00000001 EDX: 00000000
[ 6202.752730] ESI: 00000001 EDI: 00000296 EBP: c0c17c20 ESP: c0c17c04
[ 6202.752732]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 6202.752735] Process popularity-cont (pid: 7094, ti=c0c16000 task=c17a5780
task.ti=c0c16000)
[ 6202.752737] Stack:
[ 6202.752738]  c0c17c38 00000001 00000003 00000296 c3e89f88 00000001 00000296
c0c17c40
[ 6202.752744] <0> c012ff07 00000000 c0c17c4c 00000003 c3e89f88 f43ad2a0
00000000 c0c17c58
[ 6202.752749] <0> c015a59e c0c17c4c c3e9c9e0 00000000 c078ccc0 c0c17c64
c01b0db1 c3e9c9e0
[ 6202.752756] Call Trace:
[ 6202.752760]  [<c012ff07>] ? __wake_up+0x37/0x50
[ 6202.752763]  [<c015a59e>] ? __wake_up_bit+0x2e/0x40
[ 6202.752767]  [<c01b0db1>] ? unlock_page+0x41/0x50
[ 6202.752771]  [<c020718c>] ? __getblk+0x29c/0x340
[ 6202.752775]  [<c0264b80>] ? ext4_getblk+0xe0/0x1b0
[ 6202.752778]  [<c0260d19>] ? __ext4_get_inode_loc+0xe9/0x440
[ 6202.752781]  [<c026b30b>] ? ext4_find_entry+0x51b/0x750
[ 6202.752785]  [<c07972c8>] ? kernel_init+0x57/0x1db
[ 6202.752788]  [<c0797088>] ? i386_start_kernel+0x88/0xc6
[ 6202.752791]  [<c0797088>] ? i386_start_kernel+0x88/0xc6
[ 6202.752794]  [<c0797090>] ? i386_start_kernel+0x90/0xc6
[ 6202.752798]  [<c02132ad>] ? inotify_d_instantiate+0x1d/0x50
[ 6202.752801]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752804]  [<c0797008>] ? i386_start_kernel+0x8/0xc6
[ 6202.752807]  [<c01f568a>] ? d_rehash+0x2a/0x40
[ 6202.752810]  [<c01f6548>] ? d_splice_alias+0xb8/0xc0
[ 6202.752813]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752816]  [<c026b5cf>] ? ext4_lookup+0x8f/0x100
[ 6202.752819]  [<c079705c>] ? i386_start_kernel+0x5c/0xc6
[ 6202.752822]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752825]  [<c07972a8>] ? kernel_init+0x37/0x1db
[ 6202.752827]  [<c026b57d>] ? ext4_lookup+0x3d/0x100
[ 6202.752830]  [<c0797304>] ? kernel_init+0x93/0x1db
[ 6202.752833]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752836]  [<c01f6b3e>] ? d_alloc+0xee/0x170
[ 6202.752839]  [<c07972a8>] ? kernel_init+0x37/0x1db
[ 6202.752842]  [<c01ee757>] ? do_lookup+0xa7/0x200
[ 6202.752845]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752848]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752851]  [<c01eedcc>] ? do_last+0x31c/0x620
[ 6202.752854]  [<c01e5d96>] ? get_empty_filp+0x76/0x1a0
[ 6202.752857]  [<c01f0cac>] ? do_filp_open+0x1bc/0x550
[ 6202.752861]  [<c01e8518>] ? cp_new_stat64+0xe8/0x100
[ 6202.752863]  [<c0797000>] ? i386_start_kernel+0x0/0xc6
[ 6202.752867]  [<c01ed9d5>] ? getname+0x25/0x100
[ 6202.752871]  [<c01e2ae5>] ? do_sys_open+0x65/0x130
[ 6202.752874]  [<c01e2c19>] ? sys_open+0x29/0x40
[ 6202.752877]  [<c0102ddc>] ? sysenter_do_call+0x12/0x28
[ 6202.752879] Code: 5d c3 8d b4 26 00 00 00 00 31 c0 5b 5e 5d c3 66 90 55 89
e5 57 56 53 83 ec 10 89 55 ec 89 4d e8 8b 50 04 83 c0 04 8d 5a f4 39 d0 <8b> 4b
0c 89 45 f0 74 3b 8d 71 f4 eb 06 90 89 f3 8d 72 f4 8b 45 
[ 6202.752911] EIP: [<c012c62a>] __wake_up_common+0x1a/0x70 SS:ESP
0068:c0c17c04
[ 6202.752916] CR2: 0000000000000000
[ 6202.752918] ---[ end trace ce0e4871a41dd0ec ]---
[ 6202.765463] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 6202.765469] IP: [<c012c62a>] __wake_up_common+0x1a/0x70
[ 6202.765477] *pde = 00000000 
[ 6202.765479] Oops: 0000 [#3] SMP 
[ 6202.765482] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill0/state
[ 6202.765486] Modules linked in: usbhid isofs udf crc_itu_t binfmt_misc i915
drm_kms_helper drm i2c_algo_bit ppdev tun bnep ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm lp parport
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi
snd_seq_midi_event iwlagn iwlcore snd_seq yenta_socket thinkpad_acpi mac80211
rsrc_nonstatic psmouse video intel_agp tpm_tis pcspkr snd_timer snd_seq_device
led_class pcmcia_core serio_raw iTCO_wdt iTCO_vendor_support output agpgart tpm
tpm_bios nvram cfg80211 snd soundcore snd_page_alloc ohci1394 ieee1394 e1000e
[ 6202.765540] 
[ 6202.765544] Pid: 7098, comm: cmp Tainted: G      D    2.6.34-rc2 #3
7440A82/7440A82
[ 6202.765546] EIP: 0060:[<c012c62a>] EFLAGS: 00010086 CPU: 1
[ 6202.765549] EIP is at __wake_up_common+0x1a/0x70
[ 6202.765551] EAX: c3e89fd4 EBX: fffffff4 ECX: 00000001 EDX: 00000000
[ 6202.765553] ESI: 00000001 EDI: 00000296 EBP: c0c13c20 ESP: c0c13c04
[ 6202.765556]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 6202.765558] Process cmp (pid: 7098, ti=c0c12000 task=c1616400
task.ti=c0c12000)
[ 6202.765560] Stack:
[ 6202.765562]  c0c13c38 00000001 00000003 00000296 c3e89fd0 00000001 00000296
c0c13c40
[ 6202.765567] <0> c012ff07 00000000 c0c13c4c 00000003 c3e89fd0 f43ad2d8
00000000 c0c13c58
[ 6202.765573] <0> c015a59e c0c13c4c c3e8c380 00000000 c078ccc0 c0c13c64
c01b0db1 c3e8c380
[ 6202.765579] Call Trace:
[ 6202.765583]  [<c012ff07>] ? __wake_up+0x37/0x50
[ 6202.765587]  [<c015a59e>] ? __wake_up_bit+0x2e/0x40
[ 6202.765590]  [<c01b0db1>] ? unlock_page+0x41/0x50
[ 6202.765594]  [<c020718c>] ? __getblk+0x29c/0x340
[ 6202.765599]  [<c0317713>] ? __sg_alloc_table+0x73/0x110
[ 6202.765603]  [<c0264b80>] ? ext4_getblk+0xe0/0x1b0
[ 6202.765606]  [<c03135dc>] ? __const_udelay+0x2c/0x30
[ 6202.765610]  [<c03e022b>] ? ata_sff_exec_command+0x1b/0x20
[ 6202.765613]  [<c03e02b9>] ? ata_bmdma_setup+0x59/0x70
[ 6202.765616]  [<c03e012c>] ? ata_bmdma_start+0x1c/0x20
[ 6202.765619]  [<c026b30b>] ? ext4_find_entry+0x51b/0x750
[ 6202.765622]  [<c03d9e76>] ? ata_scsi_queuecmd+0xa6/0x290
[ 6202.765626]  [<c03d74a0>] ? ata_scsi_rw_xlat+0x0/0x270
[ 6202.765630]  [<c03b39e0>] ? scsi_done+0x0/0x10
[ 6202.765634]  [<c01df9e4>] ? __slab_alloc+0x304/0x500
[ 6202.765638]  [<c02fcb2e>] ? blk_peek_request+0x10e/0x190
[ 6202.765641]  [<c01f6a6d>] ? d_alloc+0x1d/0x170
[ 6202.765644]  [<c026b57d>] ? ext4_lookup+0x3d/0x100
[ 6202.765649]  [<c0797908>] ? start_kernel+0x288/0x37d
[ 6202.765651]  [<c01f6b3e>] ? d_alloc+0xee/0x170
[ 6202.765655]  [<c01ee757>] ? do_lookup+0xa7/0x200
[ 6202.765658]  [<c0797908>] ? start_kernel+0x288/0x37d
[ 6202.765661]  [<c0797908>] ? start_kernel+0x288/0x37d
[ 6202.765664]  [<c01eedcc>] ? do_last+0x31c/0x620
[ 6202.765667]  [<c01e5d96>] ? get_empty_filp+0x76/0x1a0
[ 6202.765670]  [<c01f0cac>] ? do_filp_open+0x1bc/0x550
[ 6202.765673]  [<c01c9960>] ? __do_fault+0x3f0/0x4d0
[ 6202.765676]  [<c0797908>] ? start_kernel+0x288/0x37d
[ 6202.765685]  [<c01ed9d5>] ? getname+0x25/0x100
[ 6202.765689]  [<c01e2ae5>] ? do_sys_open+0x65/0x130
[ 6202.765693]  [<c057eb37>] ? do_page_fault+0x1d7/0x3a0
[ 6202.765696]  [<c01e2c19>] ? sys_open+0x29/0x40
[ 6202.765699]  [<c0102ddc>] ? sysenter_do_call+0x12/0x28
[ 6202.765701] Code: 5d c3 8d b4 26 00 00 00 00 31 c0 5b 5e 5d c3 66 90 55 89
e5 57 56 53 83 ec 10 89 55 ec 89 4d e8 8b 50 04 83 c0 04 8d 5a f4 39 d0 <8b> 4b
0c 89 45 f0 74 3b 8d 71 f4 eb 06 90 89 f3 8d 72 f4 8b 45 
[ 6202.765733] EIP: [<c012c62a>] __wake_up_common+0x1a/0x70 SS:ESP
0068:c0c13c04
[ 6202.765738] CR2: 0000000000000000
[ 6202.765740] ---[ end trace ce0e4871a41dd0ed ]---
[ 6205.988712] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 6205.988719] IP: [<c012c62a>] __wake_up_common+0x1a/0x70
[ 6205.988727] *pde = 00000000 
[ 6205.988729] Oops: 0000 [#4] SMP 
[ 6205.988732] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill0/state
[ 6205.988736] Modules linked in: usbhid isofs udf crc_itu_t binfmt_misc i915
drm_kms_helper drm i2c_algo_bit ppdev tun bnep ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptable_filter ip_tables x_tables bridge stp kvm_intel kvm lp parport
snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm arc4 snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi
snd_seq_midi_event iwlagn iwlcore snd_seq yenta_socket thinkpad_acpi mac80211
rsrc_nonstatic psmouse video intel_agp tpm_tis pcspkr snd_timer snd_seq_device
led_class pcmcia_core serio_raw iTCO_wdt iTCO_vendor_support output agpgart tpm
tpm_bios nvram cfg80211 snd soundcore snd_page_alloc ohci1394 ieee1394 e1000e
[ 6205.988788] 
[ 6205.988792] Pid: 916, comm: jbd2/sda2-8 Tainted: G      D    2.6.34-rc2 #3
7440A82/7440A82
[ 6205.988794] EIP: 0060:[<c012c62a>] EFLAGS: 00010082 CPU: 1
[ 6205.988797] EIP is at __wake_up_common+0x1a/0x70
[ 6205.988799] EAX: c3e89fa4 EBX: fffffff4 ECX: 00000001 EDX: 00000000
[ 6205.988801] ESI: 00000001 EDI: 00000292 EBP: c3ae9dd4 ESP: c3ae9db8
[ 6205.988804]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 6205.988806] Process jbd2/sda2-8 (pid: 916, ti=c3ae8000 task=c3a73e80
task.ti=c3ae8000)
[ 6205.988808] Stack:
[ 6205.988809]  c3ae9dec 00000001 00000003 00000292 c3e89fa0 00000001 00000292
c3ae9df4
[ 6205.988815] <0> c012ff07 00000000 c3ae9e00 00000003 c3e89fa0 f43ad3f0
00000000 c3ae9e0c
[ 6205.988821] <0> c015a59e c3ae9e00 c3e8c3a0 00000000 c078ccc0 c3ae9e18
c01b0db1 c3e8c3a0
[ 6205.988827] Call Trace:
[ 6205.988831]  [<c012ff07>] ? __wake_up+0x37/0x50
[ 6205.988834]  [<c015a59e>] ? __wake_up_bit+0x2e/0x40
[ 6205.988838]  [<c01b0db1>] ? unlock_page+0x41/0x50
[ 6205.988842]  [<c020718c>] ? __getblk+0x29c/0x340
[ 6205.988845]  [<c0262ee0>] ? ext4_bmap+0x0/0xc0
[ 6205.988849]  [<c02a3034>] ? jbd2_journal_next_log_block+0x54/0x60
[ 6205.988852]  [<c02a3082>] ? jbd2_journal_get_descriptor_buffer+0x42/0x90
[ 6205.988857]  [<c029cba9>] ? jbd2_journal_commit_transaction+0xc39/0x1440
[ 6205.988861]  [<c01351e4>] ? finish_task_switch+0x34/0xb0
[ 6205.988864]  [<c02a260b>] ? kjournald2+0x8b/0x1a0
[ 6205.988867]  [<c015a630>] ? autoremove_wake_function+0x0/0x50
[ 6205.988870]  [<c02a2580>] ? kjournald2+0x0/0x1a0
[ 6205.988879]  [<c015a214>] ? kthread+0x74/0x80
[ 6205.988882]  [<c015a1a0>] ? kthread+0x0/0x80
[ 6205.988885]  [<c01033b6>] ? kernel_thread_helper+0x6/0x10
[ 6205.988886] Code: 5d c3 8d b4 26 00 00 00 00 31 c0 5b 5e 5d c3 66 90 55 89
e5 57 56 53 83 ec 10 89 55 ec 89 4d e8 8b 50 04 83 c0 04 8d 5a f4 39 d0 <8b> 4b
0c 89 45 f0 74 3b 8d 71 f4 eb 06 90 89 f3 8d 72 f4 8b 45 
[ 6205.988916] EIP: [<c012c62a>] __wake_up_common+0x1a/0x70 SS:ESP
0068:c3ae9db8
[ 6205.988920] CR2: 0000000000000000
[ 6205.988923] ---[ end trace ce0e4871a41dd0ee ]---
[19571.474057] [drm:i915_do_wait_request] *ERROR* something (likely vbetool)
disabled interrupts, re-enabling
[19692.193180] xfce4-settings-[14577]: segfault at 4 ip b6bbaf6e sp bf8a8760
error 4 in libSM.so.6.0.0[b6bb9000+7000]
[20007.939213] mtrr: no MTRR for d0000000,10000000 found

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
