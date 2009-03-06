From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12829] kernel complains on ENOSPC
Date: Fri,  6 Mar 2009 15:28:45 -0800 (PST)
Message-ID: <20090306232845.B9E3210800D@picon.linux-foundation.org>
References: <bug-12829-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573AbZCFX3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 18:29:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n26NSkul003396
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 15:28:47 -0800
In-Reply-To: <bug-12829-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12829





------- Comment #2 from sandeen@redhat.com  2009-03-06 15:28 -------
It's a series of big files, just doing cp avi foo/* /mnt/ext4fs/bar

It's a user e2image, so won't share the exact fs but will come up w/ a
reproducer.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
