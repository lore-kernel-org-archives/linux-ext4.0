From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: What to do when the journal checksum is incorrect
Date: Sat, 24 May 2008 18:34:21 -0400
Message-ID: <E1K02Jh-0002wf-2e@closure.thunk.org>
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Girish Shilamkar <girish@clusterfs.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53411 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755318AbYEXWeb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 May 2008 18:34:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I've been taking a much closer look at the ext4's journal checksum code
as I integrated it into e2fsck, and I'm finding that what it's doing
doesn't make a whole lot of sense.

Suppose the journal has five commits, with transaction ID's 2, 3, 4, 5,
and 6.  And suppose the CRC in the commit block delineating the end of
transaction #4 is bad.  At the moment, due to a bug in the code, it
stops processing at transaction #4, meaning that transactions #2, #3,
and #4 are replayed into the filesystem --- even though transaction #4
failed the CRC checksum.  Worse yet, no indication of any problems is
sent back to the ext4 filesystem code.

Even far worse, though, is that the filesystem is now in a potentially
very compromised state.  Stopping the journal replay after transaction
#3 is no better, because the rest of the filesystem may had changes made
to it since then which would have been overwritten by replaying
only transactions #2 and #3.

What this means is that the only time when it's OK for us to proceed
when there is a checksum failure is if it's the very last commit block,
and journal_async_commit's are enabled.   At any other time, we have to
assume that filesystem is corrupted.

The next question is what should we do the journal.  For the root
filesystem, we need to be able to mount it in order to run e2fsck.  If
we fail the mount because of the bad journal, then the user is forced to
use a rescue CD, at which point e2fsck is going to have to do something
automatic or force the user to start using a disk editor to recover.

So I think the right thing to do is to replay the *entire* journal,
including the commits with the failed checksums (except in the case
where journal_async_commit is enabled and the last commit has a bad
checksum, in which case we skip the last transaction).  By replaying the
entire journal, we don't lose any of the revoke blocks, which is
critical in making sure we don't overwrite any data blocks, and
replaying subsequent metadata blocks will probably leave us in a much
better position for e2fsck to be able to recover the filesystem.

But if there are any non-terminal commits that have bad checksums, we
need to pass a flag back to the filesystem, and have the filesystem call
ext4_error() indicating that the journal was corrupt; this will mark the
filesystem has containing errors, and use the filesystem policy to
decide whether to remount the filesystem read-only, continue, or panic.
Then e2fsck at boot time can try to sort out the mess.

If e2fsck is replaying the journal, it will do the same thing; play it
back despite the checksum errors, and then force a full check of the
filesystem since it is quite likely corrupted as a result.

Does this make sense?  It's the direction I plan to go in terms of
making changes to the kernel and the e2fsck's recovery code, so please
let me know if you disagree with this strategy.

							- Ted





