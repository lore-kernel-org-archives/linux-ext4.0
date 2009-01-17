From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Fri, 16 Jan 2009 18:23:09 -0800 (PST)
Message-ID: <20090117022309.2BC92108040@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630AbZAQCXk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Jan 2009 21:23:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0H2N9DH029480
	for <linux-ext4@vger.kernel.org>; Fri, 16 Jan 2009 18:23:10 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #12 from tytso@mit.edu  2009-01-16 18:23 -------
It's still not clear to me what you do to trigger the corruption.  What
modules, specifically, are you removing and inserting?   Can you narrow it down
to a single module?

The messages

[  487.377387] bio too big device hda5 (8 > 0)
[  487.377860] bio too big device hda5 (8 > 0)

... indicates that the block queue data structure has gotten corrupted (since
queue->max_hw_sectors should never be zero).   Bottom line is it sounds like
*some* module is causing random memory corruption, leading to the kernel
malfunctioning.   The bottom line is figuring out which kernel module or
modules are involved.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
