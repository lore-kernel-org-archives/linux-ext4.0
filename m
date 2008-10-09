From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Date: Wed, 8 Oct 2008 20:38:27 -0700
Message-ID: <20081008203827.f5897459.akpm@linux-foundation.org>
References: <20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
	<20081002212355.621a4fb6@infradead.org>
	<20081002214000.89420bb3.akpm@linux-foundation.org>
	<20081002214353.30873f98@infradead.org>
	<20081002215026.a63ba0d0.akpm@linux-foundation.org>
	<20081002220040.7963596c@infradead.org>
	<20081002222438.8f9f90a2.akpm@linux-foundation.org>
	<20081009030054.GD17512@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Arjan van de Ven <arjan@infradead.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYJIDj2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Oct 2008 23:39:28 -0400
In-Reply-To: <20081009030054.GD17512@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 8 Oct 2008 23:00:54 -0400 Theodore Tso <tytso@mit.edu> wrote:

> On Thu, Oct 02, 2008 at 10:24:38PM -0700, Andrew Morton wrote:
> > 
> > Mount a junk partition with `-oakpm' and run some benchmarks.  If the
> > results are "wow" then it's worth spending time on.  If the results are
> > "meh" then we can not bother..
> > 
> 
> I've ported the patch to the ext4 filesystem, and dropped it into the
> unstable portion of the ext4 patch queue.

Useful, thanks.

>  If we can get someone (hi,
> Ric!) to run fs_mark with and without -o akpm_lock_hack, I suspect we
> will find that it makes quite a large difference on that particular
> benchmark, since it is fsync-heavy to force a large number of
> transaction, and the creation of the inodes should cause multiple
> blocks that will be entangled between the current and committing
> transactions.
> 

fsync?  Yes, I suppose so.  Repeated modifications to the same
inodes/directories/bitmaps blocks/etc will hurt.

A quick test on other quantified workloads would be useful too.  If the
results look promising then someone(tm) will need to work out how to
fix this for real.

> 
> ext4: akpm's locking hack to fix locking delays
> 
> This is a port of the following patch from Andrew Morton to ext4:
> 
> 	http://lkml.org/lkml/2008/10/3/22
> 
> This fixes a major contention problem in do_get_write_access() when a
> buffer is modified in both the current and committing transaction.

More specifically: "under checkpoint writeback in the committing
transaction when the committing transaction requests write access".

