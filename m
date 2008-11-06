From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11688] Oops while writing on a newly ext4 formated 1TB partition on a external USB drive
Date: Thu,  6 Nov 2008 12:27:45 -0800 (PST)
Message-ID: <20081106202745.60C2B108043@picon.linux-foundation.org>
References: <bug-11688-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYKFU2O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 15:28:14 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA6KRjGN001376
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 12:27:46 -0800
In-Reply-To: <bug-11688-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=11688





------- Comment #2 from tytso@mit.edu  2008-11-06 12:27 -------
Can you replicate this on a newer kernel?  This looks like a failure in
ext3/jbd code, actually, triggered when the kernel was trying to free pages to
get back some memory.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
