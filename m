From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Date: Wed, 7 Nov 2007 15:36:05 +0100
Message-ID: <20071107143605.GD22214@duck.suse.cz>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz> <20071106194012.GE12857@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54070 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758064AbXKGOgG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Nov 2007 09:36:06 -0500
Content-Disposition: inline
In-Reply-To: <20071106194012.GE12857@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 06-11-07 14:40:12, Theodore Tso wrote:
> On Tue, Nov 06, 2007 at 06:19:45PM +0100, Jan Kara wrote:
> > Intended use case is that application which wants to watch any
> > modification in a subtree scans the subtree and sets flags for all
> > inodes there. Next time, it just needs to recurse in directories
> > having rtime newer than the start of the previous scan. There it can
> > handle modifications and set the flag again. It is up to application
> > to watch out for hardlinked files. It can e.g.  build their list and
> > check their mtime separately (when a hardlink to a file is created
> > its inode is modified and rtimes properly updated and thus any
> > application has an effective way of finding new hardlinked files).
> 
> Umm, yuck.
> 
> What if more than one application wants to use this facility?
  That should be fine - let's see: Each application keeps somewhere a time when
it started a scan of a subtree (or it can actually remember a time when it
set the flag for each directory), during the scan, it sets the flag on
each directory. When it wakes up to recheck the subtree it just compares
the rtime against the stored time - if rtime is greater, subtree has been
modified since the last scan and we recurse in it and when we are finished
with it we set the flag. Now notice that we don't care about the flag when
we check for changes - we care only for rtime - so if there are several
applications interested in the same subtree, the flag just gets set more
often and thus the update of rtime happens more often but the same scheme
still works fine.

> The application is using a global per-inode flag that is written out
> to disk.  So sweeping the entire subtree and setting this flag will
> involve a lot of disk i/o; as does setting a mod-time, since it could
> potentially require a large number of inode updates, and then the
> application needs to sweep through the subtree and reset the flags
> (resulting in more disk i/o).  The performance would seem to me to be
> really pessimal.  
  I don't get it here - you need to scan the whole subtree and set the flag
only during the initial scan. Later, you need to scan and set the flag only
for directories in whose subtree something changed. Similarty rtime needs
to be updated for each inode at most once after the scan. Maybe we have
different different ideas of use-cases: I consider this useful for larger
subtrees which change only seldom (or only their small parts) or you want
to check for changes only once per some longer time - so uses like backup
with rsync, updatedb, cachefiles for trees with config files (like KDE has)
etc. There the penalty for additional IO is during rtime updates is quite
negligible - if you have some usecase you'd like to measure, please propose
it and I'll measure it. I have tested the following:
  Create a tree of depth 5 where each directory has 5 subdirectories and
the leaf directories have 10 files in it. You set the flag on all
directories (umount and mount again) and then touch one file in every directory.
  With the feature enabled this takes 36.1176s (average from 5 tests) with
deviation 0.29509. Without the feature it takes 35.75480 with deviation
0.15433. So the difference in performance is 1% which is just slightly
above the error and I'd find this test case quite pesimistic for the
intended usage... 

> In addition, after you crash, there might not be any application
> waiting to watch modifications in that subtree, and yet the flags
> would still be set so the system would still be paying the performance
> penalties of needing to propagate modtimes until all of the flags
> disappear --- and for a large subtree, that might not be for a long,
> long time.
  I don't quite understand what you are afraid here - I think we
misunderstand a bit - are you aware that we don't propagate the
modification up once we hit a directory with a flag not set - hence all
possible updates in future will write each inode at most once? 

> So if the goal is some kind of modification notification system that
> watches a subtree efficiently, avoiding some of the deficiencies of
> inotify and dnotify, the interface doesn't seem to be the right way to
> go about things.  The fact that only one application at a time can use
> this interface, even if you ignore the issues of hard links and the
> performance problems and the lack of cleanup after a reboot, seems in
> my mind to just be a irreparable fatal flaw to this particular scheme.
  I hope I've refuted most of your objections ;) Thanks for having look
at the feature.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
