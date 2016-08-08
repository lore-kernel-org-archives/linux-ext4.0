From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Mon, 8 Aug 2016 12:08:18 -0400
Message-ID: <20160808160818.GA9515@thunk.org>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
 <20160805191548.GD19960@birch.djwong.org>
 <20160808035634.GA16193@thunk.org>
 <20160808062810.GC8590@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johannes Stezenbach <js@sig21.net>,
	=?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160808062810.GC8590@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Aug 07, 2016 at 11:28:10PM -0700, Darrick J. Wong wrote:
> 
> I have one lingering concern -- is it a bug that two processes could be
> computing the checksum of a buffer simultaneously?  I would have thought ext4
> would serialize that kind of buffer_head access...

Do we know how this is happening?  We've always depended on the VFS to
provide this exclusion.  The only way we should be modifying the
buffer_head at the same time if two CPU's are trying to modify the
directory at the same time, and that should _never_ be happening, even
with the new directory parallism code, unless the file system has
given permission and intends to do its own fine-grained locking.

      		     	     	       	   - Ted
