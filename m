From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Wed, 4 Nov 2009 16:53:44 +0100
Message-ID: <20091104155344.GC21088@duck.suse.cz>
References: <1256647729-29834-1-git-send-email-jack@suse.cz> <1256647729-29834-5-git-send-email-jack@suse.cz> <87zl728hil.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57819 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbZKDPxk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 10:53:40 -0500
Content-Disposition: inline
In-Reply-To: <87zl728hil.fsf@basil.nowhere.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 04-11-09 15:57:22, Andi Kleen wrote:
> Jan Kara <jack@suse.cz> writes:
> >  	ext4_io_end_t *cur_aio_dio;
> > +
> > +	/*
> > +	 * Transactions that contain inode's metadata needed to complete
> > +	 * fsync and fdatasync, respectively.
> > +	 */
> > +	atomic_t i_sync_tid;
> > +	atomic_t i_datasync_tid;
> 
> This might be a stupid question, but the atomic implies you don't hold
> any kind of reference to the transaction. So what prevents these IDs
> from wrapping while in there? Given it would be probably take a long
> time today, but might be not fully future proof to very fast future IO
> devices.
  Yes, IDs can wrap. But journalling layer actually compares them so that
wrapping does not matter unless you manage to do 2^31 transactions
inbetween. So we are still a few orders of magnitude safe with current hw.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
