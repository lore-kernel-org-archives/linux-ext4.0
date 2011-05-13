From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH v2 3/3] ext4:Reimplement convert and split_unwritten.
Date: Thu, 12 May 2011 22:26:57 -0700
Message-ID: <1305264417.9708.249.camel@mingming-laptop>
References: <1304388301-9452-1-git-send-email-xiaoqiangnk@gmail.com>
	 <1304388301-9452-4-git-send-email-xiaoqiangnk@gmail.com>
	 <1305235594.9708.75.camel@mingming-laptop>
	 <BANLkTikwXkofQwWZX037XAZNt8x_WA=zGg@mail.gmail.com>
	 <1305253114.9708.89.camel@mingming-laptop>
	 <BANLkTinA-6tuZVoc6qrS-LVmgE5HKbhnog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: achender@linux.vnet.ibm.com, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35069 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1EMF1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 May 2011 01:27:05 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4D57HKk030336
	for <linux-ext4@vger.kernel.org>; Fri, 13 May 2011 01:07:17 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4D5R4ux094562
	for <linux-ext4@vger.kernel.org>; Fri, 13 May 2011 01:27:04 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4D5R3UX028111
	for <linux-ext4@vger.kernel.org>; Fri, 13 May 2011 01:27:04 -0400
In-Reply-To: <BANLkTinA-6tuZVoc6qrS-LVmgE5HKbhnog@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-05-13 at 10:31 +0800, Yongqiang Yang wrote:
> On Fri, May 13, 2011 at 10:18 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> > On Fri, 2011-05-13 at 10:06 +0800, Yongqiang Yang wrote:
> >> On Fri, May 13, 2011 at 5:26 AM, Mingming Cao <cmm@us.ibm.com> wrote:
> >> > On Mon, 2011-05-02 at 19:05 -0700, Yongqiang Yang wrote:
> >> >> v0->v1:
> >> >>   -- ext4_ext_convert_initialized() zeroout whole extent when the extent's
> >> >>      length is less than 14.
> >> >>
> >> >> convert and split unwritten are reimplemented based on ext4_split_extent()
> >> >> added in last patch.
> >> >>
> >> >> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> >> >> Tested-by: Allison Henderson <achender@linux.vnet.ibm.com>
> >> >> ---
> >> >>  fs/ext4/extents.c |  480 ++++++++---------------------------------------------
> >> >>  1 files changed, 72 insertions(+), 408 deletions(-)
> >> >>
> >> >> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> >> >> index db1d67c..9e7c7b3 100644
> >> >> --- a/fs/ext4/extents.c
> >> >> +++ b/fs/ext4/extents.c
> >> >> @@ -2757,17 +2757,13 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >> >>                                          struct ext4_map_blocks *map,
> >> >>                                          struct ext4_ext_path *path)
> >> >>  {
> >> >> -     struct ext4_extent *ex, newex, orig_ex;
> >> >> -     struct ext4_extent *ex1 = NULL;
> >> >> -     struct ext4_extent *ex2 = NULL;
> >> >> -     struct ext4_extent *ex3 = NULL;
> >> >> -     struct ext4_extent_header *eh;
> >> >> +     struct ext4_map_blocks split_map;
> >> >> +     struct ext4_extent zero_ex;
> >> >> +     struct ext4_extent *ex;
> >> >>       ext4_lblk_t ee_block, eof_block;
> >> >>       unsigned int allocated, ee_len, depth;
> >> >> -     ext4_fsblk_t newblock;
> >> >>       int err = 0;
> >> >> -     int ret = 0;
> >> >> -     int may_zeroout;
> >> >> +     int split_flag = 0;
> >> >>
> >> >>       ext_debug("ext4_ext_convert_to_initialized: inode %lu, logical"
> >> >>               "block %llu, max_blocks %u\n", inode->i_ino,
> >> >> @@ -2779,280 +2775,87 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >> >>               eof_block = map->m_lblk + map->m_len;
> >> >>
> >> >>       depth = ext_depth(inode);
> >> >> -     eh = path[depth].p_hdr;
> >> >>       ex = path[depth].p_ext;
> >> >>       ee_block = le32_to_cpu(ex->ee_block);
> >> >>       ee_len = ext4_ext_get_actual_len(ex);
> >> >>       allocated = ee_len - (map->m_lblk - ee_block);
> >> >> -     newblock = map->m_lblk - ee_block + ext4_ext_pblock(ex);
> >> >> -
> >> >> -     ex2 = ex;
> >> >> -     orig_ex.ee_block = ex->ee_block;
> >> >> -     orig_ex.ee_len   = cpu_to_le16(ee_len);
> >> >> -     ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
> >> >>
> >> >> +     WARN_ON(map->m_lblk < ee_block);
> >> >>       /*
> >> >>        * It is safe to convert extent to initialized via explicit
> >> >>        * zeroout only if extent is fully insde i_size or new_size.
> >> >>        */
> >> >> -     may_zeroout = ee_block + ee_len <= eof_block;
> >> >> +     split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
> >> >>
> >> >> -     err = ext4_ext_get_access(handle, inode, path + depth);
> >> >> -     if (err)
> >> >> -             goto out;
> >> >>       /* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
> >> >> -     if (ee_len <= 2*EXT4_EXT_ZERO_LEN && may_zeroout) {
> >> >> -             err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> +     if (ee_len <= 2*EXT4_EXT_ZERO_LEN &&
> >> >> +         (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
> >> >> +             err = ext4_ext_zeroout(inode, ex);
> >> >>               if (err)
> >> >> -                     goto fix_extent_len;
> >> >> -             /* update the extent length and mark as initialized */
> >> >> -             ex->ee_block = orig_ex.ee_block;
> >> >> -             ex->ee_len   = orig_ex.ee_len;
> >> >> -             ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -             ext4_ext_dirty(handle, inode, path + depth);
> >> >> -             /* zeroed the full extent */
> >> >> -             return allocated;
> >> >> -     }
> >> >> -
> >> >> -     /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
> >> >> -     if (map->m_lblk > ee_block) {
> >> >> -             ex1 = ex;
> >> >> -             ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
> >> >> -             ext4_ext_mark_uninitialized(ex1);
> >> >> -             ex2 = &newex;
> >> >> -     }
> >> >> -     /*
> >> >> -      * for sanity, update the length of the ex2 extent before
> >> >> -      * we insert ex3, if ex1 is NULL. This is to avoid temporary
> >> >> -      * overlap of blocks.
> >> >> -      */
> >> >> -     if (!ex1 && allocated > map->m_len)
> >> >> -             ex2->ee_len = cpu_to_le16(map->m_len);
> >> >> -     /* ex3: to ee_block + ee_len : uninitialised */
> >> >> -     if (allocated > map->m_len) {
> >> >> -             unsigned int newdepth;
> >> >> -             /* If extent has less than EXT4_EXT_ZERO_LEN zerout directly */
> >> >> -             if (allocated <= EXT4_EXT_ZERO_LEN && may_zeroout) {
> >> >> -                     /*
> >> >> -                      * map->m_lblk == ee_block is handled by the zerouout
> >> >> -                      * at the beginning.
> >> >> -                      * Mark first half uninitialized.
> >> >> -                      * Mark second half initialized and zero out the
> >> >> -                      * initialized extent
> >> >> -                      */
> >> >> -                     ex->ee_block = orig_ex.ee_block;
> >> >> -                     ex->ee_len   = cpu_to_le16(ee_len - allocated);
> >> >> -                     ext4_ext_mark_uninitialized(ex);
> >> >> -                     ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -                     ext4_ext_dirty(handle, inode, path + depth);
> >> >> -
> >> >> -                     ex3 = &newex;
> >> >> -                     ex3->ee_block = cpu_to_le32(map->m_lblk);
> >> >> -                     ext4_ext_store_pblock(ex3, newblock);
> >> >> -                     ex3->ee_len = cpu_to_le16(allocated);
> >> >> -                     err = ext4_ext_insert_extent(handle, inode, path,
> >> >> -                                                     ex3, 0);
> >> >> -                     if (err == -ENOSPC) {
> >> >> -                             err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> -                             if (err)
> >> >> -                                     goto fix_extent_len;
> >> >> -                             ex->ee_block = orig_ex.ee_block;
> >> >> -                             ex->ee_len   = orig_ex.ee_len;
> >> >> -                             ext4_ext_store_pblock(ex,
> >> >> -                                     ext4_ext_pblock(&orig_ex));
> >> >> -                             ext4_ext_dirty(handle, inode, path + depth);
> >> >> -                             /* blocks available from map->m_lblk */
> >> >> -                             return allocated;
> >> >> -
> >> >> -                     } else if (err)
> >> >> -                             goto fix_extent_len;
> >> >> -
> >> >> -                     /*
> >> >> -                      * We need to zero out the second half because
> >> >> -                      * an fallocate request can update file size and
> >> >> -                      * converting the second half to initialized extent
> >> >> -                      * implies that we can leak some junk data to user
> >> >> -                      * space.
> >> >> -                      */
> >> >> -                     err =  ext4_ext_zeroout(inode, ex3);
> >> >> -                     if (err) {
> >> >> -                             /*
> >> >> -                              * We should actually mark the
> >> >> -                              * second half as uninit and return error
> >> >> -                              * Insert would have changed the extent
> >> >> -                              */
> >> >> -                             depth = ext_depth(inode);
> >> >> -                             ext4_ext_drop_refs(path);
> >> >> -                             path = ext4_ext_find_extent(inode, map->m_lblk,
> >> >> -                                                         path);
> >> >> -                             if (IS_ERR(path)) {
> >> >> -                                     err = PTR_ERR(path);
> >> >> -                                     return err;
> >> >> -                             }
> >> >> -                             /* get the second half extent details */
> >> >> -                             ex = path[depth].p_ext;
> >> >> -                             err = ext4_ext_get_access(handle, inode,
> >> >> -                                                             path + depth);
> >> >> -                             if (err)
> >> >> -                                     return err;
> >> >> -                             ext4_ext_mark_uninitialized(ex);
> >> >> -                             ext4_ext_dirty(handle, inode, path + depth);
> >> >> -                             return err;
> >> >> -                     }
> >> >> -
> >> >> -                     /* zeroed the second half */
> >> >> -                     return allocated;
> >> >> -             }
> >> >> -             ex3 = &newex;
> >> >> -             ex3->ee_block = cpu_to_le32(map->m_lblk + map->m_len);
> >> >> -             ext4_ext_store_pblock(ex3, newblock + map->m_len);
> >> >> -             ex3->ee_len = cpu_to_le16(allocated - map->m_len);
> >> >> -             ext4_ext_mark_uninitialized(ex3);
> >> >> -             err = ext4_ext_insert_extent(handle, inode, path, ex3, 0);
> >> >> -             if (err == -ENOSPC && may_zeroout) {
> >> >> -                     err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> -                     if (err)
> >> >> -                             goto fix_extent_len;
> >> >> -                     /* update the extent length and mark as initialized */
> >> >> -                     ex->ee_block = orig_ex.ee_block;
> >> >> -                     ex->ee_len   = orig_ex.ee_len;
> >> >> -                     ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -                     ext4_ext_dirty(handle, inode, path + depth);
> >> >> -                     /* zeroed the full extent */
> >> >> -                     /* blocks available from map->m_lblk */
> >> >> -                     return allocated;
> >> >> -
> >> >> -             } else if (err)
> >> >> -                     goto fix_extent_len;
> >> >> -             /*
> >> >> -              * The depth, and hence eh & ex might change
> >> >> -              * as part of the insert above.
> >> >> -              */
> >> >> -             newdepth = ext_depth(inode);
> >> >> -             /*
> >> >> -              * update the extent length after successful insert of the
> >> >> -              * split extent
> >> >> -              */
> >> >> -             ee_len -= ext4_ext_get_actual_len(ex3);
> >> >> -             orig_ex.ee_len = cpu_to_le16(ee_len);
> >> >> -             may_zeroout = ee_block + ee_len <= eof_block;
> >> >> -
> >> >> -             depth = newdepth;
> >> >> -             ext4_ext_drop_refs(path);
> >> >> -             path = ext4_ext_find_extent(inode, map->m_lblk, path);
> >> >> -             if (IS_ERR(path)) {
> >> >> -                     err = PTR_ERR(path);
> >> >>                       goto out;
> >> >> -             }
> >> >> -             eh = path[depth].p_hdr;
> >> >> -             ex = path[depth].p_ext;
> >> >> -             if (ex2 != &newex)
> >> >> -                     ex2 = ex;
> >> >>
> >> >>               err = ext4_ext_get_access(handle, inode, path + depth);
> >> >>               if (err)
> >> >>                       goto out;
> >> >> -
> >> >> -             allocated = map->m_len;
> >> >> -
> >> >> -             /* If extent has less than EXT4_EXT_ZERO_LEN and we are trying
> >> >> -              * to insert a extent in the middle zerout directly
> >> >> -              * otherwise give the extent a chance to merge to left
> >> >> -              */
> >> >> -             if (le16_to_cpu(orig_ex.ee_len) <= EXT4_EXT_ZERO_LEN &&
> >> >> -                     map->m_lblk != ee_block && may_zeroout) {
> >> >> -                     err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> -                     if (err)
> >> >> -                             goto fix_extent_len;
> >> >> -                     /* update the extent length and mark as initialized */
> >> >> -                     ex->ee_block = orig_ex.ee_block;
> >> >> -                     ex->ee_len   = orig_ex.ee_len;
> >> >> -                     ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -                     ext4_ext_dirty(handle, inode, path + depth);
> >> >> -                     /* zero out the first half */
> >> >> -                     /* blocks available from map->m_lblk */
> >> >> -                     return allocated;
> >> >> -             }
> >> >> -     }
> >> >> -     /*
> >> >> -      * If there was a change of depth as part of the
> >> >> -      * insertion of ex3 above, we need to update the length
> >> >> -      * of the ex1 extent again here
> >> >> -      */
> >> >> -     if (ex1 && ex1 != ex) {
> >> >> -             ex1 = ex;
> >> >> -             ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
> >> >> -             ext4_ext_mark_uninitialized(ex1);
> >> >> -             ex2 = &newex;
> >> >> -     }
> >> >> -     /* ex2: map->m_lblk to map->m_lblk + maxblocks-1 : initialised */
> >> >> -     ex2->ee_block = cpu_to_le32(map->m_lblk);
> >> >> -     ext4_ext_store_pblock(ex2, newblock);
> >> >> -     ex2->ee_len = cpu_to_le16(allocated);
> >> >> -     if (ex2 != ex)
> >> >> -             goto insert;
> >> >> -     /*
> >> >> -      * New (initialized) extent starts from the first block
> >> >> -      * in the current extent. i.e., ex2 == ex
> >> >> -      * We have to see if it can be merged with the extent
> >> >> -      * on the left.
> >> >> -      */
> >> >> -     if (ex2 > EXT_FIRST_EXTENT(eh)) {
> >> >> -             /*
> >> >> -              * To merge left, pass "ex2 - 1" to try_to_merge(),
> >> >> -              * since it merges towards right _only_.
> >> >> -              */
> >> >> -             ret = ext4_ext_try_to_merge(inode, path, ex2 - 1);
> >> >> -             if (ret) {
> >> >> -                     err = ext4_ext_correct_indexes(handle, inode, path);
> >> >> -                     if (err)
> >> >> -                             goto out;
> >> >> -                     depth = ext_depth(inode);
> >> >> -                     ex2--;
> >> >> -             }
> >> >> +             ext4_ext_mark_initialized(ex);
> >> >> +             ext4_ext_try_to_merge(inode, path, ex);
> >> >> +             err = ext4_ext_dirty(handle, inode, path + depth);
> >> >> +             goto out;
> >> >>       }
> >> >> +
> >> >>       /*
> >> >> -      * Try to Merge towards right. This might be required
> >> >> -      * only when the whole extent is being written to.
> >> >> -      * i.e. ex2 == ex and ex3 == NULL.
> >> >> +      * four cases:
> >> >> +      * 1. split the extent into three extents.
> >> >> +      * 2. split the extent into two extents, zeroout the first half.
> >> >> +      * 3. split the extent into two extents, zeroout the second half.
> >> >> +      * 4. split the extent into two extents with out zeroout.
> >> >>        */
> >> >> -     if (!ex3) {
> >> >> -             ret = ext4_ext_try_to_merge(inode, path, ex2);
> >> >> -             if (ret) {
> >> >> -                     err = ext4_ext_correct_indexes(handle, inode, path);
> >> >> +     split_map.m_lblk = map->m_lblk;
> >> >> +     split_map.m_len = map->m_len;
> >> >> +
> >> >> +     if (allocated > map->m_len) {
> >> >> +             if (allocated <= EXT4_EXT_ZERO_LEN &&
> >> >> +                 (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
> >> >> +                     /* case 3 */
> >> >> +                     zero_ex.ee_block =
> >> >> +                                      cpu_to_le32(map->m_lblk + map->m_len);
> >> >> +                     zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
> >> > Hmm, the original code zero out the entire [map->m_lblk, allocated],
> >> > where here we only zero out a portion of it. it doesnt match the split
> >> > len below also.
> >> Yeah, I just zero out a portion of it which is not the requested.  I
> >> think the requested part will have non-zero data.
> >
> > The requested part is going to be written with data, but since the
> > entire [map->m_lblk, allocated] is a relatively small range(<7 blocks),
> > the cost of zero out this small range is pretty much the same as zero
> > out a portion of it. The saving is, we dont have to the split and
> > convert the request part from uninitialized to initialized when the
> > overwritten data reach to disk.
> Yeah, this patch just zeros a portion of it and [map->m_lblk,
> allocated]  are converted to initialized.
> 

The zero out is introduced to reduce the number of times to convert
uninitilized extent to initialized, if the extent size is relativelly
small. I'd say we reserve this optimization in the cleanup patch. The
effort to addition zero out the requested space is small compare to the
effort to do the conversion.

> BTW: I think zeroout can be optimized by zeroing data in pagecache
> instead zeroout in disk directly.  What's your opinion?  It is worth
> to do or not?
> >

I understand your intention here, trying to save extra IOs caused by
zero out...but the zero out short initialized extent directly is to
reduce twice or more conversion into one single conversion, which
involves metadata update.  The block IO layer is pretty good at merging
IO requests. and writing 4k or 16K contiguous IO at once probably the
same amount of effort/time.

If we only zero out in page, and leave the on disk extent remains
unchanged(uninitialized), hmm.... we will still need to convert on disk
uninitialized extent to initialized eventually when writeout. I think it
might not gain very much.

> > Mingming
> >
> >> >
> >> >
> >> >> +                     ext4_ext_store_pblock(&zero_ex,
> >> >> +                             ext4_ext_pblock(ex) + map->m_lblk - ee_block);
> >> >> +                     err = ext4_ext_zeroout(inode, &zero_ex);
> >> >>                       if (err)
> >> >>                               goto out;
> >> >> +                     split_map.m_lblk = map->m_lblk;
> >> >> +                     split_map.m_len = allocated;
> >> >> +             } else if ((map->m_lblk - ee_block + map->m_len <
> >> >> +                        EXT4_EXT_ZERO_LEN) &&
> >> >> +                        (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
> >> >> +                     /* case 2 */
> >> >> +                     if (map->m_lblk != ee_block) {
> >> >> +                             zero_ex.ee_block = ex->ee_block;
> >> >> +                             zero_ex.ee_len = cpu_to_le16(map->m_lblk -
> >> >> +                                                     ee_block);
> >> > similar to above, the original code zero out the entire [ex->ee_block,
> >> > map->m_lblk - ee_block + map->m_len], where here we only zero out a
> >> > portion of it. same to the mismatch of the split len also.
> >> Similar to above.  Just a optimization.
> >> >
> >> >
> >> >> +                             ext4_ext_store_pblock(&zero_ex,
> >> >> +                                                   ext4_ext_pblock(ex));
> >> >> +                             err = ext4_ext_zeroout(inode, &zero_ex);
> >> >> +                             if (err)
> >> >> +                                     goto out;
> >> >> +                     }
> >> >> +
> >> >>  -                    allocated = map->m_lblk - ee_block + map->m_len;
> >> >> +
> >> >> +                     split_map.m_lblk = ee_block;
> >> >> +                     split_map.m_len =  map->m_lblk - ee_block + map->m_len;
> >> +                          allocated = map->m_len;
> >> >
> >> > I am also puzzled whether the zeroed-out extent get marked as
> >> > initialized, as done in original patch. The whole point of zero out is
> >> > to avoid frequent split of the unitizlized extent if the extent is
> >> > short. I will take a closer look at the previous patch.
> >> >
> >> > Another issue, upon success, "allocated" will return from this function.
> >> > But here allocated is the zero out length that start from ee_block, not
> >> > the length from map->m_lblk. this is wrong, the caller
> >> > ext4_ext_map_blocks expecting the length of mapped blocks from
> >> > map->m_lblk.  We now return more mapped blocks than what really done.  I
> >> > suspect the fsx error come from this bug.
> >> Yeah. it is a bug.
> >>
> >> Hi Allison,
> >>
> >> Could you test with modification above?  Here is a bug. I will also test it.
> >>
> >> Thank you.
> >> >
> >> >>               }
> >> >
> >> >
> >> >>       }
> >> >> -     /* Mark modified extent as dirty */
> >> >> -     err = ext4_ext_dirty(handle, inode, path + depth);
> >> >> -     goto out;
> >> >> -insert:
> >> >> -     err = ext4_ext_insert_extent(handle, inode, path, &newex, 0);
> >> >> -     if (err == -ENOSPC && may_zeroout) {
> >> >> -             err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> -             if (err)
> >> >> -                     goto fix_extent_len;
> >> >> -             /* update the extent length and mark as initialized */
> >> >> -             ex->ee_block = orig_ex.ee_block;
> >> >> -             ex->ee_len   = orig_ex.ee_len;
> >> >> -             ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -             ext4_ext_dirty(handle, inode, path + depth);
> >> >> -             /* zero out the first half */
> >> >> -             return allocated;
> >> >> -     } else if (err)
> >> >> -             goto fix_extent_len;
> >> >> +
> >> >> +     allocated = ext4_split_extent(handle, inode, path,
> >> >> +                                    &split_map, split_flag, 0);
> >> >> +     if (allocated < 0)
> >> >> +             err = allocated;
> >> >> +
> >> >>  out:
> >> >> -     ext4_ext_show_leaf(inode, path);
> >> >>       return err ? err : allocated;
> >> >> -
> >> >> -fix_extent_len:
> >> >> -     ex->ee_block = orig_ex.ee_block;
> >> >> -     ex->ee_len   = orig_ex.ee_len;
> >> >> -     ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -     ext4_ext_mark_uninitialized(ex);
> >> >> -     ext4_ext_dirty(handle, inode, path + depth);
> >> >> -     return err;
> >> >>  }
> >> >>
> >> >>  /*
> >> >> @@ -3083,15 +2886,11 @@ static int ext4_split_unwritten_extents(handle_t *handle,
> >> >>                                       struct ext4_ext_path *path,
> >> >>                                       int flags)
> >> >>  {
> >> >> -     struct ext4_extent *ex, newex, orig_ex;
> >> >> -     struct ext4_extent *ex1 = NULL;
> >> >> -     struct ext4_extent *ex2 = NULL;
> >> >> -     struct ext4_extent *ex3 = NULL;
> >> >> -     ext4_lblk_t ee_block, eof_block;
> >> >> -     unsigned int allocated, ee_len, depth;
> >> >> -     ext4_fsblk_t newblock;
> >> >> -     int err = 0;
> >> >> -     int may_zeroout;
> >> >> +     ext4_lblk_t eof_block;
> >> >> +     ext4_lblk_t ee_block;
> >> >> +     struct ext4_extent *ex;
> >> >> +     unsigned int ee_len;
> >> >> +     int split_flag = 0, depth;
> >> >>
> >> >>       ext_debug("ext4_split_unwritten_extents: inode %lu, logical"
> >> >>               "block %llu, max_blocks %u\n", inode->i_ino,
> >> >> @@ -3101,155 +2900,20 @@ static int ext4_split_unwritten_extents(handle_t *handle,
> >> >>               inode->i_sb->s_blocksize_bits;
> >> >>       if (eof_block < map->m_lblk + map->m_len)
> >> >>               eof_block = map->m_lblk + map->m_len;
> >> >> -
> >> >> -     depth = ext_depth(inode);
> >> >> -     ex = path[depth].p_ext;
> >> >> -     ee_block = le32_to_cpu(ex->ee_block);
> >> >> -     ee_len = ext4_ext_get_actual_len(ex);
> >> >> -     allocated = ee_len - (map->m_lblk - ee_block);
> >> >> -     newblock = map->m_lblk - ee_block + ext4_ext_pblock(ex);
> >> >> -
> >> >> -     ex2 = ex;
> >> >> -     orig_ex.ee_block = ex->ee_block;
> >> >> -     orig_ex.ee_len   = cpu_to_le16(ee_len);
> >> >> -     ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
> >> >> -
> >> >>       /*
> >> >>        * It is safe to convert extent to initialized via explicit
> >> >>        * zeroout only if extent is fully insde i_size or new_size.
> >> >>        */
> >> >> -     may_zeroout = ee_block + ee_len <= eof_block;
> >> >> -
> >> >> -     /*
> >> >> -      * If the uninitialized extent begins at the same logical
> >> >> -      * block where the write begins, and the write completely
> >> >> -      * covers the extent, then we don't need to split it.
> >> >> -      */
> >> >> -     if ((map->m_lblk == ee_block) && (allocated <= map->m_len))
> >> >> -             return allocated;
> >> >> -
> >> >> -     err = ext4_ext_get_access(handle, inode, path + depth);
> >> >> -     if (err)
> >> >> -             goto out;
> >> >> -     /* ex1: ee_block to map->m_lblk - 1 : uninitialized */
> >> >> -     if (map->m_lblk > ee_block) {
> >> >> -             ex1 = ex;
> >> >> -             ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
> >> >> -             ext4_ext_mark_uninitialized(ex1);
> >> >> -             ex2 = &newex;
> >> >> -     }
> >> >> -     /*
> >> >> -      * for sanity, update the length of the ex2 extent before
> >> >> -      * we insert ex3, if ex1 is NULL. This is to avoid temporary
> >> >> -      * overlap of blocks.
> >> >> -      */
> >> >> -     if (!ex1 && allocated > map->m_len)
> >> >> -             ex2->ee_len = cpu_to_le16(map->m_len);
> >> >> -     /* ex3: to ee_block + ee_len : uninitialised */
> >> >> -     if (allocated > map->m_len) {
> >> >> -             unsigned int newdepth;
> >> >> -             ex3 = &newex;
> >> >> -             ex3->ee_block = cpu_to_le32(map->m_lblk + map->m_len);
> >> >> -             ext4_ext_store_pblock(ex3, newblock + map->m_len);
> >> >> -             ex3->ee_len = cpu_to_le16(allocated - map->m_len);
> >> >> -             ext4_ext_mark_uninitialized(ex3);
> >> >> -             err = ext4_ext_insert_extent(handle, inode, path, ex3, flags);
> >> >> -             if (err == -ENOSPC && may_zeroout) {
> >> >> -                     err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> -                     if (err)
> >> >> -                             goto fix_extent_len;
> >> >> -                     /* update the extent length and mark as initialized */
> >> >> -                     ex->ee_block = orig_ex.ee_block;
> >> >> -                     ex->ee_len   = orig_ex.ee_len;
> >> >> -                     ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -                     ext4_ext_dirty(handle, inode, path + depth);
> >> >> -                     /* zeroed the full extent */
> >> >> -                     /* blocks available from map->m_lblk */
> >> >> -                     return allocated;
> >> >> -
> >> >> -             } else if (err)
> >> >> -                     goto fix_extent_len;
> >> >> -             /*
> >> >> -              * The depth, and hence eh & ex might change
> >> >> -              * as part of the insert above.
> >> >> -              */
> >> >> -             newdepth = ext_depth(inode);
> >> >> -             /*
> >> >> -              * update the extent length after successful insert of the
> >> >> -              * split extent
> >> >> -              */
> >> >> -             ee_len -= ext4_ext_get_actual_len(ex3);
> >> >> -             orig_ex.ee_len = cpu_to_le16(ee_len);
> >> >> -             may_zeroout = ee_block + ee_len <= eof_block;
> >> >> -
> >> >> -             depth = newdepth;
> >> >> -             ext4_ext_drop_refs(path);
> >> >> -             path = ext4_ext_find_extent(inode, map->m_lblk, path);
> >> >> -             if (IS_ERR(path)) {
> >> >> -                     err = PTR_ERR(path);
> >> >> -                     goto out;
> >> >> -             }
> >> >> -             ex = path[depth].p_ext;
> >> >> -             if (ex2 != &newex)
> >> >> -                     ex2 = ex;
> >> >> +     depth = ext_depth(inode);
> >> >> +     ex = path[depth].p_ext;
> >> >> +     ee_block = le32_to_cpu(ex->ee_block);
> >> >> +     ee_len = ext4_ext_get_actual_len(ex);
> >> >>
> >> >> -             err = ext4_ext_get_access(handle, inode, path + depth);
> >> >> -             if (err)
> >> >> -                     goto out;
> >> >> +     split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
> >> >> +     split_flag |= EXT4_EXT_MARK_UNINIT2;
> >> >>
> >> >> -             allocated = map->m_len;
> >> >> -     }
> >> >> -     /*
> >> >> -      * If there was a change of depth as part of the
> >> >> -      * insertion of ex3 above, we need to update the length
> >> >> -      * of the ex1 extent again here
> >> >> -      */
> >> >> -     if (ex1 && ex1 != ex) {
> >> >> -             ex1 = ex;
> >> >> -             ex1->ee_len = cpu_to_le16(map->m_lblk - ee_block);
> >> >> -             ext4_ext_mark_uninitialized(ex1);
> >> >> -             ex2 = &newex;
> >> >> -     }
> >> >> -     /*
> >> >> -      * ex2: map->m_lblk to map->m_lblk + map->m_len-1 : to be written
> >> >> -      * using direct I/O, uninitialised still.
> >> >> -      */
> >> >> -     ex2->ee_block = cpu_to_le32(map->m_lblk);
> >> >> -     ext4_ext_store_pblock(ex2, newblock);
> >> >> -     ex2->ee_len = cpu_to_le16(allocated);
> >> >> -     ext4_ext_mark_uninitialized(ex2);
> >> >> -     if (ex2 != ex)
> >> >> -             goto insert;
> >> >> -     /* Mark modified extent as dirty */
> >> >> -     err = ext4_ext_dirty(handle, inode, path + depth);
> >> >> -     ext_debug("out here\n");
> >> >> -     goto out;
> >> >> -insert:
> >> >> -     err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> >> >> -     if (err == -ENOSPC && may_zeroout) {
> >> >> -             err =  ext4_ext_zeroout(inode, &orig_ex);
> >> >> -             if (err)
> >> >> -                     goto fix_extent_len;
> >> >> -             /* update the extent length and mark as initialized */
> >> >> -             ex->ee_block = orig_ex.ee_block;
> >> >> -             ex->ee_len   = orig_ex.ee_len;
> >> >> -             ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -             ext4_ext_dirty(handle, inode, path + depth);
> >> >> -             /* zero out the first half */
> >> >> -             return allocated;
> >> >> -     } else if (err)
> >> >> -             goto fix_extent_len;
> >> >> -out:
> >> >> -     ext4_ext_show_leaf(inode, path);
> >> >> -     return err ? err : allocated;
> >> >> -
> >> >> -fix_extent_len:
> >> >> -     ex->ee_block = orig_ex.ee_block;
> >> >> -     ex->ee_len   = orig_ex.ee_len;
> >> >> -     ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
> >> >> -     ext4_ext_mark_uninitialized(ex);
> >> >> -     ext4_ext_dirty(handle, inode, path + depth);
> >> >> -     return err;
> >> >> +     flags |= EXT4_GET_BLOCKS_PRE_IO;
> >> >> +     return ext4_split_extent(handle, inode, path, map, split_flag, flags);
> >> >>  }
> >> >>
> >> >>  static int ext4_convert_unwritten_extents_endio(handle_t *handle,
> >> >
> >> >
> >> >
> >>
> >>
> >>
> >
> >
> >
> 
> 
> 


