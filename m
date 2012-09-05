From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] resize2fs: fix overhead calculation for meta_bg file systems
Date: Wed, 5 Sep 2012 10:10:29 +0800
Message-ID: <CAGBYx2ZRUdY1CFVnpqB-3LOr5Gs5Cs7UBv2SDxXW9Xqps_m6vQ@mail.gmail.com>
References: <20120903164525.GD5066@thunk.org> <1346690758-21072-1-git-send-email-tytso@mit.edu>
 <1346690758-21072-2-git-send-email-tytso@mit.edu> <CAGBYx2a8J1ZvWDjgv3snTCE59nqurF_sGYJ0pxSy2anXjzfBRg@mail.gmail.com>
 <20120904021412.GG5066@thunk.org> <504634D6.20608@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Kevin Liao <kevinlia@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Anssi Hannula <anssi.hannula@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33612 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab2IECKv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Sep 2012 22:10:51 -0400
Received: by lagy9 with SMTP id y9so4619254lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Sep 2012 19:10:50 -0700 (PDT)
In-Reply-To: <504634D6.20608@iki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Anssi,

The bug was fixed for a while, please check the patches:
[PATCH 1/2] ext4: teach resize report old blocks count correctly
[PATCH 2/2] ext4: ignore last group without enough space when resizing

Please have a try!!!

Thanks,
Yongqiang.

