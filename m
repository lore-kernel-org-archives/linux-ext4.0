From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Sleeping function called in invalid context
Date: Thu, 4 Aug 2016 16:58:45 -0400
Message-ID: <20160804205845.GC10933@thunk.org>
References: <57A19B9B.60005@kyup.com>
 <20160804160550.GA12861@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, Jan Kara <jack@suse.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51354 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbcHDU7B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 16:59:01 -0400
Content-Disposition: inline
In-Reply-To: <20160804160550.GA12861@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 04, 2016 at 06:05:50PM +0200, Jan Kara wrote:
> On Wed 03-08-16 10:22:03, Nikolay Borisov wrote:
> > While doing some testing on today's checkout of Linus' master branch I
> > got the following: 
> 
> > 
> > [    9.302725] BUG: sleeping function called from invalid context at ./include/linux/buffer_head.h:358
> > [    9.304403] in_atomic(): 1, irqs_disabled(): 0, pid: 1718, name: mount
> > [    9.305633] 8 locks held by mount/1718:
> 
> Yeah, this looks like a regression cause by commit 4743f83990614af "ext4:
> Fix WARN_ON_ONCE in ext4_commit_super()". Arguably that cure is worse than
> the disease but OTOH calling ext4_commit_super() from an atomic context
> (like __ext4_grp_locked_error() does) sucks as well.
> 
> I'm not sure what the right fix is here. The cleanest would probably be to
> always drop group lock in __ext4_grp_locked_error() and make sure we always
> properly bail out of mballoc code on such error. But that's a non-trivial
> amount of work. Not sure if other ext4 people have opinion on this?

The easist way to fix this is defer the ext4_commit_super() to a
workqueue.  We only need this in the errors=continue case, and in that
scenario we're not in a hurry when the superblock gets written out.

In fact, we probably want to be doing this for all of the
errors=continue cases when we want to save the error state to the
superblock, so we can do the update properly using the journal,
instead of calling ext4_commit_super() which just force writes the
block.

(Of course, if the journal is aborted we'll need to fall back to using
ext4_commit_super, of course.)

						 - Ted
