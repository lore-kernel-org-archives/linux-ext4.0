From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Fwd: bug in e2fsprogs when enable meta_bg resizing
Date: Sun, 2 Sep 2012 18:23:04 +0800
Message-ID: <CAGBYx2YNyzLYcWFc74XDgn-mguu590_S-KY-Zvb_wMnXyP2K3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62443 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2IBKXZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Sep 2012 06:23:25 -0400
Received: by vcbfk26 with SMTP id fk26so4631371vcb.19
        for <linux-ext4@vger.kernel.org>; Sun, 02 Sep 2012 03:23:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---------- Forwarded message ----------
From: Kevin Liao <kevinlia@gmail.com>
Date: Mon, Jul 30, 2012 at 10:50 AM
Subject: Re: ext4: add meta_bg and bit64 support to online resizing
To: Yongqiang Yang <xiaoqiangnk@gmail.com>


Hi Yongqiang,
I try you patches today and find one good news and one bad news. The
following is what I did (the test environment is exact the same):

1. Format the RAID0 to 12TB by using the command
mke2fs -t ext4 -m0 -b 4096 -F -O 64bit,meta_bg,^resize_inode /dev/md0 3221225472

2. Resize the RAID0 to 18TB by using the command
resize2fs /dev/md0 18T

3. Resize the same RAID0 again to 20TB by using the command
resize2fs /dev/md0 20T

The good new is the first online resizing (step 2) seems to work. The
bad news is the second online resizing (step 3) is failed with the
result that resize2fs seems never returned. After some debugging, I
find the problem may be in calculate_minimum_resize_size function.

data_needed -= SUPER_OVERHEAD(fs) * num_of_superblocks;
data_needed -= META_OVERHEAD(fs) * fs->group_desc_count;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The problem is that in my case, data_needed is smaller that
META_OVERHEAD(fs) * fs->group_desc_count. Therefore after this
operaton, data_needed becomes a extremely large value
(18446744073709533701 in this case). I think it is not reasonable and
then

extra_grps = ext2fs_div64_ceil(remainder,
            EXT2_BLOCKS_PER_GROUP(fs->super));