On Wed, Sep 5, 2012 at 1:05 AM, Anssi Hannula <anssi.hannula@iki.fi> wrote:
> 04.09.2012 05:14, Theodore Ts'o kirjoitti:
>> On Tue, Sep 04, 2012 at 09:59:55AM +0800, Yongqiang Yang wrote:
>>> Hi Kevin,
>>>
>>>   Ted has sent out the patches on online resizing for meta_bg and
>>> 64bits, so you can have a try again. It seems that the bug in
>>> e2fsprogs has been fixed.
>>
>> Make sure you use the latest version of the kernel patches that I just
>> sent out.  There quite a number of bugs in the Yongqiang's original
>> patch set which I tripped over while I was testing 64-bit resize ---
>> and please note that there are definitely still rough edges
>> (especially for in cases where the file system was created < 16TB, but
>> with the 64-bit feature and resize_inode features enabled).  There may
>> also be bugs for the straightforward case of resizing very large file
>> systems.
>
> Indeed, I hit a BUG_ON() on resize from 8589934590 blocks to 8589934640
> blocks (4k):
>  [  676.140165] ------------[ cut here ]------------
>  [  676.150026] kernel BUG at fs/ext4/resize.c:255!
>  [  676.150026] invalid opcode: 0000 [#1] SMP
>  [  676.150026] CPU 0
>  [  676.150026] Modules linked in:[  676.150026]  dm_snapshot dm_zero
> af_packet dm_mod joydev hid_generic ppdev snd_intel8x0 snd_ac97_codec
> ac97_bus usbhid microcode e1000 snd_pcm snd_page_alloc snd_timer hid
> i2c_piix4 i2c_core button snd soundcore ac parport_pc parport processor
> evdev ipv6 autofs4 ext4 crc16 jbd2 ohci_hcd sd_mod crc_t10dif usbcore
> usb_common sr_mod ata_piix ahci libahci libata scsi_mod [last unloaded:
> nf_defrag_ipv4]
>
>  [  676.150026] Pid: 1793, comm: resize2fs Not tainted
> 3.5.3-server-2anssi.9.ext4.10.2 #1 innotek GmbH VirtualBox
>  [  676.150026] RIP: 0010:[<ffffffffa014e9bc>]  [<ffffffffa014e9bc>]
> ext4_resize_fs+0x94c/0xa30 [ext4]
>  [  676.150026] RSP: 0018:ffff880046eedd18  EFLAGS: 00010246
>  [  676.150026] RAX: 0000000000040001 RBX: ffff88005b799800 RCX:
> 0000000000000001
>  [  676.150026] RDX: 0000000000081bf1 RSI: 0000000000040001 RDI:
> ffff88005b068000
>  [  676.150026] RBP: ffff880046eeddd8 R08: 0000000200000003 R09:
> 0000000000000000
>  [  676.150026] R10: 0000000000000000 R11: 0000000080042000 R12:
> 0000000000040001
>  [  676.150026] R13: ffff880037fb5e20 R14: 0000000000000000 R15:
> ffff88005b068000
>  [  676.150026] FS:  00007fb43e067740(0000) GS:ffff88005fc00000(0000)
> knlGS:0000000000000000
>  [  676.150026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  [  676.150026] CR2: 00007fd905261178 CR3: 0000000044993000 CR4:
> 00000000000006f0
>  [  676.150026] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
>  [  676.150026] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
>  [  676.150026] Process resize2fs (pid: 1793, threadinfo
> ffff880046eec000, task ffff880053f824c0)
>  [  676.150026] Stack:
>  [  676.150026]  ffff880046eedda8 ffffffff8117971e 0000000f53529c40
> 0000000000000000
>  [  676.150026]  000000020000002f 0000000000000000 0000000200000030
> ffff88005b20e990
>  [  676.150026]  0000000100000001 ffff880000000001 0000000200000000
> 0000000200000000
>  [  676.150026] Call Trace:
>  [  676.150026]  [<ffffffff8117971e>] ? do_last+0x2ee/0x9f0
>  [  676.150026]  [<ffffffffa012e05f>] ext4_ioctl+0x9af/0xbc0 [ext4]
>  [  676.150026]  [<ffffffff8117db6f>] do_vfs_ioctl+0x8f/0x4e0
>  [  676.150026]  [<ffffffff8117e051>] sys_ioctl+0x91/0xa0
>  [  676.150026]  [<ffffffff8147d0bd>] system_call_fastpath+0x1a/0x1f
>  [  676.150026] Code: c7 c1 60 2c 17 a0 ba 0c 07 00 00 48 c7 c6 9b e8 16
> a0 4c 89 e7 31 c0 e8 b3 80 ff ff c7 85 6c ff ff ff ea ff ff ff e9 4c f8
> ff ff <0f> 0b 8b 55 a4 8b 45 a0 f7 da 44 31 e0 85 c2 0f 84 6c fb ff ff
>  [  676.150026] RIP  [<ffffffffa014e9bc>] ext4_resize_fs+0x94c/0xa30 [ext4]
>  [  676.150026]  RSP <ffff880046eedd18>
>  [  676.788513] ---[ end trace fbf2bd5a59c2ab99 ]---
>
> This is BUG_ON(src_group >= group_data[0].group + flex_gd->count);
>
> I was using the below basic test script which uses a virtual large
> volume in LVM (e2fsprogs is 1.42.5, except for resize2fs):
>
> #!/bin/bash -ex
>
> VG=delta
> LV=ext4test
> LVSIZE=40T
> MOUNTPOINT="/mnt/iso"
> RESIZE2FS=/root/resize2fs
>
> INITIAL_SIZE_K=4294967295
> NEW_BLOCKS=8589934590
>
> lvcreate -l 100%FREE -V "$LVSIZE" -n "$LV" "$VG"
> mkfs.ext4 -O meta_bg,64bit,^resize_inode "/dev/$VG/$LV" "$INITIAL_SIZE_K"
>
> mount "/dev/$VG/$LV" "$MOUNTPOINT"
>
> mkdir "$MOUNTPOINT/test"
> for file in 1 2; do
>         dd if=/dev/urandom bs=1M count=50 of="$MOUNTPOINT/test/$file"
> done
> md5sum $MOUNTPOINT/test/* > $MOUNTPOINT/MD5SUM
>
> for N in $NEW_BLOCKS $((NEW_BLOCKS + 50)); do
>         $RESIZE2FS "/dev/$VG/$LV" "$N"
>
>         umount "$MOUNTPOINT"
>         fsck.ext4 -nvf "/dev/$VG/$LV"
>         mount "/dev/$VG/$LV" "$MOUNTPOINT"
>         md5sum -c "$MOUNTPOINT/MD5SUM"
> done
>
>
>
>> So while I very much appreciate users giving the code a try and
>> sending us feedback, please do think twice before using this code on
>> file systems with data that hasn't been backed up recently.  (Of
>> course, being good System Administrators you are all keeping --- and
>> verifying --- regular backups, right?  :-)
>
> --
> Anssi Hannula



-- 
Best Wishes
Yongqiang Yang
