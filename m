From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Mon, 8 Aug 2016 09:55:46 -0700
Message-ID: <20160808165546.GA11291@birch.djwong.org>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
 <20160805191548.GD19960@birch.djwong.org>
 <20160808035634.GA16193@thunk.org>
 <20160808062810.GC8590@birch.djwong.org>
 <20160808160818.GA9515@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Theodore Ts'o" <tytso@mit.edu>,
	Johannes Stezenbach <js@sig21.net>,
	=?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160808160818.GA9515@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 08, 2016 at 12:08:18PM -0400, Theodore Ts'o wrote:
> On Sun, Aug 07, 2016 at 11:28:10PM -0700, Darrick J. Wong wrote:
> > 
> > I have one lingering concern -- is it a bug that two processes could be
> > computing the checksum of a buffer simultaneously?  I would have thought ext4
> > would serialize that kind of buffer_head access...
> 
> Do we know how this is happening?  We've always depended on the VFS to
> provide this exclusion.  The only way we should be modifying the
> buffer_head at the same time if two CPU's are trying to modify the
> directory at the same time, and that should _never_ be happening, even
> with the new directory parallism code, unless the file system has
> given permission and intends to do its own fine-grained locking.

It's a combination of two things, I think.  The first is that the
checksum calculation routine (temporarily) set the checksum field to
zero during the computation, which of course is a no-no.  The patch
fixes that problem and should go in.

The second problem is that we now can have multiple lookups at the same
time, which means that there can be more than one CPU calling into
dx_probe on the same directory blocks at the same time.  There isn't any
locking on the buffer heads between readers, so we can end up with
ext4_read_dirblock racing with itself to verify the block.  It's perhaps
a little inefficient for multiple threads to be checksumming the same
block, but only turns deadly if you combine it with the first problem.

--D

> 
>       		     	     	       	   - Ted
