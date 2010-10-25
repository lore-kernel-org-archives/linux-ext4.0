From: Dmitry <dmonakhov@openvz.org>
Subject: Re: [PATCH -v2 6/6] ext4: use bio layer instead of buffer layer in mpage_da_submit_io
Date: Mon, 25 Oct 2010 17:05:59 +0400
Message-ID: <87k4l6pglk.fsf@dmon-lap.sw.ru>
References: <1287866420-23762-1-git-send-email-tytso@mit.edu> <1287866420-23762-7-git-send-email-tytso@mit.edu> <87tykavom7.fsf@dmon-lap.sw.ru> <20101025123353.GA16981@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	axboe@kernel.dk
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56616 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0JYNGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 09:06:05 -0400
Received: by ewy7 with SMTP id 7so4163057ewy.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Oct 2010 06:06:04 -0700 (PDT)
In-Reply-To: <20101025123353.GA16981@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 25 Oct 2010 08:33:53 -0400, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Oct 25, 2010 at 09:16:16AM +0400, Dmitry wrote:
> > > +	if (bio) {
> > > +		bio_get(io->io_bio);
> > > +		submit_bio(io->io_op, io->io_bio);
> > > +		BUG_ON(bio_flagged(io->io_bio, BIO_EOPNOTSUPP));
> > Definitly this BUG_ON should be converted to ext4_error or something
> > similar, otherwhise writeback attempt to removed usb-stick will be fatal
> > for a whole system. IMHO it is reasonable to skip this check at all,
> > because all work will be done in ext4_end_bio() anyway.
> > > +		bio_put(io->io_bio);
> 
> Cut and pasted from XFS.  From what I could tell from the block I/O
> layer, the only time the buffer I/O layer should return BIO_EOPNOTSUPP
> is if we pass it a discard or barrier request, and we're doing neither
> here.  So I don't think it should trigger on a removed usb-stick.
> 
> At the same time, it's not clear what good the BUG_ON() is doing here,
> either.  So perhaps we could could drop the BUG_ON, at which point we
> could drop the bio_get() and bio_put() calls, too.  To be honest I'm
> not entirely sure why the XFS code does this.
There are number of reasons why this can happen, for example
submit_bio()
  ->__generic_make_request()
      ->bio_check_eod() /* In case of virtual, device size may become
                            zero, after some error */
or if device may has fancy ->make_request_fn() callback.
Off course this is very unlikely(but i saw this couple of times)
and bio->bi_end_io() will be called in any case, so we can  drop that
extra safety logic, because sane bi_end_io(-EIO) implementation must
result in journal_abort. The only difference is the number of bio-s
we can issue before journal_abort was triggered.
So there is no an ambiguity there, you can just drop that extra check.
> 
> Jens?  Any reason why I shouldn't just remove the bio_get(), the
> BUG_ON()check, and bio_put() calls?
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
