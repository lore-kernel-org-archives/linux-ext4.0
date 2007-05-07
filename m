From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] - Make mke2fs.c defaults match mke2fs.conf defaults
Date: Mon, 7 May 2007 15:47:49 -0400
Message-ID: <20070507194749.GG17180@thunk.org>
References: <463F545A.10903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59703 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXEGTr4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 15:47:56 -0400
Content-Disposition: inline
In-Reply-To: <463F545A.10903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 07, 2007 at 11:31:22AM -0500, Eric Sandeen wrote: One of
> our testers filed a bug that said "mkfs.ext3 is much slower when
> mke2fs.conf is missing..."
> 
> This is because the shipped defaults in mke2fs.conf do not match the
> shipped defaults in the mkfs code itself; he wound up making a 1k
> block filesystem on a very large block device, for example.
> 
> So - How about this patch, to bring them back into line?  

It doesn't actually bring them completely back into line, since mke2fs
will use different block sizes depending on the size of the
filesystem.  So your patch makes the default probably a bit more
reasonable, and so I'll probably end up applying it, but it definitely
isn't a complete replacement for /etc/mke2fs.conf.

How likely do you think the case will be that mke2fs.conf would be
missing?  I'm trying to figure out how high priority of an item this
really is.

> Which makes me wonder; having "defaults" in 2 different places is
> bound to get out of sync; should we instead generate both code &
> config file defaults (and maybe man page defaults) from a common
> source?

I had been working on the assumption that the defaults if mke2fs.conf
were not present were more in the nature of emergency defaults as
opposed something that could be used a fully functional set of
configuration parameters.  So the assumption was that when you
installed the RPM, mke2fs.conf would also be there.

We could enhance the profile code so that it could read in the profile
from a memory buffer, and simply compile /etc/mke2fs.conf into mke2fs,
but that adds bloat --- the question is how necessary do we think that
really is?

Regards,

					- Ted
