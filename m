From: Peng Tao <bergwolf@gmail.com>
Subject: Re: kernel BUG at fs/ext4/move_extent.c:1317!
Date: Mon, 21 Sep 2009 09:22:35 +0800
Message-ID: <6149e97b0909201822y5f29d091jbc00b740244f39a8@mail.gmail.com>
References: <37d33d830909200625i574f3688vb0d5b82183ba2476@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>
To: SandeepKsinha <sandeepksinha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:37300 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZIUBWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Sep 2009 21:22:32 -0400
Received: by pzk34 with SMTP id 34so2129946pzk.22
        for <linux-ext4@vger.kernel.org>; Sun, 20 Sep 2009 18:22:35 -0700 (PDT)
In-Reply-To: <37d33d830909200625i574f3688vb0d5b82183ba2476@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, Sandeep,

On Sun, Sep 20, 2009 at 9:25 PM, SandeepKsinha <sandeepksinha@gmail.com=
> wrote:
> Hi Akira/others,
>
> I hit the following assert kernel BUG at fs/ext4/move_extent.c:1317!
>
> The file I was playing around with was a simple holey file created li=
ke:
>
> [/mnt]
> [18:35:13 sinhas]$ dd if=3D/dev/zero of=3D/mnt/ext4image seek=3D1000 =
count=3D5
> 5+0 records in
> 5+0 records out
> 2560 bytes (2.6 kB) copied, 0.000146457 s, 17.5 MB/s
>
> I am using v2.6.31. I have seen some patchsets a couple of days from
> you. Does any of them address any similar problem.?
Yes. The BUG_ON is unnecessary and is removed in the latest mainline
kernel. Please refer to commit
daea696dbac0e33af3cfe304efbfb8d74e0effe6 for details.

>
> Are there any prerequisites for the userspace clients of
> EXT4_IOC_MOVE_EXT? Apart from having the offsets equal for orig and
> donor inode.
> The userspace program (part of OHSM) invoking the ioctl could be foun=
d at:
> http://ohsm.git.sourceforge.net/git/gitweb.cgi?p=3Dohsm/mkatiyar/.git=
;a=3Dblob;f=3Duserspace/relocate.c;h=3Dea0fa184ce4e692258a671cb0b9ace7a=
77b9fee9;hb=3Drefs/heads/ohsm_next#l367
>
> [22145.440009] ------------[ cut here ]------------
> [22145.440019] kernel BUG at fs/ext4/move_extent.c:1317!
> [22145.440031] invalid opcode: 0000 [#10] SMP
> [22145.440044] last sysfs file:
> /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfki=
ll2/state
> [22145.440059] Modules linked in: ohsm ext4 jbd2 crc16 af_packet ppde=
v
> rfcomm bridge stp bnep sco l2cap ipv6 pci_slot sbs sbshc container
> binfmt_misc autofs4sbp2 lp parport snd_hda_codec_analog snd_hda_intel
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
> snd_seq_oss snd_seq_midi arc4 snd_rawmidi ecb joydev
> snd_seq_midi_event snd_seq iwlagn snd_timer iwlcore snd_seq_device
> mac80211 pcmcia snd btusb thinkpad_acpi led_class iTCO_wdt bluetooth
> cfg80211 psmouse yenta_socket rsrc_nonstatic pcmcia_core soundcore
> snd_page_alloc iTCO_vendor_support rfkill intel_agp agpgart pcspkr
> serio_raw wmi evdev nvram video output ac battery button processor
> ext3 jbd mbcache sr_mod cdrom sg ata_generic pata_acpi ohci1394
> ata_piix ieee1394 ehci_hcd uhci_hcd e1000e usbcore linear thermal fan
> fuse
> [22145.440314]
> [22145.440325] Pid: 7064, comm: ohsm Tainted: G =C2=A0 =C2=A0 =C2=A0D=
 =C2=A0 =C2=A0(2.6.31 #2) 7665AD6
> [22145.440336] EIP: 0060:[<f8722829>] EFLAGS: 00210246 CPU: 0
> [22145.440402] EIP is at ext4_move_extents+0x409/0x1600 [ext4]
> [22145.440412] EAX: fff8307e EBX: 00000000 ECX: ec2a7e30 EDX: fffffff=
f
> [22145.440425] ESI: f3b09ef0 EDI: 0000007d EBP: f3b09e88 ESP: f3b09da=
8
> [22145.440435] =C2=A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [22145.440448] Process ohsm (pid: 7064, ti=3Df3b08000 task=3Df6083240
> task.ti=3Df3b08000)
> [22145.440456] Stack:
> [22145.440463] =C2=A0f3b09e2c f8188be3 f3d59400 00000000 00000001 f3b=
09dd0
> ecce4ac0 f3d59400
> [22145.440489] <0> 00000000 f3d59402 00000000 f3f8ac68 f3b09e78
> f6307400 f5a2a500 00000001
> [22145.440515] <0> f61ecc00 f3b09e54 c149c640 c149c780 00000000
> 0007d9ff 0007d000 f6307400
> [22145.440544] Call Trace:
> [22145.440576] =C2=A0[<f8188be3>] ? do_get_write_access+0x763/0xab0 [=
jbd2]
> [22145.440640] =C2=A0[<f8711707>] ? __ext4_handle_dirty_metadata+0x47=
/0x1a0 [ext4]
> [22145.440664] =C2=A0[<c0375c83>] ? security_capable+0x33/0x50
> [22145.440720] =C2=A0[<f86e1463>] ? ext4_ioctl+0x273/0xfa0 [ext4]
> [22145.440779] =C2=A0[<f870b3c6>] ? ext4_fallocate+0x5f6/0x610 [ext4]
> [22145.440835] =C2=A0[<f86e11f0>] ? ext4_ioctl+0x0/0xfa0 [ext4]
> [22145.440852] =C2=A0[<c02ca2ed>] ? vfs_ioctl+0x3d/0x110
> [22145.440866] =C2=A0[<c028660f>] ? page_referenced+0x1cf/0x320
> [22145.440883] =C2=A0[<c02cab71>] ? do_vfs_ioctl+0x5f1/0xae0
> [22145.440897] =C2=A0[<c02ace42>] ? do_fallocate+0x172/0x210
> [22145.440913] =C2=A0[<c02cb106>] ? sys_ioctl+0xa6/0x100
> [22145.440927] =C2=A0[<c0104bdc>] ? sysenter_do_call+0x12/0x28
> [22145.440943] =C2=A0[<c028660f>] ? page_referenced+0x1cf/0x320
> [22145.440951] Code: ba 75 f8 00 0f 0b eb fe 66 90 83 05 78 ba 75 f8
> 01 83 15 7c ba 75 f8 00 e9 56 fd ff ff 83 05 78 bd 75 f8 01 83 15 7c
> bd 75 f8 00 <0f> 0beb fe 8b 5d c8 8b 43 20 8b 5d cc 3b 43 20 74 35 8b
> 45 c8
> [22145.441098] EIP: [<f8722829>] ext4_move_extents+0x409/0x1600 [ext4=
]
> SS:ESP 0068:f3b09da8
> [22145.441193] ---[ end trace 67bb7ca457a8d69b ]---
> [/mnt]
> [18:35:13 sinhas]$
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =E2=80=9CTo learn is to change. Education is a process that changes t=
he learner.=E2=80=9D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
