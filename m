From: Theodore Tso <tytso@mit.edu>
Subject: Re: [repost][patch 1/2] e2fsprogs: user selectable dup block handling in fsck (fwd)
Date: Fri, 6 Apr 2007 18:37:22 -0400
Message-ID: <20070406223721.GA8606@thunk.org>
References: <Pine.LNX.4.61.0702041728410.31030@webb> <Pine.LNX.4.61.0702041720460.31030@webb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Garlick <garlick@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51015 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112AbXDFWh2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2007 18:37:28 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702041728410.31030@webb> <Pine.LNX.4.61.0702041720460.31030@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Feb 04, 2007 at 05:28:38PM -0800, Jim Garlick wrote:
> Allowing all files claiming the shared blocks to have copies can
> inadvertantly bypass access restrictions.  Deleting all the files, 
> zeroing the cloned blocks, or placing the files in the /lost+found 
> directory after cloning may be preferable in some secure environments.

My apologies for not having time to review your patches sooner.  I've
been insanely busy as of late.

The assumption was that the administrator would always review a list
of files for correctness after running e2fsck, but this isn't
necessarily easy because e2fsprogs doesn't create a log for such
information in an easily accessible place.  That may end up being the
correct solution as opposed to trying to force that policy into
e2fsck.

One of my long-term plans was to extend the fix_problem() function to
log a detailed set of problems fixed into a file (either binary or
XML) that could parsed by other programs as part of some kind of
recovery process.  What would get written out is the problem ID plus
the entire problem_context structure, which has actually quite a lot
of information.  This would be enough for a lot of post-processing,
including making it easier for people to implement policies such as
deleted or archiving for review by the Site Security Officer any files
which had some of their blocks cloned.

>  -E shared=preserve|lost+found|delete
> 
>     Select the disposition of files containing shared blocks.  "preserve"
>     is the old behavior which remains the default.  "lost+found" causes
>     files to be unlinked after cloning so they will be reconnected to
>     /lost+found in pass 3.   "delete" skips cloning entirely and simply
>     deletes the files.

lost+found does not work as you have implemented them in your patches
in the case of a file which is hard linked.  That's because in pass1c
we only find the first directory where which contains a hard link to
the file name, for the purpose of displaying a pathname that will
hopefully have meaning to the system administrator.  Currently, as
implemented, if you specify a disposition of "lost+found", an inode
which has multiple hard links will have one of its hard links removed,
and since the rest of the links to the file are presend, it will not
be moved into the lost+found directory.

So if you are using shared=lost+found at your site, you may want to
use some other strategy until the patch is fixed to find and remove
all links to that particular inode.

Regards,

						- Ted
