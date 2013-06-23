From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: fuzzy'ing a 3.10-rc7 gives warning ext4_da_update_reserve_space
Date: Sun, 23 Jun 2013 13:55:22 +0200
Message-ID: <51C6E22A.5090206@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57918 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3FWLz1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jun 2013 07:55:27 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0M4lZj-1U5Win0uSr-00yzeW for
 <linux-ext4@vger.kernel.org>; Sun, 23 Jun 2013 13:55:24 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I do regular fuzz testing of upcoming kernel versions.
So the following warning doesn't occurred at a productive system, but I=
 never saw it before during tests :


2013-06-23T12:28:02.826+02:00 n22 kernel: EXT4-fs warning (device loop1=
): ext4_da_update_reserve_space:350: ext4_da_update_reserve_space: ino =
32215, used 17 with only 13 reserved data blocks
2013-06-23T12:28:02.826+02:00 n22 kernel: ------------[ cut here ]-----=
-------
2013-06-23T12:28:02.826+02:00 n22 kernel: WARNING: at fs/ext4/inode.c:3=
51 ext4_da_update_reserve_space+0x258/0x270()
2013-06-23T12:28:02.826+02:00 n22 kernel: Modules linked in: loop ip6t_=
REJECT ip6table_filter ip6_tables ipt_MASQUERADE xt_owner xt_LOG xt_lim=
it xt_multiport ipt_REJECT xt_tcpudp xt_recent xt_conntrack iptable_nat=
 nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptab=
le_filter ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bri=
dge stp ipv6 llc tun fuse dm_mod coretemp kvm_intel kvm aesni_intel i91=
5 xts hid_cherry aes_i586 cfbfillrect cfbimgblt hid_generic i2c_algo_bi=
t cfbcopyarea usbhid intel_agp uvcvideo lrw videobuf2_vmalloc videobuf2=
_memops videobuf2_core usblp hid gf128mul ablk_helper cryptd arc4 video=
dev iwldvm mac80211 fbcon intel_gtt bitblit snd_hda_codec_conexant soft=
cursor font drm_kms_helper drm psmouse 8250_pci agpgart 8250 snd_hda_in=
tel snd_hda_codec snd_pcm iwlwifi e1000e tpm_tis sr_mod snd_page_alloc =
cfg80211 snd_timer fb sdhci_pci evdev thinkpad_acpi serial_core ac tpm =
cdrom sdhci nvram snd mmc_core rfkill soundcore i2c_i801 thermal wmi fb=
dev t
pm_bios i2c_core ptp pps_core battery video acpi_cpufreq button mperf p=
rocessor thermal_sys hwmon [last unloaded: microcode]
2013-06-23T12:28:02.826+02:00 n22 kernel: CPU: 2 PID: 5857 Comm: kworke=
r/u16:0 Not tainted 3.10.0-rc7+ #1
2013-06-23T12:28:02.826+02:00 n22 kernel: Hardware name: LENOVO 4180F65=
/4180F65, BIOS 83ET73WW (1.43 ) 11/30/2012
2013-06-23T12:28:02.826+02:00 n22 kernel: Workqueue: writeback bdi_writ=
eback_workfn (flush-7:1)
2013-06-23T12:28:02.826+02:00 n22 kernel: c14a4b9a c14a4b9a e98d3a20 c1=
3d3ced e98d3a48 c1033e84 c1490d45 c14a4b9a
2013-06-23T12:28:02.826+02:00 n22 kernel: 0000015f c119f6b8 c119f6b8 00=
000011 e8e3e3b0 00000025 e98d3a58 c1033ec2
2013-06-23T12:28:02.826+02:00 n22 kernel: 00000009 00000000 e98d3aa4 c1=
19f6b8 ef786400 c13f5d71 0000015e c149d754
2013-06-23T12:28:02.827+02:00 n22 kernel: Call Trace:
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c13d3ced>] dump_stack+0x16/=
0x18
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c1033e84>] warn_slowpath_co=
mmon+0x64/0x80
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c119f6b8>] ? ext4_da_update=
_reserve_space+0x258/0x270
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c119f6b8>] ? ext4_da_update=
_reserve_space+0x258/0x270
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c1033ec2>] warn_slowpath_nu=
ll+0x22/0x30
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c119f6b8>] ext4_da_update_r=
eserve_space+0x258/0x270
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c11c6cf7>] ext4_ext_map_blo=
cks+0xfb7/0x1bc0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c110e8f7>] ? kmem_cache_all=
oc+0x77/0x150
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c10d7e53>] ? mempool_alloc_=
slab+0x13/0x20
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c114b8c8>] ? bvec_alloc+0x5=
8/0xf0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c1219293>] ? generic_make_r=
equest+0xa3/0xd0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c121931d>] ? submit_bio+0x5=
d/0x140
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c11d8560>] ? ext4_es_lru_ad=
d+0x20/0x70
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c119f9e2>] ext4_map_blocks+=
0x312/0x500
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c11a3e41>] mpage_da_map_and=
_submit+0x131/0x5e0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c11c87c4>] ? __ext4_journal=
_start_sb+0x74/0x150
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c11a4a59>] ext4_da_writepag=
es+0x339/0x5d0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c10dd4e0>] ? set_page_dirty=
_lock+0x50/0x50
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c10df1a1>] do_writepages+0x=
21/0x40
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c113f798>] __writeback_sing=
le_inode+0x38/0x240
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c1054ff3>] ? wake_up_bit+0x=
23/0x30
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c114079b>] writeback_sb_ino=
des+0x16b/0x2f0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c114099c>] __writeback_inod=
es_wb+0x7c/0xb0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c1140bfa>] wb_writeback+0x2=
2a/0x2c0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c114209c>] wb_do_writeback+=
0x9c/0x1d0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c1060288>] ? ttwu_do_wakeup=
+0x18/0x130
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c114224a>] bdi_writeback_wo=
rkfn+0x7a/0x1c0
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c10624cf>] ? wake_up_proces=
s+0x1f/0x40
2013-06-23T12:28:02.827+02:00 n22 kernel: [<c104e74e>] process_one_work=
+0x10e/0x390
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c104c945>] ? start_worker+0=
x25/0x30
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c104f518>] ? manage_workers=
=2Eisra.24+0x188/0x290
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c104f722>] worker_thread+0x=
102/0x320
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c104f620>] ? manage_workers=
=2Eisra.24+0x290/0x290
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c1054c94>] kthread+0x94/0xa=
0
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c13d85f7>] ret_from_kernel_=
thread+0x1b/0x28
2013-06-23T12:28:02.828+02:00 n22 kernel: [<c1054c00>] ? flush_kthread_=
worker+0x90/0x90
2013-06-23T12:28:02.828+02:00 n22 kernel: ---[ end trace b176e82a59e909=
b3 ]---


The file system is 257 MB big (created at a file on a tmpfs) and then m=
ounted
onto a directory accessible from a chrooted 32 bit Gentoo Linux.

In the man while that fs was overwritten however.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
