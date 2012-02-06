From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous
 direct I/O requests
Date: Mon, 6 Feb 2012 17:58:36 +0100
Message-ID: <20120206165836.GJ6890@quack.suse.cz>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
 <1327698949-12616-3-git-send-email-jmoyer@redhat.com>
 <20120202173120.GA6640@quack.suse.cz>
 <x49bopcq6gi.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab2BFQ6i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Feb 2012 11:58:38 -0500
Content-Disposition: inline
In-Reply-To: <x49bopcq6gi.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 06-02-12 11:20:29, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> +	/* workqueue for aio+dio+o_sync disk cache flushing */
> >> +	struct workqueue_struct *aio_dio_flush_wq;
> >> +
> >   Hmm, looking at the patch I'm wondering why did you introduce the new
> > workqueue? It seems dio_unwritten_wq would be enough? You just need to
> > rename it to something more appropriate ;)
> 
> I used a new workqueue as the operations are blocking, and I didn't want
> to hold up other progress.  If you think re-using the unwritten_wq is
> the right thing to do, I'm happy to comply.
  Ah, ok. Thinking about it, it's probably better to use a separate work
queue then.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
