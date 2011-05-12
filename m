From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4_ext_convert_to_initialized bug found in extended FSX
 testing
Date: Thu, 12 May 2011 14:15:02 -0700
Message-ID: <1305234902.9708.63.camel@mingming-laptop>
References: <4DC97C32.2020203@linux.vnet.ibm.com>
	 <BANLkTi=jjVcy9WQvNfYwPVNw-+t4M5WbFw@mail.gmail.com>
	 <1305162935.4102.13.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36849 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab1ELVPK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 May 2011 17:15:10 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4CKwsZo018850
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 14:58:54 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p4CLF5uN115898
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 15:15:05 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p4CLF5DW003003
	for <linux-ext4@vger.kernel.org>; Thu, 12 May 2011 15:15:05 -0600
In-Reply-To: <1305162935.4102.13.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2011-05-11 at 18:15 -0700, Mingming Cao wrote:
> On Wed, 2011-05-11 at 09:47 +0800, Yongqiang Yang wrote:
> > On Wed, May 11, 2011 at 1:56 AM, Allison Henderson
> > <achender@linux.vnet.ibm.com> wrote:
> > > Hi All,
> > >
> > > We've been trying to get punch hole through some extended fsx tests, and I ran across some other tests that were failing because the test file contained zeros where it shouldn't.  I made this fix to the ext4_ext_convert_to_initialized
> > 
> > What do you mean zeros here?
> > Some useful data is zeroed?
> > 
> > and the test has been running smooth for about an hour now.
> > Yongqiang, this one looks like it may have been associated with the
> > split extents clean up patch.  Would you mind taking a look at this
> > fix and giving it your ok if it looks good?  Thx!
> > >
> > > Signed-off-by: Allison Henderson <achender@us.ibm.com>
> > > ---
> > > :100644 100644 e363f21... ce69450... M  fs/ext4/extents.c
> > >  fs/ext4/extents.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > > index e363f21..ce69450 100644
> > > --- a/fs/ext4/extents.c
> > > +++ b/fs/ext4/extents.c
> > > @@ -2819,7 +2819,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> > >                        /* case 3 */
> > >                        zero_ex.ee_block =
> > >                                         cpu_to_le32(map->m_lblk + map->m_len);
> > > -                       zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
> > > +                       zero_ex.ee_len = cpu_to_le16(ee_len -
> > > +                                               allocated - map->m_len);
> > The logic is that we splits [ee_block, ee_block + ee_len) into
> > [ee_block, map->m_blk) that is uninitialized and [map->m_blk, ee_block
> > + ee_len) that is initialized.   We need to zero [map->m_lblk +
> > map->m_len, ee_block + ee_len).
> > and [map->m_lblk, map->m_lblk + map->m_len) is zeroed by upper layer
> > because of MAP_NEW flag.
> > 
> > Right logic?
> > 
> 
> Hmm, the logic in case 3 is-- if ex2[map->m_blk, map->m_blk+m_len] and
> ex3 together[map->mblk+m_len+1, map->m_blk+allocated] total length
> (allocated)is < than 7 blocks, then we zero out the entire ex2 and ext3,
> there is no need to do split.
> 
> I think zero_ex.ee_len should be "allocated". Look at the original code
> (before the extents splits cleanup patches), it will zero out entire 
> [map->mblk, map->m_blk+allocated] and don't do split anymore.
> 
> 
> something like this, not a patch, but show what I think the right fix.
> 
> 
>        if (allocated > map->m_len) {
>                if (allocated <= EXT4_EXT_ZERO_LEN &&
>                    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>                        /* case 3 */
>                        zero_ex.ee_block =
>                                         cpu_to_le32(map->m_lblk + map->m_len);
> -                       zero_ex.ee_len = cpu_to_le16(allocated - map->m_len);
>                        zero_ex.ee_len = cpu_to_le16(allocated);
>                        ext4_ext_store_pblock(&zero_ex,
>                                ext4_ext_pblock(ex) + map->m_lblk - ee_block);
>                        err = ext4_ext_zeroout(inode, &zero_ex);
>                         if (err)
>                                 goto out;
> -                       split_map.m_lblk = map->m_lblk;
> -                       split_map.m_len = allocated;
> +             		ext4_ext_mark_initialized(ex);
> +              		ext4_ext_try_to_merge(inode, path, ex);
> +	              err = ext4_ext_dirty(handle, inode, path + depth);
> +            		   goto out;
>   }
> 

Hi there,


I realized that we still need to insert the zeroed out extents, do one
split. But the zeroed out extent length is the whole "allocated"
space.so above is not entirely right. I think there maybe more issue
with the extent split cleanup code...

Basically the issue is the zero-out length is not calculated properly.
and doesn't match the split length.  in case 3 and 2, we both just zero
out the small portion that less then the water mark, do one split.  And
the split extent length should match the zero out length. Which I think
current cleanup patch don't. 

In case 3, since the split/zerout happen at the start of requested
logical offset, we could return the whole zeroed-out length; but in case
2, since the split/zeroout happen at the end of requested range, we
should only return the length of mapped(zince being zerout)blocks that
start from the requested logical offset.  ext4_ext_map_blocks() will
return the mapped blocks back to the caller. 


Hmm,. it might be easier to comment in the [PATCH v2 3/3]
ext4:Reimplement convert and split_unwritten. and the other patch
directly.

Mingming

> 
> 
> Mingming
> 
> 
> > 
> > I can not see the error and the meaning of ee_len - allocated - map->m_len.
> > 
> > Thanks,
> > Yongqiang.
> > 
> > 
> > >                        ext4_ext_store_pblock(&zero_ex,
> > >                                ext4_ext_pblock(ex) + map->m_lblk - ee_block);
> > >                        err = ext4_ext_zeroout(inode, &zero_ex);
> > > --
> > > 1.7.1
> > >
> > >
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


