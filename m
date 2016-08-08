From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 4.7.0-rc7 ext4 error in dx_probe
Date: Sun, 7 Aug 2016 23:56:34 -0400
Message-ID: <20160808035634.GA16193@thunk.org>
References: <20160718141723.GA8809@sig21.net>
 <7849bcd2-142d-0a12-0a04-7d0c3b6d788f@etorok.net>
 <20160805103544.kbt7znbzypvi5ofx@sig21.net>
 <20160805170228.GA19960@birch.djwong.org>
 <20160805181136.mcjnnvuo5m6kpxzb@sig21.net>
 <20160805191548.GD19960@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Johannes Stezenbach <js@sig21.net>,
	=?iso-8859-1?B?VPZy9ms=?= Edwin <edwin@etorok.net>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160805191548.GD19960@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 05, 2016 at 12:15:48PM -0700, Darrick J. Wong wrote:
> > > [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/ext4/inode.c?id=b47820edd1634dc1208f9212b7ecfb4230610a23
> > 
> > I added the patch, rebuilt and rebooted.  It will take some time
> > before I'll report back since the issue is so hard to reproduce.
> 
> FWIW I could trigger it reliably by running a bunch of directory traversal
> programs simultaneously on the same directory.  I have a script that fires
> up multiple mutts pointing to the Maildirs for the high traffic Linux lists.

Hmm, I wonder if we should request that this patch be backported to
-stable.  Darrick, what do you think?

						- Ted
