From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12787] possible circular locking dependency
Date: Wed, 25 Mar 2009 16:14:10 GMT
Message-ID: <200903251614.n2PGEApd008075@demeter.kernel.org>
References: <bug-12787-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54928 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112AbZCYQOM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 12:14:12 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2PGEAC7008076
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2009 16:14:10 GMT
In-Reply-To: <bug-12787-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12787


Marko Kohtala <marko.kohtala@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|---                         |No




--- Comment #6 from Marko Kohtala <marko.kohtala@gmail.com>  2009-03-25 16:14:09 ---
The patch did not go into 2.6.28.8. The bug is still there.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
