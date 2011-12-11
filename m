From: Paul Mackerras <paulus@samba.org>
Subject: Crash in __brelse with recent kernels copying sparse file
Date: Mon, 12 Dec 2011 10:29:51 +1100
Message-ID: <20111211232951.GA5380@bloggs.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:32819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1LKXap (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Dec 2011 18:30:45 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I'm seeing a repeatable crash in __brelse with recent kernels while
copying a sparse file with rsync.  I have a file that is about 12GB in
length but which occupies about 5.5GB.  I copy it with:

% rsync -avSP rhel6-root.img rhel6-root2.img

and at some point the system (a POWER7 12-core server) will crash like
this:

attempt to access beyond end of device
sda8: rw=0, want=776392648163376, limit=168558560
Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6bcb
Faulting instruction address: 0xc0000000001f5f38
cpu 0x14: Vector: 300 (Data Access) at [c000001bd1aaecf0]
    pc: c0000000001f5f38: .__brelse+0x18/0x60
    lr: c0000000002e07a4: .ext4_ext_drop_refs+0x44/0x80
    sp: c000001bd1aaef70
   msr: 9000000000009032
   dar: 6b6b6b6b6b6b6bcb
 dsisr: 40000000
  current = 0xc000001bd15b8010
  paca    = 0xc00000000ffe4600
    pid   = 19911, comm = flush-8:0
enter ? for help
[c000001bd1aaeff0] c0000000002e07a4 .ext4_ext_drop_refs+0x44/0x80
[c000001bd1aaf090] c0000000002e0c58 .ext4_ext_find_extent+0x408/0x4c0
[c000001bd1aaf180] c0000000002e145c .ext4_ext_insert_extent+0x2bc/0x14c0
[c000001bd1aaf2c0] c0000000002e3fb8 .ext4_ext_map_blocks+0x628/0x1710
[c000001bd1aaf420] c0000000002b2974 .ext4_map_blocks+0x224/0x310
[c000001bd1aaf4d0] c0000000002b7f2c .mpage_da_map_and_submit+0xbc/0x490
[c000001bd1aaf5a0] c0000000002b8688 .write_cache_pages_da+0x2c8/0x430
[c000001bd1aaf720] c0000000002b8b28 .ext4_da_writepages+0x338/0x670
[c000001bd1aaf8d0] c000000000157280 .do_writepages+0x40/0x90
[c000001bd1aaf940] c0000000001ea830 .writeback_single_inode+0xe0/0x530
[c000001bd1aafa00] c0000000001eb680 .writeback_sb_inodes+0x210/0x300
[c000001bd1aafb20] c0000000001ebc84 .__writeback_inodes_wb+0xd4/0x140
[c000001bd1aafbe0] c0000000001ebfec .wb_writeback+0x2fc/0x3e0
[c000001bd1aafce0] c0000000001ed770 .wb_do_writeback+0x2f0/0x300
[c000001bd1aafdf0] c0000000001ed848 .bdi_writeback_thread+0xc8/0x340
[c000001bd1aafed0] c0000000000c5494 .kthread+0xb4/0xc0
[c000001bd1aaff90] c000000000021f48 .kernel_thread+0x54/0x70

In other words, __brelse got passed a pointer that was obtained from a
freed object, which had been poisoned with the 0x6b6b... value (I have
SLAB configured with debugging enabled).

Digging a bit deeper, __brelse was called from ext4_ext_drop_refs, and
in that function we have path=0xc000001bba9761e8, depth=0x101, and i=5
at the time of the crash.  So it looks like path on entry to that
function was 0xc000001bba9760c8, and if I dump out memory from there
it looks like this:

c000001bba9760c8 00000000001085d3 0101000000000000  |................|
c000001bba9760d8 0000000000000000 c000001b4518cc3c  |............E..<|
c000001bba9760e8 c000001b4518cc30 0000000000000000  |....E..0........|

c000001bba9760f8 0000000000c69800 0100000000000000  |................|
c000001bba976108 0000000000000000 c000001b88063030  |..............00|
c000001bba976118 c000001b88063000 0000000000000000  |......0.........|

c000001bba976128 0000584400000005 00ff000000000000  |..XD............|
c000001bba976138 0000000000000000 c0000019395a0ff0  |............9Z..|
c000001bba976148 c0000019395a0000 0000000000000000  |....9Z..........|

c000001bba976158 0000000000000000 0000000000000000  |................|
c000001bba976168 0000000000000000 0000000000000000  |................|
c000001bba976178 0000000000000000 0000000000000000  |................|

c000001bba976188 0000000000000000 0000000000000000  |................|
c000001bba976198 0000000000000000 0000000000000000  |................|
c000001bba9761a8 0000000000000000 0000000000000000  |................|

c000001bba9761b8 0000000000000000 0000000000000000  |................|
c000001bba9761c8 d84156c5635688c0 c0000000002e0ca4  |.AV.cV..........|
c000001bba9761d8 09f911029d74e35b 6b6b6b6b6b6b6b6b  |.....t.[kkkkkkkk|

c000001bba9761e8 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000001bba9761f8 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|
c000001bba976208 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6b  |kkkkkkkkkkkkkkkk|

So, the first three entries in this array have depth = 257, 256, 255,
but clearly there are only 5 entries allocated, and we've run off the
end of the array into a following freed object.

Has anyone seen anything like this?  Any suggestions for patches to
try, or ways to debug this further?

Paul.
