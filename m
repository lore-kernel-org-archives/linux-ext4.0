From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: BUG at fs/ext4/inode.c:1590!
Date: Sun, 19 May 2013 19:55:04 -0400
Message-ID: <20130519235504.GA8404@thunk.org>
References: <5199514D.5090606@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49754 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab3ESXzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 May 2013 19:55:09 -0400
Content-Disposition: inline
In-Reply-To: <5199514D.5090606@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So this BUG happened with a corrupted file system using a fuzzing
process?  What is trinity?  Is that the fuzzing process or the
workload?

Can you replicate it?   Do you have the corrupted file system?

Thanks,

					- Ted

On Mon, May 20, 2013 at 12:25:17AM +0200, Toralf F=F6rster wrote:
> The following BUG happened today at a stable Gentoo Linux 32bit syste=
m with stable kernel 3.9.3:
>=20
> 2013-05-19T23:28:34.195+02:00 n22 kernel: ------------[ cut here ]---=
---------
> 2013-05-19T23:28:34.195+02:00 n22 kernel: kernel BUG at fs/ext4/inode=
=2Ec:1590!
> 2013-05-19T23:28:34.195+02:00 n22 kernel: invalid opcode: 0000 [#1] S=
MP=20
> 2013-05-19T23:28:34.195+02:00 n22 kernel: Modules linked in: loop rc_=
dib0700_rc5 dvb_usb_dib0700 dib3000mc dib8000 dvb_usb dib0070 dib7000m =
dib7000p dvb_core dibx000_common dib0090 rc_core nfsd auth_rpcgss ipt_M=
ASQUERADE xt_owner xt_multiport ipt_REJECT xt_tcpudp xt_recent xt_connt=
rack xt_limit xt_LOG iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_na=
t_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables af_packet =
pppoe pppox ppp_generic slhc bridge stp llc tun coretemp kvm_intel kvm =
fbcon bitblit usblp softcursor font psmouse acpi_cpufreq i915 uvcvideo =
sdhci_pci cfbfillrect sdhci videobuf2_vmalloc cfbimgblt videobuf2_memop=
s i2c_algo_bit mmc_core videobuf2_core cfbcopyarea intel_agp videodev i=
ntel_gtt drm_kms_helper drm mperf arc4 iwldvm agpgart evdev processor v=
ideo mac80211 iwlwifi cfg80211 thermal thermal_sys ac thinkpad_acpi bat=
tery nvram wmi e1000e rfkill fb snd_hda_codec_conexant snd_hda_intel sn=
d_hda_codec snd_pcm snd_page_alloc snd_timer i2c_i801 tpm_tis tpm i2!
>  c_core but
> ton tpm_bios 8250_pci hwmon 8250 snd ptp pps_core serial_core soundco=
re fbdev aesni_intel ablk_helper cryptd lrw aes_i586 xts gf128mul cbc f=
use nfs lockd sunrpc dm_crypt dm_mod hid_monterey hid_microsoft hid_log=
itech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple=
 hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [last unloaded: micr=
ocode]
> 2013-05-19T23:28:34.195+02:00 n22 kernel: Pid: 6292, comm: flush-7:1 =
Not tainted 3.9.3 #12 LENOVO 4180F65/4180F65
> 2013-05-19T23:28:34.195+02:00 n22 kernel: EIP: 0060:[<c11a71e9>] EFLA=
GS: 00010202 CPU: 2
> 2013-05-19T23:28:34.195+02:00 n22 kernel: EIP is at mpage_da_submit_i=
o+0x339/0x360
> 2013-05-19T23:28:34.195+02:00 n22 kernel: EAX: 00000002 EBX: f2293d20=
 ECX: e4663700 EDX: 00000000
> 2013-05-19T23:28:34.195+02:00 n22 kernel: ESI: 00000000 EDI: e4663700=
 EBP: f2293ca4 ESP: f2293bf4
> 2013-05-19T23:28:34.195+02:00 n22 kernel: DS: 007b ES: 007b FS: 00d8 =
GS: 00e0 SS: 0068
> 2013-05-19T23:28:34.197+02:00 n22 kernel: CR0: 80050033 CR2: b74ca060=
 CR3: 1bfd2000 CR4: 000407f0
> 2013-05-19T23:28:34.197+02:00 n22 kernel: DR0: 00000000 DR1: 00000000=
 DR2: 00000000 DR3: 00000000
> 2013-05-19T23:28:34.197+02:00 n22 kernel: DR6: ffff0ff0 DR7: 00000400
> 2013-05-19T23:28:34.197+02:00 n22 kernel: Process flush-7:1 (pid: 629=
2, ti=3Df2292000 task=3Df14e0000 task.ti=3Df2292000)
> 2013-05-19T23:28:34.197+02:00 n22 kernel: Stack:
> 2013-05-19T23:28:34.197+02:00 n22 kernel: 0000000e e85f039c 00000003 =
e85f02d8 0000003e 80000001 0000003e f2293dac
> 2013-05-19T23:28:34.197+02:00 n22 kernel: 80000001 00000004 00000000 =
00001000 00000000 80000001 f5a1cc00 0000f001
> 2013-05-19T23:28:34.197+02:00 n22 kernel: 00000000 00000000 00000000 =
00000004 00000000 f5a1cc00 f4796fe0 f612bf60
> 2013-05-19T23:28:34.197+02:00 n22 kernel: Call Trace:
> 2013-05-19T23:28:34.197+02:00 n22 kernel: [<c11abbba>] ? ext4_mark_in=
ode_dirty+0x6a/0x1c0
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c11acfba>] mpage_da_map_a=
nd_submit+0xfa/0x5c0
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c11d875b>] ? __ext4_journ=
al_start_sb+0x6b/0x140
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c11adbe9>] ext4_da_writep=
ages+0x339/0x5d0
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c10df3e1>] do_writepages+=
0x21/0x40
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c1141108>] __writeback_si=
ngle_inode+0x38/0x240
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c10551d3>] ? wake_up_bit+=
0x23/0x30
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c114359b>] writeback_sb_i=
nodes+0x16b/0x2f0
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c114389b>] wb_writeback+0=
xcb/0x2c0
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c10438bb>] ? lock_timer_b=
ase.isra.38+0x2b/0x50
> 2013-05-19T23:28:34.199+02:00 n22 kernel: [<c10442e9>] ? del_timer_sy=
nc+0x49/0x60
> 2013-05-19T23:28:34.200+02:00 n22 kernel: [<c1144eec>] wb_do_writebac=
k+0x9c/0x1d0
> 2013-05-19T23:28:34.200+02:00 n22 kernel: [<c1145095>] bdi_writeback_=
thread+0x75/0x230
> 2013-05-19T23:28:34.200+02:00 n22 kernel: [<c1145020>] ? wb_do_writeb=
ack+0x1d0/0x1d0
> 2013-05-19T23:28:34.200+02:00 n22 kernel: [<c1054d64>] kthread+0x94/0=
xa0
> 2013-05-19T23:28:34.200+02:00 n22 kernel: [<c1488177>] ret_from_kerne=
l_thread+0x1b/0x28
> 2013-05-19T23:28:34.200+02:00 n22 kernel: [<c1054cd0>] ? flush_kthrea=
d_work+0xd0/0xd0
> 2013-05-19T23:28:34.200+02:00 n22 kernel: Code: ff ff 85 d2 0f 45 85 =
78 ff ff ff 89 85 78 ff ff ff e9 59 ff ff ff 8d 74 26 00 8b b5 58 ff ff=
 ff 89 b5 7c ff ff ff e9 16 fe ff ff <0f> 0b 0f 0b 0f 0b 0f 0b c7 85 78=
 ff ff ff 00 00 00 00 e9 76 ff
