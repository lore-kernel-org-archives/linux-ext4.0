From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] Use ext4_ext_next_allocated_block instead of
 mext_next_extent
Date: Thu, 14 Aug 2014 17:04:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1408141704180.2267@localhost.localdomain>
References: <1407944711-5025-1-git-send-email-dmonakhov@openvz.org> <878umss83j.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166AbaHNPEi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Aug 2014 11:04:38 -0400
In-Reply-To: <878umss83j.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 13 Aug 2014, Dmitry Monakhov wrote:

> Date: Wed, 13 Aug 2014 19:49:20 +0400
> From: Dmitry Monakhov <dmonakhov@openvz.org>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu
> Subject: Re: [PATCH 1/2] Use ext4_ext_next_allocated_block instead of
>     mext_next_extent
> 
> On Wed, 13 Aug 2014 19:45:10 +0400, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Sorry this is wrong vesrion. Please ignore this series.

oops :) ok I will

> > This allow to make mext_next_extent static.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/ext4/ext4.h        |    2 --
> >  fs/ext4/extents.c     |   18 ++++++------------
> >  fs/ext4/move_extent.c |    2 +-
> >  3 files changed, 7 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 5b19760..f8d85f7 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -2739,8 +2739,6 @@ extern void ext4_double_up_write_data_sem(struct inode *orig_inode,
> >  extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
> >  			     __u64 start_orig, __u64 start_donor,
> >  			     __u64 len, __u64 *moved_len);
> > -extern int mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
> > -			    struct ext4_extent **extent);
> >  
> >  /* page-io.c */
> >  extern int __init ext4_init_pageio(void);
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 76c2df3..2e38ecb 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -5304,7 +5304,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
> >  	struct ext4_ext_path *path;
> >  	int ret = 0, depth;
> >  	struct ext4_extent *extent;
> > -	ext4_lblk_t stop_block, current_block;
> > +	ext4_lblk_t stop_block;
> >  	ext4_lblk_t ex_start, ex_end;
> >  
> >  	/* Let path point to the last extent */
> > @@ -5365,18 +5365,12 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
> >  					 (unsigned long) start);
> >  			return -EIO;
> >  		}
> > -
> > -		current_block = le32_to_cpu(extent->ee_block);
> > -		if (start > current_block) {
> > +		if (start > le32_to_cpu(extent->ee_block)) {
> >  			/* Hole, move to the next extent */
> > -			ret = mext_next_extent(inode, path, &extent);
> > -			if (ret != 0) {
> > -				ext4_ext_drop_refs(path);
> > -				kfree(path);
> > -				if (ret == 1)
> > -					ret = 0;
> > -				break;
> > -			}
> > +			start = ext4_ext_next_allocated_block(path);
> > +			ext4_ext_drop_refs(path);
> > +			kfree(path);
> > +			continue;
> >  		}
> >  		ret = ext4_ext_shift_path_extents(path, shift, inode,
> >  				handle, &start);
> > diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
> > index 671a74b..123a51b 100644
> > --- a/fs/ext4/move_extent.c
> > +++ b/fs/ext4/move_extent.c
> > @@ -76,7 +76,7 @@ copy_extent_status(struct ext4_extent *src, struct ext4_extent *dest)
> >   * ext4_ext_path structure refers to the last extent, or a negative error
> >   * value on failure.
> >   */
> > -int
> > +static int
> >  mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
> >  		      struct ext4_extent **extent)
> >  {
> > -- 
> > 1.7.1
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
