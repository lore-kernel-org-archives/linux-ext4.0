From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Date: Mon, 20 Apr 2009 17:50:11 +0200
Message-ID: <20090420155010.GG14699@duck.suse.cz>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com> <1239910921.21233.98.camel@think.oraclecorp.com> <20090420134423.GE14699@duck.suse.cz> <1240237105.16213.41.camel@think.oraclecorp.com> <20090420144241.GF14699@duck.suse.cz> <1240239490.16213.57.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37317 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZDTPuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 11:50:13 -0400
Content-Disposition: inline
In-Reply-To: <1240239490.16213.57.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 20-04-09 10:58:10, Chris Mason wrote:
> > > >   3) Currently truncate() does filemap_write_and_wait() - is it really
> > > > needed? Each guarded bh could carry with itself i_disksize it should update
> > > > to when IO is finished. Extending truncate will just update this i_disksize
> > > > at the last member of the list (or update i_disksize when the list is
> > > > empty). 
> > > >
> > > > Shortening truncate will walk the list of guarded bh's, removing from
> > > > the list those beyond new i_size, then it will behave like the extending
> > > > truncate (it works even if current i_disksize is larger than new i_size).
> > > > Note, that before we get to ext3_truncate() mm walks all the pages beyond
> > > > i_size and waits for page writeback so by the time ext3_truncate() is
> > > > called, all the IO is finished and dirty pages are canceled.
> > > 
> > > The problem here was the disk i_size being updated by ext3_setattr
> > > before the vmtruncate calls calls ext3_truncate().  So the guarded IO
> > > might wander in and change the i_disksize update done by setattr.
> > > 
> > > It all made me a bit dizzy and I just tossed the write_and_wait in
> > > instead.
> > > 
> > > At the end of the day, we're waiting for guarded writes only, and we
> > > probably would have ended up waiting on those exact same pages in
> > > vmtruncate anyway.  So, I do agree we could avoid the write with more
> > > code, but is this really a performance critical section?
> >   Well, not really critical but also not negligible - mainly because with
> > your approach we end up *submitting* new writes we could just be canceled
> > otherwise. Without fdatawrite(), data of short-lived files need not ever
> > reach the disk similarly as in writeback mode (OK, this is connected with
> > the fact that you actually don't have fdatawrite() before ext3_truncate()
> > in ext3_delete_inode() and that's what initially puzzled me).
> 
> When we're going down to zero, we don't need it.  The i_disksize gets
> updated again by ext3_truncate.  I'll toss in a special case for that
> before the write_and_wait.
  I'm sorry but why truncate to zero does not need it? If we assume that
IO completion can still happen while ext3_truncate() is running which is
what you're afraid of, then I don't see a big difference between truncate
to zero, truncate to i_disksize (which is from where you do fdatawrite) or
truncate to anything else.
  Also two other comments:
...
@@ -915,14 +1042,19 @@ int ext3_get_blocks_handle(handle_t *handle, struct
inode *inode,
         * i_disksize growing is protected by truncate_mutex.  Don't forget
         * to
         * protect it if you're about to implement concurrent
         * ext3_get_block() -bzzz
+        *
+        * FIXME, I think this only needs to extend the disk i_size when
+        * we're filling holes that came from using ftruncate to increase
+        * i_size.  Need to verify.
        */
-       if (!err && extend_disksize && inode->i_size > ei->i_disksize)
-               ei->i_disksize = inode->i_size;
+       if (!ext3_should_guard_data(inode) && !err && extend_disksize)
+               maybe_update_disk_isize(inode, inode->i_size);
This is kind of confusing. extend_disksize is used only from ext3_getblk()
which is called only for directories so the first condition is always true
- and if it wasn't sometime in future, you'd have a hard time tracking why
i_disksize is not updated.  So I'd rather add something like
  WARN_ON(extend_disksize && ext3_should_guard_data(inode));
if you wish to keep the check.

  Also I think you can have races between direct IO writing to the file
(updating i_disksize) and your completion handler updating i_disksize -
direct IO plays tricks with i_disksize to truncate allocated blocks in case
of failed write... It's all nasty ;( Probably we should somehow set clear
rules about i_disksize updates and clean up the code to obey them.
Otherwise we'll be hunting nasty races another two years...

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
