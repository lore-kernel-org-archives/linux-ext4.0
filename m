From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Issue in ext4 rename
Date: Fri, 3 Apr 2015 11:06:00 -0400
Message-ID: <20150403150600.GC9988@thunk.org>
References: <551D1EA3.1050202@huawei.com>
 <20150402140258.GC6873@thunk.org>
 <551E6405.8050600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Joseph Qi <joseph.qi@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49278 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbbDCPG3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2015 11:06:29 -0400
Content-Disposition: inline
In-Reply-To: <551E6405.8050600@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 03, 2015 at 05:57:25PM +0800, Joseph Qi wrote:
> Hi Ted,
> Thanks very much for your quick and detailed reply.
> Yes, currently it will behave as RO, or PANIC or CONT based on the
> mounted options.
> You suggested a way to make sure the allocation cannot fail.
> I am wondering if we can omit this handle when commit, for example,
> introducing a way that invalids the handle in jbd2.

Not really, because we've already started modifying data structures at
this point; hence my comment that in order to do this we would have to
implement a fairly heavyweight transaction rollback scheme.  For
eample, we could make every single ext4_journal_get_write_access()
allocate a 4k page to store a copy of the 4k buffer we were about to
modify, so in case some other ext4_journal_get_write_access() failed,
we could roll back the handle.  But that inceases the amount of memory
required for each transaction by an order of magnitude --- and worse,
what if some other handle needs to modify the same block?  We couldn't
let that handle proceed until the first handle was stopped.

So we would trash performance *and* use more memory, making memory
allocation and memory pressures worse.  In other words, the cure is
worse than the disease; much worse.

Best regards,

						- Ted
