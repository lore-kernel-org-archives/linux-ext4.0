From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Wed, 8 Jul 2009 18:31:50 -0400
Message-ID: <20090708223150.GB14005@mit.edu>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz> <20090706025319.GG6706@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37626 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758770AbZGHWb4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:56 -0400
Content-Disposition: inline
In-Reply-To: <20090706025319.GG6706@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 05, 2009 at 10:53:19PM -0400, Theodore Tso wrote:
> On Wed, Jun 24, 2009 at 06:02:40PM +0200, Jan Kara wrote:
> > The following race can happen:
> > 
> >   CPU1                          CPU2
> >                                 checkpointing code checks the buffer, adds
> >                                   it to an array for writeback
> > do_get_write_access()
> >   ...
> >   lock_buffer()
> >   unlock_buffer()
> >                                   flush_batch() submits the buffer for IO
> >   __jbd2_journal_file_buffer()
> > 
> >   So a buffer under writeout is returned from do_get_write_access(). Since
> > the filesystem code relies on the fact that journaled buffers cannot be
> > written out, it does not take the buffer lock and so it can modify buffer
> > while it is under writeout. That can lead to a filesystem corruption
> > if we crash at the right moment.
> >   We fix the problem by clearing the buffer dirty bit under buffer_lock
> > even if the buffer is on BJ_None list. Actually, we clear the dirty bit
> > regardless the list the buffer is in and warn about the fact if
> > the buffer is already journalled.

When running fsstress, we get the "Spotted dirty metadata buffer;
there's a risk of filesystem corruption in csae of a system crash" at
least half a dozen times or so.  That sounds like we have a problem.
Were you expecting that this was a "this should never happen"
situation, or is there a known bug that we need to fix here?

	      	       	       	   	- Ted
