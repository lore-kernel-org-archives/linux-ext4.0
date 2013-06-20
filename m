From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/jbd2: t_updates should increase when
 start_this_handle() failed in jbd2__journal_restart()
Date: Thu, 20 Jun 2013 14:12:15 -0400
Message-ID: <20130620181215.GD4982@thunk.org>
References: <51C1381A.2@huawei.com>
 <20130620155555.GE28309@thunk.org>
 <20130620172609.GC4288@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Younger Liu <younger.liu@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Ocfs2-Devel <ocfs2-devel@oss.oracle.com>,
	Li Zefan <lizefan@huawei.com>, jack@suse.cz
To: Josef Bacik <jbacik@fusionio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59884 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FTSMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 14:12:23 -0400
Content-Disposition: inline
In-Reply-To: <20130620172609.GC4288@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 01:26:09PM -0400, Josef Bacik wrote:
> I realize it's been a little bit since I've looked at jbd but I'll offer my
> opinion.  Callers of jbd2_journal_restart() may not be the ones who originated
> the handle, so doing what Jan has done with jbd2_journal_start_reserved() isn't
> going to work because all the guy at the top is going to see is an error and
> have no way to tell if his handle is invalid or not.

Yeah, that's what I meant by "it would require changing all of the
callers".

> What I would suggest is getting a unified way to mark that the handle has
> already been cleaned up and can just be free'd.

The problem though is we need to make sure none of the callers don't
try to do anything else with handle besides calling
jbd2_journal_stop().  In particular, we can't allow a call to
jbd2_journal_get_write_access(), jbd2_journal_revoke() to operate on
the handle, because its transaction pointer is (potentially) invalid.

> Then fix jbd2_journal_start_reserved() and jbd2_journal_restart() to
> set that in the handle and make jbd2_journal_stop() just free up the
> handle and reset current->journal_info but not return an error.
> It's important to not return an error from jbd2_journal_stop() so
> that it doesn't invoke the ext4 error handling stuff and you get a
> read only file system when the error may not be read only file
> system worthy.

The handle->h_aborted bit, which is currently not used, does most of
the right thing, modulo the question of the fact that
jbd2_journal_stop() will return an error.  What's important from my
perspective is that the various callers that operate on a handle check
is_handle_aborted() before trying to use the it.  We'll still need to
audit the callers to make sure there isn't some uncommon-taken code
path where ext4_handle_dirty_metadata() gets called after
ext4_journal_restart() has returned an error.

As a FAST paper once opined, "EIO: Error Handling Is Occasionally correct".  :-)

> This way you have a nice clean way of dealing with handle errors that allow you
> to pass back a real error to the caller and the caller can just do its normal
> jbd2_journal_stop() and cleanup and do its own error handling the way it feels.
> This keeps the yucky details of no longer valid handles all internal to jbd2 and
> ext4/ocfs2 don't have to worry about it.  Thanks,

Yes, that could work, although we'll need to check to make sure all of
the code paths that invoke jbd2_journal_restart() handle errors
appropriately, and don't rely on jbd2_journal_stop() returning an
error.  Thanks for your thoughts!

Regards,

	       	   	      	 		     - Ted
