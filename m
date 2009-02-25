From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4-fs: group descriptors corrupted!
Date: Wed, 25 Feb 2009 18:18:53 -0500
Message-ID: <20090225231853.GG1363@mit.edu>
References: <49A5AC83.1020009@cox.net> <20090225213046.GF1363@mit.edu> <49A5BC63.9030104@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux-Ext4 <linux-ext4@vger.kernel.org>
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44405 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbZBYXS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 18:18:58 -0500
Content-Disposition: inline
In-Reply-To: <49A5BC63.9030104@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Huh.  OK, there's something really strange going on here.

The kernel never updates the backup superblock; that's by design, to
avoid corruption problems.  So for example, on my laptop, if I run
dumpe2fs on my root partition, I see this:

Filesystem created:       Fri Feb 13 09:00:02 2009
Last mount time:          Tue Feb 24 14:34:19 2009
Last write time:          Tue Feb 24 14:34:19 2009
Mount count:              3
Maximum mount count:      30
Last checked:             Sat Feb 14 10:46:41 2009
Check interval:           15552000 (6 months)
Next check after:         Thu Aug 13 11:46:41 2009

However, if I run dumpe2fs -o superblock=32768 on my root partition,
I'll see this:

Filesystem created:       Fri Feb 13 09:00:02 2009
Last mount time:          Fri Feb 13 11:22:06 2009
Last write time:          Sat Feb 14 10:47:11 2009
Mount count:              0
Maximum mount count:      30
Last checked:             Sat Feb 14 10:46:41 2009
Check interval:           15552000 (6 months)
Next check after:         Thu Aug 13 11:46:41 2009

Note the difference in the "last write time" and the "last mount
time".  That's because normally we avoid touching the backup
superblocks.

Now let's take a look at your dumpe2fs output.  In your case, we see
the following:

Filesystem created:       Thu Jan 22 19:33:20 2009
Last mount time:          Fri Jan 23 16:23:58 2009
Last write time:          Sun Feb 22 02:31:02 2009
Mount count:              1
Maximum mount count:      24
Last checked:             Fri Jan 23 16:19:49 2009
Check interval:           15552000 (6 months)
Next check after:         Wed Jul 22 17:19:49 2009

and it's the same on both the primary and backup (dumpe2fs -o
superblock=32768).  The question is how the heck did *that* happen?
As I mentioned, the kernel doesn't even have code to touch the backup
superblock.  That would tend to implicate one of the e2fsprogs tools,
or sometihng using the e2fsprogs libraries --- but the recent
libraries (and you're using e2fsprogs 1.41.x) also avoid touching the
backup superblocks.  The only tools that could have done it from
e2fsprogs userland are e2fsck, tune2fs, and resize2fs, and that
doesn't explain how the values turned out to be pure garbage.

Does that the "last write" timestamp suggest anything to you?  What
was happening on the system at or around Sun Feb 22 02:31:02 2009?
Maybe if we can localize this down to what userspace program caused
the problem, it'll be a hint.

(This is why I didn't want you to run e2fsck just yet; if you had, it
would have overwritten the last write time, which could be a value
clue as to what is causing this problem.)

As far as how to recover your data, what I would recommend doing is
creating a writeable LVM snapshot, with a pretty good amount of space.
Then try running the command "mke2fs -S " on the snapshot, with
*precisely* the same mke2fs arguments and /etc/mke2fs.conf that you
used to create the filesystem in the first place.  Then cross your
fingers, and e2fsck on the snapshot, and see how much of the data you
can recover; some of it may end up in lost+found, but hopefully you'll
get most of the data back.  If it works on snapshot, only then try it
on the real LVM.  If it doesn't work out on the snapshot, you can
always discard it and try again without further corrupting any of your
original filesystem.

Good luck, and thanks in advance for anything information you can give
us to help track down this problem.  And this point I'm going to guess
that it's a nasty e2fsprogs bug, where somehow the internal in-memory
version of the block group descriptors got corrupted, and then gotten
writen out to disk.  But this is just a guess at this point --- and
I'm still left wondering why I haven't seen it on my systems and on my
regression testing.

    	       		       	       	    - Ted

