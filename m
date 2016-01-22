From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Fri, 22 Jan 2016 10:27:24 +0000
Message-ID: <bug-102731-13602-EqBrnOnyqM@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46406 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbcAVK12 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jan 2016 05:27:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D560320383
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2016 10:27:26 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 862C720384
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jan 2016 10:27:24 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=102731

--- Comment #34 from John Hughes <john@calva.com> ---
I first started seeing the problem when I moved the guest kernel to 3.16 
(i.e. started using the ext4 driver for my ext3 fileystems).

1. Host 3.16, Guest 3.16, 1G memory, filesystem goes readonly after 
around 4 days

Then I upgraded the guest to 3.18.19

2. Host 3.16 Guest 3.18.19, 1G memory, filesystem goes readonly after 
around 20 days

Then I upgraded the guest to 4.3.2

3. Host 3.16 Guest 4.3.2, 1G memory, filesystem goes readonly after 4 days

Then I upgraded the host to 4.3.2, noticed the guest had only 1G of 
memory (and the guest kernel was bitching about not having enough memory 
during some TCP operations) so I increased the guest memory to 2G,  Bad 
debugging style, but I was desperate.

4. Host 4.3.2, Guest 4.3.2, 2G memory, system ran for 90 days with no 
problem.

So now I've set the guest to 3.16 with 1G of memory.  We'll see what 
happens next.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
