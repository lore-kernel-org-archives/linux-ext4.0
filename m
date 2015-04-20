From: Jan Kara <jack@suse.cz>
Subject: Re: Use of resize2fs for enabling 64-bit inodes
Date: Mon, 20 Apr 2015 12:25:57 +0200
Message-ID: <20150420102557.GD3117@quack.suse.cz>
References: <20150417161809.GA27500@quack.suse.cz>
 <20150417185849.GD11592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbbDTK0C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 06:26:02 -0400
Content-Disposition: inline
In-Reply-To: <20150417185849.GD11592@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 17-04-15 11:58:49, Darrick J. Wong wrote:
> On Fri, Apr 17, 2015 at 06:18:09PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> >   I've noticed that you've implemented enabling 64-bit mode of a filesystem
> > in resize2fs. That is quite logical from the implementation point of view
> > however IMHO it doesn't make too much sense from user point of view.  I'd
> 
> I agree it's awkward; right now there's a bandaid that tune2fs -O 64bit will
> tell you how to run resize2fs...
> 
> > rather expect that functionality to be in tune2fs. So shouldn't we rather
> > abstract the code into a separate library that would be linked to both
> > resize2fs and tune2fs? Alternatively we could just make tune2fs call
> > resize2fs with appropriate options.
> 
> ...but I've wondered myself why we have two utilities for transforming ext4
> filesystems.  A library would probably be cleaner, but it wouldn't be too
> hard to change existing tune2fs functionality to run (instead of telling
> the user how to run) resize2fs for 64bit conversion.
  Yes. The only catch is that executing resize2fs needn't always execute
the right one (e.g. in a system where you just test new version of
e2fsprogs in the source directory).

> I guess one could combine the two into a frankentool that uses argv[0] to
> figure out which half of itself to run, with the tune2fs side being able
> to call into the resize2fs side.  But maybe it's time for the 'high level
> e2fs library' that Ted has been talking about for a while?
  Yeah, highlevel e2fsprogs library seems as a nice idea and it would solve
the problem. It's quite some work though...

> > I'm asking because I'm now looking into implementing increasing number of
> > reserved inodes. For that we may need to move some inodes and it would be
> > natural to use code from resize2fs for that. But adding that as an option
> > to resize2fs is just unintuitive from user point of view so I'd like to
> > have some concensus on how we do this... Darrick, Ted, any opinion?
> 
> What do you think of the thread "e2fsprogs: reserve more special inodes" from a
> month or so ago?
  Ah, I've missed that one. From a first look it looks OK. It seems
Konstantin did the work I wanted to do already :) So it's mostly about
creating a sane user interface.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
