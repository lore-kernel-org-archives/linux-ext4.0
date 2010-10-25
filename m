From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 6/6] ext4: use bio layer instead of buffer layer in
 mpage_da_submit_io
Date: Mon, 25 Oct 2010 08:33:53 -0400
Message-ID: <20101025123353.GA16981@thunk.org>
References: <1287866420-23762-1-git-send-email-tytso@mit.edu>
 <1287866420-23762-7-git-send-email-tytso@mit.edu>
 <87tykavom7.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	axboe@kernel.dk
To: Dmitry <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50650 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab0JYMeH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 08:34:07 -0400
Content-Disposition: inline
In-Reply-To: <87tykavom7.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 25, 2010 at 09:16:16AM +0400, Dmitry wrote:
> > +	if (bio) {
> > +		bio_get(io->io_bio);
> > +		submit_bio(io->io_op, io->io_bio);
> > +		BUG_ON(bio_flagged(io->io_bio, BIO_EOPNOTSUPP));
> Definitly this BUG_ON should be converted to ext4_error or something
> similar, otherwhise writeback attempt to removed usb-stick will be fatal
> for a whole system. IMHO it is reasonable to skip this check at all,
> because all work will be done in ext4_end_bio() anyway.
> > +		bio_put(io->io_bio);

Cut and pasted from XFS.  From what I could tell from the block I/O
layer, the only time the buffer I/O layer should return BIO_EOPNOTSUPP
is if we pass it a discard or barrier request, and we're doing neither
here.  So I don't think it should trigger on a removed usb-stick.

At the same time, it's not clear what good the BUG_ON() is doing here,
either.  So perhaps we could could drop the BUG_ON, at which point we
could drop the bio_get() and bio_put() calls, too.  To be honest I'm
not entirely sure why the XFS code does this.

Jens?  Any reason why I shouldn't just remove the bio_get(), the
BUG_ON()check, and bio_put() calls?

					- Ted
