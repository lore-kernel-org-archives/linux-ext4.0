From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Fri, 26 Oct 2012 16:30:12 +0200
Message-ID: <508A9E74.4050309@gmx.de>
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org> <5085923F.9050801@gmx.de> <20121024011128.GG28626@thunk.org> <5088260D.7080403@gmx.de> <20121024183505.GA6142@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49950 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933271Ab2JZOaS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 10:30:18 -0400
In-Reply-To: <20121024183505.GA6142@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/24/2012 08:35 PM, Theodore Ts'o wrote:
> On Wed, Oct 24, 2012 at 07:31:57PM +0200, Toralf F=C3=B6rster wrote:
>>> Are you using any kind of special mount options on your usb stick?
>>>
>> nope
>=20
> Thanks, we're trying to get a reliable repro of this failure, and so
> every bit of data helps...  I've cc'ed you on the other thread, and i=
f
> you could try the second patch I sent out last night (and let me know
> when/if the WARN_ON triggers), I'd really appreciate it.
>=20
> Thanks again,
>=20
>                                           - Ted
>=20
Well, here it is :

2012-10-25T21:05:28.000+02:00 n22 sudo: tfoerste : TTY=3Dpts/2 ; PWD=3D=
/home/tfoerste/virtual/uml ; USER=3Droot ; COMMAND=3D/bin/su -
2012-10-25T21:05:28.000+02:00 n22 sudo: pam_unix(sudo:session): session=
 opened for user root by tfoerste(uid=3D0)
2012-10-25T21:05:28.000+02:00 n22 su[18998]: Successful su for root by =
root
2012-10-25T21:05:28.000+02:00 n22 su[18998]: + /dev/pts/2 root:root
2012-10-25T21:05:28.000+02:00 n22 su[18998]: pam_unix(su:session): sess=
ion opened for user root by tfoerste(uid=3D0)
2012-10-25T21:05:44.880+02:00 n22 kernel: EXT4-fs (loop0): mounted file=
system with ordered data mode. Opts: (null)
2012-10-25T21:07:07.218+02:00 n22 kernel: JBD2: jbd2_mark_journal_empty=
 bug workaround (79, 80)
2012-10-25T21:07:07.218+02:00 n22 kernel: ------------[ cut here ]-----=
-------
2012-10-25T21:07:07.218+02:00 n22 kernel: WARNING: at fs/jbd2/journal.c=
:1364 jbd2_mark_journal_empty+0xef/0x110()
2012-10-25T21:07:07.218+02:00 n22 kernel: Hardware name: 4180F65
2012-10-25T21:07:07.218+02:00 n22 kernel: Modules linked in: bluetooth =
cpufreq_stats loop ipt_MASQUERADE xt_owner xt_multiport ipt_REJECT xt_r=
ecent xt_tcpudp xt_mac nf_conntrack_ftp xt_state xt_limit xt_LOG iptabl=
e_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filt=
er ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bridge stp=
 llc tun msr i915 coretemp cfbfillrect cfbimgblt i2c_algo_bit cfbcopyar=
ea fbcon bitblit snd_hda_codec_conexant softcursor font snd_hda_intel s=
nd_hda_codec kvm_intel snd_pcm intel_agp 8250_pci intel_gtt drm_kms_hel=
per snd_page_alloc snd_timer kvm 8250 drm thinkpad_acpi nvram uvcvideo =
snd serial_core agpgart fb sdhci_pci usblp videobuf2_vmalloc e1000e vid=
eobuf2_memops videobuf2_core videodev i2c_i801 tpm_tis soundcore hwmon =
arc4 sdhci i2c_core tpm fbdev iwldvm acpi_cpufreq mac80211 mperf ac psm=
ouse iwlwifi battery button cfg80211 rfkill evdev mmc_core processor vi=
deo tpm_bios thermal wmi xts gf128mul aesni_intel ablk_helper cryptd ae=
s_i58
6 aes_generic cbc fuse nfs lockd sunrpc dm_crypt dm_mod hid_monterey hi=
d_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry h=
id_belkin hid_apple hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [=
last unloaded: microcode]
2012-10-25T21:07:07.218+02:00 n22 kernel: Pid: 19040, comm: umount Not =
tainted 3.6.3 #8
2012-10-25T21:07:07.218+02:00 n22 kernel: Call Trace:
2012-10-25T21:07:07.218+02:00 n22 kernel: [<c10323e2>] warn_slowpath_co=
mmon+0x72/0xa0
2012-10-25T21:07:07.218+02:00 n22 kernel: [<c11e253f>] ? jbd2_mark_jour=
nal_empty+0xef/0x110
2012-10-25T21:07:07.218+02:00 n22 kernel: [<c11e253f>] ? jbd2_mark_jour=
nal_empty+0xef/0x110
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1032432>] warn_slowpath_nu=
ll+0x22/0x30
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11e253f>] jbd2_mark_journa=
l_empty+0xef/0x110
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11e272e>] jbd2_journal_des=
troy+0x1ce/0x1f0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c10529c0>] ? add_wait_queue=
+0x50/0x50
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11b079a>] ext4_put_super+0=
x4a/0x2e0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1127652>] ? dispose_list+0=
x32/0x40
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1127c0f>] ? evict_inodes+0=
x8f/0xe0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1112521>] generic_shutdown=
_super+0x51/0xd0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c10e5b45>] ? pcpu_free_area=
+0x145/0x190
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11125c9>] kill_block_super=
+0x29/0x70
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c1112800>] deactivate_locke=
d_super+0x30/0x90
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c1113247>] deactivate_super=
+0x47/0x60
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c112a41d>] mntput_no_expire=
+0xcd/0x120
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c112b1ca>] sys_umount+0x6a/=
0x330
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c112b4ae>] sys_oldumount+0x=
1e/0x20
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c13ad753>] sysenter_do_call=
+0x12/0x22
2012-10-25T21:07:07.224+02:00 n22 kernel: ---[ end trace 8e7416a7368818=
fe ]---
2012-10-25T21:07:07.000+02:00 n22 su[18998]: pam_unix(su:session): sess=
ion closed for user root
2012-10-25T21:07:07.000+02:00 n22 sudo: pam_unix(sudo:session): session=
 closed for user root


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
