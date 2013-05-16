From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 22:23:06 +0200
Message-ID: <5195402A.20100@gmx.de>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62845 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3EPUXO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:23:14 -0400
Received: from mailout-de.gmx.net ([10.1.76.10]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Lbx3C-1UBklI2HYq-00jIGy for
 <linux-ext4@vger.kernel.org>; Thu, 16 May 2013 22:23:12 +0200
In-Reply-To: <5192A8CE.30809@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/14/2013 11:12 PM, Eric Sandeen wrote:
> Is your "mount" looking at /etc/mtab ot at /proc/mounts?
I dunno, it is package sys-apps/util-linux-2.22.2 - maybe the Gentoo de=
vs know more (it is a stable 32bit Gentoo).

=46WIW today I got after another test run (kernel 3.10.-rc1+) :


2013-05-16T22:17:20.984+02:00 n22 kernel: EXT4-fs (loop0): sb orphan he=
ad is 32017
2013-05-16T22:17:20.984+02:00 n22 kernel: sb_info orphan list:
2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32017 at d9ed5a50=
: mode 103777, nlink 0, next 32003
2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32003 at dfde6d10=
: mode 102777, nlink 0, next 32021
2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32021 at d9ed6158=
: mode 103777, nlink 0, next 32013
2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32013 at d9ed55a0=
: mode 103777, nlink 0, next 0
2013-05-16T22:17:20.984+02:00 n22 kernel: ------------[ cut here ]-----=
-------
2013-05-16T22:17:20.984+02:00 n22 kernel: kernel BUG at fs/ext4/super.c=
:804!
2013-05-16T22:17:20.984+02:00 n22 kernel: invalid opcode: 0000 [#1] SMP
2013-05-16T22:17:20.984+02:00 n22 kernel: Modules linked in: dm_crypt c=
pufreq_stats loop nfsd auth_rpcgss oid_registry lockd sunrpc ipt_MASQUE=
RADE xt_owner xt_multiport ipt_REJECT xt_tcpudp xt_recent xt_conntrack =
nf_conntrack_ftp xt_limit xt_LOG iptable_nat nf_conntrack_ipv4 nf_defra=
g_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_table=
s af_packet pppoe pppox ppp_generic slhc bridge stp llc tun fuse dm_mod=
 coretemp kvm_intel kvm hid_cherry aesni_intel uvcvideo xts aes_i586 vi=
deobuf2_vmalloc lrw videobuf2_memops gf128mul ablk_helper hid_generic a=
rc4 usbhid videobuf2_core cryptd iwldvm mac80211 usblp videodev hid i91=
5 snd_hda_codec_conexant snd_hda_intel iwlwifi cfg80211 cfbfillrect cfb=
imgblt i2c_algo_bit cfbcopyarea intel_agp intel_gtt snd_hda_codec snd_p=
cm fbcon snd_page_alloc bitblit softcursor font drm_kms_helper drm snd_=
timer psmouse tpm_tis 8250_pci thinkpad_acpi agpgart nvram sr_mod evdev=
 snd tpm wmi 8250 serial_core i2c_i801 i2c_core cdrom sdhci_pci sdhci m=
mc_co
re soundcore acpi_cpufreq thermal mperf battery ac tpm_bios e1000e rfki=
ll ptp video fb button fbdev pps_core processor thermal_sys hwmon [last=
 unloaded: microcode]
2013-05-16T22:17:20.984+02:00 n22 kernel: CPU: 1 PID: 9391 Comm: umount=
 Not tainted 3.10.0-rc1+ #1
2013-05-16T22:17:20.984+02:00 n22 kernel: Hardware name: LENOVO 4180F65=
/4180F65, BIOS 83ET73WW (1.43 ) 11/30/2012
2013-05-16T22:17:20.984+02:00 n22 kernel: task: eab54290 ti: d6cfc000 t=
ask.ti: d6cfc000
2013-05-16T22:17:20.984+02:00 n22 kernel: EIP: 0060:[<c11bcb8c>] EFLAGS=
: 00010283 CPU: 1
2013-05-16T22:17:20.984+02:00 n22 kernel: EIP is at ext4_put_super+0x2d=
c/0x2e0
2013-05-16T22:17:20.984+02:00 n22 kernel: EAX: 0000003d EBX: e7adbc00 E=
CX: e7adbd50 EDX: e7adbd50
2013-05-16T22:17:20.984+02:00 n22 kernel: ESI: e7addc00 EDI: e7adbd14 E=
BP: d6cfdefc ESP: d6cfdecc
2013-05-16T22:17:20.984+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 GS=
: 00e0 SS: 0068
2013-05-16T22:17:20.984+02:00 n22 kernel: CR0: 80050033 CR2: b76bd0c0 C=
R3: 2f41e000 CR4: 000407f0
2013-05-16T22:17:20.984+02:00 n22 kernel: DR0: 00000000 DR1: 00000000 D=
R2: 00000000 DR3: 00000000
2013-05-16T22:17:20.984+02:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
2013-05-16T22:17:20.984+02:00 n22 kernel: Stack:
2013-05-16T22:17:20.984+02:00 n22 kernel: c155c130 e7adddbc 00007d0d d9=
ed55a0 000087ff 00000000 00000000 d9ed5580
2013-05-16T22:17:20.984+02:00 n22 kernel: e7adbd50 e7addc00 e7addc58 c1=
4957a0 d6cfdf18 c111f441 d6cfdf28 d6cfdf18
2013-05-16T22:17:20.984+02:00 n22 kernel: f1fd4200 00000083 e7addc00 d6=
cfdf28 c111f4e9 e7addc00 c15f1e28 d6cfdf38
2013-05-16T22:17:20.984+02:00 n22 kernel: Call Trace:
2013-05-16T22:17:20.984+02:00 n22 kernel: [<c111f441>] generic_shutdown=
_super+0x51/0xd0
2013-05-16T22:17:20.984+02:00 n22 kernel: [<c111f4e9>] kill_block_super=
+0x29/0x70
2013-05-16T22:17:20.984+02:00 n22 kernel: [<c111f734>] deactivate_locke=
d_super+0x44/0x70
2013-05-16T22:17:20.984+02:00 n22 kernel: [<c1120107>] deactivate_super=
+0x47/0x60
2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1136e8d>] mntput_no_expire=
+0xcd/0x120
2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1137d4e>] SyS_umount+0xae/=
0x330
2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1137fee>] SyS_oldumount+0x=
1e/0x20
2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1477601>] sysenter_do_call=
+0x12/0x22
2013-05-16T22:17:20.985+02:00 n22 kernel: Code: 24 30 c1 55 c1 05 bc 01=
 00 00 89 44 24 04 e8 4d 22 2b 00 8b 4d ec 8b 55 f0 8b 09 39 ca 75 b2 3=
9 93 50 01 00 00 0f 84 9a fe ff ff <0f> 0b 66 90 55 89 e5 83 ec 20 66 6=
6 66 66 90 8d 45 18 c7 04 24
2013-05-16T22:17:20.985+02:00 n22 kernel: EIP: [<c11bcb8c>] ext4_put_su=
per+0x2dc/0x2e0 SS:ESP 0068:d6cfdecc
2013-05-16T22:17:20.985+02:00 n22 kernel: ---[ end trace 0970735cee5272=
0b ]---

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
