From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 00/10 v5] ext4: extent status tree (step2)
Date: Sun, 10 Feb 2013 16:40:07 +0800
Message-ID: <20130210084007.GA14075@gmail.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <20130210013857.GA8526@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Jan kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60499 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3BJIZx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Feb 2013 03:25:53 -0500
Received: by mail-pb0-f54.google.com with SMTP id rr4so316884pbb.27
        for <linux-ext4@vger.kernel.org>; Sun, 10 Feb 2013 00:25:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130210013857.GA8526@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Sat, Feb 09, 2013 at 08:38:57PM -0500, Theodore Ts'o wrote:
> Hi Zheng,
> 
> Thanks for working on this!  I've included your v5 extent status tree
> patches into the ext4 dev tree.  I will start doing further testing.
> 
> I suspected it wouldn't make a different, but I tested and confirmed
> that your patches don't help fix the regression introduced by the
> patch: disable-merging-of-uninitialized-extents
> 
> As a result, I've moved the following patches to the unstable portion
> of the ext4 patch queue, pending further investigation and discussion:
> 
> disable-merging-of-uninitialized-extents
> remove-unnecessary-wait-for-extent-coversion-in-ext4_fallocate
> ext4_split_extent_should_take_care_of_extent_zeroout
> 
> I will be running a full set of tests and looking more deeply at the
> patches, but for now I want to get them into linux-next for more
> testing and review.

I have seen that the patch series has been merged into 'dev' branch of
ext4 repo.  But I found a problem that a chunk in patch 9/10 is missing
in your branch.  In that patch ext4_map_blocks is replaced with
ext4_ext_map_blocks because when we call ext4_map_blocks to convert
unwritten extents it will fail.  In ext4_map_blocks it first tries
to lookup extent status tree and the unwritten extent in this tree has
been converted in end_io callback function.  So that means that
ext4_map_blocks will return immediately and unwritten extent in disk
will never be converted.  I have replied a mail for that patch to
describe it.  Please check it.

Thanks,
                                                - Zheng

