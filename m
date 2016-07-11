From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [RFC PATCH] ext4: validate number of meta clusters in group
Date: Mon, 11 Jul 2016 20:50:57 +0200
Message-ID: <5783EA91.30402@oracle.com>
References: <57766AE1.1040508@oracle.com>
 <20160702074903.GA4914@birch.djwong.org> <577EB740.10502@oracle.com>
 <20160711025153.GO26097@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160711025153.GO26097@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 07/11/2016 04:51 AM, Theodore Ts'o wrote:
> On Thu, Jul 07, 2016 at 10:10:40PM +0200, Vegard Nossum wrote:
>>
>> I ran into a second problem (this time it was num_clusters_in_group()
>> returning a bogus value) with the same symptoms (random memory
>> corruptions), the new attached patch fixes both problems by checking the
>> values at mount time.
>
> Can you give me a dumpe2fs -h of a file system that is causing
> num_clusters_in_group() to be bogus?
>
> I want to make sure I'm checking that correct base values, insteda of
> doing a brute force loop over all of the block groups and calling
> ext4_num_clusters_in_group() and ext4_num_base_meta_clusters() for all
> block groups.
>
> Thanks!!

It's sbi->s_es->s_reserved_gdt_blocks:

$ dumpe2fs -h input/da33000e751e26880ba5c2ee31e871b99f3d12e4.full
dumpe2fs 1.42.9 (4-Feb-2014)
Filesystem volume name:   <none>
Last mounted on:          /home/vegard/kernel-fuzzing-v1.0-pre1/mnt
Filesystem UUID:          c54d8f19-a95c-41b0-8e9a-2e612005ef76
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      dir_prealloc filetype extent flex_bg 
sparse_super huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    journal_data_writeback debug bsdgroups 
user_xattr acl uid16 nobarrier block_validity discard nodelalloc 
MNTOPT_12 MNTOPT_13 MNTOPT_14 MNTOPT_16 MNTOPT_17 MNTOPT_18 MNTOPT_19 
MNTOPT_20 MNTOPT_21 MNTOPT_22 MNTOPT_24 MNTOPT_25 MNTOPT_26 MNTOPT_27 
MNTOPT_28 MNTOPT_29 MNTOPT_30
Filesystem state:         not clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              4096
Block count:              16384
Reserved block count:     819
Free blocks:              0
Free inodes:              0
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      65535
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         2048
Inode blocks per group:   256
RAID stripe width:        3
First meta block group:   2139062143
Flex block group size:    16
Filesystem created:       Tue Oct 13 17:55:43 2037
Last mount time:          Mon Jul 11 20:27:01 2016
Last write time:          Mon Jul 11 20:27:01 2016
Mount count:              2
Maximum mount count:      -1
Last checked:             Wed Jul  6 11:18:12 2016
Check interval:           0 (<none>)
Lifetime writes:          1213 kB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               128
Journal inode:            8
Default directory hash:   HASHALG_127
Directory Hash Seed:      7f7f7f7f-7f7f-7f7f-7f7f-7f7f7f7f7f7f
Journal backup:           type 127

