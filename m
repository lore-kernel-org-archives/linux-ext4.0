From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: ext4: journal has aborted
Date: Tue, 01 Jul 2014 21:07:27 +0900
Message-ID: <53B2A47F.90903@samsung.com>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Matteo Croce <technoboy85@gmail.com>,
	David Jander <david@protonic.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52324 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGAMHa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 08:07:30 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N81006DQ8CG9ND0@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 01 Jul 2014 21:07:28 +0900 (KST)
In-reply-to: <20140701084206.GG9743@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

i have interesting for this problem..Because i also found the same problem..
Is it Journal problem?

I used the Linux version 3.16.0-rc3.

[    3.866449] EXT4-fs error (device mmcblk0p13): ext4_mb_generate_buddy:756: group 0, 20490 clusters in bitmap, 20488 in gd; block bitmap corrupt.
[    3.877937] Aborting journal on device mmcblk0p13-8.
[    3.885025] Kernel panic - not syncing: EXT4-fs (device mmcblk0p13): panic forced after error
[    3.885025]
[    3.891751] CPU: 1 PID: 1488 Comm: mv Not tainted 3.16.0-rc3-00206-gc0f4eea0-dirty #2
[    3.899594] [<c0016258>] (unwind_backtrace) from [<c00127d4>] (show_stack+0x10/0x14)
[    3.907294] [<c00127d4>] (show_stack) from [<c051f458>] (dump_stack+0x78/0xc8)
[    3.914495] [<c051f458>] (dump_stack) from [<c051cd28>] (panic+0x8c/0x1f0)
[    3.921354] [<c051cd28>] (panic) from [<c018eb38>] (ext4_handle_error+0x68/0xa8)
[    3.928730] [<c018eb38>] (ext4_handle_error) from [<c018f584>] (__ext4_grp_locked_error+0x88/0x1c0)
[    3.937759] [<c018f584>] (__ext4_grp_locked_error) from [<c01a1e04>] (ext4_mb_generate_buddy+0x260/0x398)
[    3.947306] [<c01a1e04>] (ext4_mb_generate_buddy) from [<c01a3d20>] (ext4_mb_init_cache+0x2fc/0x7fc)
[    3.956433] [<c01a3d20>] (ext4_mb_init_cache) from [<c01a43d8>] (ext4_mb_init_group+0x1b8/0x234)
[    3.965186] [<c01a43d8>] (ext4_mb_init_group) from [<c01a4950>] (ext4_mb_load_buddy+0x34c/0x380)
[    3.973952] [<c01a4950>] (ext4_mb_load_buddy) from [<c01a9918>] (ext4_free_blocks+0x47c/0xd30)
[    3.982545] [<c01a9918>] (ext4_free_blocks) from [<c019b440>] (ext4_ext_remove_space+0xae0/0x1474)
[    3.991486] [<c019b440>] (ext4_ext_remove_space) from [<c019df68>] (ext4_ext_truncate+0xb4/0xd4)
[    4.000251] [<c019df68>] (ext4_ext_truncate) from [<c0178ac4>] (ext4_truncate+0x37c/0x43c)
[    4.008497] [<c0178ac4>] (ext4_truncate) from [<c017ba90>] (ext4_evict_inode+0x334/0x4f4)
[    4.016660] [<c017ba90>] (ext4_evict_inode) from [<c01229b0>] (evict+0x94/0x158)
[    4.024036] [<c01229b0>] (evict) from [<c011f1fc>] (__dentry_kill+0x1dc/0x22c)
[    4.031238] [<c011f1fc>] (__dentry_kill) from [<c011f924>] (dput+0xa8/0x1ac)
[    4.038282] [<c011f924>] (dput) from [<c0119a1c>] (SyS_renameat2+0x250/0x36c)
[    4.045396] [<c0119a1c>] (SyS_renameat2) from [<c0119b7c>] (SyS_rename+0x28/0x30)
[    4.052859] [<c0119b7c>] (SyS_rename) from [<c000eea0>] (ret_fast_syscall+0x0/0x3c)

I used with the eMMC card. I want to know the debugging point for this problem.
If anybody have solution, let me know, plz.

