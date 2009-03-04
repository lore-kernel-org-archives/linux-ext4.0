From: Jan Kara <jack@suse.cz>
Subject: Re: fsx-linux loosing mmap() writes under memory pressure
Date: Wed, 4 Mar 2009 18:50:31 +0100
Message-ID: <20090304175031.GA24730@duck.suse.cz>
References: <20090304145109.GA7140@duck.suse.cz> <20090304155535.GA23108@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: user-mode-linux-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:43985 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbZCDRuf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Mar 2009 12:50:35 -0500
Content-Disposition: inline
In-Reply-To: <20090304155535.GA23108@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 04-03-09 16:55:35, Jan Kara wrote:
> On Wed 04-03-09 15:51:09, Jan Kara wrote:
> >   first, I'd like to point out that this has happened under UML so it can
> > be just some obscure bug in that architecture but I belive it's worth
> > debugging anyway. Now to the problem:
> >   This has happened with today Linus's git snapshot. The filesystem is ext3
> > with *1KB* blocksize. I booted UML with 64MB of memory and run (these are
> > test's from Andrew Morton's torture tests):
> >   fsx-linux -l 8000000 /mnt/testfile
> >   bash-shared-mapping -t 8 /mnt/bashfile 50000000
> > (the second test just makes the UML under memory pressure and stresses the
> > filesystem, otherwise it does not interact with fsx-linux in any way).
> >   After some time (like an hour) fsx-linux reported the file is corrupted. I
> > tried again and it happened again so probably some debugging should be
> > possible.
> >   Both times it seems we've simply completely lost a write which happened
> > through mmap (2 pages in the first case, 3 pages in the second case). Also
> > I've checked and in the first case no blocks are allocated for the offsets
> > where the data should be so most probably we've lost the write before
> > block_write_full_page() called get_block().
> >   I'll debug this further but I wanted let people know there's some problem
> > and maybe somebody has some bright idea :).  I'm attaching the log from fsx
> > if someone is interested. 
>   Testing a bit more, I managed to reproduce the problem on ext2 and what's
> more strange, now the lost page was written via ordinary write() (fsxlog
> attached). So I believe this is more likely to be UML specific...
  And to add even more information, this also happens on ext2 with 4KB
blocksize (although much more rarely it seems). Again the data was written
by an extending write() but the block for it was not even allocated...

									Honza
