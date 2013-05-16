From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 15:36:00 -0500
Message-ID: <51954330.1080106@redhat.com>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab3EPUgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:36:06 -0400
In-Reply-To: <5195402A.20100@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/13 3:23 PM, Toralf F=C3=B6rster wrote:
> On 05/14/2013 11:12 PM, Eric Sandeen wrote:
>> Is your "mount" looking at /etc/mtab ot at /proc/mounts?
> I dunno, it is package sys-apps/util-linux-2.22.2 - maybe the Gentoo =
devs know more (it is a stable 32bit Gentoo).

<dropping fsdevel & LKML from cc:>

That's why I then asked:

>> What does /proc/mounts say, does it contain this device or mountpoin=
t?

so what does your /proc/mounts contain?

> FWIW today I got after another test run (kernel 3.10.-rc1+) :

which seems to probably be a different problem, although since open-but=
-unlinked
inodes, which populate the orphan inode list, would also prevent an umo=
unt,
this might be related.

You hit this in ext4_put_super() during umount:

        /* Debugging code just in case the in-memory inode orphan list
         * isn't empty.  The on-disk one can be non-empty if we've
         * detected an error and taken the fs readonly, but the
         * in-memory list had better be clean by this point. */
        if (!list_empty(&sbi->s_orphan))
                dump_orphan_list(sb, sbi);
        J_ASSERT(list_empty(&sbi->s_orphan));

any chance you've got anything crazy going on like mounting the same lo=
op
file on 2 machines via an nfs export, or anything else out of the ordin=
ary?

If you mount it and do "find -inum 32017 /mount/point" for each of the =
inode
numbers below, do the files in question have anything unique going on?

-Eric

