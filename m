From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Uninitialized extent races
Date: Mon, 24 Dec 2012 19:17:45 +0800
Message-ID: <20121224111745.GA12051@gmail.com>
References: <20121221012526.GD13474@quack.suse.cz>
 <20121221031151.GA5014@thunk.org>
 <20121221161929.GF17357@quack.suse.cz>
 <20121221180243.GB31731@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:61801 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2LXLEU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Dec 2012 06:04:20 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so3107872dak.20
        for <linux-ext4@vger.kernel.org>; Mon, 24 Dec 2012 03:04:20 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121221180243.GB31731@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 01:02:43PM -0500, Theodore Ts'o wrote:
> On Fri, Dec 21, 2012 at 05:19:29PM +0100, Jan Kara wrote:
> >   No, I'm speaking about merging currently uninitialized extents. I.e.
> > suppose someone does the following on a filesystem with dioread_nolock so
> > that writeback happens via unwritten extents:
> >   fd = open("file", O_RDWR);
> >   pwrite(fd, buf, 4096, 0);
> > 					flusher thread starts writing
> > 					we create uninitialized extent for
> > 					  range 0-4096
> >   fallocate(fd, 0, 4096, 4096);
> >     - we merge extents and now have just 1 uninitialized extent for range
> >       0-8192
> > 					ext4_convert_unwritten_extents() now
> > 					  has to split the extent to finish
> > 					  the IO.
> 
> Ah, I see.  Disabling the the merging that might take place as a
> result of the fallocate.  Yes, I agree that's a completely sane thing
> to do.
> 
> The alternate approach would be to add a flag in the extent status
> tree indicating that an unwritten conversion is pending, but that
> would add more complexity.

Hi Ted and Jan,

Sorry for delay reply.  Indeed we could add a flag in extent status tree
to indicate an pending unwritten extent, and I believe that it can bring
us some benefits.  But I wonder whether this case often happens.  Do we
have some real workloads?

Regards,
                                        - Zheng
