From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 22 Jan 2016 15:20:01 +0000
Message-ID: <bug-102731-13602-EzcKX9W3L5@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35472 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbcAVPUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2016 10:20:09 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AEB462039E
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2016 15:20:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8327620461
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2016 15:20:01 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #35 from cwseys@physics.wisc.edu ---
Thanks!
I think you mistyped 4.2.3 -> 4.3.2 .

Here's the table (helps me see any pattern b/c it is closer together.  Less 
memory required. :) )

Hversion    Gversion  Gmem  time before read-only
3.16        3.16      1 GB  ~4 days
3.16        3.18.19   1 GB  ~20 days
3.16        4.2.3     1 GB  4 days
4.2.3       4.2.3     2 GB  not after ~90 days
4.2.3       3.16      1 GB  inprogress


> Then I upgraded the host to 4.3.2, noticed the guest had only 1G of
> memory (and the guest kernel was bitching about not having enough memory
> during some TCP operations) so I increased the guest memory to 2G,  Bad
> debugging style, but I was desperate.

Debugging and production don't get along well together. :)

> So now I've set the guest to 3.16 with 1G of memory.  We'll see what
> happens next.

I haven't tried changing the host's kernel version yet. Will be interested to 
know how it turns out!  Thanks for debugging and hopefully you'll help us 
(Debian/Ubuntu users) find a workaround at least.

Thanks again,
Chad.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
