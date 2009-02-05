From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Thu,  5 Feb 2009 08:30:39 -0800 (PST)
Message-ID: <20090205163039.3459A108048@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbZBEQbB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 11:31:01 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n15GUdfX020602
	for <linux-ext4@vger.kernel.org>; Thu, 5 Feb 2009 08:30:40 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #10 from jack@suse.cz  2009-02-05 08:30 -------
Created an attachment (id=20124)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20124&action=view)
Fix for the bug in ext4_write_begin and ext4_da_write_begin

This patch should fix the problem. Testing welcome ;)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