> 2013-05-19T23:28:34.200+02:00 n22 kernel: EIP: [<c11a71e9>] mpage_da_=
submit_io+0x339/0x360 SS:ESP 0068:f2293bf4
> 2013-05-19T23:28:34.200+02:00 n22 kernel: ---[ end trace 6b3eadfbb825=
e4d2 ]---
>=20
>=20
>=20
> The trinity log files hangs here since about a hour:
> ...
> [4673] [415] rt_sigsuspend(unewset=3D0xc0100220, sigsetsize=3D0x5ffde=
f7a) =3D -1 (Invalid argument)
> [4673] [416] munlock(addr=3D0x85c6800, len=3D4096) =3D 0
> [4673] [417] splice(fd_in=3D8, off_in=3D0, fd_out=3D12, off_out=3D0x8=
5c3000[page_0xff], len=3D4097, flags=3D8) =3D 4097
> [4673] [418] fstatat64(dfd=3D12, filename=3D"/mnt/n22/v1/v2/d10", sta=
tbuf=3D0, flag=3D0x284d0014) =3D -1 (Invalid argument)
> [4673] [419] mincore(start=3D1, len=3D0x1000000, vec=3D0x85c0000[page=
_zeros]) =3D -1 (Invalid argument)
> [4673] [420] timer_settime(timer_id=3D0x5f3bdbfa, flags=3D0x3075aee6,=
 new_setting=3D0x85c3000[page_0xff], old_setting=3D0x85c3001) =3D -1 (I=
nvalid argument)
> [4673] [421] syncfs(fd=3D12) [watchdog] pid 4514 hasn't made progress=
 in 30 seconds! (last:1368998898 now:1368998928 diff:30). Stuck in sysc=
