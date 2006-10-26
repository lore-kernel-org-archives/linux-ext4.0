From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC] Ext3 online defrag
Date: Thu, 26 Oct 2006 09:37:37 -0400
Message-ID: <20061026133737.GA31996@thunk.org>
References: <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com> <20061025170052.GA19513@havoc.gtf.org> <20061026014020.GC8394166@melbourne.sgi.com> <20061026033316.GC27858@thunk.org> <20061026063648.GE8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	'Dave Kleikamp' <shaggy@austin.ibm.com>,
	'Alex Tomas' <alex@clusterfs.com>, 'Jan Kara' <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:25236 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1161218AbWJZNjG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Oct 2006 09:39:06 -0400
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061026063648.GE8394166@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 26, 2006 at 04:36:48PM +1000, David Chinner wrote:
> > > Remember, I'm not just talking about defrag - I'm talking about
> > > an interface that is actually useful to apps that might care
> > > about how data is laid out on disk but the applications writers
> > > don't know anyhting about how filesystem X or Y or Z is
> > > implemented. Putting the burden of learning about fileystem
> > > internals on application developers is not the correct solution.

If all you want is something for applicaiton developers, about all you
can do is to tell the filesystem, "create the file so that it will be
quickly accessed after accessing this file or this directory".  I
really don't see the point of having the application specify block
numbers if you're also claiming the applicaiton isn't going to know
anything about the filesystem layout --- or even the RAID layout of
the filesystem.  I don't think it's at **all** useful to be
half-pregnant on this score.

						- Ted
