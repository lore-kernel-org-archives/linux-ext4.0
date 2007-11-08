From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Thu, 8 Nov 2007 16:28:22 +0100
Message-ID: <20071108152822.GF6781@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz> <20071106194012.GE12857@thunk.org> <20071107143605.GD22214@duck.suse.cz> <20071108002037.GA7728@thunk.org> <20071108105642.GB6781@duck.suse.cz> <20071108143759.GF7728@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54228 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753751AbXKHP2Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2007 10:28:24 -0500
Content-Disposition: inline
In-Reply-To: <20071108143759.GF7728@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 08-11-07 09:37:59, Theodore Tso wrote:
> Ah, OK, so the two things that I didn't get from your patch
> description are:
> 
> 1) the rtime flag and rtime field are only set on directories
> 2) the intended use is not trackerd and its ilk, but rsync and updatedb,
>    so it is desirable that scan/queries be persistent across reboots
> 
> But then the major hole in this scheme is still the issue of hard
> links.  The rsync program is still going to have to scan the entire
> subtree looking for hard links, since an inode with multiple links
> into the directory tree can't guarantee that all of its parent
> directories will have their rtime field updated.
  Not really - initially rsync can scan a tree for hardlinks and remember
where they are. If a hardlink to a file is created, an rtime update is
sent up the tree via the path used to create the link. So during next scan,
rsync will see the file is modified and finds out that its nlink is > 1
and adds it to the list of hardlinked files.
  So for things like regular backups hardlinks can be dealt with
efficiently.

> A program like updatedb which only cares about filenames will be OK,
> since that means it really only cares about knowing when directories
> have changed, and you can't have hard links to directories.
> 
> The other problem, of course, is that this feature would become ext
> 2/3/4 specific, and I could see future filesystems possibly wanting
> this.  So this raises the question of whether the interface should be
> at the VFS layer or not --- and if so, how to handle querying whether
> a particulra filesystem supports it, and what happens if you have a
> subtree which is covered by a filesystem that doesn't support rtime?
> 
> So a program like rsync would need to scan /proc/self/mounts to see
> whether or not it would be safe to use this feature in the first
  Yes, being filesystem specific and thus requiring special handling of
mount points is a disadvantage of this approach.

> place.  And, of course, rsync would need to know whether it has write
> access to the tree in order to set flags in the directory, and what to
> do if some portion of the subtree isn't writeable by rsync.
  Yes, the cases where we cannot modify the flag in a tree would have to be
handled (similarly as the cases where the filesystem simply does not
support the feature). I don't think it wouldn't be too complicated but I have
not the modification for rsync yet, so I can underestimate...

> On Thu, Nov 08, 2007 at 11:56:42AM +0100, Jan Kara wrote:
> > > Note by the way that since you need to own the file/directory to set
> > > flags, this means that only programs that are running as root or
> > > running as the uid who owns the entire subtree will be able to use
> > > this scheme.  One advantage of doing in kernel memory is that you
> > > might be able to support watching a tree that is not owned by the
> > > watcher.
> >   Yes, that is the advantage. On the other hand we could allow setting that
> > particular flag even without being an owner of the inode. In fact, I
> > don't currently see use case where you won't be either root (rsync,
> > updatedb) or an owner of the files (watching config file trees) but I guess
> > people would find some :).
> 
> Sometimes people like to use rsync to copy a subtree to which they
> have read access but not write access.  (And here note that it's not
> enough to have write access, you actually need to *own* all of the
> directories in the subtree).
  Yes, so in such cases my feature won't be able to help. But I think
there are still enough cases where it would help.

> Yes, it's safe to let any user *set* the rtime flag, but we couldn't
> let them clear the rtime flag, since then they would be able to hide a
> file modification from some other (potentially privileged) process.
  Good point.

> Speaking of security, I assume your patch will never allow rtime to go
> backwards (for example if the user attempts to backdate a file's mtime
> field using the utime() or utimes() system call)?
  No, the patch does not allow this. But anyway in case user has enough
rights to change file's mtime, would it really be a security concern?

> I guess I'm convinced that updatedb could use this facility, but there
> are enough asteriks around it that I'm not sure that rsync could
> safely use this feature in production.  I don't doubt that in a cold
> cache case, it would speed up rsync, but because it doesn't handle
> hard links, it's not reliable.  Since rsync often gets used for
> backups, this is a big deal.  There are also questions about what to
> do if rsync doesn't have write access to the filesystem, or if there
> is a non-rtime capable filesystem mounted in the subtree, etc., that
> can be worked around, but would add a lot of complexity and grottiness
> to the rsync source tree.  Is the rsync maintainer really willing to
> add all of the necessary hair to support this rtime facility into
> their program?
  Hardlinks can be worked-around as I wrote above and there would have to
be a fallback in case we cannot set the flag. So I agree the code would be
more complicated but I think it could be done in a quite clean way - but of
course that has to be proven by a patch which I don't have yet. I have not
spoken to rsync maintainers about this - first I want to have at least a
preliminary version of a patch for rsync so that we have something to
talk about...
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
