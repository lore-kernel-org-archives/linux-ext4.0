From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC 1/2] ext4: speed-up truncate/unlink
Date: Tue, 18 Sep 2012 00:10:06 -0400
Message-ID: <20120918041006.GC32195@thunk.org>
References: <CAA0+VHzw55=4X43GK9RkRK_q4qmzR8KyqrrFidQMCPb6r4nPeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrey Sidorov <qrxd43@motorola.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51224 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab2IREKK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 00:10:10 -0400
Content-Disposition: inline
In-Reply-To: <CAA0+VHzw55=4X43GK9RkRK_q4qmzR8KyqrrFidQMCPb6r4nPeA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 01:00:30AM +0400, Andrey Sidorov wrote:
> Do not iterate over data blocks scanning for bh's to forget as they're
> never exist. This improves time taken by unlink / truncate syscall.
> Tested by continuously truncating file that is being written by dd.
> Another test is rm -rf of linux tree while tar unpacks it. With
> ordered data mode condition unlikely(!tbh) was always met in
> ext4_free_blocks. With journal data mode tbh was found only few times,
> so optimisation is also possible.

Thanks for this patch.  It's good you did the testing, although from a
theoretical point of view I'm sure it's sound because the only case
where journal=data mode will there be data blocks in the buffer cache.
In the other cases, the data is cached in the page cache, so it's a
waste of time looking up the blocks so they can be bforgotten.

The one thing which is missing from your patch is a Signed-off-by:
footer.  This has a specific legal meaning.  See:

	http://elinux.org/Developer_Certificate_Of_Origin

You don't need to resend this patch, though; just reply with an
acknowledgement that you agree to add your DCO to the patch:

Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>


Thanks for contributing to the ext4 file system!

						- Ted