> On Fri, Feb 08, 2013 at 04:43:56PM +0800, Zheng Liu wrote:
> > Hi all,
> > 
> > This is my fifth try to implement the second step of extent status tree.
> > The patch set can be divided into the following parts.
> > 
> > Patch 1/10
> >   This patch refines the extent status tree
> > 
> > Patch 2/10-6/10
> >   These patches try to track all extent status in extent status tree and
> > make it as a extent cache.  In extent_status structure bit field is removed
> > because we get some warnings from 'sparse'.  Now es_pblk and es_status are
> > manipulated by ext4_es_*_pblock and ext4_es_*_status directly.  Currently
> > when an unwritten extent is allocated, we never know it from map->m_flags
> > because ext4_ext_map_blocks doesn't return EXT4_MAP_UNWRITTEN flag.  A
> > patch fixes it and we can determine the extent status according to m_flags.
> >   According to Jan's feedback, we put the hole into extent cache to avoid
> > to access extent tree in disk as far as possible.  Here if the whole file
> > is a hole, this hole will not be cached in extent status tree because it
> > is always splitted immediately.  Meanwhile the hole will not be cached
> > when ext4_da_map_blocks looks up a block mapping because this hole will be
> > as a delayed extent later.
> > 
> > Patch 7/10-8/10
> >   This two patches try to reclaim memory from extent status tree when we
> > are under a high memeory pressure.
> > 
> > Patch 9/10-10/10
> >   Thses patches are picked up again from 1st version because I aware that
> > they could remove a bogus wait in ext4_ind_direct_IO when dioread_nolock
> > is enabled.  After applied them, the latency of dio read can be reduced.
> > 
> > I measure it using fio and the result shows as below.
> > 
> > config file
> > -----------
> > [global]
> > ioengine=psync
> > direct=1
> > bs=4k
> > thread
> > group_reporting
> > directory=/mnt/sda1/
> > filename=testfile
> > filesize=10g
> > size=10g
> > runtime=120
> > iodepth=16
> > 
> > [fio]
> > rw=randrw
> > numjobs=4
> > 
> > result
> > ------
> > w/ bogus wait
> >   read : io=1508.1MB, bw=12876KB/s, iops=3218 , runt=120001msec
> >     clat (usec): min=128 , max=268738 , avg=718.62, stdev=3703.97
> >      lat (usec): min=128 , max=268739 , avg=718.78, stdev=3703.97
> >   write: io=1505.2MB, bw=12843KB/s, iops=3210 , runt=120001msec
> >     clat (usec): min=47 , max=991727 , avg=520.94, stdev=3451.63
> >      lat (usec): min=47 , max=991727 , avg=521.31, stdev=3451.63
> > 
> > w/o bogus wait
> >   read : io=1576.4MB, bw=13451KB/s, iops=3362 , runt=120001msec
> >     clat (usec): min=128 , max=283906 , avg=685.88, stdev=2762.64
> >      lat (usec): min=128 , max=283907 , avg=686.05, stdev=2762.64
> >   write: io=1577.9MB, bw=13458KB/s, iops=3364 , runt=120001msec
> >     clat (usec): min=48 , max=977942 , avg=498.97, stdev=3093.08
> >      lat (usec): min=48 , max=977943 , avg=499.33, stdev=3093.08
> > 
> > From the result we can see that the avg. of latency could be reduced a little.
> > 
> > changelog:
> > v5 <- v4:
> >  - drop a patch that removes EXT4_MAP_FROM_CLUSTER flag
> >    (I will revise it in the patch set of get_block_t refinement)
> >  - fold original patch 3/9 into patch 4/9
> >  - manipulate es_pblk and es_status directly
> >    (bit field is removed because it causes some warnings from 'sparse')
> >  - let ext4_ext_map_blocks return EXT4_MAP_UNWRITTEN flag
> >  - rename ext4_es_find_extent with ext4_es_find_delayed_extent
> >  - add hole status and put hole into extent status tree as a cache
> >  - convert unwritten extents from extent status tree in ext4_ext_direct_IO
> >    and end_io callback
> >  - remove a bogus wait in ext4_ind_direct_IO when dioread_nolock is enabled
> > 
> > v4 <- v3:
> >  - register a normal shrinker to reclaim extent from extent status tree
> > 
> > v3 <- v2:
> >  - use prune_super() to reclaim extents from extent status tree
> >  - stashed es_status into es_pblk
> >  - remove single extent cache
> >  - rebase against 3.8-rc4
> > 
> > v2 <- v1:
> >  - drop patches that try to improve unwritten extent conversion
> >  - remove EXT4_MAP_FROM_CLUSTER flag
> >  - add tracepoint for ext4_es_lookup_extent()
> >  - drop a patch, which tries to fix a warning when bigalloc and delalloc
> >    are enabled
> >  - add a shrinker to reclaim memory from extent status tree
> >  - rebase against 3.8-rc2
> > 
> > v4: http://lwn.net/Articles/536037/
> > v3: http://lwn.net/Articles/533730/
> > v2: http://lwn.net/Articles/532446/
> > v1: http://lwn.net/Articles/531065/
> > 
> > As always, any comments or feedbacks are welcome.
> > 
> > FWIW, when I try to implement patch 3/10, I realize that get_block_t and
> > *_map_blocks functions need to be refactored because in ext4 we already
> > have six get_block_t functions
> >  - ext4_get_block
> >  - ext4_get_block_write
> >  - ext4_get_block_write_nolock
> >  - noalloc_get_block_write
> >  - ext4_da_get_block_prep
> >  - _ext4_get_block
> > 
> > and four *_map_blocks
> >  - ext4_map_blocks
> >  - ext4_da_map_blocks
> >  - ext4_ext_map_blocks
> >  - ext4_ind_map_blocks
> > 
> > So I am planning to refine them.  First I will try to split ext4_map_blocks
> > into two parts, e.g. ext4_map_blocks_read and ext4_map_blocks_write, and 
> > then try other cleanups and improvmentes.
> > 
> > Thanks,
> > 						- Zheng
> > 
> > Zheng Liu (10):
> >   ext4: refine extent status tree
> >   ext4: add physical block and status member into extent status tree
> >   ext4: let ext4_ext_map_blocks return EXT4_MAP_UNWRITTEN flag
> >   ext4: track all extent status in extent status tree
> >   ext4: lookup block mapping in extent status tree
> >   ext4: remove single extent cache
> >   ext4: adjust some functions for reclaiming extents from extent status
> >     tree
> >   ext4: reclaim extents from extent status tree
> >   ext4: convert unwritten extents from extent status tree in end_io
> >   ext4: remove bogus wait for unwritten extents in ext4_ind_direct_IO
> > 
> >  fs/ext4/ext4.h              |  21 +-
> >  fs/ext4/ext4_extents.h      |   6 -
> >  fs/ext4/extents.c           | 211 ++++--------
> >  fs/ext4/extents_status.c    | 779 +++++++++++++++++++++++++++++++++++---------
> >  fs/ext4/extents_status.h    |  84 ++++-
> >  fs/ext4/file.c              |  16 +-
> >  fs/ext4/indirect.c          |   5 -
> >  fs/ext4/inode.c             | 148 +++++++--
> >  fs/ext4/move_extent.c       |   3 -
> >  fs/ext4/page-io.c           |   8 +-
> >  fs/ext4/super.c             |   8 +-
> >  include/trace/events/ext4.h | 207 ++++++++++--
> >  12 files changed, 1075 insertions(+), 421 deletions(-)
> > 
> > -- 
> > 1.7.12.rc2.18.g61b472e
> > 
