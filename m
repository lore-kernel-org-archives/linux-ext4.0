From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12679] 2.6.28.4 ext4 fs hang, load 22 and up, may be
 firefox/apps stuck on sync_page
Date: Thu, 9 Apr 2009 15:09:50 GMT
Message-ID: <200904091509.n39F9ogj014575@demeter.kernel.org>
References: <bug-12679-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58684 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZDIPJw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 11:09:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n39F9olS014576
	for <linux-ext4@vger.kernel.org>; Thu, 9 Apr 2009 15:09:50 GMT
In-Reply-To: <bug-12679-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12679


daniel schroeder <sec@dschroeder.info> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE
         Regression|---                         |No




--- Comment #8 from daniel schroeder <sec@dschroeder.info>  2009-04-09 15:09:50 ---
seems to be fixed...mentioned patch is in 2.6.28.9...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
