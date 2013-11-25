From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 09/25] e2fsck: teach EA refcounting code to handle 64bit
 block addresses
Date: Mon, 25 Nov 2013 16:18:31 +0800
Message-ID: <20131125081831.GD5964@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018044955.7339.72152.stgit@birch.djwong.org>
 <20131018183700.GC19188@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49386 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3KYIPq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 03:15:46 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so4929093pde.7
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 00:15:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018183700.GC19188@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 18, 2013 at 11:37:00AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 17, 2013 at 09:49:55PM -0700, Darrick J. Wong wrote:
> > The extended attribute refcounting code only accepts blk_t, which is
> > dangerous because EA blocks can exist at high addresses (> 2^32) as
> > well.  Therefore, widen the block fields to 64 bits.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> > ---
> >  e2fsck/e2fsck.h      |   12 ++++++------
> >  e2fsck/ea_refcount.c |   36 ++++++++++++++++++------------------
> >  2 files changed, 24 insertions(+), 24 deletions(-)
> > 
> > 
> > diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> > index 13d70f1..f1df525 100644
> > --- a/e2fsck/e2fsck.h
> > +++ b/e2fsck/e2fsck.h
> > @@ -432,17 +432,17 @@ extern struct dx_dir_info *e2fsck_dx_dir_info_iter(e2fsck_t ctx, int *control);
> >  /* ea_refcount.c */
> >  extern errcode_t ea_refcount_create(int size, ext2_refcount_t *ret);
> >  extern void ea_refcount_free(ext2_refcount_t refcount);
> > -extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
> > +extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk,
> >  				   int *ret);
> >  extern errcode_t ea_refcount_increment(ext2_refcount_t refcount,
> > -				       blk_t blk, int *ret);
> > +				       blk64_t blk, int *ret);
> >  extern errcode_t ea_refcount_decrement(ext2_refcount_t refcount,
> > -				       blk_t blk, int *ret);
> > +				       blk64_t blk, int *ret);
> >  extern errcode_t ea_refcount_store(ext2_refcount_t refcount,
> > -				   blk_t blk, int count);
> > -extern blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
> > +				   blk64_t blk, int count);
> > +extern blk64_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
> >  extern void ea_refcount_intr_begin(ext2_refcount_t refcount);
> > -extern blk_t ea_refcount_intr_next(ext2_refcount_t refcount, int *ret);
> > +extern blk64_t ea_refcount_intr_next(ext2_refcount_t refcount, int *ret);
> >  
> >  /* ehandler.c */
> >  extern const char *ehandler_operation(const char *op);
> > diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
> > index e66e636..6f376a3 100644
> > --- a/e2fsck/ea_refcount.c
> > +++ b/e2fsck/ea_refcount.c
> > @@ -25,14 +25,14 @@
> >   * checked, its bit is set in the block_ea_map bitmap.
> >   */
> >  struct ea_refcount_el {
> > -	blk_t	ea_blk;
> > +	blk64_t	ea_blk;
> >  	int	ea_count;
> >  };
> >  
> >  struct ea_refcount {
> > -	blk_t		count;
> > -	blk_t		size;
> > -	blk_t		cursor;
> > +	unsigned long		count;
> > +	unsigned long		size;
> > +	unsigned long		cursor;
> 
> This (unsigned long instead of blk_t) is the only thing that changed since last
> time.
> 
> --D
> 
> >  	struct ea_refcount_el	*list;
> >  };
> >  
> > @@ -111,11 +111,11 @@ static void refcount_collapse(ext2_refcount_t refcount)
> >   * 	specified position.
> >   */
> >  static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
> > -						 blk_t blk, int pos)
> > +						 blk64_t blk, int pos)
> >  {
> >  	struct ea_refcount_el 	*el;
> >  	errcode_t		retval;
> > -	blk_t			new_size = 0;
> > +	blk64_t			new_size = 0;
> >  	int			num;
> >  
> >  	if (refcount->count >= refcount->size) {
> > @@ -153,7 +153,7 @@ static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
> >   * 	and we can't find an entry, create one in the sorted list.
> >   */
> >  static struct ea_refcount_el *get_refcount_el(ext2_refcount_t refcount,
> > -					      blk_t blk, int create)
> > +					      blk64_t blk, int create)
> >  {
> >  	int	low, high, mid;
> >  
> > @@ -206,7 +206,7 @@ retry:
> >  	return 0;
> >  }
> >  
> > -errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
> > +errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk,
> >  				int *ret)
> >  {
> >  	struct ea_refcount_el	*el;
> > @@ -220,7 +220,7 @@ errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
> >  	return 0;
> >  }
> >  
> > -errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk_t blk, int *ret)
> > +errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk64_t blk, int *ret)
> >  {
> >  	struct ea_refcount_el	*el;
> >  
> > @@ -234,7 +234,7 @@ errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk_t blk, int *ret)
> >  	return 0;
> >  }
> >  
> > -errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk_t blk, int *ret)
> > +errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk64_t blk, int *ret)
> >  {
> >  	struct ea_refcount_el	*el;
> >  
> > @@ -249,7 +249,7 @@ errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk_t blk, int *ret)
> >  	return 0;
> >  }
> >  
> > -errcode_t ea_refcount_store(ext2_refcount_t refcount, blk_t blk, int count)
> > +errcode_t ea_refcount_store(ext2_refcount_t refcount, blk64_t blk, int count)
> >  {
> >  	struct ea_refcount_el	*el;
> >  
> > @@ -263,7 +263,7 @@ errcode_t ea_refcount_store(ext2_refcount_t refcount, blk_t blk, int count)
> >  	return 0;
> >  }
> >  
> > -blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount)
> > +blk64_t ext2fs_get_refcount_size(ext2_refcount_t refcount)
> >  {
> >  	if (!refcount)
> >  		return 0;
> > @@ -277,7 +277,7 @@ void ea_refcount_intr_begin(ext2_refcount_t refcount)
> >  }
> >  
> >  
> > -blk_t ea_refcount_intr_next(ext2_refcount_t refcount,
> > +blk64_t ea_refcount_intr_next(ext2_refcount_t refcount,
> >  				int *ret)
> >  {
> >  	struct ea_refcount_el	*list;
> > @@ -370,7 +370,7 @@ int main(int argc, char **argv)
> >  	int	i = 0;
> >  	ext2_refcount_t refcount;
> >  	int		size, arg;
> > -	blk_t		blk;
> > +	blk64_t		blk;
> >  	errcode_t	retval;
> >  
> >  	while (1) {
> > @@ -394,7 +394,7 @@ int main(int argc, char **argv)
> >  			printf("Freeing refcount\n");
> >  			break;
> >  		case BCODE_STORE:
> > -			blk = (blk_t) bcode_program[i++];
> > +			blk = (blk64_t) bcode_program[i++];
> >  			arg = bcode_program[i++];
> >  			printf("Storing blk %u with value %d\n", blk, arg);
> >  			retval = ea_refcount_store(refcount, blk, arg);
> > @@ -403,7 +403,7 @@ int main(int argc, char **argv)
> >  					"while storing blk %u", blk);
> >  			break;
> >  		case BCODE_FETCH:
> > -			blk = (blk_t) bcode_program[i++];
> > +			blk = (blk64_t) bcode_program[i++];
> >  			retval = ea_refcount_fetch(refcount, blk, &arg);
> >  			if (retval)
> >  				com_err("ea_refcount_fetch", retval,
> > @@ -413,7 +413,7 @@ int main(int argc, char **argv)
> >  				       blk, arg);
> >  			break;
> >  		case BCODE_INCR:
> > -			blk = (blk_t) bcode_program[i++];
> > +			blk = (blk64_t) bcode_program[i++];
> >  			retval = ea_refcount_increment(refcount, blk, &arg);
> >  			if (retval)
> >  				com_err("ea_refcount_increment", retval,
> > @@ -423,7 +423,7 @@ int main(int argc, char **argv)
> >  				       blk, arg);
> >  			break;
> >  		case BCODE_DECR:
> > -			blk = (blk_t) bcode_program[i++];
> > +			blk = (blk64_t) bcode_program[i++];
> >  			retval = ea_refcount_decrement(refcount, blk, &arg);
> >  			if (retval)
> >  				com_err("ea_refcount_decrement", retval,
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
