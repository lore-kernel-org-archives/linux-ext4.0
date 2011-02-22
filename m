From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29402] kernel panics while running ffsb scalability workloads
 on 2.6.38-rc1 through -rc5
Date: Tue, 22 Feb 2011 13:43:25 GMT
Message-ID: <201102221343.p1MDhPri028681@demeter2.kernel.org>
References: <bug-29402-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:46618 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1BVNnZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 08:43:25 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p1MDhPJ9028682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Feb 2011 13:43:25 GMT
In-Reply-To: <bug-29402-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29402


Lukas Czerner <lczerner@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lczerner@redhat.com




--- Comment #6 from Lukas Czerner <lczerner@redhat.com>  2011-02-22 13:43:24 ---
Hi Eric,

it might be just a shot in the dark, but would you be willing to try out this
patch ? Unfortunately I do not currently have a machine to reproduce the
problem.

I *think* that the problem is in the block layer (bio_batch_end_io() and
blkdev_issue_zeroout() to be specific) and since lazy init is using that to do
the zeroing we can not hit it with lazy init turned off.

Now, the problem I see is that when we are going to wait_for_completion() in
blkdev_issue_discard() we check if the bb.done equals issued (number of issued
bios). If it equals, we can skip the wait_for_completion() and jump out of the
function since there is nothing to wait for. However, there is a ordering
problem because bio_batch_end_io() is calling atomic_inc(&bb->done) before
complete(), hence it might seem to blkdev_issue_zeroout() that all bios has
been completed and exit. At this point when bio_batch_end_io() is going to call
complete(bb->wait) bb does not longer exist since it was declared locally in
blkdev_issue_zeroout() ==> panic while trying to acquire wait.lock!

(thread 1)                         (thread 2)
bio_batch_end_io()                 blkdev_issue_zeroout()
  if(bb) {                         ...
    if (bb->end_io)                ...
      bb->end_io(bio, err);        ...
    atomic_inc(&bb->done);         ...
    ...                            while (issued != atomic_read(&bb.done))
    ...                            (let issued == bb.done)
    ...                            (do the rest of the function)
    ...                            return ret;
    complete(bb->wait);
    ^^^^^^^^
Panic in complete() while trying to acquire spinlock.

I hope it is not complete nonsense :).Please let me know whether the patch
helps.

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
