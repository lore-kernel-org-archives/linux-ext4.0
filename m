From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] jbd2: fix r_count overflows leading to buffer overflow
 in journal recovery
Date: Thu, 14 May 2015 11:09:29 -0700
Message-ID: <20150514180929.GF30577@birch.djwong.org>
References: <20150513185646.GE30577@birch.djwong.org>
 <20150514121940.GC10093@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26826 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbbENSJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2015 14:09:38 -0400
Content-Disposition: inline
In-Reply-To: <20150514121940.GC10093@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2015 at 02:19:40PM +0200, Jan Kara wrote:
> On Wed 13-05-15 11:56:46, Darrick J. Wong wrote:
> > The journal revoke block recovery code does not check r_count for
> > sanity, which means that an evil value of r_count could result in
> > the kernel reading off the end of the revoke table and into whatever
> > garbage lies beyond.  This could crash the kernel, so fix that.
> > 
> > However, in testing this fix, I discovered that the code to write
> > out the revoke tables also was not correctly checking to see if the
> > block was full -- the current offset check is fine so long as the
> > revoke table space size is a multiple of the record size, but this
> > is not true when either journal_csum_v[23] are set.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ...
> > @@ -594,9 +594,14 @@ static void write_one_revoke_record(journal_t *journal,
> >  	if (jbd2_journal_has_csum_v2or3(journal))
> >  		csum_size = sizeof(struct jbd2_journal_revoke_tail);
> >  
> > +	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_64BIT))
> > +		sz = 8;
> > +	else
> > +		sz = 4;
> > +
> >  	/* Make sure we have a descriptor with space left for the record */
> >  	if (descriptor) {
> > -		if (offset >= journal->j_blocksize - csum_size) {
> > +		if (offset + sz >= journal->j_blocksize - csum_size) {
>   Hum, but we can have strict inequality here, can't we? Otherwise the
> patch looks good to me.

You're right, it could be greater-than here.  Will respin this and the
corresponding e2fsprogs patch.

--D

> 
> 								Honza
> 
> 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
