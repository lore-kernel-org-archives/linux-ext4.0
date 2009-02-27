From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Fri, 27 Feb 2009 09:16:56 -0800 (PST)
Message-ID: <20090227171656.9C7F211D108@picon.linux-foundation.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367AbZB0RRs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Feb 2009 12:17:48 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1RHGubs019175
	for <linux-ext4@vger.kernel.org>; Fri, 27 Feb 2009 09:16:57 -0800
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787


marko.kohtala@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #20381|application/octet-stream    |text/plain
          mime type|                            |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
