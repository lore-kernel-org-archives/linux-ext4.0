From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: mke2fs and lazy_itable_init
Date: Thu, 8 May 2008 22:18:27 -0400
Message-ID: <20080509021827.GA8871@mit.edu>
References: <20080508224847.GR3627@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42958 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923AbYEICSq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 May 2008 22:18:46 -0400
Content-Disposition: inline
In-Reply-To: <20080508224847.GR3627@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 08, 2008 at 04:48:47PM -0600, Andreas Dilger wrote:
> I just noticed lazy_itable_init in the mke2fs.8.in man page.  I think
> a warning needs to be added there that this is not currently safe to
> use, because the kernel does not yet do the background zeroing.  There
> is nothing in the man page to indicate that this is unsafe...

Yeah, I was hoping we would actually get this fixed before 1.41 was
released....  (i.e., implement the background zeroing).  One of the
things I was thinking about was whether we could avoid needing to go
through the jbd layer when zeroing out an entire inode table block,
and then in the completion callback function when the block group was
completely initiaized, we could clear the ITABLE_UNINIT flag.

It doesn't need to go through the journal, because if we crash without
having the flag set, its not a big deal; the inode table will just not
be marked initialized.  The only thing which might require a little
care is if buffer head referencing part of the inode table which is
getting zero'ed out is in flight when an inode allocation happens, an
inode gets marked dirty, and fs/ext4/inode.c wants to write out an
inode table block that is in the middle of being zero'ed.  Given that
we've bypassed the jbd layer for efficiency's sake, something bad
could happy unless we protect it with some kind of lock.

Or we could just say that this initialization pass is relatively rare,
so do it the cheap cheasy way, even if the blocks end up going through
the journal.  The upside is that it should be pretty quick and easy to
code it this way.

					- Ted
