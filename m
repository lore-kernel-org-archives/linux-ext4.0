From: Andreas Dilger <adilger@sun.com>
Subject: Re: What to do when the journal checksum is incorrect
Date: Mon, 26 May 2008 12:24:28 -0600
Message-ID: <20080526182428.GT3516@webber.adilger.int>
References: <E1K02Jh-0002wf-2e@closure.thunk.org>
 <20080525063024.GG3516@webber.adilger.int> <20080525113842.GE5970@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64903 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYEZSYb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 14:24:31 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4QIOUNG027851
	for <linux-ext4@vger.kernel.org>; Mon, 26 May 2008 11:24:31 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1H00G01N3ZIF00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 26 May 2008 11:24:30 -0700 (PDT)
In-reply-to: <20080525113842.GE5970@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 25, 2008  07:38 -0400, Theodore Ts'o wrote:
> Well, what are the alternatives?  Remember, we could have potentially
> 50-100 megabytes of stale metadata that haven't been written to
> filesystem.  And unlike ext2, we've deliberately held back writing
> back metadata by pinning it so, things could be much worse.  So let's
> tick off the possibilities:
> 
> * An individual data block is bad --- we write complete garbage into
>   the filesystem, which means in the worst case we lose 32 inodes
>   (unless that inode table block is repeated later in the journal), 1
>   directory block (causing files to land in lost+found), one bitmap
>   block (which e2fsck can regenerate), or a data block (if data=jouranalled).
> 
> * A journal descriptor block is bad --- if it's just a bit-flip, we
>   could end up writing a data block in the wrong place, which would be
>   bad; if it's complete garbage, we will probably assume the journal
>   ended early, and leave the filesystem silently badly corrupted.
> 
> * The journal commit block is bad --- probably we will just silently
>   assume the journal ended early, unless the bit-flip happened exactly
>   in the CRC field.
> 
> The most common case is that one or more individual data blocks in the
> journal are bad, and the question is whether writing that garbage into
> the filesystem is better or worse than aborting the journal right then
> and there.

You are focussing on the case where 1 or 2 filesystem blocks in the
journal are bad, but I suspect the real-world cases are more likely to
be 1 or 2MB of data are bad, or more.  Considering that a disk sector
is at least 4 or 64kB in size, and problems like track misalignment
(overpowered seek), write failure (high-flying write), or device cache
reordering problems will result in a large number of bad blocks in the
journal, I don't think 1 or 2 filesystem is a realistic failure scenario
anymore.

> The problem with only replaying the "good" part of the journal is the
> kernel then truncates the journal, and it leaves e2fsck with no way of
> doing anything intelligent afterwards.  So another possibility is to
> not replay the journal at all, and fail the mount unless the
> filesystem is being mounted read-only; but the question is whether we
> are better off not replaying the journal at *all*, or just replaying
> part of it.

I'd think at a minimum to replay the journal up to the bad transaction.
That the current code is broken and also replays the bad transaction is
of course incorrect.  The probability that later transactions have
begun checkpointing their blocks to the filesystem is decreasing for
each later transaction after the bad one, so the probability of those
changes corrupting the filesystem are correspondingly lower.

> Consider that if /boot/grub/menu.lst got written, and one of its data
> block was previously directory block that had since gotten deleted,
> but in the journal and had been revoked, replaying part of the journal
> might make the system non-bootable.

Sure, such scenarios exist, but the architecture of ext3/4 is that the
data block will _likely_ have been rewritten in the same place.  The
more likely case is that some important filesystem metadata (itable,
indirect blocks of files, etc) is being overwritten and corruption in
the journal is a laser-guided missile to finding all of the important
blocks in the filesystem to spread that corruption to.

> So the other alternative I seriously considered was not replaying the
> journal at all, and bailing out after seeing the bad checksum --- but
> that just defers the problem to e2fsck, and e2fsck can't really do
> anything much different, and the tools to allow a human to make a
> decision on a block by block basis in the journal don't exist, and
> even if they did would make more system administrators run screaming.
> 
> I suspect the *best* approach is to change the journal format one more
> time, and include a CRC on a per-block basis in the descriptor blocks,
> and a CRC for the entire descriptor block.  That way, we can decide
> what to replay or not on a per-block basis.

Yes, I was thinking exactly this same thing.  This would give the maximum
probability of the correct outcome, because only "correct" blocks are
checkpointed into the filesystem, and at least an old version of the
block is present in the filesystem (unless it is a new block).  The chance
also exists that a later transaction will even overwrite the bad block,
which will avoid even the need to invoke e2fsck.

This would need:
- a checksum in the per-block transaction record (tag).  One option is
  to keep an 8- or 16-bit checksum in the "flags" field, to keep it
  compatible with older JBD implementations.
- a checksum of the commit header and tags to ensure we can trust the
  per-block checksums, and we don't need a huge checksum for each block.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

