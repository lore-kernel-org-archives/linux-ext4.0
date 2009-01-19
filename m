From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 tree backports for 2.6.27.10 and 2.6.28
Date: Mon, 19 Jan 2009 17:03:00 +0530
Message-ID: <20090119113300.GC9482@skywalker>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759546AbZASLdX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 17, 2009 at 01:43:55PM -0500, Theodore Ts'o wrote:
> 
> I've created a couple of ext4 backport branches which have been uploaded
> to the ext4 git tree:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 
>    http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git
> 
> The master branch contains the latest ext4 patch queue, against Linus's
> tip; currently, this is versus 2.6.29-rc2.  The 'for_linus' tag is
> located on this branch, and currently contains a number of urgent fixes
> that I plan to be pushing to Linus after he gets back from
> linux.conf.au.  They are mostly fixes that prevent OOPS or cpu lockups
> when ext4 mounts an intentionally corrupted filesystem.
> 
> The ext4-stable branch is based off of 2.6.28, and contains all of the
> patches which were pushed to linus during the 2.6.29-rc1 merge window,
> plus the fixes listed above in the 'master' branch.  It is designed for
> people who want the very latest in the ext4 tree versus a stable kernel.
> 
> The for-stable branch is currently based off of 2.6.28, and contains a
> candidate set of patches to be included in the 2.6.28.y stable tree.
> Ext4 developers --- I would appreciate it if you could review the
> patches on the ext4-stable tree, and see if I missed any patches which
> in your opinion should be pushed to the 2.6.28.y tree.  Furthermore, if
> some folks could test the for-stable branch and let me know whether or
> not you found it stable, I would appreciate it.  Some of the patches
> were relatively painful to backport, given the desire to remove
> "non-critical" patches, so I'm not 100% certain I got the backports
> completely right.  Please test!
> 
> The for-stable-2.6.27 is currently based off of 2.6.27.11, and it
> contains a candidate set of patches to be incuded in the 2.6.27.y tree.
> It was even more difficult to backport these patches to 2.6.27.y, and so
> I would **really** appreciate if some folks could review and test this
> branch.  In addition, a number of changes (in particular some of
> Aneesh's resize race condition patches) were painful enough that I
> decided to abort and not try to do the backport.  It was late, and I was
> getting tired....  If someone would like to try to backport some of
> these missing patches, I would appreciate it; Aneesh, you might have
> better luck since they were originally your patches, and they were
> complicated enough that I was worried that there might have been
> prerequisites that I had missed so they would function correctly.
> 
> The patch backports can be summarized in this table below.  It contains
> the original mainline commit ID, the commit ID in the 2.6.28 for-stable
> branch, and the commit ID in the for-stable-2.6.27 branch.  If you see
> "-----" in the column for the 2.6.27-stable column, those were patches
> which I did not backport due to lack of valor/courage at 11pm at night.
> 
>       	    		     	     	- Ted
> 
> mainline 2.6.28  2.6.27
>     commit-description
> -------------------------------------------------------------------------
> f99b2589 485f02f 11599d0
>     ext4: Add support for non-native signed/unsigned htree hash algorithms
> 
> 2a21e37e 7426272 8443aef
>     ext4: tone down ext4_da_writepages warnings
> 
> 791b7f08 2efd58c c7eef47
>     ext4: Fix the delalloc writepages to allocate blocks at the right offset.
> 
> 565a9617 ce99b0d b2a193d
>     ext4: avoid ext4_error when mounting a fs with a single bg
> 
> ff7ef329 3a04ef3 626e5b9
>     ext4: Widen type of ext4_sb_info.s_mb_maxs[]
> 
> fd98496f f97e641 dc270b3
>     jbd2: Add barrier not supported test to journal_wait_on_commit_record
> 
> 032115fc b9475aa c1944c2
>     ext4: Don't overwrite allocation_context ac_status
> 
> e21675d4 c31a2b2 -----
>     ext4: Add blocks added during resize to bitmap

Will send the patch as a reply to this mail to linux-ext4 

> 
> 920313a7 2a4f6ca -----
>     ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize

Will send the patch as a reply to this mail to linux-ext4 

> 
> c3a326a6 66364e6 24a5c92
>     ext4: cleanup mballoc header files
> 
> 7a2fcbf7 39a0b8b -----
>     ext4: don't use blocks freed but not yet committed in buddy cache init

This would need the patch "use rb-tree for free blocks tracking".
Will send the patch as a reply to this mail to linux-ext4 

>     
> e8134b27 83a082c c712c85
>     ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
> 
> 39341867 8e53df4 4d3302c
>     ext4: Fix the race between read_inode_bitmap() and ext4_new_inode()
> 
> e97fcd95 20d6100 7e081e8
>     jbd2: Add BH_JBDPrivateStart
> 
> 2ccb5fb9 92f1c0e -----
>     ext4: Use new buffer_head flag to check uninit group bitmaps initialization

Will send the patch as a reply to this mail to linux-ext4 

> 
> 648f5879 51eef9f 469a48a
>     ext4: mark the blocks/inode bitmap beyond end of group as used
> 
> 8556e8f3 5a2c7ad 686beef
>     ext4: Don't allow new groups to be added during block allocation
> 
> 29eaf024 39d994e 0c56383
>     ext4: Init the complete page while building buddy cache
> 
> 0087d9fb 808dfdb -----
>     ext4: Fix s_dirty_blocks_counter if block allocation failed with nodelalloc

2.6.27 doesn't have  ext4: Add percpu dirty block accounting. So we
won't need this patch.

> 
> 4ec11028 cf7da20 -----
>     ext4: Add sanity checks for the superblock before mounting the filesystem

-aneesh
