From: Theodore Tso <tytso@mit.edu>
Subject: Re: panic on boot at ext4_mb_poll_new_transaction
Date: Thu, 16 Oct 2008 12:35:31 -0400
Message-ID: <20081016163531.GG12962@mit.edu>
References: <20081016070735.GA28486@csclub.uwaterloo.ca> <20081016143035.GA10825@mit.edu> <48F75164.20500@redhat.com> <20081016152134.GC12962@mit.edu> <48F76055.2090502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54306 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754559AbYJPQff (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 12:35:35 -0400
Content-Disposition: inline
In-Reply-To: <48F76055.2090502@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 10:40:05AM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> 
> > Eric, I suspect this patch in the ext4 patch queue should fix things.
> > 
> >       do_mballoc_init_before_doing_filesystem_recovery
> > 
> > 							- Ted
> 
> Ah, you're right.  I thought I had that in the fedora kernel, so was
> looking for something new, but ... nope.  grr.
> 
> /me runs off to update.

BTW, since I've been doing a lot of work on the patch queue, including
recently rebasing off of 2.6.27-git5 so I could pick up the blkdev
discard patches, I've been maintaining the ext4-stable branch in the
ext4 git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git

It contains all of the patches that have gone upstream to Linus,
against the baseline 2.6.27 kernel.  We still need to cherry-pick the
most critical bugs fixes in that branch to submit to the -stable
kernel series....

						- Ted

