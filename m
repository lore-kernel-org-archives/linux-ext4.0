From: Andreas Dilger <adilger@sun.com>
Subject: Re: What to do when the journal checksum is incorrect
Date: Sun, 25 May 2008 00:30:24 -0600
Message-ID: <20080525063024.GG3516@webber.adilger.int>
References: <E1K02Jh-0002wf-2e@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39760 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYEYGa2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 25 May 2008 02:30:28 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4P6UR0x005645
	for <linux-ext4@vger.kernel.org>; Sat, 24 May 2008 23:30:27 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1E00801UUBB100@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 24 May 2008 23:30:27 -0700 (PDT)
In-reply-to: <E1K02Jh-0002wf-2e@closure.thunk.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 24, 2008  18:34 -0400, Theodore Ts'o wrote:
> Suppose the journal has five commits, with transaction ID's 2, 3, 4, 5,
> and 6.  And suppose the CRC in the commit block delineating the end of
> transaction #4 is bad.  At the moment, due to a bug in the code, it
> stops processing at transaction #4, meaning that transactions #2, #3,
> and #4 are replayed into the filesystem --- even though transaction #4
> failed the CRC checksum.  Worse yet, no indication of any problems is
> sent back to the ext4 filesystem code.

I agree it is a bug that transaction #4 with the bad checksum would be
replayed, but I thought there was supposed to be an error returned in
case of the bad checksum not being in the last transaction?

> Even far worse, though, is that the filesystem is now in a potentially
> very compromised state.  Stopping the journal replay after transaction
> #3 is no better, because the rest of the filesystem may had changes made
> to it since then which would have been overwritten by replaying
> only transactions #2 and #3.

This is true, but I don't agree with the conculsion you draw from it.

> So I think the right thing to do is to replay the *entire* journal,
> including the commits with the failed checksums (except in the case
> where journal_async_commit is enabled and the last commit has a bad
> checksum, in which case we skip the last transaction).  By replaying the
> entire journal, we don't lose any of the revoke blocks, which is
> critical in making sure we don't overwrite any data blocks, and
> replaying subsequent metadata blocks will probably leave us in a much
> better position for e2fsck to be able to recover the filesystem.

I don't agree with this at all.  With the exception of the checksum
error being in the last transaction, there is a danger of complete
garbage being checkpointed into the filesystem if the checksum is bad.
The alternative to not replay the rest of the transactions at worst
has some probability that newer versions of the blocks were checkpointed
into the filesystem before it crashed.

You are proposing that we write some blocks which we know to be garbage
directly into the filesystem metadata instead of leaving some unordered
writes in the filesystem to be fixed (as happens with ext2 all of the time).

> But if there are any non-terminal commits that have bad checksums, we
> need to pass a flag back to the filesystem, and have the filesystem call
> ext4_error() indicating that the journal was corrupt; this will mark the
> filesystem has containing errors, and use the filesystem policy to
> decide whether to remount the filesystem read-only, continue, or panic.
> Then e2fsck at boot time can try to sort out the mess.

Yes, that is definitely the right approach, and I thought that was the
case.  It's been a while since I looked at the code.

> If e2fsck is replaying the journal, it will do the same thing; play it
> back despite the checksum errors, and then force a full check of the
> filesystem since it is quite likely corrupted as a result.
> 
> Does this make sense?  It's the direction I plan to go in terms of
> making changes to the kernel and the e2fsck's recovery code, so please
> let me know if you disagree with this strategy.

I do disagree.  The whole point of this patch was to avoid the case where
random garbage had been written into the journal and then splattering it
all over the filesystem.  Considering that the journal has the highest
density of important metadata in the filesystem, it is virtually impossible
to get more serious corruption than in the journal.

PS - note new email addresses

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

