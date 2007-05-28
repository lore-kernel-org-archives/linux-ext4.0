From: Jan Kara <jack@suse.cz>
Subject: Re: ext2_discard_prealloc() called on each iput?
Date: Mon, 28 May 2007 18:04:20 +0200
Message-ID: <20070528160420.GD21509@duck.suse.cz>
References: <20070522161127.GC13633@duck.suse.cz> <20070523123743.GD5608@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58502 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751082AbXE1Pwp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2007 11:52:45 -0400
Content-Disposition: inline
In-Reply-To: <20070523123743.GD5608@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 23-05-07 08:37:43, Theodore Tso wrote:
> On Tue, May 22, 2007 at 06:11:27PM +0200, Jan Kara wrote:
> > 
> >   while fixing some problems with preallocation in UDF, I had a look how
> > ext2 solves similar problems. I found out that ext2_discard_prealloc() is
> > called on every iput() from ext2_put_inode(). Is it really appropriate? I
> > don't see a reason for doing so...
> 
> I agree, it's probably not appropriate.  It's been that way for a long
> time, though (since 2.4.20).  It's not as horrible as it seems since
> unlike traditional Unix systems, we don't call iput() as often, since
> for example operations like close() end up calling dput(), which
> decrements the ref. count on dentry, not the inode.  But it would
> probably be better to check to see if i_count is 1 before deciding to
> discard the preallocation.
  OK, but then you could move the code to drop_inode() which is called at
exactly that moment... I've been thinking more about it when fixing UDF.
Discarding prealloc at drop_inode() has the disadvantage that
symlinks/directories will keep their preallocated blocks until inodes are
evicted from memory. Which is probably why ext2 discards prealloc on
iput().

> >   Also I found slightly misleading the comment at ext2_release_file().
> > As far as I understand the code it isn't when /all/ files are closed but
> > rather when all fd's for given filp are closed. I.e. if you open the same
> > file two times, ->release will get called once for each open. Am I right?
> 
> Yep!
> 
> > If so, then also calling ext2_discard_prealloc() from ext2_release_file()
> > is suboptimal, isn't it?
> 
> Yes, although it's a bit better because only discaord the
> preallocation if the file descriptor was opened for writing.  The file
> could be opened for writing by multiple file descriptors, true, but in
> that case it's likely that the write pattern will be a random access one
> anyway, so the preallocated region is less useful.
  OK, but still we could use e.g. i_writecount to check that we drop the
last descriptor for writing...

> P.S.  Note that ext3 and ext4 use a different preallocation scheme;
  Yes, I know that. That's why I looked at ext2 when searching for
inspiration how to fix UDF :)

> still patches to fix the comments might not be a bad idea, since it
> might save confusion by others later on.
  Ok, will write one.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
