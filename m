From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 86681] INFO: task nfsd:16901 blocked for more than 120 seconds.
 ; NFSD: Failed to remove expired client state directory
Date: Wed, 22 Oct 2014 18:21:07 +0000
Message-ID: <bug-86681-13602-FUcqxpMZbO@https.bugzilla.kernel.org/>
References: <bug-86681-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35270 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaJVSVK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2014 14:21:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DC18020265
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2014 18:21:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C767920259
	for <linux-ext4@vger.kernel.org>; Wed, 22 Oct 2014 18:21:08 +0000 (UTC)
In-Reply-To: <bug-86681-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=86681

bfields@fieldses.org changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|NFS                         |ext4
           Assignee|bfields@fieldses.org        |fs_ext4@kernel-bugs.osdl.or
                   |                            |g

--- Comment #2 from bfields@fieldses.org ---
Yes, the first backtraces there all show an nfsd IO operation waiting in ext4. 
Some later backtraces show waiting on the state lock but that could easily be a
consequence.  Assuming for now it's an ext4/jbd problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
