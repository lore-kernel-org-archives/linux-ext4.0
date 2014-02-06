From: Jon Bernard <jbernard@tuxion.com>
Subject: Re: kernel bug at fs/ext4/resize.c:409
Date: Thu, 6 Feb 2014 16:08:44 -0500
Message-ID: <20140206210844.GA4335@helmut>
References: <20140203182634.GA28811@shaniqua>
 <20140203185633.GA22856@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51537 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754348AbaBFVJR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Feb 2014 16:09:17 -0500
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 1503A20804
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 16:09:16 -0500 (EST)
Received: from localhost (unknown [108.15.197.135])
	by mail.messagingengine.com (Postfix) with ESMTPA id A31CF680296
	for <linux-ext4@vger.kernel.org>; Thu,  6 Feb 2014 16:08:48 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20140203185633.GA22856@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Feb 03, 2014 at 01:26:34PM -0500, Jon Bernard wrote:
> > Hello all,
> > 
> > A coworker is seeing the following bug when attempting to resize a root
> > volume (during init by calling resizefs) from 1GB to the size of the
> > underlying partition size of 20GB.
> > 
> > If the partition size is changed (to i.e. 10GB), the bug seems to not
> > trigger.  I have access to this machine, if there are any experiments
> > that would provide more useful information - please let me know.
> 
> Here are three questions to start:
> 
> 1)  What kernel version was this oops coming from?

3.12.9-301.fc20.x86_64

> 2)  Could you please send me the output of dumpe2fs of the file system?

Dump attached.

> 3)  Can you reproduce the problem?

It happens every time with this particular filesystem image.  A new
image built with slightly different variables (size, contents, etc)
usually yields a filesystem that behaves correctly.  But once they have
a bad one, it breaks on resize every time.

Let me know if I can provide any other information.  I have access to
the machine for some time, so I can run a modified kernel or module and
post results if that would help.

Thanks,

-- 
Jon

--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dump.txt"

