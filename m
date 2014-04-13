From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Mon, 14 Apr 2014 09:39:58 +1000
Message-ID: <20140413233958.GB27694@dastard>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-3-git-send-email-lczerner@redhat.com>
 <20140412135906.GC13837@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:61892 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaDMXkD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 19:40:03 -0400
Content-Disposition: inline
In-Reply-To: <20140412135906.GC13837@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 12, 2014 at 09:59:06AM -0400, Theodore Ts'o wrote:
> On Fri, Apr 11, 2014 at 08:57:44PM +0200, Lukas Czerner wrote:
> > Currently in do_fallocate in collapse range case we're checking whether
> > offset + len is not bigger than i_size. However there is nothing which
> > would prevent i_size from changing so the check is pointless. It should
> > be done in the file system itself and the file system needs to make sure
> > that i_size is not going to change.
> > 
> > As it is now we can easily crash kernel by having two processes doing
> > truncate and fallocate collapse range at the same time. This can be
> > reproduced on ext4 and it is theoretically possible on xfs even though I
> > was not able to trigger it with this simple test.
> > 
> > This commit removes the check from do_fallocate and adds it to the file
> > system.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext4/extents.c | 11 +++++++++--
> >  fs/open.c         |  8 --------
> >  fs/xfs/xfs_file.c | 10 +++++++++-
> >  3 files changed, 18 insertions(+), 11 deletions(-)
> 
> Looks good to me.  Do the xfs folks mind if I carry this in the ext4
> tree and push it to Linus shortly after -rc1?  If so, please send me
> an ack'ed by.

No, go ahead. I was going to do the same thing, anyway, if nobody
else beat me to it...

Acked-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave
-- 
Dave Chinner
david@fromorbit.com
