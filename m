From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Date: Wed, 27 May 2009 16:59:11 +0200
Message-ID: <20090527145911.GH16006@duck.suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz> <20090527142332.GB10842@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761743AbZE0O7K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 10:59:10 -0400
Content-Disposition: inline
In-Reply-To: <20090527142332.GB10842@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 27-05-09 10:23:32, Theodore Tso wrote:
> On Wed, May 27, 2009 at 03:00:57PM +0200, Jan Kara wrote:
> > 
> > The series is against 2.6.30-rc7. The first two patches are just
> > small cleanup and should be merged separately (Ted should have the
> > ext4 cleanup rebased on top of current ext4 tree). 
> 
> So I can take the cleanup (which will be different given the changes
> that are ready to get merged once the merge window opens), but it
  I sent you yesterday the version of the cleanup which should apply to the
latest patch queue. I think you can merge it right away.
 In fact, this series should not depend on the cleanup in ext4 at all, I've
just included it for completeness along with ext3 cleanup of the same
problem (and the patch series depends on ext3 cleanup).

> looks like the the second ext4 patch can't go in until we get
> agreement that changes to the VFS layer should go in, correct?  So
> we'll have a merge order dependency here.
  Yes, we have to agree on VFS changes before ext4 changes make sense.

> (And this one will be the 2nd merge order dependency we have in the
> ext4 tree, since I also have some patches in the unstable portion of
> the tree which are waiting for some tracing patches to go in.)
> 
> OK, what I'll probably do is to merge the core VFS patch plus the 2nd
> ext4 patch into the ext4 patch queue in the unstable portion of the
> queue for testing purposes, but I won't actually push the VFS core
> changes.  We can figure out later who actually pushes the ext4 patch
> which utilizes the new VFS infrastructure.
  Yes, that would be fine. Thanks. Luckily, the dependence is just one way
(ext4 change has to go after the VFS patch) so it's just enough to merge
that ext4 change some time after VFS changes go in.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
