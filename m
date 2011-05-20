From: Michael Guntsche <mike@it-loops.com>
Subject: Page allocation error during mount with 2.6.39
Date: Fri, 20 May 2011 11:22:22 +0200
Message-ID: <20110520111728@it-loops.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:49990
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935470Ab1ETJ3K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 05:29:10 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello list,

After upgrading to 2.6.39 I reformatted one of my partitions to ext4 to
do some testing. During a simple mount I got the following page
allocation failure, the mount succeeded though.
The problem is not really reproducible (I tried mounting several times
afterwards) but I thought I might mention it nevertheless.

Kind regards,
Michael Guntsche

mount: page allocation failure. order:5, mode:0xc0d0
Pid: 7813, comm: mount Not tainted 2.6.39 #1
Call Trace:
 [<c121391a>] ? printk+0x18/0x1a
 [<c105e2a5>] __alloc_pages_nodemask+0x419/0x5f7
 [<c105e49a>] __get_free_pages+0x17/0x28
 [<c107a3a3>] __kmalloc+0xfe/0x10e
 [<fc3dbf92>] ? ext4_count_free_inodes+0x41/0x53 [ext4]
 [<fc3ecdba>] ext4_fill_super+0x1284/0x26eb [ext4]
 [<c10b8ed6>] ? disk_name+0x51/0xa6
 [<c107ea58>] mount_bdev+0x142/0x177
 [<c10e2b00>] ? ida_get_new_above+0x155/0x1e2
 [<c10e2b43>] ? ida_get_new_above+0x198/0x1e2
 [<fc3e8578>] ext4_mount+0x1a/0x20 [ext4]
 [<fc3ebb36>] ? ext4_remount+0x416/0x416 [ext4]
 [<c107ef8b>] mount_fs+0x16/0xbb
 [<c109009c>] ? alloc_vfsmnt+0x68/0x107
 [<c109036a>] vfs_kern_mount+0x46/0x7c
 [<c1090b22>] do_kern_mount+0x34/0xb6
 [<c1091e69>] do_mount+0x424/0x689
 [<c106722d>] ? strndup_user+0x2e/0x3f
 [<c1092330>] sys_mount+0x66/0x9b
 [<c1217acd>] syscall_call+0x7/0xb
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
active_anon:35786 inactive_anon:12102 isolated_anon:0
 active_file:111413 inactive_file:189649 isolated_file:0
 unevictable:0 dirty:3 writeback:0 unstable:0
 free:246973 slab_reclaimable:130660 slab_unreclaimable:5621
 mapped:7296 shmem:955 pagetables:547 bounce:0
DMA free:3548kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:88kB inactive_file:224kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15804kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:7072kB slab_unreclaimable:120kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 865 3031 3031
Normal free:21224kB min:3728kB low:4660kB high:5592kB active_anon:4kB inactive_anon:3944kB active_file:61408kB inactive_file:60972kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:12kB writeback:0kB mapped:52kB shmem:4kB slab_reclaimable:515568kB slab_unreclaimable:22364kB kernel_stack:1264kB pagetables:2188kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 17333 17333
HighMem free:963120kB min:512kB low:2844kB high:5180kB active_anon:143140kB inactive_anon:44464kB active_file:384156kB inactive_file:697400kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2218632kB mlocked:0kB dirty:0kB writeback:0kB mapped:29132kB shmem:3816kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 13*4kB 7*8kB 47*16kB 20*32kB 2*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 3548kB
Normal: 4148*4kB 421*8kB 41*16kB 11*32kB 2*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 21224kB
HighMem: 566*4kB 323*8kB 154*16kB 57*32kB 26*64kB 6*128kB 3*256kB 1*512kB 52*1024kB 80*2048kB 179*4096kB = 963120kB
302083 total pagecache pages
68 pages in swap cache
Swap cache stats: add 70, delete 2, find 3/3
Free swap  = 524012kB
Total swap = 524284kB
786336 pages RAM
559026 pages HighMem
7375 pages reserved
214978 pages shared
354410 pages non-shared
EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
