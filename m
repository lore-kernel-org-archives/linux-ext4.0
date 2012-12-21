From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Uninitialized extent races
Date: Thu, 20 Dec 2012 22:11:51 -0500
Message-ID: <20121221031151.GA5014@thunk.org>
References: <20121221012526.GD13474@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39648 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab2LUDMK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 22:12:10 -0500
Content-Disposition: inline
In-Reply-To: <20121221012526.GD13474@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 02:25:26AM +0100, Jan Kara wrote:
> Am I missing something Dmitry? Also I was wondering about one thing: Does
> anybody see a problem with disabling merging of uninitialized extents
> completely? It would simplify the code (end_io conversion doesn't need to
> potentially split extents) and the case when we really want to merge
> extents - i.e., when someone calls fallocate() on small chunks - doesn't
> seem like the case we need to optimize for? 

Which case specifically are you talking about here?

Are you talking about the merging of _formerly_ uninitialized extents?
i.e., what keeps the extent tree from exploding if you fallocate one
megabyte region, and then write to all 256 blocks of that one megabyte
region, except in a random order?

Or something else?

> Also it would bound the amount of transaction credits we need for
> conversion to 1 block which would make it easier for me to change
> ext4 to clear PageWriteback only after extent conversion is done
> (again code simplification, more uniform handling of page
> writeback).

So I'm confused.  If it's the case that we're thinking about, we only
need a single transaction credit, because we're not currently merging
across adjacent interior extent tree blocks.

Can you be a bit more explicit about which case you're thinking about?
I do agree that the extent tree code is too complicated, but we also
have the problem that we probably been more merging, not less, since
we can already end up with a case where you start with a single extent
tree block after fallocating a gigabyte or two.  Then after writing
randomly into that gigabyte file using AIO, we can end up with a very
deep, spindly extent tree containing multiple interior extent tree
blocks, because we're not doing sufficient merging --- and in
particular, we currently have no way at all of decreasing the depth of
the extent tree.

						- Ted
