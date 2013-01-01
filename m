From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Uninitialized extent races
Date: Tue, 1 Jan 2013 12:49:47 +0800
Message-ID: <20130101044947.GA7546@gmail.com>
References: <20121221012526.GD13474@quack.suse.cz>
 <20121221031151.GA5014@thunk.org>
 <20121221161929.GF17357@quack.suse.cz>
 <20121221180243.GB31731@thunk.org>
 <20121224111745.GA12051@gmail.com>
 <20121231083221.GA7564@quack.suse.cz>
 <20121231163146.GA6795@gmail.com>
 <20121231164446.GJ7564@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61187 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3AAEgN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Dec 2012 23:36:13 -0500
Received: by mail-pb0-f43.google.com with SMTP id um15so7335644pbc.30
        for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2012 20:36:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121231164446.GJ7564@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 31, 2012 at 05:44:46PM +0100, Jan Kara wrote:
> On Tue 01-01-13 00:31:46, Zheng Liu wrote:
> > On Mon, Dec 31, 2012 at 09:32:21AM +0100, Jan Kara wrote:
> > > On Mon 24-12-12 19:17:45, Zheng Liu wrote:
> > > > On Fri, Dec 21, 2012 at 01:02:43PM -0500, Theodore Ts'o wrote:
> > > > > On Fri, Dec 21, 2012 at 05:19:29PM +0100, Jan Kara wrote:
> > > > > >   No, I'm speaking about merging currently uninitialized extents. I.e.
> > > > > > suppose someone does the following on a filesystem with dioread_nolock so
> > > > > > that writeback happens via unwritten extents:
> > > > > >   fd = open("file", O_RDWR);
> > > > > >   pwrite(fd, buf, 4096, 0);
> > > > > > 					flusher thread starts writing
> > > > > > 					we create uninitialized extent for
> > > > > > 					  range 0-4096
> > > > > >   fallocate(fd, 0, 4096, 4096);
> > > > > >     - we merge extents and now have just 1 uninitialized extent for range
> > > > > >       0-8192
> > > > > > 					ext4_convert_unwritten_extents() now
> > > > > > 					  has to split the extent to finish
> > > > > > 					  the IO.
> > > > > 
> > > > > Ah, I see.  Disabling the the merging that might take place as a
> > > > > result of the fallocate.  Yes, I agree that's a completely sane thing
> > > > > to do.
> > > > > 
> > > > > The alternate approach would be to add a flag in the extent status
> > > > > tree indicating that an unwritten conversion is pending, but that
> > > > > would add more complexity.
> > > > 
> > > > Sorry for delay reply.  Indeed we could add a flag in extent status tree
> > > > to indicate an pending unwritten extent, and I believe that it can bring
> > > > us some benefits.  But I wonder whether this case often happens.  Do we
> > > > have some real workloads?
> > >   It doesn't happen often but it *can* happen. Thus you have to implement
> > > a code which handles the case. I don't think bit in extent status tree is
> > > really necessary. Just disabling merging of uninitialized extents is
> > > simple. If we see there are some real workloads which have problems with
> > > it, we can resort to a more complex solution using extent tree...
> > 
> > Thanks for your explanation.  I don't know whether or not you have
> > generated a patch for this problem.  I am willing to make it in a proper
> > time.  If you have begun to generate it, please let me know. :-)
>   Disabling the merging is trivial and I have a patch for that. Just making
> all other changes so that Christoph's DIO patches can work is non-trivial.
> I already have several smaller fixes and cleanups to make things easier but
> writeback path still has locking issues - I have a solution in mind but
> whether it will be needed or not depends on what I asked in the other email
> - whether extent status tree can really be used or not...

Yeah, I have replied the mail in the other thread.  Thanks for your
time.

Regards,
                                                - Zheng
