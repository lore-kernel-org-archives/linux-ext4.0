From: Daniel Drake <dsd@laptop.org>
Subject: ext4 online resize crash
Date: Fri, 30 Mar 2012 10:08:27 -0600
Message-ID: <CAMLZHHQ=FMXAzvhE7GOCONtr8d4RB1HBx9Wbjx+01MOYuN85ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: xiaoqiangnk@gmail.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33258 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab2C3QI2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2012 12:08:28 -0400
Received: by vbbff1 with SMTP id ff1so478663vbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Mar 2012 09:08:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

ext4 online resize crashes here. It has done since I first tested it
during the 3.3-rc series. Reproducible every time.
Reproduced on linus master of today.

It fails in ext4_alloc_group_tables() :
	BUG_ON(src_group >= group_data[0].group + flex_gd->count);

------------[ cut here ]------------
kernel BUG at fs/ext4/resize.c:236!
invalid opcode: 0000 [#1] PREEMPT
Modules linked in:

Pid: 754, comm: resize2fs Not tainted 3.3.0+ #24 OLPC XO/XO
EIP: 0060:[<b050c1dc>] EFLAGS: 00010246 CPU: 0
EIP is at ext4_resize_fs+0x33e/0x7aa
EAX: 0000001e EBX: eb4d0800 ECX: 00000007 EDX: e9bf5800
ESI: 00000000 EDI: 00000000 EBP: e9d6decc ESP: e9d6de50
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
CR0: 8005003b CR2: a754a746 CR3: 39d92000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process resize2fs (pid: 754, ti=e9d6c000 task=e9d8b6c0 task.ti=e9d6c000)
Stack:
 b04b5420 e9d6def4 e942c400 0000001d 000e817f 00000000 e6121780 00000000
 00000001 00000001 00008000 00000000 000e8180 00000000 00000010 000e8000
 00000000 00000000 00000000 0000001e e9be8800 e9bf5800 0000001c 0000001d
Call Trace:
 [<b04b5420>] ? mntput_no_expire+0x27/0xe3
 [<b04f649a>] ext4_ioctl+0x726/0x850
 [<b0438a35>] ? get_parent_ip+0xb/0x31
 [<b0740196>] ? sub_preempt_count+0x81/0x8e
 [<b073de32>] ? _raw_spin_unlock_irqrestore+0x1c/0x32
 [<b055e09f>] ? __debug_check_no_obj_freed+0xe4/0x137
 [<b04f5d74>] ? ext4_bio_write_page+0x342/0x342
 [<b04adc03>] do_vfs_ioctl+0x459/0x48a
 [<b04a0873>] ? do_sys_open+0x166/0x170
 [<b04adc7a>] sys_ioctl+0x46/0x68
 [<b04a08a3>] ? sys_open+0x26/0x2e
 [<b0742610>] sysenter_do_call+0x12/0x26
Code: ff 85 c0 74 19 8b 55 d0 8b 45 d4 e8 97 fa fd ff 8b 75 8c 0f b7
96 ce 00 00 00 8d 74 10 01 8b 55 d8 8b 42 08 03 03 39 45 d0 72 02 <0f>
0b 8b 45 d0 f7 65 ac c7 45 cc 00 00 00 00 89 45 ac 8b 45 c8
EIP: [<b050c1dc>] ext4_resize_fs+0x33e/0x7aa SS:ESP 0068:e9d6de50
---[ end trace 6a35bc10f51f2ada ]---

Filesystem was created with:
	mkfs.ext4 -O dir_index,^huge_file -E resize=8G -m1 -L OLPCRoot $root_loop

If I add the following printk immediately before the BUG_ON:
    pr_info("src_group %d group %d count %d\n", src_group,
group_data[0].group, flex_gd->count);

The (complete) output is:
    src_group 29 group 29 count 1
    src_group 30 group 29 count 1
    <crash>

dumpe2fs output:

Filesystem volume name:   OLPCRoot
Last mounted on:          /
Filesystem UUID:          065cbf69-807e-4d2f-bf6d-67d79eebef89
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    journal_data_ordered user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              232000
Block count:              950272
Reserved block count:     9262
Free blocks:              440094
Free inodes:              155413
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      226
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8000
Inode blocks per group:   500
Flex block group size:    16
Filesystem created:       Sat Mar 24 18:46:36 2012
Last mount time:          Fri Mar 30 15:58:23 2012
Last write time:          Thu Mar 29 22:06:20 2012
Mount count:              16
Maximum mount count:      -1
Last checked:             Sat Mar 24 18:46:36 2012
Check interval:           0 (<none>)
Lifetime writes:          75 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      260f9726-4cbe-4147-9cf8-191517538697
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             64M
Journal length:           16384
Journal sequence:         0x0000009b
Journal start:            1


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x3375, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-227
  Block bitmap at 228 (+228), Inode bitmap at 244 (+244)
  Inode table at 260-759 (+260)
  15960 free blocks, 0 free inodes, 1662 directories
  Free blocks: 15733-15811, 16886, 16888-32767
  Free inodes:
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0x4a7c, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32995
  Block bitmap at 229 (bg #0 + 229), Inode bitmap at 245 (bg #0 + 245)
  Inode table at 760-1259 (bg #0 + 760)
  0 free blocks, 0 free inodes, 2424 directories
  Free blocks:
  Free inodes:
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0x9c9f, unused inodes 0
  Block bitmap at 230 (bg #0 + 230), Inode bitmap at 246 (bg #0 + 246)
  Inode table at 1260-1759 (bg #0 + 1260)
  0 free blocks, 0 free inodes, 698 directories
  Free blocks:
  Free inodes:
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0xeec9, unused inodes 0
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98531
  Block bitmap at 231 (bg #0 + 231), Inode bitmap at 247 (bg #0 + 247)
  Inode table at 1760-2259 (bg #0 + 1760)
  0 free blocks, 0 free inodes, 510 directories
  Free blocks:
  Free inodes:
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0xb69b, unused inodes 0
  Block bitmap at 232 (bg #0 + 232), Inode bitmap at 248 (bg #0 + 248)
  Inode table at 2260-2759 (bg #0 + 2260)
  0 free blocks, 53 free inodes, 2257 directories
  Free blocks:
  Free inodes: 39722-39774
Group 5: (Blocks 163840-196607) [ITABLE_ZEROED]
  Checksum 0xfbbb, unused inodes 6754
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-164067
  Block bitmap at 233 (bg #0 + 233), Inode bitmap at 249 (bg #0 + 249)
  Inode table at 2760-3259 (bg #0 + 2760)
  0 free blocks, 6768 free inodes, 812 directories, 6754 unused inodes
  Free blocks:
  Free inodes: 40779, 40790, 40793, 40796, 40810-40811, 40833,
40860-40863, 40865-40867, 41247-48000
Group 6: (Blocks 196608-229375) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xd23b, unused inodes 8000
  Block bitmap at 234 (bg #0 + 234), Inode bitmap at 250 (bg #0 + 250)
  Inode table at 3260-3759 (bg #0 + 3260)
  0 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks:
  Free inodes: 48001-56000
Group 7: (Blocks 229376-262143) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x272c, unused inodes 8000
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229603
  Block bitmap at 235 (bg #0 + 235), Inode bitmap at 251 (bg #0 + 251)
  Inode table at 3760-4259 (bg #0 + 3760)
  0 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks:
  Free inodes: 56001-64000
Group 8: (Blocks 262144-294911) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x026c, unused inodes 8000
  Block bitmap at 236 (bg #0 + 236), Inode bitmap at 252 (bg #0 + 252)
  Inode table at 4260-4759 (bg #0 + 4260)
  0 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks:
  Free inodes: 64001-72000
Group 9: (Blocks 294912-327679) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xe048, unused inodes 8000
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-295139
  Block bitmap at 237 (bg #0 + 237), Inode bitmap at 253 (bg #0 + 253)
  Inode table at 4760-5259 (bg #0 + 4760)
  0 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks:
  Free inodes: 72001-80000
Group 10: (Blocks 327680-360447) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xbf72, unused inodes 8000
  Block bitmap at 238 (bg #0 + 238), Inode bitmap at 254 (bg #0 + 254)
  Inode table at 5260-5759 (bg #0 + 5260)
  0 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks:
  Free inodes: 80001-88000
Group 11: (Blocks 360448-393215) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x4a65, unused inodes 8000
  Block bitmap at 239 (bg #0 + 239), Inode bitmap at 255 (bg #0 + 255)
  Inode table at 5760-6259 (bg #0 + 5760)
  0 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks:
  Free inodes: 88001-96000
Group 12: (Blocks 393216-425983) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xd728, unused inodes 8000
  Block bitmap at 240 (bg #0 + 240), Inode bitmap at 256 (bg #0 + 256)
  Inode table at 6260-6759 (bg #0 + 6260)
  6932 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 401610-401623, 417312-417329, 417535-417793,
417795-417798, 417800-418625, 418683, 418750-418751, 418791,
418810-418815, 420061, 420173-420355, 420357-420867, 420869-421379,
421381-421891, 421893, 421895-422399, 422406-425983
  Free inodes: 96001-104000
Group 13: (Blocks 425984-458751) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xdaf4, unused inodes 8000
  Block bitmap at 241 (bg #0 + 241), Inode bitmap at 257 (bg #0 + 257)
  Inode table at 6760-7259 (bg #0 + 6760)
  14873 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 443879-458751
  Free inodes: 104001-112000
Group 14: (Blocks 458752-491519) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x4691, unused inodes 8000
  Block bitmap at 242 (bg #0 + 242), Inode bitmap at 258 (bg #0 + 258)
  Inode table at 7260-7759 (bg #0 + 7260)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 458752-491519
  Free inodes: 112001-120000
Group 15: (Blocks 491520-524287) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xb386, unused inodes 8000
  Block bitmap at 243 (bg #0 + 243), Inode bitmap at 259 (bg #0 + 259)
  Inode table at 7760-8259 (bg #0 + 7760)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 491520-524287
  Free inodes: 120001-128000
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0x13b4, unused inodes 0
  Block bitmap at 524288 (+0), Inode bitmap at 524304 (+16)
  Inode table at 524320-524819 (+32)
  18654 free blocks, 0 free inodes, 1869 directories
  Free blocks: 538402-557055
  Free inodes:
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0x4522, unused inodes 0
  Block bitmap at 524289 (bg #16 + 1), Inode bitmap at 524305 (bg #16 + 17)
  Inode table at 524820-525319 (bg #16 + 532)
  0 free blocks, 0 free inodes, 1947 directories
  Free blocks:
  Free inodes:
Group 18: (Blocks 589824-622591) [ITABLE_ZEROED]
  Checksum 0x31d3, unused inodes 0
  Block bitmap at 524290 (bg #16 + 2), Inode bitmap at 524306 (bg #16 + 18)
  Inode table at 525320-525819 (bg #16 + 1032)
  0 free blocks, 0 free inodes, 464 directories
  Free blocks:
  Free inodes:
Group 19: (Blocks 622592-655359) [ITABLE_ZEROED]
  Checksum 0x6ead, unused inodes 0
  Block bitmap at 524291 (bg #16 + 3), Inode bitmap at 524307 (bg #16 + 19)
  Inode table at 525820-526319 (bg #16 + 1532)
  23683 free blocks, 0 free inodes, 729 directories
  Free blocks: 631165-631295, 631808-655359
  Free inodes:
Group 20: (Blocks 655360-688127) [ITABLE_ZEROED]
  Checksum 0x48ee, unused inodes 4591
  Block bitmap at 524292 (bg #16 + 4), Inode bitmap at 524308 (bg #16 + 20)
  Inode table at 526320-526819 (bg #16 + 2032)
  32768 free blocks, 4591 free inodes, 2453 directories, 4591 unused inodes
  Free blocks: 655360-688127
  Free inodes: 163410-168000
Group 21: (Blocks 688128-720895) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x3e6e, unused inodes 8000
  Block bitmap at 524293 (bg #16 + 5), Inode bitmap at 524309 (bg #16 + 21)
  Inode table at 526820-527319 (bg #16 + 2532)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 688128-720895
  Free inodes: 168001-176000
Group 22: (Blocks 720896-753663) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x59ba, unused inodes 8000
  Block bitmap at 524294 (bg #16 + 6), Inode bitmap at 524310 (bg #16 + 22)
  Inode table at 527320-527819 (bg #16 + 3032)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 720896-753663
  Free inodes: 176001-184000
Group 23: (Blocks 753664-786431) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x8370, unused inodes 8000
  Block bitmap at 524295 (bg #16 + 7), Inode bitmap at 524311 (bg #16 + 23)
  Inode table at 527820-528319 (bg #16 + 3532)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 753664-786431
  Free inodes: 184001-192000
Group 24: (Blocks 786432-819199) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x2fb2, unused inodes 8000
  Block bitmap at 524296 (bg #16 + 8), Inode bitmap at 524312 (bg #16 + 24)
  Inode table at 528320-528819 (bg #16 + 4032)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 786432-819199
  Free inodes: 192001-200000
Group 25: (Blocks 819200-851967) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x93ca, unused inodes 8000
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-819427
  Block bitmap at 524297 (bg #16 + 9), Inode bitmap at 524313 (bg #16 + 25)
  Inode table at 528820-529319 (bg #16 + 4532)
  32540 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 819428-851967
  Free inodes: 200001-208000
Group 26: (Blocks 851968-884735) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x7f73, unused inodes 8000
  Block bitmap at 524298 (bg #16 + 10), Inode bitmap at 524314 (bg #16 + 26)
  Inode table at 529320-529819 (bg #16 + 5032)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 851968-884735
  Free inodes: 208001-216000
Group 27: (Blocks 884736-917503) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x2ed4, unused inodes 8000
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-884963
  Block bitmap at 524299 (bg #16 + 11), Inode bitmap at 524315 (bg #16 + 27)
  Inode table at 529820-530319 (bg #16 + 5532)
  32540 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 884964-917503
  Free inodes: 216001-224000
Group 28: (Blocks 917504-950271) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x4366, unused inodes 8000
  Block bitmap at 524300 (bg #16 + 12), Inode bitmap at 524316 (bg #16 + 28)
  Inode table at 530320-530819 (bg #16 + 6032)
  32768 free blocks, 8000 free inodes, 0 directories, 8000 unused inodes
  Free blocks: 917504-950271
  Free inodes: 224001-232000

Happy to test patches!

Thanks,
Daniel
