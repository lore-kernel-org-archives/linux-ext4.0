From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] Increasing efficiency of full data journaling
Date: Fri, 07 Mar 2014 13:48:49 +0000
Message-ID: <bug-70121-13602-6qocIAkhML@https.bugzilla.kernel.org/>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40881 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaCGNsv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2014 08:48:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ADE2320306
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 13:48:50 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A169E202F0
	for <linux-ext4@vger.kernel.org>; Fri,  7 Mar 2014 13:48:49 +0000 (UTC)
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

--- Comment #7 from Theodore Tso <tytso@mit.edu> ---
On Fri, Mar 07, 2014 at 07:16:40AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
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

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
