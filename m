From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/6] ext4: Punch hole and DAX fixes
Date: Thu, 15 Oct 2015 11:13:11 +0200
Message-ID: <20151015091311.GA5234@quack.suse.cz>
References: <1444822227-29984-1-git-send-email-jack@suse.com>
 <20151014180604.GA31803@linux.intel.com>
 <20151014210707.GA18639@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Dave Chinner <david@fromorbit.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45871 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbbJOJNP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Oct 2015 05:13:15 -0400
Content-Disposition: inline
In-Reply-To: <20151014210707.GA18639@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-10-15 15:07:07, Ross Zwisler wrote:
> On Wed, Oct 14, 2015 at 12:06:04PM -0600, Ross Zwisler wrote:
> > On Wed, Oct 14, 2015 at 01:30:21PM +0200, Jan Kara wrote:
> > > Hello,
> > > 
> > > This series fixes a long standing problem of racing punch hole and page fault
> > > resulting in possible filesystem corruption or stale data exposure. We fix the
> > > problem by using a new inode-private rw_semaphore i_mmap_sem to synchronize
> > > page faults with truncate and punch hole operations.
> > > 
> > > When having this exclusion, the only remaining problem with DAX implementation
> > > are races between two page faults zeroing out same block concurrently (where
> > > the data written after the first fault finishes are possibly overwritten by
> > > the second fault still doing zeroing). That is dealt with by patches 5 and 6
> > > in this series where we implement block zeroing directly in ext4_map_blocks().
> > > 
> > > The patches survived xfstests run both in dax and non-dax mode.
> > > 
> > > 								Honza
> > 
> > I threw these patches in to my own test setup and was able to hit the
> > following with generic/198:
> > 
> > [   57.453855] run fstests generic/198 at 2015-10-14 11:41:21
> > [   57.585886] ------------[ cut here ]------------
> > [   57.585890] kernel BUG at fs/ext4/inode.c:3057!
> > [   57.585892] invalid opcode: 0000 [#1] SMP 
> > [   57.585894] Modules linked in: nd_pmem nd_btt nd_e820 libnvdimm
> > [   57.585898] CPU: 0 PID: 3099 Comm: aiodio_sparse2 Not tainted 4.3.0-rc4_ext4_locking+ #1
> > [   57.585899] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
> > [   57.585900] task: ffff88040ea3b400 ti: ffff8800ba5e8000 task.ti: ffff8800ba5e8000
> > [   57.585901] RIP: 0010:[<ffffffff812f7b79>]  [<ffffffff812f7b79>] ext4_dax_mmap_get_block+0x1f9/0x250
> > [   57.585906] RSP: 0000:ffff8800ba5ebc48  EFLAGS: 00010216
> > [   57.585907] RAX: 0000000000000200 RBX: ffff8800ba5ebcf8 RCX: 000000000000000c
> > [   57.585908] RDX: ffff8800ba5ebcf8 RSI: 000000000000004b RDI: ffff8801fbdb13c0
> > [   57.585909] RBP: ffff8800ba5ebca0 R08: ffffffff812f7980 R09: ffff8801fbdb15e0
> > [   57.585910] R10: 00007f7921c00000 R11: 000000000000000c R12: ffff8801fbdb13c0
> > [   57.585911] R13: 0000000000000001 R14: ffff8800b153c870 R15: 0000000000000000
> > [   57.585912] FS:  00007f7928999700(0000) GS:ffff880411000000(0000) knlGS:0000000000000000
> > [   57.585913] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   57.585914] CR2: 00007f7921c00000 CR3: 00000000bb1b5000 CR4: 00000000000406f0
> > [   57.585917] Stack:
> > [   57.585918]  ffff8800ba351000 ffff8800bafca028 0000000000000000 000002000000004b
> > [   57.585920]  ffff8800ba5ebd08 000000004edcd27a ffff8800baf47f18 ffff8801fbdb13c0
> > [   57.585922]  00007f7921c00000 ffff8800b153c870 0000000000000000 ffff8800ba5ebd90
> > [   57.585924] Call Trace:
> > [   57.585928]  [<ffffffff812a061c>] __dax_pmd_fault+0x15c/0x590
> > [   57.585931]  [<ffffffff81224d46>] ? kmem_cache_alloc+0xd6/0x210
> > [   57.585934]  [<ffffffff812f06ab>] ext4_dax_pmd_fault+0xbb/0x140
> > [   57.585936]  [<ffffffff811f6d0b>] handle_mm_fault+0x2cb/0x1960
> > [   57.585938]  [<ffffffff811f6a9a>] ? handle_mm_fault+0x5a/0x1960
> > [   57.585941]  [<ffffffff81067731>] __do_page_fault+0x191/0x3f0
> > [   57.585943]  [<ffffffff81067a5f>] trace_do_page_fault+0x4f/0x120
> > [   57.585944]  [<ffffffff8106217a>] do_async_page_fault+0x1a/0xa0
> > [   57.585947]  [<ffffffff81a23dc8>] async_page_fault+0x28/0x30
> > [   57.585948] Code: e8 3d ef ff ff 85 c0 41 89 c5 4c 89 fa be 18 0c 00 00 48 c7 c7 50 0a c3 81 78 31 e8 82 17 03 00 85 c0 44 0f 48 f0 e9 98 fe ff ff <0f> 0b be 1d 0c 00 00 48 c7 c7 f8 6e f2 81 e8 74 b6 da ff c6 05 
> > [   57.585969] RIP  [<ffffffff812f7b79>] ext4_dax_mmap_get_block+0x1f9/0x250
> > [   57.585971]  RSP <ffff8800ba5ebc48>
> > [   57.585973] ---[ end trace 356a2226c61d7104 ]---
> > 
> > I'll spend some time today trying to figure out what's going on, but thought
> > I'd let you know early in case you were already debugging this.
> > 
> > My test setup is a pair of 4 GiB PMEM partitions in a KVM guest, one for the
> > TEST_DEV and the other for the SCRATCH_DEV.  I'm setting "-o dax" with
> > MOUNT_OPTIONS:
> > 
> > # ./check generic/198
> > FSTYP         -- ext4
> > PLATFORM      -- Linux/x86_64 alara 4.3.0-rc4_ext4_locking+
> > MKFS_OPTIONS  -- /dev/pmem0p2
> > MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
> > 
> > generic/198 0s ... [failed, exit status 139] - output mismatch (see /root/xfstests/results//generic/198.out.bad)
> >     --- tests/generic/198.out	2015-10-02 10:19:36.804795880 -0600
> >     +++ /root/xfstests/results//generic/198.out.bad	2015-10-14 11:41:21.234972535 -0600
> >     @@ -1,2 +1,3 @@
> >      QA output created by 198
> >      Silence is golden.
> >     +./tests/generic/198: line 55:  3099 Segmentation fault      $AIO_TEST "$TEST_DIR/aiodio_sparse"
> >     ...
> >     (Run 'diff -u tests/generic/198.out /root/xfstests/results//generic/198.out.bad'  to see the entire diff)
> 
> It looks like the issue is that we're running through the DAX PMD fault
> path, so we are trying to map 2 MiB at once.  ext4_dax_mmap_get_block()
> enforces an assumption that it will only be called for a single block at
> a time with
> 
> 	BUG_ON(map.m_len != 1);
> 
> When running through the PMD path, though, map.m_len is 512.  I'm
> guessing that you didn't hit this in your testing because things weren't
> set up in such a way that you received PMD faults.

Yeah, actually I was running on older version of your locking fixes in
generic DAX code which completely disabled PMD faults. Furthermore I've
used ordinary ramdisk as a backing device so alignment could have been an
issue as well.

> To be able to get this to work in my setup I reserve PMEM starting at an
> aligned address (I have it at a 2GiB alignment, something smaller might be
> sufficient) and I set up my partitions to be on 1GiB alignments as well.
> There may be more precise ways to get this to to work. :)
> 
> For ease of copy and paste, my mmap param for PMEM is "memmap=8G!8G" (I
> have 16 GiB of RAM in my VM), and here is the bash function I use to set
> up my test environment:
> 
> function xfstests_init {
>         umount /dev/pmem* 2>/dev/null
>         parted -s $xfstests_dev mktable msdos
>         parted -s -a optimal $xfstests_dev mkpart Primary 1 4GiB
>         parted -s -a optimal $xfstests_dev mkpart Primary 4GiB 7GiB
> 
>         if [[ $test_fs == "xfs" ]]; then
>                 mkfs.xfs -f $TEST_DEV
>                 mkfs.xfs -f $SCRATCH_DEV
>         elif [[ $test_fs == "ext4" ]]; then
>                 mkfs.ext4 -F $TEST_DEV
>                 mkfs.ext4 -F $SCRATCH_DEV
>         elif [[ $test_fs == "ext2" ]]; then
>                 mkfs.ext2 -F $TEST_DEV
>                 mkfs.ext2 -F $SCRATCH_DEV
>         else
>                 echo "Invalid test fs '$test_fs'"
>         fi
> }

Thanks. I'll fix the bug (and recheck whether something actually depends on
that assertion) and try testing with PMD faults enabled.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
