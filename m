From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62751] INFO: rcu_sched detected stalls on CPUs/tasks: { 3}
 (detected by 2, t=15107 jiffies, g=270766, c=270765, q=0)
Date: Fri, 20 Dec 2013 16:16:22 +0000
Message-ID: <bug-62751-13602-Z4tbHAqgYG@https.bugzilla.kernel.org/>
References: <bug-62751-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52030 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab3LTQQ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Dec 2013 11:16:26 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D033E206F3
	for <linux-ext4@vger.kernel.org>; Fri, 20 Dec 2013 16:16:24 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 95B0B206EC
	for <linux-ext4@vger.kernel.org>; Fri, 20 Dec 2013 16:16:23 +0000 (UTC)
In-Reply-To: <bug-62751-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=62751

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #12 from Theodore Tso <tytso@mit.edu> ---
Hi Louis,

Can you talk a bit about your workload?   What sort of applications are you
running on the file system which is having the problems?   A database?  Squid
cache, something else?   Is it a lot of random writes?    What sort of files
does it create?  Does it create and delete a lot of files?   Etc.

It looks like your system has 8GB of memory --- is that right?   How much free
memory does your machine normally has?   Also, if you still have your ext4 file
system image, could you run "e2freefrag -v /dev/mapper/XXX"?

Many thanks!!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
