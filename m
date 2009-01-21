From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH] vfs: Call filesystem callback when backing
	device caches should be flushed
Date: Wed, 21 Jan 2009 13:55:37 +0100
Message-ID: <20090121125537.GB3186@duck.suse.cz>
References: <20090120160527.GA17067@duck.suse.cz> <20090120231647.GC2392@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47232 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751499AbZAUMzi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jan 2009 07:55:38 -0500
Content-Disposition: inline
In-Reply-To: <20090120231647.GC2392@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-01-09 15:16:48, Joel Becker wrote:
> On Tue, Jan 20, 2009 at 05:05:27PM +0100, Jan Kara wrote:
> >   we noted in our testing that ext2 (and it seems some other filesystems as
> > well) don't flush disk's write caches on cases like fsync() or changing
> > DIRSYNC directory. This is my attempt to solve the problem in a generic way
> > by calling a filesystem callback from VFS at appropriate place as Andrew
> > suggested. For ext2 what I did is enough (it just then fills in
> > block_flush_device() as .flush_device callback) and I think it could be
> > fine for other filesystems as well.
> 
> 	The only question I have is why this would be optional.  It
> would seem that this would be the preferred default behavior for all
> block filesystems.  We have the backing_dev_info and a way to override
> the default if a filesystem needs something special.
  The reason why I've decided for NOP to be the default is that filesystems
doing proper journalling with barriers should not need this (as the barrier
in the transaction commit already does the job for them).  So these would
have to override the operation to NOP which seems a bit silly. Also virtual
filesystems without backing device would have to override this to NOP.
  Finally, I prefer maintainers of the filesystems themselves to decide
whether their filesystem needs flushing and thus knowingly impose this
performance penalty on them...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
