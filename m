From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [next-20101028] Call trace in ext4
Date: Thu, 28 Oct 2010 12:34:55 +0200
Message-ID: <AANLkTin+GsrEFb2+tYD4ctg3o9t3wzpcywOkF9S1n6=0@mail.gmail.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163630fe6196ce3d0493aae427
Cc: "Theodore Ts'o" <tytso@mit.edu>, sfr@canb.auug.org.au,
	Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48426 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0J1Ke4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Oct 2010 06:34:56 -0400
In-Reply-To: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--00163630fe6196ce3d0493aae427
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[ Changes subject s/next-20101038/next-20101028 ]

Not sure if there got something wrong when merging ext4 [1] into
linux-next (before GIT-pull-request to LKML) or some patches missing
from Ted's ext4/upstream-merge GIT branch?

- Sedat -

P.S.: Forgotten to add v2 of 2nd patch I mentionned below, sorry.

[1] http://lkml.org/lkml/2010/10/27/480
[2] http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Dshortlog=
;h=3Drefs/heads/upstream-merge

On Thu, Oct 28, 2010 at 12:05 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> Hi,
>
> I have built today linux-next as of next-20101028 in a non-BKL config
> (kernel-config attached) on a Debian i386/sid host.
>
> When I start my quassel IRC-client I get reproducibly this call-trace:
>
> # tail -40 kern.log
> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.872957] EXT3-fs (sdb5): warning:
> maximal mount count reached, running e2fsck is recommended
> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.873621] EXT3-fs (sdb5): using
> internal journal
> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.873635] EXT3-fs (sdb5): mounted
> filesystem with ordered data mode
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480401] ------------[ cut here ]=
------------
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480598] kernel BUG at
> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/ext4=
/inode.c:2721!
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480979] invalid opcode: 0000 [#1=
] SMP
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.481155] last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/PNP0C09:00/PNP0C0=
A:00/power_supply/BAT0/energy_full
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.481610] Modules linked in: ext3
> jbd sco aes_i586 rfcomm bnep aes_generic l2cap bluetooth acpi_cpufreq
> mperf cpufreq_powersave cpufreq_userspace cpufreq_stats ppdev
> cpufreq_conservative lp dm_crypt binfmt_misc arc4 snd_intel8x0 ecb
> snd_intel8x0m radeon thinkpad_acpi snd_ac97_codec ath5k snd_seq_midi
> ac97_bus pcmcia snd_pcm_oss joydev snd_rawmidi snd_seq_midi_event ath
> mac80211 snd_mixer_oss ttm cfg80211 snd_seq snd_pcm yenta_socket
> pcmcia_rsrc drm_kms_helper drm snd_seq_device snd_timer pcmcia_core
> i2c_algo_bit nsc_ircc rfkill snd_page_alloc irda i2c_i801 shpchp snd
> i2c_core tpm_tis rng_core pci_hotplug psmouse processor tpm soundcore
> parport_pc video ac tpm_bios battery button led_class pcspkr evdev
> parport power_supply serio_raw nvram output crc_ccitt fuse autofs4
> ext4 mbcache jbd2 crc16 dm_mod usbhid hid usb_storage sg sd_mod sr_mod
> crc_t10dif cdrom ata_generic ata_piix libata uhci_hcd ehci_hcd usbcore
> scsi_mod thermal e1000 thermal_sys floppy nls_base [last unloaded:
> scsi
> Oct 28 11:44:16 tbox kernel: _wait_scan]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] Pid: 237, comm:
> jbd2/sda5-8 Not tainted 2.6.36-next-20101028.1-686 #1 2374SG6/2374SG6
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] EIP: 0060:[<f86282fb>]
> EFLAGS: 00010246 CPU: 0
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] EIP is at
> ext4_writepage+0x8d/0x1f1 [ext4]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] EAX: 40020029 EBX:
> f76934a0 ECX: 05050030 EDX: 00000000
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] ESI: 00005050 EDI:
> 00001000 EBP: f5f3c548 ESP: ef973dbc
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0DS: 007b ES: 007b =
FS:
> 00d8 GS: 00e0 SS: 0068
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] Process jbd2/sda5-8 (pid=
:
> 237, ti=3Def972000 task=3Def8c9080 task.ti=3Def972000)
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] Stack:
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A000000005 00000000
> ef973e98 00000000 f5f3c600 ef973e98 00000000 00005050
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0c108fe6e f76934a0
> c1090ea4 00000001 f5f3c600 00000004 00000002 00000000
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A000000006 0000000e
> ef9a6180 c108fe66 e74172ff 0000000e 00000000 f7693400
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] Call Trace:
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c108fe6e>] ? __w=
ritepage+0x8/0x1f
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1090ea4>] ?
> write_cache_pages+0x1cc/0x281
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c108fe66>] ? __w=
ritepage+0x0/0x1f
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1090f6f>] ?
> generic_writepages+0x16/0x1d
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<f85ab8d9>] ?
> journal_submit_data_buffers+0xf5/0x150 [jbd2]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<f85abd1e>] ?
> jbd2_journal_commit_transaction+0x2d1/0xda3 [jbd2]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1025bdb>] ?
> dequeue_task_fair+0x1b/0x57
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c10392df>] ?
> lock_timer_base+0x19/0x34
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1039356>] ?
> try_to_del_timer_sync+0x5c/0x63
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<f85afdf2>] ?
> kjournald2+0x9e/0x1c7 [jbd2]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1043ffe>] ?
> autoremove_wake_function+0x0/0x29
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<f85afd54>] ?
> kjournald2+0x0/0x1c7 [jbd2]
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1043cb2>] ? kth=
read+0x63/0x68
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c1043c4f>] ? kth=
read+0x0/0x68
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] =C2=A0[<c10034fe>] ?
> kernel_thread_helper+0x6/0x10
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] Code: 0c 89 34 24 89 ce =
0f
> ac d6 0c 39 7c 24 04 75 05 39 34 24 74 07 bf 00 10 00 00 eb 08 89 cf
> 81 e7 ff 0f 00 00 8b 03 f6 c4 08 75 04 <0f> 0b eb fe c7 04 24 00 00 00
> 00 83 7b 0c 00 75 37 68 46 ac 62
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.484020] EIP: [<f86282fb>]
> ext4_writepage+0x8d/0x1f1 [ext4] SS:ESP 0068:ef973dbc
> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.564589] ---[ end trace 1b8c420fb=
1d1ae45 ]---
>
> The code section looks like:
> [ fs/ext4/inode.c ]
> ...
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If the page does not have buffers (for what=
ever reason),
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * try to create them using __block_write_begi=
n. =C2=A0If this
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * fails, redirty the page and move on.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!page_buffers(page)) { =C2=A0 =C2=A0 <--- =
LINE #2721
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (__block_write_=
begin(page, 0, len,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0noalloc_g=
et_block_write)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0redirty_page:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0redirty_page_for_writepage(wbc, page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0unlock_page(page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0commit_write =3D 1=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> ...
>
> I am not sure if this is a general ext4 problem or only in a non-BKL setu=
p.
>
> Hope this helps to track down the problem.
>
> Kind Regards,
> - Sedat -
>
> P.S.:
> I also have tried with patches from [1] and [2], v2 versions attached
> to make linux-next happy.
>
> [1] http://lkml.org/lkml/2010/10/28/36
> [2] http://lkml.org/lkml/2010/10/28/40
>

--00163630fe6196ce3d0493aae427
Content-Type: text/x-diff; charset=US-ASCII;
	name="tip-origin-tree-build-failure-was-GIT-PULL-ext4-update-for-2.6.37-v2.patch"
Content-Disposition: attachment;
	filename="tip-origin-tree-build-failure-was-GIT-PULL-ext4-update-for-2.6.37-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gfthyr6p3

ZGlmZiAtcmR1cCBzb3VyY2VfaTM4Nl9ub25lLm9yaWcvZnMvZXh0NC94YXR0ci5oIHNvdXJjZV9p
Mzg2X25vbmUvZnMvZXh0NC94YXR0ci5oCi0tLSBzb3VyY2VfaTM4Nl9ub25lLm9yaWcvZnMvZXh0
NC94YXR0ci5oCTIwMTAtMTAtMjAgMjI6MzA6MjIuMDAwMDAwMDAwICswMjAwCisrKyBzb3VyY2Vf
aTM4Nl9ub25lL2ZzL2V4dDQveGF0dHIuaAkyMDEwLTEwLTI4IDExOjM3OjM0LjY0NDIxODA1NyAr
MDIwMApAQCAtMTIyLDcgKzEyMiw3IEBAIGV4dDRfeGF0dHJfcHV0X3N1cGVyKHN0cnVjdCBzdXBl
cl9ibG9jawogfQogCiBzdGF0aWMgaW5saW5lIGludAotaW5pdF9leHQ0X3hhdHRyKHZvaWQpCitl
eHQ0X2luaXRfeGF0dHIodm9pZCkKIHsKIAlyZXR1cm4gMDsKIH0KTnVyIGluIHNvdXJjZV9pMzg2
X25vbmUvZnMvZXh0NDogeGF0dHIuaC5yZWouCg==
--00163630fe6196ce3d0493aae427--
