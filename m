From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC] fs: only call sync_filesystem() when remounting
 read-only
Date: Wed, 12 Mar 2014 21:16:29 -0400
Message-ID: <20140313011629.GA2796@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
 <20140308160818.GC11633@thunk.org>
 <20140313003635.GA4263@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lucas Nussbaum <lucas.nussbaum@loria.fr>,
	linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org Emmanuel Jeanvoine"
	<emmanuel.jeanvoine@inria.fr>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40656 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbaCMBQf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 21:16:35 -0400
Content-Disposition: inline
In-Reply-To: <20140313003635.GA4263@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2014 at 11:36:35AM +1100, Dave Chinner wrote:
> > Folks on linux-fsdevel, any objections if I carry this patch in the
> > ext4 tree?  I don't think it should cause problems for other file
> > systems, since any file system that tries to rely on the implied
> > syncfs() is going to be subject to races, but it might make such a
> > race condition bug much more visible...
> 
> IMO, I think that you should be looking to fix ext4 syncfs issues,
> not changing the VFS behaviour that might cause subtle and unnoticed
> problems for other filesystems. We should not be moving data
> inegrity operations without first auditing of all the filesystem
> remount operations for issues.

The issue is that it's forcing a CACHE FLUSH if we don't need to force
a journal commit, since it's possible that data writes could have been
sent to the disk without modifying fs metadata that would require a
commit.  So arguably what we're doing with ext4 is _correct_, where as
with ext3 we would simply not calling blkdev_issue_barrier() in that
situation.

The issue is that if userspace executes a no-op remount, there
shouldn't be a reason to call sync_filesystem() at all.  But I'm also
not so sure that I should be that solicitous of a workload where
someone is calling thousands and thousands of no-op remounts.....

	   	   	     	 	      	    - Ted
