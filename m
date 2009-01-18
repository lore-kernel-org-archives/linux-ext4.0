From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Sun, 18 Jan 2009 15:39:05 -0800 (PST)
Message-ID: <20090118233905.B7B9310800F@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbZARXjf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 18:39:35 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0INd5d5010913
	for <linux-ext4@vger.kernel.org>; Sun, 18 Jan 2009 15:39:06 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #4 from vedranf@vedranf.mine.nu  2009-01-18 15:39 -------
Sure, I'm waiting for 2.6.28 to enter debian so I can test. I have 1.7GB of
memory, of that more than 1GB is free (excluding cache). All other filesystems
are ext3 including the source (ext3->ext4). Quota is enabled but not set for
any user. I disabled it (init.d/quota stop) and tried writing (ext3->ext4)
again and oops didn't happen. Will test more, but this could be the issue. What
I don't understand is why it doesn't happen when I'm writing to ext3.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
