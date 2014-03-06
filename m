From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70121] Increasing efficiency of full data journaling
Date: Thu, 06 Mar 2014 15:34:46 +0000
Message-ID: <bug-70121-13602-ZcQ55DUsoH@https.bugzilla.kernel.org/>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56391 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbaCFPeu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 10:34:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 73D50201F4
	for <linux-ext4@vger.kernel.org>; Thu,  6 Mar 2014 15:34:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9A3052026C
	for <linux-ext4@vger.kernel.org>; Thu,  6 Mar 2014 15:34:46 +0000 (UTC)
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=70121

--- Comment #5 from Theodore Tso <tytso@mit.edu> ---
On Thu, Feb 06, 2014 at 10:38:04AM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> 
> Here comes the idea: From a logical view to achieve this safety it is not
> needed to write the file 2 times. A simple committing should achieve the same
> level of safety. Here is an example: The filesystem could store a value for the
> file which is reflecting its state. It is initialized as empty value indicating
> the file has not successfully be written. As soon as the file has been written
> it is set to 1. This would avoid writing the file 2 times and still guarantee
> that the file will never be visible for te user in a damaged state on a crash
> as the filesystem check would see that the file state is unequal to 1 and
> correct the problem.

How does the file system know that the file has "successfully been
written"?  Secondly, even if we did know, in order to guarantee the
transaction semantics, we *always* update the journal first.  Only
after the journals is updated, do we write back to the final location
on disk.  So what you are suggesting just simply wouldn't work.

> ~2 years ago I have disabled full data journaling for a short time but at this
> point an application crashed while it was writing a lot of files. The result
> was that many files got damaged which encouraged me to never disable full data
> journaling again. Now I'm seeing only 2 possible states of a file: Either it is
> only registered in the filesystem with a size of 0 bytes or it is completely
> written. I was never able to reproduce a half-written file with full data
> journaling enabled.

You have a buggy application which isn't using fsync() where it
should.  If you can't fix the application, one thing you can do is to
enable use the nodelalloc mount option.  Although disabling delayed
allocation will involve a performance hit, it's much less of a
performance hit compared to data journalling, and it will avoid the
double write problem.

One of the reasons why I'm not particularly fond of this solution is
that, beyond not guaranteeing data integrity after a crash (it just
makes it more likely, but if you crash at the wrong moment, you can
still lose data --- this is true with data journalling too, btw; if
you haven't seen it, you've just gotten lucky), and beyond the fact
that it imposes a generic performance, it imposes a specific
performance penalty against applications which actually do the correct
thing and use fsync().

One of the unfortunate features of ext3, which also didn't have
delayed allocation (and ext4 with nodelalloc basically reverts this
aspect of file system behaviour to ext3 levels), is that it encouraged
applications not to use fsync(), which is a "works most of the time
until it doesn't", which is probably _why_ you have the buggy
application or applications.  But in the long run, it's better to fix
the buggy applications than to rely on nodelalloc.

Cheers,

                        - Ted

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
