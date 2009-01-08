From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 changes in linux-next
Date: Wed, 7 Jan 2009 19:20:06 -0500
Message-ID: <20090108002006.GD4698@mit.edu>
References: <20090107140436.46a17a3e.akpm@linux-foundation.org> <20090107153209.b49d5cf7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:41018 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZAHAUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2009 19:20:09 -0500
Content-Disposition: inline
In-Reply-To: <20090107153209.b49d5cf7.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 07, 2009 at 03:32:09PM -0800, Andrew Morton wrote:
> On Wed, 7 Jan 2009 14:04:36 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > a pile of new ext4 stuff just turned up in linux-next

Sorry, most of the stuff had been sitting in the unstable part of the
queue, but I didn't have time to get them fully vetted and pushed into
the stable tree until the week just before and after the new year's.
They've actually been tested for a while, but I like to review all the
patches before they go in.

> Do you plan on merging all those changes into mainline for 2.6.29?  If
> so, please do so asap?

Yes, and I sent the pull request to Linus earlier today.  Last I
checked it hasn't hit his public tree yet, but hopefully it will by
tomorrow.

							- Ted