Filesystem volume name:   cloudimg-rootfs
Last mounted on:          /
Filesystem UUID:          942e3be7-4655-4250-8de4-7e6ffb5595e2
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              1080816
Block count:              1080688
Reserved block count:     54034
Free blocks:              338604
Free inodes:              948273
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         32752
Inode blocks per group:   2047
Flex block group size:    16
Filesystem created:       Mon Feb  3 15:25:08 2014
Last mount time:          Thu Feb  6 18:41:42 2014
Last write time:          Thu Feb  6 18:41:41 2014
Mount count:              18
Maximum mount count:      -1
Last checked:             Mon Feb  3 15:25:08 2014
Check interval:           0 (<none>)
Lifetime writes:          69 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       19343
Default directory hash:   half_md4
Directory Hash Seed:      8f043eea-0268-4208-9167-34286deca46f
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             64M
Journal length:           16384
Journal sequence:         0x00000030
Journal start:            1


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0xf064, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-1025
  Block bitmap at 1026 (+1026), Inode bitmap at 1042 (+1042)
  Inode table at 1058-3104 (+1058)
  0 free blocks, 0 free inodes, 5537 directories
  Free blocks: 
  Free inodes: 
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0xfcf6, unused inodes 12736
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-33793
  Block bitmap at 1027 (bg #0 + 1027), Inode bitmap at 1043 (bg #0 + 1043)
  Inode table at 3105-5151 (bg #0 + 3105)
  0 free blocks, 12736 free inodes, 565 directories, 12736 unused inodes
  Free blocks: 
  Free inodes: 52769-65504
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x2191, unused inodes 30532
  Block bitmap at 1028 (bg #0 + 1028), Inode bitmap at 1044 (bg #0 + 1044)
  Inode table at 5152-7198 (bg #0 + 5152)
  0 free blocks, 30532 free inodes, 2220 directories, 30532 unused inodes
  Free blocks: 
  Free inodes: 67725-98256
Group 3: (Blocks 98304-131071) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xec2b, unused inodes 32752
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-99329
  Block bitmap at 1029 (bg #0 + 1029), Inode bitmap at 1045 (bg #0 + 1045)
  Inode table at 7199-9245 (bg #0 + 7199)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 98257-131008
Group 4: (Blocks 131072-163839) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xf126, unused inodes 32752
  Block bitmap at 1030 (bg #0 + 1030), Inode bitmap at 1046 (bg #0 + 1046)
  Inode table at 9246-11292 (bg #0 + 9246)
  132 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 157084-157087, 157184-157311
  Free inodes: 131009-163760
Group 5: (Blocks 163840-196607) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x374c, unused inodes 32752
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-164865
  Block bitmap at 1031 (bg #0 + 1031), Inode bitmap at 1047 (bg #0 + 1047)
  Inode table at 11293-13339 (bg #0 + 11293)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 163761-196512
Group 6: (Blocks 196608-229375) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xa529, unused inodes 32752
  Block bitmap at 1032 (bg #0 + 1032), Inode bitmap at 1048 (bg #0 + 1048)
  Inode table at 13340-15386 (bg #0 + 13340)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 196513-229264
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x496e, unused inodes 32752
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-230401
  Block bitmap at 1033 (bg #0 + 1033), Inode bitmap at 1049 (bg #0 + 1049)
  Inode table at 15387-17433 (bg #0 + 15387)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 229265-262016
Group 8: (Blocks 262144-294911) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xa147, unused inodes 32752
  Block bitmap at 1034 (bg #0 + 1034), Inode bitmap at 1050 (bg #0 + 1050)
  Inode table at 17434-19480 (bg #0 + 17434)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 262017-294768
Group 9: (Blocks 294912-327679) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x06e4, unused inodes 32752
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-295937
  Block bitmap at 1035 (bg #0 + 1035), Inode bitmap at 1051 (bg #0 + 1051)
  Inode table at 19481-21527 (bg #0 + 19481)
  2 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 305491-305492
  Free inodes: 294769-327520
Group 10: (Blocks 327680-360447) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x53e4, unused inodes 32752
  Block bitmap at 1036 (bg #0 + 1036), Inode bitmap at 1052 (bg #0 + 1052)
  Inode table at 21528-23574 (bg #0 + 21528)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 327521-360272
Group 11: (Blocks 360448-393215) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x2764, unused inodes 32752
  Block bitmap at 1037 (bg #0 + 1037), Inode bitmap at 1053 (bg #0 + 1053)
  Inode table at 23575-25621 (bg #0 + 23575)
  52 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 385319, 385339, 385473, 386011, 386047, 386055, 386065, 386103, 386121, 386141, 386471, 386603, 386615, 386639, 386647, 386679, 386705, 386723, 386731, 386761, 386785, 386797, 386993, 387001, 387023, 387321, 388387, 388555, 388683, 388717, 388743, 389071, 389107, 389155, 389173, 389195, 389295, 389735, 390187, 390223, 390783, 390945, 390987, 391015, 391127, 392079, 392581, 392593, 392611, 392903, 393027, 393087
  Free inodes: 360273-393024
Group 12: (Blocks 393216-425983) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xb54a, unused inodes 32752
  Block bitmap at 1038 (bg #0 + 1038), Inode bitmap at 1054 (bg #0 + 1054)
  Inode table at 25622-27668 (bg #0 + 25622)
  10189 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 397607, 397623, 397635, 397743, 398211, 398543, 398591, 398717, 398759, 399111, 399263, 399343, 400071, 400143, 400203, 400211, 400219, 400241, 400319, 402071, 402379, 402431, 402731, 402763, 402771, 402839, 402859, 402867, 403057, 403079, 403091, 403147, 403433-403455, 415819-416255, 416271, 416273, 416277-416280, 416285-416287, 416291-416313, 416319-425983
  Free inodes: 393025-425776
Group 13: (Blocks 425984-458751) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xedd5, unused inodes 32752
  Block bitmap at 1039 (bg #0 + 1039), Inode bitmap at 1055 (bg #0 + 1055)
  Inode table at 27669-29715 (bg #0 + 27669)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 425984-458751
  Free inodes: 425777-458528
Group 14: (Blocks 458752-491519) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x3f13, unused inodes 32752
  Block bitmap at 1040 (bg #0 + 1040), Inode bitmap at 1056 (bg #0 + 1056)
  Inode table at 29716-31762 (bg #0 + 29716)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 458752-491519
  Free inodes: 458529-491280
Group 15: (Blocks 491520-524287) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x5e51, unused inodes 32752
  Block bitmap at 1041 (bg #0 + 1041), Inode bitmap at 1057 (bg #0 + 1057)
  Inode table at 33794-35840 (bg #1 + 1026)
  16384 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 507904-524287
  Free inodes: 491281-524032
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0x7c5f, unused inodes 0
  Block bitmap at 524288 (+0), Inode bitmap at 524304 (+16)
  Inode table at 524320-526366 (+32)
  0 free blocks, 0 free inodes, 2275 directories
  Free blocks: 
  Free inodes: 
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0x1b57, unused inodes 0
  Block bitmap at 524289 (bg #16 + 1), Inode bitmap at 524305 (bg #16 + 17)
  Inode table at 526367-528413 (bg #16 + 2079)
  0 free blocks, 0 free inodes, 3615 directories
  Free blocks: 
  Free inodes: 
Group 18: (Blocks 589824-622591) [ITABLE_ZEROED]
  Checksum 0x2677, unused inodes 22195
  Block bitmap at 524290 (bg #16 + 2), Inode bitmap at 524306 (bg #16 + 18)
  Inode table at 528414-530460 (bg #16 + 4126)
  0 free blocks, 22196 free inodes, 826 directories, 22195 unused inodes
  Free blocks: 
  Free inodes: 600087, 600094-622288
Group 19: (Blocks 622592-655359) [ITABLE_ZEROED]
  Checksum 0x89be, unused inodes 31008
  Block bitmap at 524291 (bg #16 + 3), Inode bitmap at 524307 (bg #16 + 19)
  Inode table at 530461-532507 (bg #16 + 6173)
  0 free blocks, 31008 free inodes, 1744 directories, 31008 unused inodes
  Free blocks: 
  Free inodes: 624033-655040
Group 20: (Blocks 655360-688127) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x3b1a, unused inodes 32752
  Block bitmap at 524292 (bg #16 + 4), Inode bitmap at 524308 (bg #16 + 20)
  Inode table at 532508-534554 (bg #16 + 8220)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 655041-687792
Group 21: (Blocks 688128-720895) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xd75d, unused inodes 32752
  Block bitmap at 524293 (bg #16 + 5), Inode bitmap at 524309 (bg #16 + 21)
  Inode table at 534555-536601 (bg #16 + 10267)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 687793-720544
Group 22: (Blocks 720896-753663) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x051e, unused inodes 32752
  Block bitmap at 524294 (bg #16 + 6), Inode bitmap at 524310 (bg #16 + 22)
  Inode table at 536602-538648 (bg #16 + 12314)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 720545-753296
Group 23: (Blocks 753664-786431) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x1a1c, unused inodes 32752
  Block bitmap at 524295 (bg #16 + 7), Inode bitmap at 524311 (bg #16 + 23)
  Inode table at 538649-540695 (bg #16 + 14361)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 753297-786048
Group 24: (Blocks 786432-819199) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xb213, unused inodes 32752
  Block bitmap at 524296 (bg #16 + 8), Inode bitmap at 524312 (bg #16 + 24)
  Inode table at 540696-542742 (bg #16 + 16408)
  0 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 
  Free inodes: 786049-818800
Group 25: (Blocks 819200-851967) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x79b0, unused inodes 32752
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-820225
  Block bitmap at 524297 (bg #16 + 9), Inode bitmap at 524313 (bg #16 + 25)
  Inode table at 542743-544789 (bg #16 + 18455)
  20736 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 827392-835583, 839075-839091, 839140-839536, 839809-840191, 840193-840196, 840198, 840201, 840207, 840214-840217, 840219-840221, 840223-840231, 840237, 840239, 840246-851967
  Free inodes: 818801-851552
Group 26: (Blocks 851968-884735) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x0506, unused inodes 32752
  Block bitmap at 524298 (bg #16 + 10), Inode bitmap at 524314 (bg #16 + 26)
  Inode table at 544790-546836 (bg #16 + 20502)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 851968-884735
  Free inodes: 851553-884304
Group 27: (Blocks 884736-917503) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x049f, unused inodes 32752
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-885761
  Block bitmap at 524299 (bg #16 + 11), Inode bitmap at 524315 (bg #16 + 27)
  Inode table at 546837-548883 (bg #16 + 22549)
  31742 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 885762-917503
  Free inodes: 884305-917056
Group 28: (Blocks 917504-950271) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xe183, unused inodes 32752
  Block bitmap at 524300 (bg #16 + 12), Inode bitmap at 524316 (bg #16 + 28)
  Inode table at 548884-550930 (bg #16 + 24596)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 917504-950271
  Free inodes: 917057-949808
Group 29: (Blocks 950272-983039) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x0dc4, unused inodes 32752
  Block bitmap at 524301 (bg #16 + 13), Inode bitmap at 524317 (bg #16 + 29)
  Inode table at 550931-552977 (bg #16 + 26643)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 950272-983039
  Free inodes: 949809-982560
Group 30: (Blocks 983040-1015807) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xdf87, unused inodes 32752
  Block bitmap at 524302 (bg #16 + 14), Inode bitmap at 524318 (bg #16 + 30)
  Inode table at 552978-555024 (bg #16 + 28690)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 983040-1015807
  Free inodes: 982561-1015312
Group 31: (Blocks 1015808-1048575) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xc085, unused inodes 32752
  Block bitmap at 524303 (bg #16 + 15), Inode bitmap at 524319 (bg #16 + 31)
  Inode table at 555025-557071 (bg #16 + 30737)
  32768 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 1015808-1048575
  Free inodes: 1015313-1048064
Group 32: (Blocks 1048576-1080687) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x4600, unused inodes 32752
  Block bitmap at 1048576 (+0), Inode bitmap at 1048592 (+16)
  Inode table at 1048608-1050654 (+32)
  30063 free blocks, 32752 free inodes, 0 directories, 32752 unused inodes
  Free blocks: 1048577-1048591, 1048593-1048607, 1050655-1080687
  Free inodes: 1048065-1080816

--WIyZ46R2i8wDzkSu--
