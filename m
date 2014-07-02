From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: journal has aborted
Date: Wed, 02 Jul 2014 17:49:34 +0400
Message-ID: <871tu327m9.fsf@openvz.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com> <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org> <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: David Jander <david@protonic.nl>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51659 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaGBNtj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jul 2014 09:49:39 -0400
Received: by mail-lb0-f177.google.com with SMTP id u10so7905773lbd.22
        for <linux-ext4@vger.kernel.org>; Wed, 02 Jul 2014 06:49:37 -0700 (PDT)
In-Reply-To: <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Tue, 1 Jul 2014 10:55:11 +0200, Matteo Croce <technoboy85@gmail.com> wrote:
> 2014-07-01 10:42 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> > On Tue, Jul 01, 2014 at 08:26:19AM +0200, David Jander wrote:
> >>
> >> Hi,
> >>
> >> On Mon, 30 Jun 2014 23:30:10 +0200
> >> Matteo Croce <technoboy85@gmail.com> wrote:
> >>
> >> > I was web surfing and using gimp when:
> >> >
> >> > EXT4-fs error (device sda2): ext4_mb_generate_buddy:756: group 199,
> >> > 9414 clusters in bitmap, 9500 in gd; block bitmap corrupt.
> >>
> >> I was about to post a related question to this list. I am also seeing these
> >> kind of errors when using ext4 on latest mainline (I began testing with 3.15
> >> where I saw this and now in 3.16-rc3 it is still there).
> >> It happens almost instantly when power-cycling the system (unclean shutdown).
> >> The next time the system boots, I get these errors.
> >>
> >> AFAICT, you are using a pretty recent kernel. Which version exactly?
> >>
> >> > Aborting journal on device sda2-8.
> >> > EXT4-fs (sda2): Remounting filesystem read-only
> >
> > Matteo, could you please post the full dmesg log somewhere?  I'm interested in
> > what happens before all this happens, because...
> 
It is reasonable to understand what is the root of this issue in disk
driver or issue in JBD. Can you please run fio utility for your disk
( can be found here http://git.kernel.dk/?p=fio.git;a=summary) or simply
install it with your favorite pkg mgr (yum install fio) 
and run verify job for your disk (see attachment)
like follows: # fio disk-verify.fio
####### job:disk-verify.fio #############

--=-=-=
Content-Disposition: inline; filename=disk-veryfy.fio

[global]
bs=64k
direct=1
rw=randwrite
ioengine=libaio
iodepth=32
runtime=3600
time_based

verify=crc32c-intel
verify_fatal=1
verify_dump=1
verify_backlog=1024
verify_async=1
verifysort=1
exitall

##############
# My volume '/dev/mapper/vg-test_dev' size of 10gb
# In order to run this script just change job't name for example '/dev/sda'
###############
# This job will run 4 concurent threads which operate on separated regions
# [0,2gb][2gb,4gb][4gb,6gb][6gb,8gb]
#
[/dev/mapper/vg-test_dev]
numjobs=4
offset_increment=2G
size=2G

--=-=-=


> I've rebooted the notebook twice
> 
> >> > ------------[ cut here ]------------
> >> > WARNING: CPU: 6 PID: 4134 at fs/ext4/ext4_jbd2.c:259
> >> > __ext4_handle_dirty_metadata+0x18e/0x1d0()
> >> > Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek
> >> > snd_hda_codec_generic ecb uvcvideo videobuf2_vmalloc videobuf2_memops
> >> > videobuf2_core videodev ath3k btusb rts5139(C) ctr ccm iTCO_wdt bnep
> >> > rfcomm bluetooth nls_iso8859_1 vfat fat arc4 intel_rapl
> >> > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> >> > snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm
> >> > aesni_intel aes_x86_64 snd_seq_midi snd_seq_midi_event ath9k led_class
> >> > glue_helper ath9k_common lrw gf128mul ath9k_hw ablk_helper cryptd ath
> >> > mac80211 snd_rawmidi snd_seq cfg80211 radeon microcode rfkill
> >> > snd_timer snd_seq_device sr_mod psmouse r8169 snd cdrom i915 lpc_ich
> >> > soundcore ttm mii mfd_core drm_kms_helper drm intel_gtt agpgart
> >> > ehci_pci mei_me xhci_hcd tpm_infineon ehci_hcd video mei wmi tpm
> >> > backlight
> >> > CPU: 6 PID: 4134 Comm: gimp-2.8 Tainted: G         C    3.15.0 #6
> >> >  0000000000000009 ffffffff813acbdd 0000000000000000 ffffffff8103de3d
> >> >  ffff8802365231a0 00000000ffffffe2 0000000000000000 ffff8800b90816c0
> >> >  ffffffff814205a0 ffffffff8118879e 0000000000000005 ffff8802365231a0
> >> > Call Trace:
> >> >  [<ffffffff813acbdd>] ? dump_stack+0x41/0x51
> >> >  [<ffffffff8103de3d>] ? warn_slowpath_common+0x6d/0x90
> >> >  [<ffffffff8118879e>] ? __ext4_handle_dirty_metadata+0x18e/0x1d0
> >> >  [<ffffffff8116e130>] ? ext4_dirty_inode+0x20/0x50
> >> >  [<ffffffff811903e9>] ? ext4_free_blocks+0x539/0xa40
> >> >  [<ffffffff8118468b>] ? ext4_ext_remove_space+0x83b/0xe60
> >> >  [<ffffffff81186a58>] ? ext4_ext_truncate+0x98/0xc0
> >> >  [<ffffffff8116c985>] ? ext4_truncate+0x2b5/0x300
> >> >  [<ffffffff8116d3d8>] ? ext4_evict_inode+0x3d8/0x410
> >> >  [<ffffffff81114a46>] ? evict+0xa6/0x160
> >> >  [<ffffffff81109346>] ? do_unlinkat+0x186/0x2a0
> >> >  [<ffffffff8110e51e>] ? SyS_getdents+0xde/0x100
> >> >  [<ffffffff8110e1d0>] ? fillonedir+0xd0/0xd0
> >> >  [<ffffffff813b2626>] ? system_call_fastpath+0x1a/0x1f
> >> > ---[ end trace 795411398e41fbcb ]---
> >> > EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at
> >> > line 241, credits 91/91, errcode -30
> >> > EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at
> >> > line 241, credits 91/91, errcode -30<2>EXT4-fs error (device sda2) in
> >> > ext4_free_blocks:4867: Journal has aborted
> >> > EXT4-fs error (device sda2): ext4_ext_rm_leaf:2731: inode #8257653:
> >> > block 6520936: comm gimp-2.8: journal_dirty_metadata failed: handle
> >> > type 5 started at line 241, credits 91/91, errcode -30
> >> > EXT4-fs error (device sda2) in ext4_ext_remove_space:3018: Journal has
> >> > aborted EXT4-fs error (device sda2) in ext4_ext_truncate:4666: Journal has
> >> > aborted EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
> >> > has aborted
> >> > EXT4-fs error (device sda2) in ext4_truncate:3788: Journal has aborted
> >> > EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
> >> > has aborted
> >> > EXT4-fs error (device sda2) in ext4_orphan_del:2684: Journal has aborted
> >> > EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
> >> > has aborted
> >>
> >> I did not get these errors. I suspect this may be a consequence of FS
> >> corruption due to a bug in etx4.
> >>
> >> Here's why I suspect a bug:
> >>
> >> I am running latest git head (3.16-rc3+ as of yesterday) on an ARM system with
> >> eMMC flash. The eMMC is formatted in SLC mode ("enhanced" mode according to
> >> eMMC 4.41) and "reliable-writes" are enabled, so power-cycling should not
> >> cause FS corruption in presence of a journal.
> 
> I have a Samsung SSD 840 PRO
> 
> >> I can format the eMMC device either as EXT3 or EXT4 for the test. After
> >> formatting and writing the rootfs to the partition I can boot successfully in
> >> either situation. Once booted from eMMC, I start bonnie++ (to just stress the
> >> FS for a while), and after a minute or so the board is power-cycled while
> >> bonnie++ is still running.
> >>
> >> Next time I boot the situation is this:
> >>
> >> With EXT3: All seems fine, journal is replayed, no errors. I can repeat this as
> >> many times as I want, FS stays consistent.
> >>
> >> With EXT4: After just one power cycle I start getting this:
> >>
> >> [    7.603871] EXT4-fs error (device mmcblk0p2): ext4_mb_generate_buddy:757: group 1, 8542 clusters in bitmap, 8550 in gd; block bitmap corrupt.
> >> [    7.616743] JBD2: Spotted dirty metadata buffer (dev = mmcblk0p2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> >
> > I've been seeing this same set of symptoms with 3.15.0 on various SSDs (Samsung
> > 840 Pro, Crucial M4).  It seems that something (upstart?) is holding open some
> > file or other during poweroff, which means that the root fs can't be unmounted
> > or even remounted rw.  I also noticed that the next time the system comes up,
> > the kernel tells me that it has to process the inode orphan list as part of
> > recovery.
> >
> > Shortly after the orphan list gets processed, I get that message and the FS
> > goes ro.  A subsequent fsck run reveals that the block bitmap is indeed
> > incorrect in that block group, and when I bd the blocks that are incorrect in
> > the bitmap, I see what could be some kind of upstart log file.  Either way, I
> > suspect some bug in orphan processing.
> >
> > <shrug> I don't know if this is specific to SSDs or spinning rust.  Right now
> > I've simply rigged the initramfs to e2fsck -p the root fs before mounting it,
> > which seems(?) to have patched around it for now.
> >
> >> If I continue the test, it doesn't take long and serious corruption starts
> >> occurring.
> >
> > You're getting actual FS data corruption too?  Or more of those messages?
> 
> Actually it seems that there are no corruption
> 
> > --D
> >>
> >> Again, with EXT3 I am unable to detect any problems.
> >>
> >> Best regards,
> >>
> >> --
> >> David Jander
> >> Protonic Holland.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Matteo Croce
> OpenWrt Developer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
