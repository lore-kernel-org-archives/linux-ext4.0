From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116471] Core in ext4 filesystem on a Dell Server
Date: Fri, 15 Apr 2016 21:48:14 +0000
Message-ID: <bug-116471-13602-J41892DPVB@https.bugzilla.kernel.org/>
References: <bug-116471-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33459 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcDOVsS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Apr 2016 17:48:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 35D1A20373
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2016 21:48:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3B3F72037C
	for <linux-ext4@vger.kernel.org>; Fri, 15 Apr 2016 21:48:16 +0000 (UTC)
In-Reply-To: <bug-116471-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=116471

Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com

--- Comment #1 from Eric Sandeen <sandeen@redhat.com> ---
First of all, this looks like a rebuilt centos kernel based on RHEL7.0 - i.e a
modified, old, distro kernel.  So upstream bugzilla may not be the best place
for it.

That said, this is down a do_coredump() path, hitting BUG_ON(irqs_disabled())

We've seen similar things on xfs, also down the do_coredump() path, in an
upstream 3.14 kernel (http://oss.sgi.com/archives/xfs/2014-02/msg00325.html).

That launched a long thread, and nobody seemed to come to an answer of why
interrupts were disabled at that point.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
