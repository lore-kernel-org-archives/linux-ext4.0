From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: generic/224 failures on 4.5 - encrypted test case
Date: Tue, 15 Mar 2016 18:13:56 -0400
Message-ID: <20160315221356.GC23848@thunk.org>
References: <20160315213727.GA2635@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48268 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbcCOWN7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 18:13:59 -0400
Content-Disposition: inline
In-Reply-To: <20160315213727.GA2635@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2016 at 05:37:27PM -0400, Eric Whitney wrote:
> The test fails relatively rarely - about one in ten trials.  The set of
> reported kernel errors varies considerably from run to run.  The one constant
> is an ENOSPC complaint from ext4_bio_write_page() which appears whether the
> test passes or fails.
>
> [   18.146614] ext4_bio_write_page: ret = -12
>

-12 is not ENOSPC; it's ENOMEM.   (ENOSPC is 28).

So basically we're hitting a case where generic/224 is submitting data
so quickly that we can't handle it fast enough.  I suspect the call
path is that we're inside the jbd2_commit(), and we're calling
journal_submit_data_buffers(), which ends up calling
ext4_writepages(), and this is returning the ENOMEM.  Unfortunately
we're not providing a better message there, and we just return
jbd2_journal_abort() if journal_submit_data_buffers() fails.

I suspect what we need to do is to pass down a flag through
ext4_bio_write_page() and ext4_encrypt() so that in the case where we
are doing a data integrity sync, that we have to use GFP_NOFAIL in our
data allocations in the fs/ext4/crypto.c.

							- Ted
