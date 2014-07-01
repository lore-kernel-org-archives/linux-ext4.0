From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: journal has aborted
Date: Tue, 1 Jul 2014 02:02:40 -0700
Message-ID: <20140701090240.GH9743@birch.djwong.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matteo Croce <technoboy85@gmail.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40771 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaGAJCx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 05:02:53 -0400
Content-Disposition: inline
In-Reply-To: <20140701082619.1ac77f1d@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 01, 2014 at 08:26:19AM +0200, David Jander wrote:
> 
> Hi,
> 
> On Mon, 30 Jun 2014 23:30:10 +0200
> Matteo Croce <technoboy85@gmail.com> wrote:
> 
> > I was web surfing and using gimp when:
> > 
> > EXT4-fs error (device sda2): ext4_mb_generate_buddy:756: group 199,
> > 9414 clusters in bitmap, 9500 in gd; block bitmap corrupt.
> 
> I was about to post a related question to this list. I am also seeing these
> kind of errors when using ext4 on latest mainline (I began testing with 3.15
> where I saw this and now in 3.16-rc3 it is still there).
> It happens almost instantly when power-cycling the system (unclean shutdown).
> The next time the system boots, I get these errors.

Hmm... David, could you also send me your dmesg when this happens?  (I hope you
can figure out a way to stash it somewhere...)

I'm particularly interested in what the FS might do with regards to post-crash
recovery.

--D

> 
> AFAICT, you are using a pretty recent kernel. Which version exactly?
> 
> > Aborting journal on device sda2-8.
> > EXT4-fs (sda2): Remounting filesystem read-only
> > ------------[ cut here ]------------
> > WARNING: CPU: 6 PID: 4134 at fs/ext4/ext4_jbd2.c:259
> > __ext4_handle_dirty_metadata+0x18e/0x1d0()
> > Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek
> > snd_hda_codec_generic ecb uvcvideo videobuf2_vmalloc videobuf2_memops
> > videobuf2_core videodev ath3k btusb rts5139(C) ctr ccm iTCO_wdt bnep
> > rfcomm bluetooth nls_iso8859_1 vfat fat arc4 intel_rapl
> > x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> > snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm
> > aesni_intel aes_x86_64 snd_seq_midi snd_seq_midi_event ath9k led_class
> > glue_helper ath9k_common lrw gf128mul ath9k_hw ablk_helper cryptd ath
> > mac80211 snd_rawmidi snd_seq cfg80211 radeon microcode rfkill
> > snd_timer snd_seq_device sr_mod psmouse r8169 snd cdrom i915 lpc_ich
> > soundcore ttm mii mfd_core drm_kms_helper drm intel_gtt agpgart
> > ehci_pci mei_me xhci_hcd tpm_infineon ehci_hcd video mei wmi tpm
> > backlight
> > CPU: 6 PID: 4134 Comm: gimp-2.8 Tainted: G         C    3.15.0 #6
> >  0000000000000009 ffffffff813acbdd 0000000000000000 ffffffff8103de3d
> >  ffff8802365231a0 00000000ffffffe2 0000000000000000 ffff8800b90816c0
> >  ffffffff814205a0 ffffffff8118879e 0000000000000005 ffff8802365231a0
> > Call Trace:
> >  [<ffffffff813acbdd>] ? dump_stack+0x41/0x51
> >  [<ffffffff8103de3d>] ? warn_slowpath_common+0x6d/0x90
> >  [<ffffffff8118879e>] ? __ext4_handle_dirty_metadata+0x18e/0x1d0
> >  [<ffffffff8116e130>] ? ext4_dirty_inode+0x20/0x50
> >  [<ffffffff811903e9>] ? ext4_free_blocks+0x539/0xa40
> >  [<ffffffff8118468b>] ? ext4_ext_remove_space+0x83b/0xe60
> >  [<ffffffff81186a58>] ? ext4_ext_truncate+0x98/0xc0
> >  [<ffffffff8116c985>] ? ext4_truncate+0x2b5/0x300
> >  [<ffffffff8116d3d8>] ? ext4_evict_inode+0x3d8/0x410
> >  [<ffffffff81114a46>] ? evict+0xa6/0x160
> >  [<ffffffff81109346>] ? do_unlinkat+0x186/0x2a0
> >  [<ffffffff8110e51e>] ? SyS_getdents+0xde/0x100
> >  [<ffffffff8110e1d0>] ? fillonedir+0xd0/0xd0
> >  [<ffffffff813b2626>] ? system_call_fastpath+0x1a/0x1f
> > ---[ end trace 795411398e41fbcb ]---
> > EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at
> > line 241, credits 91/91, errcode -30
> > EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at
> > line 241, credits 91/91, errcode -30<2>EXT4-fs error (device sda2) in
> > ext4_free_blocks:4867: Journal has aborted
> > EXT4-fs error (device sda2): ext4_ext_rm_leaf:2731: inode #8257653:
> > block 6520936: comm gimp-2.8: journal_dirty_metadata failed: handle
> > type 5 started at line 241, credits 91/91, errcode -30
> > EXT4-fs error (device sda2) in ext4_ext_remove_space:3018: Journal has
> > aborted EXT4-fs error (device sda2) in ext4_ext_truncate:4666: Journal has
> > aborted EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
> > has aborted
> > EXT4-fs error (device sda2) in ext4_truncate:3788: Journal has aborted
> > EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
> > has aborted
> > EXT4-fs error (device sda2) in ext4_orphan_del:2684: Journal has aborted
> > EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
> > has aborted
> 
> I did not get these errors. I suspect this may be a consequence of FS
> corruption due to a bug in etx4.
> 
> Here's why I suspect a bug:
> 
> I am running latest git head (3.16-rc3+ as of yesterday) on an ARM system with
> eMMC flash. The eMMC is formatted in SLC mode ("enhanced" mode according to
> eMMC 4.41) and "reliable-writes" are enabled, so power-cycling should not
> cause FS corruption in presence of a journal.
> 
> I can format the eMMC device either as EXT3 or EXT4 for the test. After
> formatting and writing the rootfs to the partition I can boot successfully in
> either situation. Once booted from eMMC, I start bonnie++ (to just stress the
> FS for a while), and after a minute or so the board is power-cycled while
> bonnie++ is still running.
> 
> Next time I boot the situation is this:
> 
> With EXT3: All seems fine, journal is replayed, no errors. I can repeat this as
> many times as I want, FS stays consistent.
> 
> With EXT4: After just one power cycle I start getting this:
> 
> [    7.603871] EXT4-fs error (device mmcblk0p2): ext4_mb_generate_buddy:757: group 1, 8542 clusters in bitmap, 8550 in gd; block bitmap corrupt.
> [    7.616743] JBD2: Spotted dirty metadata buffer (dev = mmcblk0p2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> 
> If I continue the test, it doesn't take long and serious corruption starts
> occurring.
> 
> Again, with EXT3 I am unable to detect any problems.
> 
> Best regards,
> 
> -- 
> David Jander
> Protonic Holland.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
