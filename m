From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Fri, 27 Feb 2009 09:15:44 -0800 (PST)
Message-ID: <20090227171544.AF4D011D108@picon.linux-foundation.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbZB0RQe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2009 12:16:34 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RHFirv019030
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 09:15:45 -0800
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787





------- Comment #2 from marko.kohtala@gmail.com  2009-02-27 09:15 -------
Created an attachment (id=20382)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20382&action=view)
Kernel log


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
