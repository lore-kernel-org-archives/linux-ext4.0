From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 4/5] ext4: update extent status tree after an extent
 is zeroed out
Date: Fri, 8 Mar 2013 21:14:32 +0800
Message-ID: <20130308131431.GC18986@gmail.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
 <1362579435-6333-5-git-send-email-wenqing.lz@taobao.com>
 <87sj47gq71.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60032 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3CHM7X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Mar 2013 07:59:23 -0500
Received: by mail-pb0-f43.google.com with SMTP id md12so1187691pbc.16
        for <linux-ext4@vger.kernel.org>; Fri, 08 Mar 2013 04:59:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <87sj47gq71.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 07, 2013 at 07:55:14PM +0400, Dmitry Monakhov wrote:
> On Wed,  6 Mar 2013 22:17:14 +0800, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > When we try to split an extent, this extent could be zeroed out and mark
> > as initialized.  But we don't know this in ext4_map_blocks because it
> > only returns a length of allocated extent.  Meanwhile we will mark this
> > extent as uninitialized because we only check m_flags.
> > 
> > This commit update extent status tree when we try to split an unwritten
> > extent.  We don't need to worry about the status of this extent because
> > we always mark it as initialized.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/extents.c        | 35 +++++++++++++++++++++++++++++++----
> >  fs/ext4/extents_status.c | 17 +++++++++++++++++
> >  fs/ext4/extents_status.h |  3 +++
> >  fs/ext4/inode.c          | 10 ++++++++++
> >  4 files changed, 61 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 110e85a..7e37018 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2925,7 +2925,7 @@ static int ext4_split_extent_at(handle_t *handle,
> >  {
> >  	ext4_fsblk_t newblock;
> >  	ext4_lblk_t ee_block;
> > -	struct ext4_extent *ex, newex, orig_ex;
> > +	struct ext4_extent *ex, newex, orig_ex, zero_ex;
> >  	struct ext4_extent *ex2 = NULL;
> >  	unsigned int ee_len, depth;
> >  	int err = 0;
> > @@ -2996,12 +2996,26 @@ static int ext4_split_extent_at(handle_t *handle,
> >  	err = ext4_ext_insert_extent(handle, inode, path, &newex, flags);
> >  	if (err == -ENOSPC && (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
> >  		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
> > -			if (split_flag & EXT4_EXT_DATA_VALID1)
> > +			if (split_flag & EXT4_EXT_DATA_VALID1) {
> >  				err = ext4_ext_zeroout(inode, ex2);
> > -			else
> > +				zero_ex.ee_block = ex2->ee_block;
> > +				zero_ex.ee_len = ext4_ext_get_actual_len(ex2);
> > +				ext4_ext_store_pblock(&zero_ex,
> > +						      ext4_ext_pblock(ex2));
> > +			} else {
> >  				err = ext4_ext_zeroout(inode, ex);
> > -		} else
> > +				zero_ex.ee_block = ex->ee_block;
> > +				zero_ex.ee_len = ext4_ext_get_actual_len(ex);
> > +				ext4_ext_store_pblock(&zero_ex,
> > +						      ext4_ext_pblock(ex));
> > +			}
> > +		} else {
> >  			err = ext4_ext_zeroout(inode, &orig_ex);
> > +			zero_ex.ee_block = orig_ex.ee_block;
> > +			zero_ex.ee_len = ext4_ext_get_actual_len(&orig_ex);
> > +			ext4_ext_store_pblock(&zero_ex,
> > +					      ext4_ext_pblock(&orig_ex));              
> > +		}
> >  		if (err)
> >  			goto fix_extent_len;
> > @@ -3009,6 +3023,12 @@ static int ext4_split_extent_at(handle_t *handle,
> >  		ex->ee_len = cpu_to_le16(ee_len);
> >  		ext4_ext_try_to_merge(handle, inode, path, ex);
> >  		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
> > +		if (err)
> > +			goto fix_extent_len;
> > +
> > +		/* update extent status tree */
> > +		err = ext4_es_zeroout(inode, &zero_ex);
> > +
> Previous blocks are correct but too complex.
> At this point we know that extent "ex" becomes initialized so just
> manually update it like follows:
>         err = ext4_es_insert_extent(inode, ee_block, ee_len,
>                                                    ext4_ext_pblock(ex),
>                                                    EXTENT_STATUS_WRITTEN);

Yeah, but maybe a inline function is better.  As you said below, I need
to avoid to define a local variable that is used only once.  So it look
like this:

inline int ext4_es_zeroout(struct inode *inode, struct ext4_extent *ex)
{
        return ext4_es_insert_extent(inode, le32_to_cpu(ex->ee_block),
                                     ext4_ext_get_actual_len(ex),
                                     ext4_ext_pblock(ex),
                                     EXTENT_STATUS_WRITTEN);
}

What do you think?

> BTW I'm wonder what happen if one of ext4_es_xxx functions failed with
> error. ASAIU this possible only incase of ENOMEM so it is very unlikely
> but allowed. If this happens then es_tree will be out of sinc with
> extent_tree which later result in corruption.

I don't think we need to worry about it because we always remove some
extents from status tree, and then try to insert some one.  -ENOMEM will
be returned when we are trying to insert a extent.  So when -ENOMEM is
returned, that means that no related extent is in status tree.  So later
we won't lookup this extent in map_blocks().

> >  		goto out;
> >  	} else if (err)
> >  		goto fix_extent_len;
> > @@ -3150,6 +3170,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >  	ee_block = le32_to_cpu(ex->ee_block);
> >  	ee_len = ext4_ext_get_actual_len(ex);
> >  	allocated = ee_len - (map->m_lblk - ee_block);
> > +	zero_ex.ee_len = 0;
> >  
> >  	trace_ext4_ext_convert_to_initialized_enter(inode, map, ex);
> >  
> > @@ -3247,6 +3268,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >  		err = ext4_ext_zeroout(inode, ex);
> >  		if (err)
> >  			goto out;
> > +		zero_ex.ee_block = ex->ee_block;
> > +		zero_ex.ee_len = ext4_ext_get_actual_len(ex);
> > +		ext4_ext_store_pblock(&zero_ex, ext4_ext_pblock(ex));
> >  
> >  		err = ext4_ext_get_access(handle, inode, path + depth);
> >  		if (err)
> > @@ -3305,6 +3329,9 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
> >  		err = allocated;
> >  
> >  out:
> > +	/* If we have gotten a failure, don't zero out status tree */
> > +	if (!err)
> > +		err = ext4_es_zeroout(inode, &zero_ex);
> >  	return err ? err : allocated;
> >  }
> >  
> > diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> > index a434f81..e7bebbc 100644
> > --- a/fs/ext4/extents_status.c
> > +++ b/fs/ext4/extents_status.c
> > @@ -854,6 +854,23 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
> >  	return err;
> >  }
> >  
> > +int ext4_es_zeroout(struct inode *inode, struct ext4_extent *ex)
> > +{
> > +	ext4_lblk_t  ee_block;
> > +	ext4_fsblk_t ee_pblock;
> > +	unsigned int ee_len;
> > +
> > +	ee_block  = le32_to_cpu(ex->ee_block);
> > +	ee_len    = ext4_ext_get_actual_len(ex);
> > +	ee_pblock = ext4_ext_pblock(ex);
> Andreas Dilger do not like local variables which used only once.  Let's avoid that.

As I said above.

Regards,
                                                - Zheng
