From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Tue, 17 Nov 2009 22:26:24 GMT
Message-ID: <200911172226.nAHMQOfN026252@demeter.kernel.org>
References: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45174 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbZKQW0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Nov 2009 17:26:18 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAHMQOfh026253
	for <linux-ext4@vger.kernel.org>; Tue, 17 Nov 2009 22:26:24 GMT
In-Reply-To: <bug-14562-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14562


Francis Russell <francis+lkbt@unchartedbackwaters.co.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
  Attachment #23817|Warning from syslog         |Warning from syslog (the
        description|                            |pasted version didn't
                   |                            |format well).




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
