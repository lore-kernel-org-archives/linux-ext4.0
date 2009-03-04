From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling barriers  -- and then hang
Date: Tue,  3 Mar 2009 21:29:29 -0800 (PST)
Message-ID: <20090304052929.B114D10800D@picon.linux-foundation.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750719AbZCDFaB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Mar 2009 00:30:01 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n245TT32001535
	for <linux-ext4@vger.kernel.org>; Tue, 3 Mar 2009 21:29:30 -0800
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815





------- Comment #1 from sandeen@redhat.com  2009-03-03 21:29 -------
ext4 has barriers on by default, so you'll see the disabling barriers message
on lvm every time you mount (it does not support barriers).

if you'd like to rule that out, mount with -o barrier=0

When you're hung, try echo w > /proc/sysrq-trigger (or SysRq-W) to get a list
of sleeping processes.

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
