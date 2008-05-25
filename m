From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What to do when the journal checksum is incorrect
Date: Sun, 25 May 2008 07:38:42 -0400
Message-ID: <20080525113842.GE5970@mit.edu>
References: <E1K02Jh-0002wf-2e@closure.thunk.org> <20080525063024.GG3516@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57419 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433AbYEYLjA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2008 07:39:00 -0400
Content-Disposition: inline
In-Reply-To: <20080525063024.GG3516@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 25, 2008 at 12:30:24AM -0600, Andreas Dilger wrote:
> I don't agree with this at all.  With the exception of the checksum
> error being in the last transaction, there is a danger of complete
> garbage being checkpointed into the filesystem if the checksum is bad.
> The alternative to not replay the rest of the transactions at worst
> has some probability that newer versions of the blocks were checkpointed
> into the filesystem before it crashed.
> 
> You are proposing that we write some blocks which we know to be garbage
> directly into the filesystem metadata instead of leaving some unordered
> writes in the filesystem to be fixed (as happens with ext2 all of the time).


Well, what are the alternatives?  Remember, we could have potentially
50-100 megabytes of stale metadata that haven't been written to
filesystem.  And unlike ext2, we've deliberately held back writing
back metadata by pinning it so, things could be much worse.  So let's
tick off the possibilities:

* An individual data block is bad --- we write complete garbage into
  the filesystem, which means in the worst case we lose 32 inodes
  (unless that inode table block is repeated later in the journal), 1
  directory block (causing files to land in lost+found), one bitmap
  block (which e2fsck can regenerate), or a data block (if data=jouranalled).

* A journal descriptor block is bad --- if it's just a bit-flip, we
  could end up writing a data block in the wrong place, which would be
  bad; if it's complete garbage, we will probably assume the journal
  ended early, and leave the filesystem silently badly corrupted.

* The journal commit block is bad --- probably we will just silently
  assume the journal ended early, unless the bit-flip happened exactly
  in the CRC field.

The most common case is that one or more individual data blocks in the
journal are bad, and the question is whether writing that garbage into
the filesystem is better or worse than aborting the journal right then
and there.

The problem with only replaying the "good" part of the journal is the
kernel then truncates the journal, and it leaves e2fsck with no way of
doing anything intelligent afterwards.  So another possibility is to
not replay the journal at all, and fail the mount unless the
filesystem is being mounted read-only; but the question is whether we
are better off not replaying the journal at *all*, or just replaying
part of it.

Consider that if /boot/grub/menu.lst got written, and one of its data
block was previously directory block that had since gotten deleted,
but in the journal and had been revoked, replaying part of the journal
might make the system non-bootable.

So the other alternative I seriously considered was not replaying the
journal at all, and bailing out after seeing the bad checksum --- but
that just defers the problem to e2fsck, and e2fsck can't really do
anything much different, and the tools to allow a human to make a
decision on a block by block basis in the journal don't exist, and
even if they did would make more system administrators run screaming.

I suspect the *best* approach is to change the journal format one more
time, and include a CRC on a per-block basis in the descriptor blocks,
and a CRC for the entire descriptor block.  That way, we can decide
what to replay or not on a per-block basis.

> > But if there are any non-terminal commits that have bad checksums, we
> > need to pass a flag back to the filesystem, and have the filesystem call
> > ext4_error() indicating that the journal was corrupt; this will mark the
> > filesystem has containing errors, and use the filesystem policy to
> > decide whether to remount the filesystem read-only, continue, or panic.
> > Then e2fsck at boot time can try to sort out the mess.
> 
> Yes, that is definitely the right approach, and I thought that was the
> case.  It's been a while since I looked at the code.

Nope, right now the mount will silently succeed, even though part of
the journal (include the commit with the bad CRC, but no commits
beyond that) have been replayed, and then the entire journal is
truncated and thrown away.

Basically, almost any change we make would be an improvement.  :-)

	   	      	     	     	      	 - Ted