all 267:clock_nanosleep. Sending SIGKILL.
>=20
>=20
> I created an EXT4FS on the file /mnt/ramdisk/disk1, loop-mounted it a=
t /mnt/ramdisk/victims,
> I mounted a stable Gentoo Linux image onto /mnt/ramdisk/trinity, chro=
oted into + started a fuzzying process
>=20
> $ ps axf | grep trinity
>  2427 pts/2    S+     0:00  |   \_ sudo /home/tfoerste/workspace/bin/=
chr_uml.sh -r /home/tfoerste/virtual/uml/trinity -t cd /mnt/n22/v1; whi=
le [[ : ]]; do trinity -C 4 -V /mnt/n22/v1/v2/ -m; sleep 2; done
>  2428 pts/2    S+     0:00  |       \_ /bin/sh /home/tfoerste/workspa=
ce/bin/chr_uml.sh -r /home/tfoerste/virtual/uml/trinity -t cd /mnt/n22/=
v1; while [[ : ]]; do trinity -C 4 -V /mnt/n22/v1/v2/ -m; sleep 2; done
>  2479 pts/2    S+     0:00  |           \_ /bin/sh /home/tfoerste/wor=
kspace/bin/chr_uml.sh -r /home/tfoerste/virtual/uml/trinity -t cd /mnt/=
n22/v1; while [[ : ]]; do trinity -C 4 -V /mnt/n22/v1/v2/ -m; sleep 2; =
done
>  4681 pts/2    D+     0:00  |           |   \_ grep -q -e Regeneratin=
g random pages -e Triggering periodic reseed. /mnt/ramdisk/victims/v1/t=
rinity.log
>  2483 pts/2    S+     0:00  |           \_ su - tfoerste -c cd /mnt/n=
22/v1; while [[ : ]]; do trinity -C 4 -V /mnt/n22/v1/v2/ -m; sleep 2; d=
one
>  2485 pts/2    S+     0:00  |               \_ /bin/bash -c cd /mnt/n=
22/v1; while [[ : ]]; do trinity -C 4 -V /mnt/n22/v1/v2/ -m; sleep 2; d=
one
>  4510 pts/2    S+     0:00  |                   \_ trinity -C 4 -V /m=
nt/n22/v1/v2/ -m
>  4511 pts/2    D+     0:00  |                       \_ trinity -C 4 -=
V /mnt/n22/v1/v2/ -m
>  4512 pts/2    S+     0:00  |                       \_ trinity -C 4 -=
V /mnt/n22/v1/v2/ -m
>  4514 pts/2    SNL+   0:00  |                           \_ trinity -C=
 4 -V /mnt/n22/v1/v2/ -m
>  4546 pts/2    SNL+   0:00  |                           \_ trinity -C=
 4 -V /mnt/n22/v1/v2/ -m
>  4651 pts/2    SNL+   0:00  |                           \_ trinity -C=
 4 -V /mnt/n22/v1/v2/ -m
>  4673 pts/2    DNL+   0:00  |                           \_ trinity -C=
 4 -V /mnt/n22/v1/v2/ -m
>  5421 pts/5    S+     0:00      \_ grep --colour=3Dauto trinity
>=20
>=20
> --=20
> MfG/Sincerely
> Toralf F=F6rster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
