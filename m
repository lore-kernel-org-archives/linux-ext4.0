From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 421482] Firefox 3 uses fsync excessively
Date: Mon, 26 May 2008 11:49:55 -0700
Message-ID: <20080526114955.82c062f2.akpm@linux-foundation.org>
References: <bug-421482-310856@https.bugzilla.mozilla.org/>
	<200805260513.m4Q5DAU8018498@mrapp54.mozilla.org>
	<20080526000506.1d0fb047.akpm@linux-foundation.org>
	<20080526100751.GB24507@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbYEZSu2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 May 2008 14:50:28 -0400
In-Reply-To: <20080526100751.GB24507@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 26 May 2008 06:07:51 -0400 Theodore Tso <tytso@MIT.EDU> wrote:

> On Mon, May 26, 2008 at 12:05:06AM -0700, Andrew Morton wrote:
> > It's purportedly showing that fdatasync() on ext3 is syncing the whole
> > world in fsync()-fashion even with an application which does not grow
> > the file size.
> > 
> > But fdatasync() shouldn't do that.  Even if the inode is dirty from
> > atime or mtime updates, that shouldn't cause fdatasync() to run an
> > ext3 commit?
> 
> Well, ideally it shouldn't, although POSIX allows fdatasync() to be
> implemented in terms of fsync().  It is at the moment.  :-/

Well..

> The problem is we don't currently have a way of distinguishing between
> a "smudged" inode (only the mtime/atime has changed) and a "dirty"
> inode (even if the number of blocks hasn't changed, if i_size has
> changed, or i_mode, or anything else, including extended attributes
> inline in the inode).

Who do you mena by "we"?  ext3 or the kernel as a whole?

>  We're not tracking that difference.  If we only
> allow mtime/atime changes through setattr (see Cristoph's patches),
> and don't set the VFS dirty bit, but our own "smudged" bit, we could
> do it --- but at the moment, we're not.

But the VFS _does_ track these things, via the eternally
incomprehensible I_DIRTY_SYNC and I_DIRTY_DATASYNC.

We have:

	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
		goto out;

which _should_ cause the fs to skip the commit during fdatasync() if
only mtime and ctime have changed?

