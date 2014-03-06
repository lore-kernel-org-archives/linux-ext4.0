From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Thu, 6 Mar 2014 17:54:16 +0100
Message-ID: <20140306165416.GA2182@dhcp-27-189.brq.redhat.com>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
 <1393855228-13592-3-git-send-email-mlombard@redhat.com>
 <20140306154407.GA28226@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140306154407.GA28226@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 06, 2014 at 10:44:07AM -0500, Theodore Ts'o wrote:
> On Mon, Mar 03, 2014 at 03:00:28PM +0100, Maurizio Lombardi wrote:
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index 08ddfda..546575a 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -3059,6 +3059,21 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
> >  		size	  = ac->ac_o_ex.fe_len << bsbits;
> >  	}
> >  	size = size >> bsbits;
> > +
> > +	/* In any case, the size cannot be greater than the number
> > +	 * of maximum free blocks per group.
> > +	 */
> > +	if (size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb)) {
> > +		int sz_log2;
> > +
> > +		size = EXT4_BLOCKS_PER_GROUP(ac->ac_sb);
> > +
> > +		/* Recalculate the start offset */
> > +		sz_log2 = __fls(size << bsbits);
> > +		start_off = ((loff_t) ac->ac_o_ex.fe_logical >>
> > +					(sz_log2 - bsbits)) << sz_log2;
> > +	}
> > +
> >  	start = start_off >> bsbits;
> >  
> >  	/* don't cover already allocated blocks in selected range */
> 
> This definitely fixes the bug.  However, there will be some cases
> where if the blocks per group is sufficiently small, where for smaller
> files, start_off would have been 0 instead of that complicated
> expression.

Mmmm... if I correctly understood how ext4_normalize_request() works, everytime
you truncate the value of "size" you have to recalculate the correct start offset.
Note that start_off is zero only in those case where size is left untouched or
increased.

> 
> Looking at ext4_mb_normalize_request(), exactly what this code is
> trying to do is actually a bit opaque to me, and every time I look at
> it I get a headache.

Yes unfortunately the code is not very easy to understand.
I may be missing something and it would be nice to have someone who knows it
better to shed some light on it.

Regards,
Maurizio Lombardi

