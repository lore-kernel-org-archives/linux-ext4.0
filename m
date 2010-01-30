From: tytso@mit.edu
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Date: Sat, 30 Jan 2010 12:25:02 -0500
Message-ID: <20100130172502.GA788@thunk.org>
References: <4B633F9A.8000404@sandeen.net>
 <20100130105501.GA22909@infradead.org>
 <4B645B0D.205@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>, Giel de Nijs <giel@vectorwise.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38249 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0A3RZJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jan 2010 12:25:09 -0500
Content-Disposition: inline
In-Reply-To: <4B645B0D.205@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 30, 2010 at 10:15:09AM -0600, Eric Sandeen wrote:
> > me on a 32-bit machine.  The patch below fixes it up, but it seems like
> > we should rather add a variant of that code as aio_read/write commands
> > to xfs_io instead of adding a new test program.
> 
> ok, that's probably better - again, though, it takes at least a release
> cycle before most folks can test it.  But I guess that's not the end of
> the world.

Stupid question --- who uses xfs_io besides xfstests?  Any chance we
could consider dropping in some version of xfs_io into xfstests, or
actually moving it into xfstests from xfsprogs if xfstests is the
exclusive user of that program?  I've been trying to get more people
to use xfstests, since it would be good if more companies and more
projects were using it --- and one of the things that makes it hard is
all of the dependencies that it has.  If there was some way we could
gradually make xfstests more self-contained, it would certainly be
nice.

						- Ted