>=20
> 2013-05-16T22:17:20.984+02:00 n22 kernel: EXT4-fs (loop0): sb orphan =
head is 32017
> 2013-05-16T22:17:20.984+02:00 n22 kernel: sb_info orphan list:
> 2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32017 at d9ed5a=
50: mode 103777, nlink 0, next 32003
> 2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32003 at dfde6d=
10: mode 102777, nlink 0, next 32021
> 2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32021 at d9ed61=
58: mode 103777, nlink 0, next 32013
> 2013-05-16T22:17:20.984+02:00 n22 kernel: inode loop0:32013 at d9ed55=
a0: mode 103777, nlink 0, next 0
> 2013-05-16T22:17:20.984+02:00 n22 kernel: ------------[ cut here ]---=
---------
> 2013-05-16T22:17:20.984+02:00 n22 kernel: kernel BUG at fs/ext4/super=
=2Ec:804!
> 2013-05-16T22:17:20.984+02:00 n22 kernel: invalid opcode: 0000 [#1] S=
MP
> 2013-05-16T22:17:20.984+02:00 n22 kernel: Modules linked in: dm_crypt=
 cpufreq_stats loop nfsd auth_rpcgss oid_registry lockd sunrpc ipt_MASQ=
UERADE xt_owner xt_multiport ipt_REJECT xt_tcpudp xt_recent xt_conntrac=
k nf_conntrack_ftp xt_limit xt_LOG iptable_nat nf_conntrack_ipv4 nf_def=
rag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tab=
les af_packet pppoe pppox ppp_generic slhc bridge stp llc tun fuse dm_m=
od coretemp kvm_intel kvm hid_cherry aesni_intel uvcvideo xts aes_i586 =
videobuf2_vmalloc lrw videobuf2_memops gf128mul ablk_helper hid_generic=
 arc4 usbhid videobuf2_core cryptd iwldvm mac80211 usblp videodev hid i=
915 snd_hda_codec_conexant snd_hda_intel iwlwifi cfg80211 cfbfillrect c=
fbimgblt i2c_algo_bit cfbcopyarea intel_agp intel_gtt snd_hda_codec snd=
_pcm fbcon snd_page_alloc bitblit softcursor font drm_kms_helper drm sn=
d_timer psmouse tpm_tis 8250_pci thinkpad_acpi agpgart nvram sr_mod evd=
ev snd tpm wmi 8250 serial_core i2c_i801 i2c_core cdrom sdhci_pci !
 sd!
>  hci mmc_co
> re soundcore acpi_cpufreq thermal mperf battery ac tpm_bios e1000e rf=
kill ptp video fb button fbdev pps_core processor thermal_sys hwmon [la=
st unloaded: microcode]
> 2013-05-16T22:17:20.984+02:00 n22 kernel: CPU: 1 PID: 9391 Comm: umou=
nt Not tainted 3.10.0-rc1+ #1
> 2013-05-16T22:17:20.984+02:00 n22 kernel: Hardware name: LENOVO 4180F=
65/4180F65, BIOS 83ET73WW (1.43 ) 11/30/2012
> 2013-05-16T22:17:20.984+02:00 n22 kernel: task: eab54290 ti: d6cfc000=
 task.ti: d6cfc000
> 2013-05-16T22:17:20.984+02:00 n22 kernel: EIP: 0060:[<c11bcb8c>] EFLA=
GS: 00010283 CPU: 1
> 2013-05-16T22:17:20.984+02:00 n22 kernel: EIP is at ext4_put_super+0x=
2dc/0x2e0
> 2013-05-16T22:17:20.984+02:00 n22 kernel: EAX: 0000003d EBX: e7adbc00=
 ECX: e7adbd50 EDX: e7adbd50
> 2013-05-16T22:17:20.984+02:00 n22 kernel: ESI: e7addc00 EDI: e7adbd14=
 EBP: d6cfdefc ESP: d6cfdecc
> 2013-05-16T22:17:20.984+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 =
GS: 00e0 SS: 0068
> 2013-05-16T22:17:20.984+02:00 n22 kernel: CR0: 80050033 CR2: b76bd0c0=
 CR3: 2f41e000 CR4: 000407f0
> 2013-05-16T22:17:20.984+02:00 n22 kernel: DR0: 00000000 DR1: 00000000=
 DR2: 00000000 DR3: 00000000
> 2013-05-16T22:17:20.984+02:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
> 2013-05-16T22:17:20.984+02:00 n22 kernel: Stack:
> 2013-05-16T22:17:20.984+02:00 n22 kernel: c155c130 e7adddbc 00007d0d =
d9ed55a0 000087ff 00000000 00000000 d9ed5580
> 2013-05-16T22:17:20.984+02:00 n22 kernel: e7adbd50 e7addc00 e7addc58 =
c14957a0 d6cfdf18 c111f441 d6cfdf28 d6cfdf18
> 2013-05-16T22:17:20.984+02:00 n22 kernel: f1fd4200 00000083 e7addc00 =
d6cfdf28 c111f4e9 e7addc00 c15f1e28 d6cfdf38
> 2013-05-16T22:17:20.984+02:00 n22 kernel: Call Trace:
> 2013-05-16T22:17:20.984+02:00 n22 kernel: [<c111f441>] generic_shutdo=
wn_super+0x51/0xd0
> 2013-05-16T22:17:20.984+02:00 n22 kernel: [<c111f4e9>] kill_block_sup=
er+0x29/0x70
> 2013-05-16T22:17:20.984+02:00 n22 kernel: [<c111f734>] deactivate_loc=
ked_super+0x44/0x70
> 2013-05-16T22:17:20.984+02:00 n22 kernel: [<c1120107>] deactivate_sup=
er+0x47/0x60
> 2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1136e8d>] mntput_no_expi=
re+0xcd/0x120
> 2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1137d4e>] SyS_umount+0xa=
e/0x330
> 2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1137fee>] SyS_oldumount+=
0x1e/0x20
> 2013-05-16T22:17:20.985+02:00 n22 kernel: [<c1477601>] sysenter_do_ca=
ll+0x12/0x22
> 2013-05-16T22:17:20.985+02:00 n22 kernel: Code: 24 30 c1 55 c1 05 bc =
01 00 00 89 44 24 04 e8 4d 22 2b 00 8b 4d ec 8b 55 f0 8b 09 39 ca 75 b2=
 39 93 50 01 00 00 0f 84 9a fe ff ff <0f> 0b 66 90 55 89 e5 83 ec 20 66=
 66 66 66 90 8d 45 18 c7 04 24
> 2013-05-16T22:17:20.985+02:00 n22 kernel: EIP: [<c11bcb8c>] ext4_put_=
super+0x2dc/0x2e0 SS:ESP 0068:d6cfdecc
> 2013-05-16T22:17:20.985+02:00 n22 kernel: ---[ end trace 0970735cee52=
720b ]---
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
