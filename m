From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 20:28:41 -0400
Message-ID: <20070730002840.GA7202@thunk.org>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <20070728195114.GA5952@infradead.org> <20070729173035.GU5992@schatzie.adilger.int> <20070729192437.GB14530@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>, Alex Tomas <alex@clusterfs.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36207 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763725AbXG3A2w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jul 2007 20:28:52 -0400
Content-Disposition: inline
In-Reply-To: <20070729192437.GB14530@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 29, 2007 at 08:24:37PM +0100, Christoph Hellwig wrote:
> I'm a big proponent of having proper common delalloc code, but the
> one proposed here is not generic for the existing filesystem using
> delalloc.  It's still on my todo list to revamp the xfs code to get
> rid of some of the existing mess and make it useable genericly.  If
> the ext4 users are fine with the end result we could move to generic
> code.

Do you think it would be faster for you to revamp the code or to give
instructions about how you'd like to clean up the code and what has to
be preserved in order to keep XFS happy, so someone else could give it
a try?  Or do you think the code is to grotty and/or tricky for
someone else to attempt this?

> Note that moving to VFS is bullshit either way, writeback code is
> nowhere near the VFS nor should it.

Agreed.  I would think the something like mm/delayed_alloc.c would be
preferable.  Ideally it would be like the filemap.c code, where it
would be relatively easy for most standard filesystems to hook into it
and get the advantages of delayed allocation.  (Although granted it
will probably require more effort on the part of a filesystem author
than filemap!)

						- Ted
