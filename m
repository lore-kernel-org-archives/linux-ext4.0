From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 6 Dec 2006 20:11:00 +1100
Message-ID: <20061206091100.GA33919298@melbourne.sgi.com>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1> <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:47785 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760352AbWLFJLV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 04:11:21 -0500
To: Nikolai Joukov <kolya@cs.sunysb.edu>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.53.0612051049200.27677@compserv1>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 05, 2006 at 11:41:28AM -0500, Nikolai Joukov wrote:
> > > As we promised on the linux-ext4 list on October 31, here is the patch
> > > that adds secure deletion via a trash-bin functionality for ext4.  It is a
> > > compromise solution that combines secure deletion with the trash-bin support
> > > (the latter had been requested by even more people than the former :-).
> >
> > Given that almost all of the code for this uses vfs interfaces and
> > only a couple of simple filesystem hooks, is there any reason for
> > this being ext4 specific?  i.e. why aren't you hooking the vfs layer
> > so we get a single undelete/secure delete implementation for all
> > filesystems?
> 
> You are right.  Actually, we mentioned it as a benefit number 4 of this
> approach in the original post.  Most of the code is not
> file-system--specific and can be used by any other (all other?) file
> system(s).  The only complication is that only ext2/3/4 and reiser file
> systems already support the per-file secure deletion and undelete
> attributes.

They are defined but unused in 2.6.19, right? I can't see anywhere
in the 2.6.19 ext2/3/4/reiser trees that actually those flags,
including setting and retrieving them from disk. JFS i can see
sets, clears and retreives them, but not the fielsystems you
mention. Though I might just be blind..... ;)

If all we need to add to XFS is support for those flags, then XFS
support would be trivial to add.

Oh, damn. I take that back. We're almost out of flag space in the on
disk inode - these two flags would use the last 2 flag bits so this
may require an on disk inode format change in XFS. This will be
a little more complex than I first thought, but not impossible
as we already support two on-disk inode format versions.

> Since ext4 is in early development now, we believe it'd be easier to get
> such code into ext4 than into the main-line VFS.  If there's enough
> interested among the kernel maintainers, we'd be happy to move this
> functionality to the VFS and provide f/s hooks for
> secure-deletion/trash-bin.

I'd certainly like to see new functionality like this added at the
VFS rather than in any particular filesystem. Don't know about
anyone else, though....

> I guess, the right thing to do would be to move the common trash-bin
> (tb.c and tb.h) code into the /fs and /include/linux directories.

And call them trashbin.[ch] ;)

> Also, VFS would require just a couple of trivial changes to support
> something like '-o trashbin' mount-time option for all file systems.
> In addition, individual file systems may support per-file attributes for
> this (e.g., ext2/3/4).

Sounds like a good idea to me.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
