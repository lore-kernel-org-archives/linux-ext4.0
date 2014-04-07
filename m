From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Dirty ext4 blocks system startup
Date: Mon, 7 Apr 2014 08:48:20 -0400
Message-ID: <20140407124820.GB8468@thunk.org>
References: <1459400.cqhC1n3S74@f209>
 <20140404182020.GA8888@birch.djwong.org>
 <5060780.kj9pBZIMgD@web.de>
 <7488414.mDGKOZ8cSK@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Markus <M4rkusXXL@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51062 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbaDGMsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Apr 2014 08:48:25 -0400
Content-Disposition: inline
In-Reply-To: <7488414.mDGKOZ8cSK@web.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 07, 2014 at 12:58:40PM +0200, Markus wrote:
> 
> Finally e2image finished successfully. But the produced file is way too big for a mail.
> 
> Any other possibility?
> (e2image does dump everything except file data and free space. But the problem seems to be just in the bitmap and/or journal.)
> 
> Actually, when I look at the code around e2fsck/recovery.c:594
> The error is detected and continue is called.
> But tagp/tag is never changed, but the checksum is always compared to the one from tag. Intended?

What mount options are you using?  It appears that you have journal
checksums enabled, which isn't on by default, and unfortunately,
there's a good reason for that.  The original code assumed that the
most common case for journal corruption would be caused by an
incomplete journal transaction getting written out if one were using
journal_async_commit.  This feature has not been enabled by default
because the qeustion of what to do when the journal gets corrupted in
other cases is not an easy one.

If some part of a transaction which is not the very last transaction
in the journal gets corrupted, replaying it could do severe damage to
the file system.  Unfortunately, simply deleting the journal and then
recreating it could also do more damage as well.  Most of the time, a
bad checksum happens because the last transaction hasn't fully made it
out to disk (especially if you use the journal_async_commit option,
which is a bit of a misnomer and has its own caveats[1]).  But if the
checksum violation happens in a journal transaction that is not the
last transaction in the journal, right now the recovery code aborts,
because we don't have good automated logic to handle this case.

I suspect if you need to get your file system back on its feet, the
best thing to do is to create a patched e2fsck that doesn't abort when
it finds a checksum error, but instead continues.  Then run it to
replay the journal, and then force a full file system check and hope
for the best.

What has been on my todo list to implement, but has been relatively
low priority because this is not a feature that we've documented or
encouraged peple to use, is to have e2fsck skip the transaction has a
bad checksum (i.e., not replay it at all), and then force a full file
system check.  This is a bit safer, but if you make e2fsck ignore the
checksum, it's no worse than if journal checksums weren't enabled in
the first place.

The long term thing that we need to add before we can really support
journal checksums is to checksum each individual data block, instead
of just each transaction.  Then when we have a bad checksum, we can
skip just the one bad data block, and then force a full fsck.

I'm sorry you ran into this.  What I should do is to disable these
mount options for now, since users who stumble across them, as
apparently you have, might be tempted to use them, and then get into
trouble.

     	      	      	   	      	   	 - Ted

[1] The issue with journal_async_commit is that it's possible (fairly
unlikely, but still possible) that the guarantees of data=ordered will
be violated.  If the data blocks that were written out while we are
resolving a delayed allocation writeback haven't made it all the way
down to the platter, it's possible for all of the journal writes and
the commit block to be reordered ahead of the data blocks.  In that
case, the checksum for the commit block would be valid, but some of
the data blocks might not have been written back to disk.
