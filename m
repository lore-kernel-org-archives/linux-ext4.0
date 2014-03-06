From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Thu, 6 Mar 2014 18:54:05 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com> <1393855228-13592-3-git-send-email-mlombard@redhat.com> <20140306154407.GA28226@thunk.org> <20140306165416.GA2182@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaCFRyM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 12:54:12 -0500
In-Reply-To: <20140306165416.GA2182@dhcp-27-189.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 6 Mar 2014, Maurizio Lombardi wrote:

> Date: Thu, 6 Mar 2014 17:54:16 +0100
> From: Maurizio Lombardi <mlombard@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org
> Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
> 
> On Thu, Mar 06, 2014 at 10:44:07AM -0500, Theodore Ts'o wrote:
> > On Mon, Mar 03, 2014 at 03:00:28PM +0100, Maurizio Lombardi wrote:
> > > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > > index 08ddfda..546575a 100644
> > > --- a/fs/ext4/mballoc.c
> > > +++ b/fs/ext4/mballoc.c
> > > @@ -3059,6 +3059,21 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
> > >  		size	  = ac->ac_o_ex.fe_len << bsbits;
> > >  	}
> > >  	size = size >> bsbits;
> > > +
> > > +	/* In any case, the size cannot be greater than the number
> > > +	 * of maximum free blocks per group.
> > > +	 */
> > > +	if (size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb)) {
> > > +		int sz_log2;
> > > +
> > > +		size = EXT4_BLOCKS_PER_GROUP(ac->ac_sb);
> > > +
> > > +		/* Recalculate the start offset */
> > > +		sz_log2 = __fls(size << bsbits);
> > > +		start_off = ((loff_t) ac->ac_o_ex.fe_logical >>
> > > +					(sz_log2 - bsbits)) << sz_log2;
> > > +	}
> > > +
> > >  	start = start_off >> bsbits;
> > >  
> > >  	/* don't cover already allocated blocks in selected range */
> > 
> > This definitely fixes the bug.  However, there will be some cases
> > where if the blocks per group is sufficiently small, where for smaller
> > files, start_off would have been 0 instead of that complicated
> > expression.
> 
> Mmmm... if I correctly understood how ext4_normalize_request() works, everytime
> you truncate the value of "size" you have to recalculate the correct start offset.
> Note that start_off is zero only in those case where size is left untouched or
> increased.

(ignoring the fact that the ext4_mb_normalize_request() is broken
for now)

Yes it tries to align down the start_off of the bigger requests to the 512,
1024, 2048, or 4096 respectively. What the reason for it is really I have
no idea. The fact is however that this will only affect file systems
with bs smaller than 4k since the start_off will be always aligned to
block size afterwards (obviously).

That said this alignment is only done when the request is "big
enough". With your change we also do it when the block group is
"small enough" which is the change in behaviour which I think was
not really intended.

Honestly I do not think this really matters a lot but this alignment
you've added is not necessary.

All that said, I was getting to rewrite this mess a long time ago,
it's just a reminder that it's something that needs to be done.
Especially since the bigger requests are getting split unnecessarily
which hurts especially in fallocate case.

Thanks!
-Lukas

> 
> > 
> > Looking at ext4_mb_normalize_request(), exactly what this code is
> > trying to do is actually a bit opaque to me, and every time I look at
> > it I get a headache.
> 
> Yes unfortunately the code is not very easy to understand.
> I may be missing something and it would be nice to have someone who knows it
> better to shed some light on it.
> 
> Regards,
> Maurizio Lombardi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
