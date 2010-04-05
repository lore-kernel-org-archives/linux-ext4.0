From: tytso@mit.edu
Subject: Re: [patch/rft] jbd2: tag journal writes as metadata I/O
Date: Mon, 5 Apr 2010 13:52:05 -0400
Message-ID: <20100405175205.GA4681@thunk.org>
References: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, esandeen@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab0DERwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Apr 2010 13:52:06 -0400
Content-Disposition: inline
In-Reply-To: <x49iq8b9ep5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 01, 2010 at 03:04:54PM -0400, Jeff Moyer wrote:
> 
> So, I'm submitting this patch for comments and testing.  I have a
> similar patch for jbd that I will submit if folks agree that this is a
> good idea.

Added to the ext4 patch queue.

What benchmark were you using to test small file writes?  This looks
good to me as well, but we might want to do some extra benchmarking
just to be sure we're not accidentally introducing a performance
regression.

						- Ted
