From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [Bug 30872] New: Calling kfree() for uninitialized pointer in ext4_mb_init_backend()
Date: Mon, 14 Mar 2011 18:07:57 +0800
Message-ID: <AANLkTinp_Omm7rmb1TUer=KgqJK_tbHdJ4e-BCT=_sYt@mail.gmail.com>
References: <bug-30872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37028 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1CNKH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 06:07:58 -0400
Received: by qwk3 with SMTP id 3so1123036qwk.19
        for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 03:07:57 -0700 (PDT)
In-Reply-To: <bug-30872-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 10, 2011 at 10:21 PM,  <bugzilla-daemon@bugzilla.kernel.org=
> wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D30872
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Summary: Calling kfree() for unini=
tialized pointer in
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
ext4_mb_init_backend()
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Product: File System
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version: 2.5
> =C2=A0 =C2=A0Kernel Version: 2.6.38-rc5 (ext4 subsystem tree)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Platform: All
> =C2=A0 =C2=A0 =C2=A0 =C2=A0OS/Version: Linux
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Tree: Mainline
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: NEW
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Severity: normal
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Priority: P1
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Component: ext4
> =C2=A0 =C2=A0 =C2=A0 =C2=A0AssignedTo: fs_ext4@kernel-bugs.osdl.org
> =C2=A0 =C2=A0 =C2=A0 =C2=A0ReportedBy: dame_eugene@mail.ru
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Regression: No
>
>
> Tested on ext4 module from git tree
> git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git,
> tip: b616844310a6c8a4ab405d3436bbb6e53cfd852f
>
> Arch: x86
>
> At fs/ext4/mballoc.c:2389, memory is allocated for sbi->s_group_info =
array. The
> elements of this array (pointers themselves) seem to be initialized w=
hen
> ext4_mb_add_groupinfo() is called (line 2408).
>
> If ext4_mb_add_groupinfo() fails for some reason (e.g. if memory allo=
cation at
> line 2296 fails), ext4_mb_init_backend() tries to call kfree() for ea=
ch
> element in sbi->s_group_info array, including the ones that have not =
been
> initialized yet:
>
> fs/ext4/mballoc.c:2414:
> err_freebuddy:
> =C2=A0 =C2=A0cachep =3D get_groupinfo_cache(sb->s_blocksize_bits);
> =C2=A0 =C2=A0while (i-- > 0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0kmem_cache_free(cachep, ext4_get_group_inf=
o(sb, i));
> =C2=A0 =C2=A0i =3D num_meta_group_infos;
> =C2=A0 =C2=A0while (i-- > 0)

literally understand, should be
while (--i >=3D 0)

Could you try with above?


> =C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(sbi->s_group_info[i]); /* <=3D oops =
here */
> =C2=A0 =C2=A0iput(sbi->s_buddy_cache);
>
> 'num_meta_group_infos' seems to be the total number of the elements t=
hat should
> have been created.
>
> The problem showed up when I ran tests for ext4 from Linux Test Proje=
ct
> (ext4-alloc-test, test #7, to be exact).
>
> 'num_meta_group_infos' was 12 on my system. The first 2 calls to
> ext4_mb_add_groupinfo() (ln 2408) succeeded but the 3rd one failed.
> kfree(sbi->s_group_info[11]) resulted in a kernel oops:
>
> --------------------------------------------------
> [ 6349.953315] EXT4-fs: can't allocate buddy mem
> [ 6349.953587] BUG: unable to handle kernel paging request at f7853a0=
0
> [ 6349.953591] IP: [<c02f1273>] kfree+0x43/0xf0
> [ 6349.953613] *pde =3D 00000000
> [ 6349.953615] Oops: 0000 [#1] SMP
> [ 6349.953617] last sysfs file:
> /sys/devices/virtual/block/loop1/queue/rotational
> [ 6349.953623] Modules linked in: ext4 jbd2 crc16 kedr_controller
> kedr_fsim_indicator_kmalloc kedr_fsim_indicator_common kedr_fsim_vmm
> kedr_fsim_mem_util kedr_fsim_cmm kedr_fault_simulation kedr_trace ked=
r_base
> fuse snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd af_packet m=
perf loop
> dm_mod ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm parport_pc =
snd_timer
> parport snd sr_mod cdrom ac e1000 sg i2c_piix4 soundcore snd_page_all=
oc button
> pcspkr ohci_hcd ehci_hcd rtc_cmos rtc_core rtc_lib usbcore sd_mod fan=
 processor
> ata_generic ata_piix thermal thermal_sys hwmon ahci libahci libata sc=
si_mod
> [last unloaded: kedr_base]
> [ 6349.953655]
> [ 6349.953657] Pid: 8379, comm: mount Not tainted 2.6.38-rc5-testbox-=
ext4+ #1
> innotek GmbH VirtualBox
> [ 6349.953664] EIP: 0060:[<c02f1273>] EFLAGS: 00010086 CPU: 0
> [ 6349.953666] EIP is at kfree+0x43/0xf0
> [ 6349.953667] EAX: f7853a00 EBX: 02b50001 ECX: 00000000 EDX: 000000b=
b
> [ 6349.953669] ESI: f8a15391 EDI: 00000202 EBP: e7e03d70 ESP: e7e03d6=
0
> [ 6349.953670] =C2=A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 6349.953672] Process mount (pid: 8379, ti=3De7e02000 task=3Df66bed3=
0
> task.ti=3De7e02000)
> [ 6349.953674] Stack:
> [ 6349.953675] =C2=A0eea9cae8 02b50001 f446f400 f446f400 e7e03d8c f8a=
15391 f8f01609
> 00000002
> [ 6349.953679] =C2=A000032609 02b50001 0000000a e7e03dbc f8f01609 000=
20000 00000000
> f47ce1c0
> [ 6349.953683] =C2=A0f446f400 f446f400 0000000c f446f400 f446f400 e48=
66bf0 f446f400
> e7e03e98
> [ 6349.953687] Call Trace:
> [ 6349.953691] =C2=A0[<f8a15391>] repl_kfree+0x51/0xa0 [kedr_fsim_cmm=
]
> [ 6349.953709] =C2=A0[<f8f01609>] ext4_mb_init+0x2a9/0x4b0 [ext4]
> [ 6349.953716] =C2=A0[<f8ef1b22>] ext4_fill_super+0x2602/0x2ae0 [ext4=
]
> [ 6349.953726] =C2=A0[<c02fd920>] mount_bdev+0x170/0x1b0
> [ 6349.953732] =C2=A0[<f8ee706a>] ext4_mount+0x1a/0x20 [ext4]
> [ 6349.953741] =C2=A0[<c02fd0f0>] vfs_kern_mount+0x70/0x230
> [ 6349.953753] =C2=A0[<c02fd309>] do_kern_mount+0x39/0xd0
> [ 6349.953755] =C2=A0[<c0314d72>] do_mount+0x432/0x6c0
> [ 6349.953768] =C2=A0[<c0315326>] sys_mount+0x66/0xa0
> [ 6349.953771] =C2=A0[<c0202ddc>] sysenter_do_call+0x12/0x28
> [ 6349.953772] Code: 7d fc 85 c9 75 73 83 fb 10 76 61 9c 58 8d 74 26 =
00 89 c7
> fa 90 8d 74 26 00 8d 83 00 00 00 40 c1 e8 0c c1 e0 05 03 05 64 ff 86 =
c0 <8b> 10
> 80 e6 80 0f 85 8b 00 00 00 8b 10 80 e6 80 75 7c 8b 10 81
> [ 6349.953796] EIP: [<c02f1273>] kfree+0x43/0xf0 SS:ESP 0068:e7e03d60
> [ 6349.953799] CR2: 00000000f7853a00
> [ 6349.953801] ---[ end trace 8e09ff66f4f48163 ]---
> --------------------------------------------------
>
> If I understand correctly what happens in ext4_mb_init_backend(), zer=
oing
> sbi->s_group_info on allocation could fix the problem:
> fs/ext4/mballoc.c:2389:
> - sbi->s_group_info =3D kmalloc(array_size, GFP_KERNEL);
> + sbi->s_group_info =3D kzalloc(array_size, GFP_KERNEL);
>
> This issue was detected with the help of KEDR framework
> (http://kedr.berlios.de/). repl_kfree() that can be seen in the call =
stack
> above is a thin wrapper around kfree() that simply output its argumen=
t to a
> trace.
>
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Dem=
ail
> ------- You are receiving this mail because: -------
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Regards
dave
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
