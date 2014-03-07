From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 70121] Increasing efficiency of full data journaling
Date: Fri, 7 Mar 2014 08:48:37 -0500
Message-ID: <20140307134837.GA13249@thunk.org>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
 <bug-70121-13602-LhyKKCgh7t@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38391 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaCGNsl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 08:48:41 -0500
Content-Disposition: inline
In-Reply-To: <bug-70121-13602-LhyKKCgh7t@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2014 at 07:16:40AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > How does the file system know that the file has "successfully been
> > written"?  Secondly, even if we did know, in order to guarantee the
> > transaction semantics, we *always* update the journal first.  Only
> > after the journals is updated, do we write back to the final location
> > on disk.  So what you are suggesting just simply wouldn't work.
> 
> It seems it is just a too major change. Maybe it is something that could be
> considered in ext5.

If you think it can be done, plesae submit patches.  :-)

> > it just
> > makes it more likely, but if you crash at the wrong moment, you can
> > still lose data
> 
> 
> I have never seen a damaged file with full data journaling enabled. Can you
> show me a race condition so that I can reproduce it? Hm, maybe it would be
> possible if the journal is smaller than the file (I'm wondering what would
> happen in such a case).

If the application is in the middle of writing the file when the
journal is committing, the file can be half written at the point where
the system is rebooted.  If you are thinking about the case where the
application writes to a temp file, and then renames the temp file on
top of the pre-existing file (without first fsync'ing the temp file,
which is the application bug), then yes, data journalling will save
you from that one particular use case, but it will come at a cost.
(And if you crash while you are writing the temp file, of course you
do lose your pending changes.)  You can get the same level of
protection by using mount -o nodelalloc instead of mount -o
data=journal.

As I said before, you'll give up some performance, but it won't be as
bad as using data=journal --- and you should still file bug reports
with your applications so they use fsync() properly.  I'll note that
if they don't, you'll have problems with all other file systems,
whether they be xfs, btrfs, etc.  Fsync(2) is the *only* way you can
guarantee that the contents of a file which has been written is safely
on stable store.

							- Ted
