From: Jan Kara <jack@suse.cz>
Subject: Re: Journal async commit broken for data=ordered?
Date: Wed, 15 Feb 2012 16:57:07 +0100
Message-ID: <20120215155707.GB9015@quack.suse.cz>
References: <20120214155536.GA16561@quack.suse.cz>
 <15A0337B-5C65-4C36-9AD9-BE5D0E8EF812@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2BOP5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 10:57:10 -0500
Content-Disposition: inline
In-Reply-To: <15A0337B-5C65-4C36-9AD9-BE5D0E8EF812@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 14-02-12 13:56:30, Andreas Dilger wrote:
> On 2012-02-14, at 8:55 AM, Jan Kara wrote:
> >  I've just realized that JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT breaks
> > guarantees of data=ordered mode in ext4. The problem is that async commit
> > code assumes that when a checksum of a transaction in the journal matches,
> > all necessary data is on disk. This is true for metadata but need not be so
> > for data - the whole transaction may be correctly on pernament storage
> > while some data is still sitting in drive's caches. Thus if a power failure
> > happens at that moment, we have broken guarantees of data=ordered mode.
> > Seeing that async commit code isn't used by default anyway (I remember
> > there used to be some problems with it), shouldn't we just rip it out?
> 
> A better long-term solution would be to submit the block IO in advance of
> marking the metadata dirty, so the data is safe on disk before the journal
> becomes involved.
  Umm, I don't see how that would really make difference. Unless you flush
disk's caches you can never be sure data made it to disk. And you must make
sure data is on disk before anyone has a chance to see transaction writing
these data fully written into the log.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
