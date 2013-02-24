From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Sat, 23 Feb 2013 19:14:47 -0500
Message-ID: <20130224001447.GB1196@thunk.org>
References: <87obfcs1x6.fsf@openvz.org>
 <20130222180325.GB21264@thunk.org>
 <87txp3cqwt.fsf@openvz.org>
 <51289343.90704@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49608 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab3BXAOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Feb 2013 19:14:52 -0500
Content-Disposition: inline
In-Reply-To: <51289343.90704@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 23, 2013 at 06:00:35PM +0800, Zheng Liu wrote:
> > Actually I think that the regression in 269'th you have found recently
> > caused by similar issue and commit which you foud by bisecting ( the one
> > which allow migration between indirect<->extent based inodes)
> > simply helps to spot real issue in es_caching code.
> 
> I will revise this patch.  IIRC, we forgot to update status tree after
> an inode is migrated from extent-based to indirect-based.  Thanks for
> pointing out.

Can you do this as a new commit?  I've already bumped the master
pointer up since I finished running xfstests and I'm seeing no
regressions (at least with my set of xfstests).  So given that
everything has been tested and things looks pretty stable, I pushed up
the master branch.

I did remember that you were still working on this regression, but
since we're already half-way through the merge window, I really want
to make things are ready for a merge request to Linus.  (Which I
probably will be sending to Linus by Monday or Tuesday.)

I do plan to collect bug fixes and any remaining regression fixes to
push to Linus by -rc2 or -rc3, so if don't rush fixing up defrag
functionality.

Thanks!!

						- Ted
