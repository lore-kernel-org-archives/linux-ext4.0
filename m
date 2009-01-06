From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12370] kernel BUG at fs/jbd2/journal.c:1108
Date: Tue,  6 Jan 2009 03:15:38 -0800 (PST)
Message-ID: <20090106111538.8A89F10800F@picon.linux-foundation.org>
References: <bug-12370-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbZAFLQL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 06:16:11 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06BFcnV024453
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 03:15:39 -0800
In-Reply-To: <bug-12370-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12370





------- Comment #1 from dmaciejak@fortinet.com  2009-01-06 03:15 -------
Created an attachment (id=19673)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19673&action=view)
img poc


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
