From: Stefan Assmann <sassmann@kpanic.de>
Subject: RIP [<ffffffff812c3b77>] ext4_release_file+0x37/0xc0 with 4.5-rc6
 when resuming from suspend
Date: Sat, 5 Mar 2016 11:24:46 +0100
Message-ID: <56DAB3EE.5020203@kpanic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sassmann@kpanic.de
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-40-253.xlhost.de ([84.200.40.253]:34381 "EHLO
	app1a.xlhost.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754305AbcCEKaZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 05:30:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Occasionally when trying to resume from suspend to RAM I get the
following GPF.

  Stefan

[  882.344245] PM: resume of devices complete after 83682.775 msecs
[  882.420550] PM: Finishing wakeup.
[  882.420551] Restarting tasks ...=C2=B7
[  882.420664] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has=
 bogus alignment
[  882.421141] done.
[  882.422027] usb 3-9.1.1: USB disconnect, device number 33
[  882.452719] general protection fault: 0000 [#1] SMP=C2=B7
[  882.453244] Modules linked in: btrfs xor raid6_pq ufs hfsplus hfs mi=
nix msdos jfs xfs libcrc32c xt_CHECKSUM tun fuse ipt_MASQUERADE nf_nat_=
masquerade_ipv4 xt_addrtype br_netfilter overlay ip6t_rpfilter ip6t_REJ=
ECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_filter ebtable=
_nat
ebtable_broute bridge ebtables ip6table_raw ip6table_nat nf_conntrack_i=
pv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6tab=
le_filter ip6_tables iptable_raw iptable_nat nf_conntrack_ipv4 nf_defra=
g_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security =
bnep arc4
intel_rapl x86_pkg_temp_thermal iwlmvm snd_hda_codec_realtek coretemp s=
nd_hda_codec_hdmi snd_hda_codec_generic mac80211 vfat fat kvm_intel snd=
_hda_intel iTCO_wdt iTCO_vendor_support kvm snd_hda_codec btusb iwlwifi=
 uvcvideo btrtl
[  882.456611]  snd_hda_core videobuf2_vmalloc videobuf2_memops videobu=
f2_v4l2 btbcm snd_hwdep irqbypass snd_seq videobuf2_core btintel snd_se=
q_device cfg80211 i2c_i801 pcspkr videodev joydev lpc_ich bluetooth thi=
nkpad_acpi snd_pcm media ie31200_edac snd_timer snd mei_me mei edac_cor=
e shpchp
soundcore rfkill tpm_tis tpm nfsd binfmt_misc auth_rpcgss nfs_acl lockd=
 grace dm_crypt 8021q garp stp llc mrp i915 crct10dif_pclmul crc32_pclm=
ul crc32c_intel i2c_algo_bit drm_kms_helper ghash_clmulni_intel sdhci_p=
ci e1000e sdhci mmc_core drm serio_raw ptp pps_core wmi fjes video sunr=
pc
[  882.459687] CPU: 7 PID: 5299 Comm: dhclient Tainted: G        W     =
  4.5.0-0.rc6.git1.1.vanilla.knurd.1.fc23.x86_64 #1
[  882.460305] Hardware name: LENOVO 20EGS0R60P/20EGS0R60P, BIOS GNET73=
WW (2.21 ) 03/12/2015
[  882.460923] task: ffff880420921d80 ti: ffff88046819c000 task.ti: fff=
f88046819c000
[  882.461578] RIP: 0010:[<ffffffff812c3b77>]  [<ffffffff812c3b77>] ext=
4_release_file+0x37/0xc0
[  882.462231] RSP: 0018:ffff88046819fbf8  EFLAGS: 00010246
[  882.462870] RAX: c0c0c0c000000039 RBX: ffff8804698e9000 RCX: 0000000=
000000001
[  882.463511] RDX: ffff8804642035d8 RSI: ffff880464203500 RDI: ffff880=
4698e9000
[  882.464135] RBP: ffff88046819fc10 R08: 0000000000000000 R09: 0000000=
000000000
[  882.464774] R10: ffff8804698e9000 R11: ffff880464203510 R12: 0000000=
000000010
[  882.465384] R13: ffff8804698e9000 R14: ffff880464a076a0 R15: ffff880=
46afee0c0
[  882.466020] FS:  00007f95c134c8c0(0000) GS:ffff88047e3c0000(0000) kn=
lGS:0000000000000000
[  882.466637] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  882.467248] CR2: 000055f5eb54eda0 CR3: 0000000001c0a000 CR4: 0000000=
0001406e0
[  882.467887] Stack:
[  882.468495]  ffff8804698e9000 ffff880464203500 0000000000000010 ffff=
88046819fc58
[  882.469118]  ffffffff8123b34f ffff8804698e9000 ffff880464203510 ffff=
ffff81f28ed0
[  882.469758]  ffff880420922478 ffff880420921d80 ffff880464203c00 ffff=
8804653fe968
[  882.470441] Call Trace:
[  882.471076]  [<ffffffff8123b34f>] __fput+0xdf/0x1f0
[  882.471688]  [<ffffffff8123b49e>] ____fput+0xe/0x10
[  882.472304]  [<ffffffff810c0d03>] task_work_run+0x73/0x90
[  882.472952]  [<ffffffff810a7185>] do_exit+0x2d5/0xb30
[  882.473556]  [<ffffffff810a7a67>] do_group_exit+0x47/0xb0
[  882.474187]  [<ffffffff810b2f51>] get_signal+0x291/0x610
[  882.474803]  [<ffffffff81017287>] do_signal+0x37/0x6b0
[  882.475449]  [<ffffffff811e3fb6>] ? handle_mm_fault+0x866/0x1ae0
[  882.476097]  [<ffffffff81114dda>] ? ktime_get_ts64+0x4a/0xf0
[  882.476732]  [<ffffffff8124daab>] ? poll_select_copy_remaining+0xfb/=
0x140
[  882.477365]  [<ffffffff8100320c>] exit_to_usermode_loop+0x8c/0xd0
[  882.478002]  [<ffffffff81003d41>] syscall_return_slowpath+0xa1/0xb0
[  882.478641]  [<ffffffff817b830c>] int_ret_from_sys_call+0x25/0x8f
[  882.479267] Code: 48 89 fb 48 83 ec 08 48 8b 87 68 ff ff ff 48 c1 e8=
 24 a8 01 75 4e f6 46 44 02 74 0b 8b 83 50 01 00 00 83 f8 01 74 54 48 8=
b 43 28 <48> 8b 80 58 04 00 00 48 8b 40 68 f6 40 5c 20 74 1d 48 8b 83 6=
8=C2=B7
[  882.480630] RIP  [<ffffffff812c3b77>] ext4_release_file+0x37/0xc0
[  882.481277]  RSP <ffff88046819fbf8>
[  882.481937] ---[ end trace 32281f35372d5d05 ]---

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
