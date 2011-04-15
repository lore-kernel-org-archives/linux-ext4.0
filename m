From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH RFC 1/3] ext4:Add a function merging extent right and
 left.
Date: Fri, 15 Apr 2011 09:39:33 -0700
Message-ID: <1302885573.2901.13.camel@mingming-laptop>
References: <1302759651-21222-1-git-send-email-xiaoqiangnk@gmail.com>
	 <1302759651-21222-2-git-send-email-xiaoqiangnk@gmail.com>
	 <1302807787.3408.25.camel@mingming-laptop>
	 <BANLkTindru2SnxLLFwb7bMxnkuhwP9MH2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51959 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1DOQjm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2011 12:39:42 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3FGHeUk014755
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2011 12:17:40 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3FGdbQL2654236
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2011 12:39:37 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3FGdaBM007643
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2011 13:39:37 -0300
In-Reply-To: <BANLkTindru2SnxLLFwb7bMxnkuhwP9MH2g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-04-15 at 09:12 +0800, Yongqiang Yang wrote:
> On Fri, Apr 15, 2011 at 3:03 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> > On Wed, 2011-04-13 at 22:40 -0700, Yongqiang Yang wrote:
> >> 1] Rename ext4_ext_try_to_merge() to ext4_ext_try_to_merge_right().
> >>
> >> 2] Add a new function ext4_ext_try_to_merge() which tries to merge
> >>    an extent both left and right.
> >>
> >> 3] Use the new function in ext4_ext_convert_unwritten_endio() and
> >>    ext4_ext_insert_extent().
> >>
> >> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> >> ---
> >>  fs/ext4/extents.c |   65 ++++++++++++++++++++++++++++------------------------
> >>  1 files changed, 35 insertions(+), 30 deletions(-)
> >>
> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >> index dd2cb50..11f30d2 100644
> >> --- a/fs/ext4/extents.c
> >> +++ b/fs/ext4/extents.c
> >> @@ -1563,7 +1563,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
> >>   * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
> >>   * 1 if they got merged.
> >>   */
> >> -static int ext4_ext_try_to_merge(struct inode *inode,
> >> +static int ext4_ext_try_to_merge_right(struct inode *inode,
> >>                                struct ext4_ext_path *path,
> >>                                struct ext4_extent *ex)
> >>  {
> >> @@ -1603,6 +1603,31 @@ static int ext4_ext_try_to_merge(struct inode *inode,
> >>  }
> >>
> >>  /*
> >> + * This function tries to merge the @ex extent to neighbours in the tree.
> >> + * return 1 if merge left else 0.
> >> + */
> >> +static int ext4_ext_try_to_merge(struct inode *inode,
> >> +                               struct ext4_ext_path *path,
> >> +                               struct ext4_extent *ex) {
> >> +     struct ext4_extent_header *eh;
> >> +     unsigned int depth;
> >> +     int merge_done = 0;
> >> +     int ret = 0;
> >> +
> >> +     depth = ext_depth(inode);
> >> +     BUG_ON(path[depth].p_hdr == NULL);
> >> +     eh = path[depth].p_hdr;
> >> +
> >> +     if (ex > EXT_FIRST_EXTENT(eh))
> >> +             merge_done = ext4_ext_try_to_merge_right(inode, path, ex - 1);
> >> +
> >> +     if (!merge_done)
> >> +             ret = ext4_ext_try_to_merge_right(inode, path, ex);
> >> +
> >
> > Is there any reason not to merge right after merge left? The old code
> > does both, I think.
> What does merge left do?  Actually it does as merge right, it merge
> ex-1 to right until no more merges can be done.  So if merge to right
> happens then, ex,ex+1 has been tried to merge also.
> 

Yep, you are right, the merge is always merge toward right. 

> >
> >> +     return ret;
> >> +}
> >> +
> >> +/*
> >>   * check if a portion of the "newext" extent overlaps with an
> >>   * existing extent.
> >>   *
> >> @@ -3039,6 +3064,7 @@ fix_extent_len:
> >>       ext4_ext_dirty(handle, inode, path + depth);
> >>       return err;
> >>  }
> >> +
> >>  static int ext4_convert_unwritten_extents_endio(handle_t *handle,
> >>                                             struct inode *inode,
> >>                                             struct ext4_ext_path *path)
> >> @@ -3047,46 +3073,25 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
> >>       struct ext4_extent_header *eh;
> >>       int depth;
> >>       int err = 0;
> >> -     int ret = 0;
> >>
> >>       depth = ext_depth(inode);
> >>       eh = path[depth].p_hdr;
> >>       ex = path[depth].p_ext;
> >>
> >> +     ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
> >> +             "block %llu, max_blocks %u\n", inode->i_ino,
> >> +             (unsigned long long)le32_to_cpu(ex->ee_block),
> >> +             ext4_ext_get_actual_len(ex));
> >> +
> >>       err = ext4_ext_get_access(handle, inode, path + depth);
> >>       if (err)
> >>               goto out;
> >>       /* first mark the extent as initialized */
> >>       ext4_ext_mark_initialized(ex);
> >>
> >> -     /*
> >> -      * We have to see if it can be merged with the extent
> >> -      * on the left.
> >> -      */
> >> -     if (ex > EXT_FIRST_EXTENT(eh)) {
> >> -             /*
> >> -              * To merge left, pass "ex - 1" to try_to_merge(),
> >> -              * since it merges towards right _only_.
> >> -              */
> >> -             ret = ext4_ext_try_to_merge(inode, path, ex - 1);
> >> -             if (ret) {
> >> -                     err = ext4_ext_correct_indexes(handle, inode, path);
> >> -                     if (err)
> >> -                             goto out;
> >> -                     depth = ext_depth(inode);
> >> -                     ex--;
> >> -             }
> >> -     }
> >> -     /*
> >> -      * Try to Merge towards right.
> >> -      */
> >> -     ret = ext4_ext_try_to_merge(inode, path, ex);
> >> -     if (ret) {
> >> -             err = ext4_ext_correct_indexes(handle, inode, path);
> >> -             if (err)
> >> -                     goto out;
> >> -             depth = ext_depth(inode);
> >> -     }
> >> +     /* correct indexes is nt needed becasue borders are not changed */
> >> +     ext4_ext_try_to_merge(inode, path, ex);
> >> +
> >
> > Ah, so you discovered an issue -- currently ext4 can't merge across the
> > index block borders. that's a pity. This might need to fix up,
> Yes, currently borders are changed only in one case that storing an
> extent to an empty leaf.
> 
> I think the patch which enable merging across index block should be
> independent on these patches.
> 

Sure.

> 
> > especially with split is going to be heavily used in punch hole,
> > snapshots, direct IO handling holes.
> What does direct IO here refer to?  It seems I am missing something.
> 
> These patches involves ext4_ext_convrt_to_initialized() in buffer
> write case, and split_unwritten_extents() and
> convert_to_initialized_endio() in direct IO case.
> 

The plit_unwritten_extents() and convert_to_initialized_endio() were
added to support direct IO on holes/fallocated space. That's what I am
referring to above.

> >
> >
> >>       /* Mark modified extent as dirty */
> >>       err = ext4_ext_dirty(handle, inode, path + depth);
> >>  out:
> >
> >
> >
> 
> 
> 


