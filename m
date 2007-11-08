From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Thu, 8 Nov 2007 11:56:42 +0100
Message-ID: <20071108105642.GB6781@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz> <20071106194012.GE12857@thunk.org> <20071107143605.GD22214@duck.suse.cz> <20071108002037.GA7728@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44293 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756698AbXKHK4p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2007 05:56:45 -0500
Content-Disposition: inline
In-Reply-To: <20071108002037.GA7728@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 07-11-07 19:20:38, Theodore Tso wrote:
> On Wed, Nov 07, 2007 at 03:36:05PM +0100, Jan Kara wrote:
> > > What if more than one application wants to use this facility?
> >
> >   That should be fine - let's see: Each application keeps somewhere a time when
> > it started a scan of a subtree (or it can actually remember a time when it
> > set the flag for each directory), during the scan, it sets the flag on
> > each directory. When it wakes up to recheck the subtree it just compares
> > the rtime against the stored time - if rtime is greater, subtree has been
> > modified since the last scan and we recurse in it and when we are finished
> > with it we set the flag. Now notice that we don't care about the flag when
> > we check for changes - we care only for rtime - so if there are several
> > applications interested in the same subtree, the flag just gets set more
> > often and thus the update of rtime happens more often but the same scheme
> > still works fine.
> 
> OK, so in this case you don't need to set rtime on the every single
> file inode, but only directory inode, right?  Because you're only
  Yes, that's actually what I'm doing - sorry if I didn't make it clear
earlier.

> using checking the rtime at the directory level, and not the flag.
> And it's just as easy for you to check the rtime flag for the file's
> containing directory (modulo magic vis-a-vis hard links) as the file's
> inode.
  Exactly.

> I'm just really wishing that rtime and the rtime flag didn't have live
> on disk, but could rather be in memory.  If you only needed to save
> the directory flags and rtimes, that might actually be doable.
  I already gave some thought to this but there seemed to be some
drawbacks. Query I want to support is: given a directory, tell me which of
its subdirectories (arbitrarily deep below) have been modified since time
T.  That is what you need to support faster rsync, updatedb and similar
loads.  Also I want to allow a reboot to happen inbetween the modification
and a query (handling a crash correctly would be nice too but honestly my
current implementation is not completely reliable in this regard either) so
some pernament storage is needed in any case. What I can imagine we could
do is to report all modifications to userspace - that has a problem that
there are *many* possible modifications but we are interested only whether
there happened some since time T. We could improve this by an in-memory
inode flag "I'm not interested in modifications any further" and reporting
the change only if the parent directory does not have this flag set (note
that this flag gets lost when we evict the inode from memory). But I would
say that in the end all this message passing, climbing the tree from
userspace and maintaining data structure in memory and on disk would cost
use more than the current implementation... Also it has the disadvantage
that we miss the modifications which happen before we start the userspace
daemon catching the events.
  Doing this in kernel memory has a problem how to solve the persistency
across reboots (dumping mod's to userspace on request?) and also on my
system you'd have roughly a few MB of pinned memory for these purposes...
Plausible but I don't really like it...

> Note by the way that since you need to own the file/directory to set
> flags, this means that only programs that are running as root or
> running as the uid who owns the entire subtree will be able to use
> this scheme.  One advantage of doing in kernel memory is that you
> might be able to support watching a tree that is not owned by the
> watcher.
  Yes, that is the advantage. On the other hand we could allow setting that
particular flag even without being an owner of the inode. In fact, I
don't currently see use case where you won't be either root (rsync,
updatedb) or an owner of the files (watching config file trees) but I guess
people would find some :).

> >   I don't get it here - you need to scan the whole subtree and set the flag
> > only during the initial scan. Later, you need to scan and set the flag only
> > for directories in whose subtree something changed. Similarty rtime needs
> > to be updated for each inode at most once after the scan. 
> 
> OK, so in the worst case every single file in a kernel source tree
> might change after doing an extreme git checkout.  That means around
> 36k of files get updated.  So if you have to set/clear the rtime flag
> during the checkout process 36k file inodes would have to have their
> rtime flag cleared, plus 2k worth of directory inodes; but those would
> probably be folded into other changes made to the inodes anyway.  But
  Yes, here the impact is hardly measurable as I've written in the previous
email.

> then when trackerd goes back and scans the subtree, if you are
> actually setting rtime flags for every single file inode, then that's
> 38k of indoes that need updating.  If you only need to set the rtime
> flags for directories, that's only 2k worth of extra gratuitous inode
> updates.
  As I wrote above, the flag is only set on directories so yes a scan
modifies 2k directory inodes. But such scan happens only when you run rsync
- I don't aim at something like 'trackerd' which would watch the filesystem
all the time. My idea is that those applications that currently do "scan
the tree, stat all files, check mtimes if something changed" would in
future do "scan those directories that have rtime newer than T". So the
overall balance is:
  Currently: scan and stat all files in the tree, compare mtimes
  With rtime: scan those directories in whose subtree has something changed
- stat all files in them, modify directory inodes

So you trade a lot of reading for some writes... I can actually try to measure
how much it will improve rsync scan on my computer :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
