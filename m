From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v7 2/11] xfs: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Date: Wed, 07 Jan 2015 14:46:24 +0900
Message-ID: <001601d02a3d$459aaa00$d0cffe00$@samsung.com>
References: <004001d02670$33d2f3c0$9b78db40$@samsung.com>
	<20150106163326.GF5874@bfoster.bfoster>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>,
	linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>
To: 'Brian Foster' <bfoster@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-reply-to: <20150106163326.GF5874@bfoster.bfoster>
Content-language: ko
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

> 
> On Fri, Jan 02, 2015 at 06:40:54PM +0900, Namjae Jeon wrote:
> > This patch implements fallocate's FALLOC_FL_INSERT_RANGE for XFS.
> >
> > 1) Make sure that both offset and len are block size aligned.
> > 2) Update the i_size of inode by len bytes.
> > 3) Compute the file's logical block number against offset. If the computed
> >    block number is not the starting block of the extent, split the extent
> >    such that the block number is the starting block of the extent.
> > 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
> >    towards right by len bytes. This step will make a hole of len bytes
> >    at offset.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Cc: Brian Foster<bfoster@redhat.com>
> > ---
> 
> Hi Namjae,
Hi Brian,
> 
> Just a few small things...
> 

> > +	} else {
> > +		startoff = got.br_startoff + offset_shift_fsb;
> > +		/*
> > +		 * If this is not the last extent in the file, make sure there's
> > +		 * enough room between current extent and next extent for
> > +		 * accomodating the shift.
> 
> Spelling nit:	   accommodating
Okay, I will fix it.

> 
> > +		 */
> > +		if (*current_ext < (total_extents - 1)) {
> > +			contp = xfs_iext_get_ext(ifp, *current_ext + 1);
> > +			xfs_bmbt_get_all(contp, &cont);
> > +			if (startoff + got.br_blockcount > cont.br_startoff)
> > +				return -EINVAL;
> > +			if (xfs_bmse_can_merge(&got, &cont,  offset_shift_fsb))
> > +				WARN_ON_ONCE(1);
> 
> Ok, but a comment before the check would be nice should somebody have to
> look up the warning that fires here. E.g.,:
> 
> /*
>  * Unlike a left shift (which involves a hole punch), a right shift does
>  * not modify extent neighbors in any way. We should never find
>  * mergeable extents in this scenario. Check anyways and warn if we
>  * encounter two extents that could be one.
>  */
Okay, I will update it.

> > -	/*
> > -	 * There may be delalloc extents in the data fork before the range we
> > -	 * are collapsing out, so we cannot use the count of real extents here.
> > -	 * Instead we have to calculate it from the incore fork.
> > -	 */
> > -	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
> > -	while (nexts++ < num_exts && current_ext < total_extents) {
> > +	/* some sanity checking before we finally start shifting extents */
> > +	if ((SHIFT == SHIFT_LEFT && current_ext > stop_extent) ||
> > +	     (SHIFT == SHIFT_RIGHT && current_ext < stop_extent)) {
> > +		error = EIO;
> > +		goto del_cursor;
> > +	}
> 
> If stop_extent is consistently exclusive now, we probably need to use >=
> and <= here (e.g., 'stop_extent' should never be shifted).
You're Right. I will fix it.
> 
> > +

> > +del_cursor:
> > +	if (cur) {
> > +		cur->bc_private.b.allocated = 0;
> > +		xfs_btree_del_cursor(cur,
> > +				error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
> > +	}
> > +	xfs_trans_log_inode(tp, ip, logflags);
> 
> 	if (logflags)
> 		xfs_trans_log_inode(tp, ip, logflags);
Okay.
> 
> Otherwise, the rest looks pretty good. I'll try to do some testing with
> it soon.
Thanks very much for your review!!
> 
> Brian
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
