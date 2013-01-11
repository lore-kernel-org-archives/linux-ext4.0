From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] call end_page_writeback after converting unwritten extents
 in ext4_end_io
Date: Fri, 11 Jan 2013 10:29:07 +0800
Message-ID: <20130111022907.GA7234@gmail.com>
References: <20130110055617.GA4415@gmail.com>
 <20130110144719.GA26413@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42426 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3AKCP0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jan 2013 21:15:26 -0500
Received: by mail-pa0-f41.google.com with SMTP id bj3so718451pad.0
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jan 2013 18:15:25 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130110144719.GA26413@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 10, 2013 at 03:47:19PM +0100, Jan Kara wrote:
[cut...]
> > Now I have an idea to solve this problem.  We start a journal before submitting
> > an io request rather than start it in ext4_convert_unwritten_extents().  The
> > reason of starting a journal in ext4_convert_unwritten_extents() is that we need
> > to calculate credits for journal.  But as far as I understand the credits is not
> > increased in this function because we have splitted extents before submitting
> > this io request.  A 'handle_t *handle' will be added into ext4_io_end_t, and it
> > will be used in ext4_convert_unwritten_extents().  Then we can avoid to
> > trigger a journal commit when starting a journal.
>   I'm actually already working on a solution. The disadvantage of starting
> a transaction before IO submission is that the handle will hold transaction
> open all the time until IO is finished and extent converted. So it can
> effectively block any filesystem activity for a relatively long time. I've
> already written a patch for JBD2 to allow transaction reservation - it
> reserves blocks in the journal but they are not attached to a particular
> transaction. Later during extent conversion we transform this reservation
> into a real handle (without waiting for the journal so locking is OK).

Great!

> 
> The part I'm missing so far is adding transaction reservation into IO
> submission path. That is actually somewhat tricky because we have to do it
> before taking page locks and propagate the reserved handle all the way down
> to the point where we allocate io_end. And furthermore we have to somehow
> deal with the fact that IO to one extent can be split among multiple BIOs
> (as it happens e.g. when an extent is longer than 512 KB which is usual
> limit on BIO size) and thus multiple io_end structures are created and
> extent is converted in parts (actually we didn't think about this problem
> previously in extent conversion code).  We don't know in advance how much
> BIOs we'll need to write the extents (bio_add_page() decides when the BIO
> is full and there are other constraints on BIO than just the total size) so
> what we need to do it so have one io_end structure shared by all the BIOs
> covering the extent. That will also save us from unnecessary splitting and
> joining of extents for conversion. But doing that requires some changes to
> io submission path which is why it's taking me longer than I'd like (plus I
> have other obligations than just improving ext4 ;) But I'm working on it so
> please stay tuned...

Now all I need to do is to have a cup of coffee and wait your patches. :)

Regards,
                                                - Zheng
