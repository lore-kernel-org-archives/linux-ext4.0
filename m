From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH-v2] JBD: Fix race between free buffer and commit
	trasanction
Date: Wed, 28 May 2008 17:15:08 -0700
Message-ID: <1212020108.3791.51.camel@localhost.localdomain>
References: <1210971693.3608.46.camel@localhost.localdomain>
	 <20080518223739.GB11006@atrey.karlin.mff.cuni.cz>
	 <1211227158.3663.25.camel@localhost.localdomain>
	 <20080519132553.de9b78b0.akpm@linux-foundation.org>
	 <1211234829.3663.39.camel@localhost.localdomain>
	 <1211306575.3664.19.camel@localhost.localdomain>
	 <20080520235303.GB23521@atrey.karlin.mff.cuni.cz>
	 <1211390093.5571.16.camel@BVR-FS.beaverton.ibm.com>
	 <20080524224447.GE20563@atrey.karlin.mff.cuni.cz>
	 <1211998739.3791.20.camel@localhost.localdomain>
	 <20080528185554.GA16018@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, pbadari@us.ibm.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51560 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYE2APM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 May 2008 20:15:12 -0400
In-Reply-To: <20080528185554.GA16018@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2008-05-28 at 20:55 +0200, Jan Kara wrote:
> On Wed 28-05-08 11:18:59, Mingming Cao wrote:

> > @@ -1682,9 +1712,11 @@ out:
> >   * journal_try_to_free_buffer() is changing its state.  But that
> >   * cannot happen because we never reallocate freed data as metadata
> >   * while the data is part of a transaction.  Yes?
> > + *
> > + * Return 0 on failure, 1 on success
> >   */
> >  int journal_try_to_free_buffers(journal_t *journal,
> > -				struct page *page, gfp_t unused_gfp_mask)
> > +				struct page *page, gfp_t gfp_mask)
> >  {
> >  	struct buffer_head *head;
> >  	struct buffer_head *bh;
> > @@ -1713,7 +1745,28 @@ int journal_try_to_free_buffers(journal_
> >  		if (buffer_jbd(bh))
> >  			goto busy;
> >  	} while ((bh = bh->b_this_page) != head);
> > +
> >  	ret = try_to_free_buffers(page);
> > +
> > + 	/*
> > +	 * There are a number of places where journal_try_to_free_buffers()
> > +	 * could race with journal_commit_transaction(), the later still
> > +	 * holds the reference to the buffers to free while processing them.
> > +	 * try_to_free_buffers() failed to free those buffers. Some of the
> > +	 * caller of releasepage() request page buffers to be dropped, otherwise
> > +	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
> > +	 *
> > +	 * So, if the caller of try_to_release_page() wants the synchronous
> > +	 * behaviour(i.e make sure buffers are dropped upon return),
> > +	 * let's wait for the current transaction to finish flush of
> > +	 * dirty data buffers, then try to free those buffers again,
> > +	 * with the journal locked.
> > +	 */
> > +	if (ret == 0 && (gfp_mask & GFP_KERNEL == GFP_KERNEL)) {
>   I think Andrew prefered this test to be expanded but otherwise the patch
> is fine now. You can add:
>   Acked-by: Jan Kara <jack@suse.cz>
> 
Okay, I will update the patch and cleanup the history, sent it to
Andrew. Thanks.

Mingming

