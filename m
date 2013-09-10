From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix dirty pages writback regression.
Date: Tue, 10 Sep 2013 14:53:50 +0200
Message-ID: <20130910125350.GB5454@quack.suse.cz>
References: <1378778578-5000-1-git-send-email-zheng.z.yan@intel.com>
 <20130910090044.GB894@quack.suse.cz>
 <522EE1F5.1080505@intel.com>
 <20130910091715.GA3046@quack.suse.cz>
 <CAAM7YAmJYWC0O+0jg4rw4xWACm8MzW4L8Ybs9bJPySc7Op4JDg@mail.gmail.com>
 <20130910111519.GA5454@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, "Yan, Zheng" <zheng.z.yan@intel.com>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	lkp@linux.intel.com
To: "Yan, Zheng" <ukernel@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab3IJMxz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Sep 2013 08:53:55 -0400
Content-Disposition: inline
In-Reply-To: <20130910111519.GA5454@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-09-13 13:15:19, Jan Kara wrote:
> On Tue 10-09-13 19:01:16, Yan, Zheng wrote:
> > On Tue, Sep 10, 2013 at 5:17 PM, Jan Kara <jack@suse.cz> wrote:
> > > On Tue 10-09-13 17:10:13, Yan, Zheng wrote:
> > >> On 09/10/2013 05:00 PM, Jan Kara wrote:
> > >> > On Tue 10-09-13 10:02:58, Yan, Zheng wrote:
> > >> >> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > >> >>
> > >> >> Our Linux Kernel Performance project found that commit 4e7ea81db5
> > >> >> (ext4: restructure writeback path) indroduced regression. After
> > >> >> the commit, ext4 does not merge adjacent mapped dirty pages during
> > >> >> writeback. The "!buffer_delay(bh) && !buffer_unwritten(bh)" check
> > >> >> in mpage_add_bh_to_extent() prevents the merging.
> > >> >>
> > >> >> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > >> >> ---
> > >> >>  fs/ext4/inode.c | 3 +--
> > >> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> > >> >>
> > >> >> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > >> >> index c79fd7d..bfeb8b2 100644
> > >> >> --- a/fs/ext4/inode.c
> > >> >> +++ b/fs/ext4/inode.c
> > >> >> @@ -1944,8 +1944,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
> > >> >>    struct ext4_map_blocks *map = &mpd->map;
> > >> >>
> > >> >>    /* Buffer that doesn't need mapping for writeback? */
> > >> >> -  if (!buffer_dirty(bh) || !buffer_mapped(bh) ||
> > >> >> -      (!buffer_delay(bh) && !buffer_unwritten(bh))) {
> > >> >> +  if (!buffer_dirty(bh) || !buffer_mapped(bh)) {
> > >> >   Sadly it isn't that easy. The condition is there for a reason... The
> > >> > reason is that we are looking for an extent to map. When we already have
> > >> > some buffer to map and then there is buffer which doesn't need mapping we
> > >> > cannot just add it to the extent because then we would allocate too many
> > >> > blocks.
> > >>
> > >> the "(b_state & BH_FLAGS) == map->m_flags)" check in
> > >> mpage_add_bh_to_extent() should prevent delayed and non-delayed dirty
> > >> pages from merging. What am I missing here?
> > >   Yes, that is true. Sorry, I didn't realize this originally. But what
> > > difference would then your patch make?
> > >
> > 
> > Continuous dirty pages that are "!buffer_delay(bh) && !buffer_unwritten(bh)"
> > can be merged during writeback. I think the change will reduce number of
> > bio for workload that re-writes existing data.
>   I see. The code is actually supposed to achieve that as well - when we
> have a sequence of mapped and dirty buffers (pages), we keep map->m_len ==
> 0 and just always return true from mpage_add_bh_to_extent(). This way
> the caller keep adding pages to current bio in ext4_bio_write_page() while
> they are contiguous.
> 
> However I agree there is something broken somewhere in this logic because I
> can reproduce the regression with that commit as well and the request sizes
> are somewhat smaller after the patch (not sure if that thing alone can be
> the reason for rather big throughput drop). I'm investigating it now.
  I've tracked down the problem. It is that we were too aggressive writing
back pages and thus we were finding less consecutive dirty pages (with
random IO workloads the longer you wait with writeback the better IO
pattern you get). And the writeback was too aggressive because we weren't
properly terminating the writeback when nr_to_write dropped to zero. After
I fixed that condition I'm getting about 25% better throughput then before
code reorg... I'll be sending the patch with numbers etc. later this
afternoon.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
