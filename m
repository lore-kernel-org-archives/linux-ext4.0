From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] jbd2: commit as soon as possible after
 log_start_commit
Date: Mon, 4 Feb 2013 16:02:04 -0500
Message-ID: <20130204210204.GB12826@thunk.org>
References: <1359654788-6078-1-git-send-email-tytso@mit.edu>
 <1359654788-6078-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Barry J. Marson" <bmarson@redhat.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46947 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab3BDVCH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Feb 2013 16:02:07 -0500
Content-Disposition: inline
In-Reply-To: <1359654788-6078-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 12:53:07PM -0500, Theodore Ts'o wrote:
> Once a transaction has been requested to be committed, don't let any
> other handles start under that transaction, and don't allow any
> pending transactions to be extended (i.e., in the case of
> unlink/ftruncate).
> 
> The idea is once the transaction has had log_start_commit() called on
> it, at least one thread is blocked waiting for that transaction to
> commit, and over time, more and more threads will end up getting
> blocked.  In order to avoid high variability in file system operations
> getting blocked behind the a blocked start_this_handle(), we should
> try to get the commit started as soon as possible.

I'm going to drop this patch because thanks to some performance
measurement works by Barry Marson at Red Hat, it shows that this patch
apparently makes things worse by 17% with AIM7.

At a guess, it looks like some AIM7 has enough threads competing for
the CPU that it can take a good 80ms or more before kjournald can get
scheduled, and then start locking down the transaction.  During those
80ms, a number of short transactions get in and out and make forward
progress on the benchmark.  However, there are some "long pole"
handles that will take up to 100-250ms to complete, and during that
time, nothing else can get done.  By starting to lock down the
transaction as soon as the commit is requested, instead of waiting
until the kjournald thread can be scheduled, we end up limiting
forward progress made by the quick "in and out" handles, and this far
outweighs the benefits of stopping a long-lived handle from getting
started.

It may be that after we do some work to conclusively identify what
these "long pole" handles might be --- I strongly suspect they come
from truncate/unlink calls, but we need to make sure.  If in fact they
are coming from truncate/unlink calls, it might be possible to let a
truncate processing stop its handle once it notices that we are
requesting that a journal commit should start, so we can lower the
average amount of time start_this_handle() gets blocked waiting for a
commit to complete.

Thanks again to Barry for doing the benchmarking work!  As always,
people who provide us with benchmarking support provide an absolutely
invaluable service.

					- Ted