...
for (grp = groups; grp < groups+extra_grps; grp++) {

In my case, extra_grps is equal to 562949953421311 which is also a
extremely large value. The for loop will take very long time to finish
and that's why I say "resize2fs seems never returned"

I hope this information can helps. If you need any other information,
just let me know. Thanks a lot.

Regards,
Kevin Liao


2012/7/26 Yongqiang Yang <xiaoqiangnk@gmail.com>
>
> On Thu, Jul 26, 2012 at 7:03 PM, Kevin Liao <kevinlia@gmail.com> wrote:
> > Hi Yongqiang,
> >
> > It's my pleasure to wok with you about this great feature. Because I am also
> > busy on other things today and tomorrow, I will try you patch next Monday.
> > But I want to ask one more thing, after applying you patch, what is the
> > correct command for mke2fs? Thanks a lot for your help.
> It needs meta_bg and bit64 options and ^resize_inode
>
> Cheers,
> Yongqiang.
> >
> > Regards,
> > Kevin Liao
> >
> > 2012/7/25 Yongqiang Yang <xiaoqiangnk@gmail.com>
> >>
> >> Hi Kevin,
> >>
> >> The 2nd patch is the patch for e2fsprogs,  the 1st patch is one of
> >> patches you found for kernel, you can replace the responding one you
> >> found with this one.
> >>
> >> If you find any bugs, that is great!  I remember that I did not update
> >> the community patches because I am busy on other things.  I will come
> >> back aat weekend.
> >>
> >> Hope we can work together to make these patches accepted!
> >> Yongqiang.
> >>
> >> ---------- Forwarded message ----------
> >> From: Yongqiang Yang <xiaoqiangnk@gmail.com>
> >> Date: Mon, Apr 16, 2012 at 11:42 PM
> >> Subject: Re: ext4: add meta_bg and bit64 support to online resizing
> >> To: Anssi Hannula <anssi.hannula@iki.fi>
> >>
> >>
> >> Sorry, forgot to attach patches.
> >>
> >> Yongqiang.
> >>
> >> On 4/16/12, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
> >> > Hi Anssi,
> >> >
> >> >  I updated the patch again. Could you test it again?  This time it
> >> > should
> >> > work.
> >> >
> >> >  There are 2 patches in attachment, one is the patch for kernel side
> >> > while another one is patch for user side aka e2fsprogs.
> >> >
> >> > I am not sure my patch for e2fsprogs works.
> >> >
> >> > Thanks,
> >> > Yongqiang.
> >> >
> >> > On Mon, Apr 16, 2012 at 7:08 PM, Anssi Hannula <anssi.hannula@iki.fi>
> >> > wrote:
> >> >> 16.04.2012 13:42, Yongqiang Yang kirjoitti:
> >> >>> Hi Anssi,
> >> >>
> >> >> Hi!
> >> >>
> >> >>> I am not sure if I asked the sizes you are using before, that says the
> >> >>> file system is resized from which size to which size.  I can not find
> >> >>> the number in the thread, so could you tell me the two sizes?  Is 'the
> >> >>> to size' beyond 256TB?
> >> >>
> >> >> From 4TB to 32TB.
> >> >>
> >> >> Interestingly, I now notice the below log says
> >> >>  EXT4-fs: resized filesystem from 1073741824 upto 8589934590 blocks
> >> >> but the filesystem is actually 1073741823 blocks long (as said by
> >> >> mkfs.ext4 and dumpe2fs). But maybe that discrepancy has always been
> >> >> there, haven't checked...
> >> >>
> >> >>> Thanks,
> >> >>>
> >> >>> Yongqiang.
> >> >>>
> >> >>> On Sun, Apr 15, 2012 at 2:20 AM, Anssi Hannula <anssi.hannula@iki.fi>
> >> >>> wrote:
> >> >>>> 11.04.2012 19:46, Anssi Hannula kirjoitti:
> >> >>>>> 11.04.2012 08:07, Yongqiang Yang kirjoitti:
> >> >>>>>> Hi Anssi,
> >> >>>>>
> >> >>>>> Hi!
> >> >>>>
> >> >>>> Hi!
> >> >>>>
> >> >>>>>
> >> >>>>>> I have sent the updated patches to you by git send-email.  If you
> >> >>>>>> encounter any bug, please tell me.
> >> >>>>>
> >> >>>>> OK, will test as soon I can (possibly Friday or Saturday).
> >> >>>>>
> >> >>>>>
> >> >>>>
> >> >>>> Now it seemed to resize successfully, but there was "general
> >> >>>> protection
> >> >>>> fault" at umount time after the resize. End of log below, disassembly
> >> >>>> at
> >> >>>>
> >> >>>> http://www.cs.tut.fi/~hannulaa/ext4-disasm.6.txt
> >> >>>>
> >> >>>>> [ 5940.920621] EXT4-fs DEBUG (fs/ext4/resize.c, 1076):
> >> >>>>> update_backups:
> >> >>>>> [ 5940.928597] update metadata backup 0x1f8000(+0)
> >> >>>>> [ 5940.931980] EXT4-fs: resized filesystem from 1073741824 upto
> >> >>>>> 8589934590 blocks
> >> >>>>> [ 5946.980961] EXT4-fs DEBUG (fs/ext4/ialloc.c, 1179):
> >> >>>>> ext4_init_inode_table:
> >> >>>>> [ 5946.988265] going to zero out inode table in group 4
> >> >>>>> [ 5947.812881] general protection fault: 0000 [#1] SMP
> >> >>>>> [ 5947.820375] CPU 0
> >> >>>>> [ 5947.820375] Modules linked in: dm_snapshot dm_zero af_packet
> >> >>>>> dm_mod
> >> >>>>> ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd
> >> >>>>> joydev
> >> >>>>> i2c_piix4 soundcore parport_pc snd_page_alloc i2c_core parport e1000
> >> >>>>> battery processor ac button evdev ipv6 autofs4 ext4 jbd2 crc16
> >> >>>>> sr_mod
> >> >>>>> ide_pci_generic usbhid hid pata_acpi sd_mod crc_t10dif ata_generic
> >> >>>>> piix
> >> >>>>> ide_core ahci ata_piix ehci_hcd ohci_hcd libahci libata usbcore
> >> >>>>> usb_common scsi_mod [last unloaded: scsi_wait_scan]
> >> >>>>> [ 5947.820375]
> >> >>>>> [ 5947.820375] Pid: 1329, comm: umount Not tainted
> >> >>>>> 3.3.1-server-2anssi.9.ext4.4.2 #1 innotek GmbH VirtualBox
> >> >>>>> [ 5947.820375] RIP: 0010:[<ffffffffa01c53c7>]  [<ffffffffa01c53c7>]
> >> >>>>> ext4_mb_release+0x87/0x3b0 [ext4]
> >> >>>>> [ 5947.820375] RSP: 0018:ffff880044827d68  EFLAGS: 00010246
> >> >>>>> [ 5947.820375] RAX: ffff8800378d4a40 RBX: ffff8800378d40f8 RCX:
> >> >>>>> bbbbbbbbbbbbbbbb
> >> >>>>> [ 5947.820375] RDX: 0000000000010a40 RSI: 0000000000000000 RDI:
> >> >>>>> ffff88004bd48000
> >> >>>>> [ 5947.820375] RBP: ffff880044827dd8 R08: 0000000000000429 R09:
> >> >>>>> 0000000000000000
> >> >>>>> [ 5947.820375] R10: 0000000000000003 R11: 0000000000000000 R12:
> >> >>>>> ffff8800378d4a40
> >> >>>>> [ 5947.820375] R13: 0000000000010a40 R14: 0000000000040000 R15:
> >> >>>>> ffff88005a774248
> >> >>>>> [ 5947.820375] FS:  00007ff8bcf8f740(0000) GS:ffff88005fc00000(0000)
> >> >>>>> knlGS:0000000000000000
> >> >>>>> [ 5947.820375] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> >>>>> [ 5947.820375] CR2: 00007ff8bc8ab150 CR3: 0000000047f77000 CR4:
> >> >>>>> 00000000000006f0
> >> >>>>> [ 5947.820375] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >> >>>>> 0000000000000000
> >> >>>>> [ 5947.820375] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> >> >>>>> 0000000000000400
> >> >>>>> [ 5947.820375] Process umount (pid: 1329, threadinfo
> >> >>>>> ffff880044826000,
> >> >>>>> task ffff88005a898000)
> >> >>>>> [ 5947.820375] Stack:
> >> >>>>> [ 5947.820375]  ffff8800378d4f80 0000000000000000 ffff880059990400
> >> >>>>> 0000000000000000
> >> >>>>> [ 5947.820375]  ffff88005b72d250 000000000000003f ffff880051054ee0
> >> >>>>> ffff880051054f00
> >> >>>>> [ 5947.820375]  ffff8800378d40f8 ffff8800378d4a40 ffff8800378d40f8
> >> >>>>> ffff880059990400
> >> >>>>> [ 5947.820375] Call Trace:
> >> >>>>> [ 5947.820375]  [<ffffffffa01af757>] ext4_put_super+0xa7/0x350
> >> >>>>> [ext4]
> >> >>>>> [ 5947.820375]  [<ffffffff8117dcf2>]
> >> >>>>> generic_shutdown_super+0x62/0xf0
> >> >>>>> [ 5947.820375]  [<ffffffff8117ddb0>] kill_block_super+0x30/0x80
> >> >>>>> [ 5947.820375]  [<ffffffff8117e055>]
> >> >>>>> deactivate_locked_super+0x45/0x70
> >> >>>>> [ 5947.820375]  [<ffffffff8117ebde>] deactivate_super+0x4e/0x70
> >> >>>>> [ 5947.820375]  [<ffffffff8119b6e6>] mntput_no_expire+0xb6/0x100
> >> >>>>> [ 5947.820375]  [<ffffffff8119c431>] sys_umount+0x71/0x380
> >> >>>>> [ 5947.820375]  [<ffffffff81496cb9>] system_call_fastpath+0x16/0x1b
> >> >>>>> [ 5947.820375] Code: 49 8b 74 24 38 4c 89 e0 45 31 ed 66 0f 1f 84 00
> >> >>>>> 00
> >> >>>>> 00 00 00 45 89 e8 48 83 ee 01 44 89 ea 41 d3 e8 4c 21 ee 44 89 c1 48
> >> >>>>> 8b
> >> >>>>> 0c cf <48> 8b 0c f1 48 89 4d c0 48 89 d1 83 e1 7f 48 89 ca 48 89 4d
> >> >>>>> b8
> >> >>>>> [ 5947.820375] RIP  [<ffffffffa01c53c7>] ext4_mb_release+0x87/0x3b0
> >> >>>>> [ext4]
> >> >>>>> [ 5947.820375]  RSP <ffff880044827d68>
> >> >>>>> [ 5948.073421] ---[ end trace 0865eba7eb58c5d6 ]---
> >> >>>>
> >> >>>> --
> >> >>>> Anssi Hannula
> >> >>>
> >> >>>
> >> >>>
> >> >>
> >> >>
> >> >> --
> >> >> Anssi Hannula
> >> >
> >> >
> >> >
> >> > --
> >> > Best Wishes
> >> > Yongqiang Yang
> >> >
> >>
> >>
> >> --
> >> Best Wishes
> >> Yongqiang Yang
> >>
> >>
> >> --
> >> Best Wishes
> >> Yongqiang Yang
> >
> >
>
>
>
> --
> Best Wishes
> Yongqiang Yang




-- 
Best Wishes
Yongqiang Yang
