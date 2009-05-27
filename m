From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Date: Wed, 27 May 2009 10:23:32 -0400
Message-ID: <20090527142332.GB10842@mit.edu>
References: <1243429268-3028-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56886 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761539AbZE0OXl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 10:23:41 -0400
Content-Disposition: inline
In-Reply-To: <1243429268-3028-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2009 at 03:00:57PM +0200, Jan Kara wrote:
> 
> The series is against 2.6.30-rc7. The first two patches are just
> small cleanup and should be merged separately (Ted should have the
> ext4 cleanup rebased on top of current ext4 tree). 

So I can take the cleanup (which will be different given the changes
that are ready to get merged once the merge window opens), but it
looks like the the second ext4 patch can't go in until we get
agreement that changes to the VFS layer should go in, correct?  So
we'll have a merge order dependency here.

(And this one will be the 2nd merge order dependency we have in the
ext4 tree, since I also have some patches in the unstable portion of
the tree which are waiting for some tracing patches to go in.)

OK, what I'll probably do is to merge the core VFS patch plus the 2nd
ext4 patch into the ext4 patch queue in the unstable portion of the
queue for testing purposes, but I won't actually push the VFS core
changes.  We can figure out later who actually pushes the ext4 patch
which utilizes the new VFS infrastructure.

						- Ted
