From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] [RFC] mkjournal: zero journal blocks only when
	necessary
Date: Wed, 29 Jul 2009 13:16:49 -0400
Message-ID: <20090729171649.GB14105@mit.edu>
References: <71a0d6ff0905120549h628146d8p3def31b09b79199a@mail.gmail.com> <1248883096-2294-1-git-send-email-alexander.shishckin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Alexander Shishkin <alexander.shishckin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46121 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZG2RRE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Jul 2009 13:17:04 -0400
Content-Disposition: inline
In-Reply-To: <1248883096-2294-1-git-send-email-alexander.shishckin@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 29, 2009 at 06:58:16PM +0300, Alexander Shishkin wrote:
> Will something like this do?
> 
> The only blocks that might theoretically (although very unlikely) be
> dangerous for newly-created filesystem's integrity are those that
> still contain valid signatures, others can be safely skipped.
> 
> Since reads are generally faster (or at least, not slower), this
> gives some performance increase during mkfs run.

Did you bother benchmarking what this would do on normal disk drives?
Previously we were writing out the blocks to be zeroed in large chunks
at a time for speed reasons.  This patch reduces it to reading the
journal one block at a time, and if it contains a valid signature it
writes a zero block.

The patch also doesn't check for commit blocks, which are just as much
a problem (if not more so) than revoke blocks.

						- Ted