With this patch:

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3020fd7..87655c6 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -208,6 +208,8 @@ static int ext4_init_block_bitmap(struct super_block 
*sb,
         memset(bh->b_data, 0, sb->s_blocksize);

         bit_max = ext4_num_base_meta_clusters(sb, block_group);
+       printk(KERN_ERR "kernel BUG: %llu > %llu\n", bit_max, 
sb->s_blocksize * 8);
+       BUG_ON(bit_max > sb->s_blocksize * 8);
         for (bit = 0; bit < bit_max; bit++)
                 ext4_set_bit(bit, bh->b_data);

I'm getting:

[EXT4 FS bs=1024, gc=2, bpg=8192, ipg=2048, mo=e000e02c, mo2=0002]
System zones: 1-2, 67-67, 98-609, 4179-4179, 5714-5714, 8193-8194
EXT4-fs (loop0): mounting with "discard" option, but the device does not 
support discard
EXT4-fs (loop0): mounted filesystem without journal. Opts: errors=remount-ro
kernel BUG: 65537 > 8192
------------[ cut here ]------------
kernel BUG at fs/ext4/balloc.c:212!
invalid opcode: 0000 [#1]
CPU: 0 PID: 53 Comm: ext4.exe Not tainted 4.7.0-rc5+ #638
task: ffff8800003354c0 ti: ffff880000338000 task.ti: ffff880000338000
RIP: 0010:[<ffffffff810fbd20>]  [<ffffffff810fbd20>] 
ext4_read_block_bitmap_nowait+0x590/0x5a0
RSP: 0018:ffff88000033b8b8  EFLAGS: 00010202
RAX: 0000000000002000 RBX: ffff880000301800 RCX: ffffffff81629200
RDX: 0000000000010001 RSI: 0000000000000246 RDI: 0000000000000246
RBP: ffff88000033b8f8 R08: 0000000000000400 R09: 0000000000000006
R10: ffffffff8170f144 R11: 000000000000008d R12: ffff880000353800
R13: 0000000000000000 R14: 0000000000010001 R15: ffff8800070185b0
FS:  00007f8056697780(0000) GS:ffffffff81621000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000060b000 CR3: 000000000031d000 CR4: 00000000000006b0
Stack:
  0000000002408840 0000000000000004 ffff880000301000 0000000000000000
  ffff88000027c260 ffffea000000af70 0000000000000000 ffff880000301800
  ffff88000033b980 ffffffff8112993d ffffea000000af70 ffffffff8107faed
Call Trace:
  [<ffffffff8112993d>] ext4_mb_init_cache+0x14d/0x5e0
  [<ffffffff8107faed>] ? add_to_page_cache_lru+0x7d/0xf0
  [<ffffffff81129f15>] ext4_mb_init_group+0x145/0x270
  [<ffffffff8112a5d8>] ext4_mb_load_buddy_gfp+0x408/0x480
  [<ffffffff8112e595>] ext4_free_blocks+0x315/0x9c0
  [<ffffffff8113236c>] ext4_clear_blocks+0x18c/0x260
  [<ffffffff81132555>] ext4_free_data+0x115/0x160
  [<ffffffff8113367a>] ext4_ind_truncate+0x2aa/0x330
  [<ffffffff8112dc2d>] ? ext4_discard_preallocations+0x11d/0x380
  [<ffffffff81049fd3>] ? __might_sleep+0x43/0x80
  [<ffffffff81107795>] ext4_truncate+0x2a5/0x2f0
  [<ffffffff8110844f>] ext4_direct_IO+0x4ff/0x5c0
  [<ffffffff8108242f>] generic_file_direct_write+0x9f/0x150
  [<ffffffff81082784>] __generic_file_write_iter+0xb4/0x1e0
  [<ffffffff81049fd3>] ? __might_sleep+0x43/0x80
  [<ffffffff810fdc8b>] ext4_file_write_iter+0x11b/0x320
  [<ffffffff810be81b>] ? do_filp_open+0x8b/0xd0
  [<ffffffff810b1faf>] __vfs_write+0xbf/0x120
  [<ffffffff810b2115>] vfs_write+0xa5/0x110
  [<ffffffff810b2274>] SyS_write+0x44/0xb0
  [<ffffffff8129242f>] entry_SYSCALL_64_fastpath+0x1a/0xa4
Code: 28 48 d3 ea 48 63 d2 48 0f ab 10 e9 ba fe ff ff 4c 89 e6 48 89 df 
4c 89 45 c8 45 31 f6 e8 f9 85 01 00 4c 8b 45 c8 48 89 c2 eb 95 <0f> 0b 
66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41
RIP  [<ffffffff810fbd20>] ext4_read_block_bitmap_nowait+0x590/0x5a0
  RSP <ffff88000033b8b8>
---[ end trace 12713795a17c50f4 ]---

Hope this helps,


Vegard
