From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12821] filesystem corrupts on heavy I/O
Date: Fri,  6 Mar 2009 12:30:25 -0800 (PST)
Message-ID: <20090306203025.94793108042@picon.linux-foundation.org>
References: <bug-12821-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168AbZCFUar (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Mar 2009 15:30:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n26KUP6Z023700
	for <linux-ext4@vger.kernel.org>; Fri, 6 Mar 2009 12:30:26 -0800
In-Reply-To: <bug-12821-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12821





------- Comment #12 from sandeen@redhat.com  2009-03-06 12:30 -------
Created an attachment (id=20449)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20449&action=view)
stat of the problematic inode in (hacked) debugfs

This is for the ext4 devs as much as anything; it's a hacked stat <inode> of
the inode that generated the messages.

It does have 3 levels, which would be sufficient to enter the code that
generated the warning, due to what I believe is your bug.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
