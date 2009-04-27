From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Date: Mon, 27 Apr 2009 11:53:39 +0200
Message-ID: <20090427095339.GW4593@kernel.dk>
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090424184047.GA17001@lst.de> <20090425151656.GH13608@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:35706 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757065AbZD0Jxk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Apr 2009 05:53:40 -0400
Content-Disposition: inline
In-Reply-To: <20090425151656.GH13608@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 25 2009, Theodore Tso wrote:
> On Fri, Apr 24, 2009 at 08:40:47PM +0200, Christoph Hellwig wrote:
> > On Thu, Apr 23, 2009 at 09:21:24PM +0200, Jens Axboe wrote:
> > > The intent was to add some sort of notification mechanism from the file
> > > system to inform the IO scheduler (and others?) that this process is how
> > > holding a file system wide resource. So if you have a low priority
> > > process getting access to such a resource, you want to boost its
> > > priority to avoid higher priority apps getting stuck beind it. Sort of a
> > > poor mans priority inheritance.
> > > 
> > > It would be wonderful if you could kick this process more into gear on
> > > the fs side...
> 
> I have to agree with Christoph; it would be nice if this were actually
> documented somewhere.  Filesystem authors can't do something if they
> don't understand what the semantics are and how it is supposed to be
> used!

I don't disagree, the project (unfortunately) never really went
anywhere. THe half-assed implementation was meant to be picked up by fs
people. I guess that's what is happening now, so it's a belated success
:-)

> I'm kind of curious why you implemented things in this way, though.
> Is there a reason why the bosting is happening deep in the guts of the
> cfq code, instead of in blk-core.c when the submission of the block
> I/O request is processed?

You would need to implement a lot more logic in the block layer to
handle it there, as it stands it's basically a scheduler decision. So
the positioning is right imho, the placement of fs hooks is probably
mostly crap and could do with some work.

-- 
Jens Axboe