Best Regards,
Jaehoon Chung

On 07/01/2014 05:42 PM, Darrick J. Wong wrote:
> On Tue, Jul 01, 2014 at 08:26:19AM +0200, David Jander wrote:
>>
>> Hi,
>>
>> On Mon, 30 Jun 2014 23:30:10 +0200
>> Matteo Croce <technoboy85@gmail.com> wrote:
>>
>>> I was web surfing and using gimp when:
>>>
>>> EXT4-fs error (device sda2): ext4_mb_generate_buddy:756: group 199,
>>> 9414 clusters in bitmap, 9500 in gd; block bitmap corrupt.
>>
>> I was about to post a related question to this list. I am also seeing these
>> kind of errors when using ext4 on latest mainline (I began testing with 3.15
>> where I saw this and now in 3.16-rc3 it is still there).
>> It happens almost instantly when power-cycling the system (unclean shutdown).
>> The next time the system boots, I get these errors.
>>
>> AFAICT, you are using a pretty recent kernel. Which version exactly?
>>
>>> Aborting journal on device sda2-8.
>>> EXT4-fs (sda2): Remounting filesystem read-only
> 
> Matteo, could you please post the full dmesg log somewhere?  I'm interested in
> what happens before all this happens, because...
> 
>>> ------------[ cut here ]------------
>>> WARNING: CPU: 6 PID: 4134 at fs/ext4/ext4_jbd2.c:259
>>> __ext4_handle_dirty_metadata+0x18e/0x1d0()
>>> Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek
>>> snd_hda_codec_generic ecb uvcvideo videobuf2_vmalloc videobuf2_memops
>>> videobuf2_core videodev ath3k btusb rts5139(C) ctr ccm iTCO_wdt bnep
>>> rfcomm bluetooth nls_iso8859_1 vfat fat arc4 intel_rapl
>>> x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
>>> snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm
>>> aesni_intel aes_x86_64 snd_seq_midi snd_seq_midi_event ath9k led_class
>>> glue_helper ath9k_common lrw gf128mul ath9k_hw ablk_helper cryptd ath
>>> mac80211 snd_rawmidi snd_seq cfg80211 radeon microcode rfkill
>>> snd_timer snd_seq_device sr_mod psmouse r8169 snd cdrom i915 lpc_ich
>>> soundcore ttm mii mfd_core drm_kms_helper drm intel_gtt agpgart
>>> ehci_pci mei_me xhci_hcd tpm_infineon ehci_hcd video mei wmi tpm
>>> backlight
>>> CPU: 6 PID: 4134 Comm: gimp-2.8 Tainted: G         C    3.15.0 #6
>>>  0000000000000009 ffffffff813acbdd 0000000000000000 ffffffff8103de3d
>>>  ffff8802365231a0 00000000ffffffe2 0000000000000000 ffff8800b90816c0
>>>  ffffffff814205a0 ffffffff8118879e 0000000000000005 ffff8802365231a0
>>> Call Trace:
>>>  [<ffffffff813acbdd>] ? dump_stack+0x41/0x51
>>>  [<ffffffff8103de3d>] ? warn_slowpath_common+0x6d/0x90
>>>  [<ffffffff8118879e>] ? __ext4_handle_dirty_metadata+0x18e/0x1d0
>>>  [<ffffffff8116e130>] ? ext4_dirty_inode+0x20/0x50
>>>  [<ffffffff811903e9>] ? ext4_free_blocks+0x539/0xa40
>>>  [<ffffffff8118468b>] ? ext4_ext_remove_space+0x83b/0xe60
>>>  [<ffffffff81186a58>] ? ext4_ext_truncate+0x98/0xc0
>>>  [<ffffffff8116c985>] ? ext4_truncate+0x2b5/0x300
>>>  [<ffffffff8116d3d8>] ? ext4_evict_inode+0x3d8/0x410
>>>  [<ffffffff81114a46>] ? evict+0xa6/0x160
>>>  [<ffffffff81109346>] ? do_unlinkat+0x186/0x2a0
>>>  [<ffffffff8110e51e>] ? SyS_getdents+0xde/0x100
>>>  [<ffffffff8110e1d0>] ? fillonedir+0xd0/0xd0
>>>  [<ffffffff813b2626>] ? system_call_fastpath+0x1a/0x1f
>>> ---[ end trace 795411398e41fbcb ]---
>>> EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at
>>> line 241, credits 91/91, errcode -30
>>> EXT4: jbd2_journal_dirty_metadata failed: handle type 5 started at
>>> line 241, credits 91/91, errcode -30<2>EXT4-fs error (device sda2) in
>>> ext4_free_blocks:4867: Journal has aborted
>>> EXT4-fs error (device sda2): ext4_ext_rm_leaf:2731: inode #8257653:
>>> block 6520936: comm gimp-2.8: journal_dirty_metadata failed: handle
>>> type 5 started at line 241, credits 91/91, errcode -30
>>> EXT4-fs error (device sda2) in ext4_ext_remove_space:3018: Journal has
>>> aborted EXT4-fs error (device sda2) in ext4_ext_truncate:4666: Journal has
>>> aborted EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
>>> has aborted
>>> EXT4-fs error (device sda2) in ext4_truncate:3788: Journal has aborted
>>> EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
>>> has aborted
>>> EXT4-fs error (device sda2) in ext4_orphan_del:2684: Journal has aborted
>>> EXT4-fs error (device sda2) in ext4_reserve_inode_write:4877: Journal
>>> has aborted
>>
>> I did not get these errors. I suspect this may be a consequence of FS
>> corruption due to a bug in etx4.
>>
>> Here's why I suspect a bug:
>>
>> I am running latest git head (3.16-rc3+ as of yesterday) on an ARM system with
>> eMMC flash. The eMMC is formatted in SLC mode ("enhanced" mode according to
>> eMMC 4.41) and "reliable-writes" are enabled, so power-cycling should not
>> cause FS corruption in presence of a journal.
>>
>> I can format the eMMC device either as EXT3 or EXT4 for the test. After
>> formatting and writing the rootfs to the partition I can boot successfully in
>> either situation. Once booted from eMMC, I start bonnie++ (to just stress the
>> FS for a while), and after a minute or so the board is power-cycled while
>> bonnie++ is still running.
>>
>> Next time I boot the situation is this:
>>
>> With EXT3: All seems fine, journal is replayed, no errors. I can repeat this as
>> many times as I want, FS stays consistent.
>>
>> With EXT4: After just one power cycle I start getting this:
>>
>> [    7.603871] EXT4-fs error (device mmcblk0p2): ext4_mb_generate_buddy:757: group 1, 8542 clusters in bitmap, 8550 in gd; block bitmap corrupt.
>> [    7.616743] JBD2: Spotted dirty metadata buffer (dev = mmcblk0p2, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
> 
> I've been seeing this same set of symptoms with 3.15.0 on various SSDs (Samsung
> 840 Pro, Crucial M4).  It seems that something (upstart?) is holding open some
> file or other during poweroff, which means that the root fs can't be unmounted
> or even remounted rw.  I also noticed that the next time the system comes up,
> the kernel tells me that it has to process the inode orphan list as part of
> recovery.
> 
> Shortly after the orphan list gets processed, I get that message and the FS
> goes ro.  A subsequent fsck run reveals that the block bitmap is indeed
> incorrect in that block group, and when I bd the blocks that are incorrect in
> the bitmap, I see what could be some kind of upstart log file.  Either way, I
> suspect some bug in orphan processing.
> 
> <shrug> I don't know if this is specific to SSDs or spinning rust.  Right now
> I've simply rigged the initramfs to e2fsck -p the root fs before mounting it,
> which seems(?) to have patched around it for now.
> 
>> If I continue the test, it doesn't take long and serious corruption starts
>> occurring.
> 
> You're getting actual FS data corruption too?  Or more of those messages?
> 
> --D
>>
>> Again, with EXT3 I am unable to detect any problems.
>>
>> Best regards,
>>
>> -- 
>> David Jander
>> Protonic Holland.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

