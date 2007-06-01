From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 1 Jun 2007 07:41:00 -0400
Message-ID: <20070601114100.GB13905@thunk.org>
References: <1179777153.3910.13.camel@garfield> <p731wgwcbac.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55170 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415AbXFALlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2007 07:41:06 -0400
Content-Disposition: inline
In-Reply-To: <p731wgwcbac.fsf@bingen.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 01, 2007 at 10:46:19AM +0200, Andi Kleen wrote:
> 
> That will make laptop users very unhappy if you spin up their disks
> every 5 seconds.  And even on other systems it might reduce the MTBF
> if you write the super block much more often than before. It might
> be better to set it up in some way to only increase that number when
> the super block is written for some other reason anyways.

You would never want to use this feature on a laptop; it would buy no
benefit for its costs, since with (all common) laptops, their hard
drives can't be shared with other machines in a cluster.

Unfortunately, it's not possible to do what you suggest, since one of
the whole points of increasing the sequence number every 5 seconds is
to act as a keep-alive, so another machine trying to access the shared
hard drive can tell whether or not the machine which currently had the
hard drive mounted is still alive or not.

This is why I and others have been a little worried about implementing
this feature, since it adds complexity which has to be in a proper HA
system anyway, and what is there isn't really an optimal HA solution
(since it lacks STONITH) and so you have to implement the
functionality again _anyway_ using a proper HA solution.

The argument on the other side is that it protects against failed HA
solutions, and against users who are too stupid to know that they need
an HA solution.  It does do the first; the second would only apply if
the users who were too stupid to realize they needed an HA solution,
were smart enough to enable it the MMP feature --- and because of its
many costs, including keeping the disk spun up on laptops, and
delaying the time required to mount the disk by 10 seconds, I don't
think it will ever be enabled by default.  Hence, I don't really think
it helps the idiotic user problem.

But apparently a belt-and-suspenders approach to HA is comforting to
some users, and so I don't mind reserving the space.  The code to
implement it still seems like more complexity than what should be in
the kernel.  My suggestion would be to put it in a separate file, and
make it be something which has to be explicitly configured to enable
it, possibly as a module (but that may add too much extra hair).  I
really don't think the save-the-stupid-user argument holds water, but
the belt-and-suspenders argument IFF you are using a shared-disk setup
is a valid, although probably not a common setup.

Regards,

						- Ted
