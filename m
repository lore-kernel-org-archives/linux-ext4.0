From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13930] non-contiguous files (64.9%) on a ext4 fs
Date: Mon, 19 Oct 2009 05:55:33 GMT
Message-ID: <200910190555.n9J5tX78010457@demeter.kernel.org>
References: <bug-13930-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38271 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZJSFz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Oct 2009 01:55:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9J5tXUY010459
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2009 05:55:33 GMT
In-Reply-To: <bug-13930-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13930


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
     Kernel Version|Linux version 2.6.31-rc5    |2.6.31-5(deb)
                   |(logik@LogikPC) (gcc        |
                   |version 4.3.3 (Debian       |
                   |4.3.3-15) ) #1 SMP PREEMPT  |
                   |Sat Aug 1 19:52:55 CEST     |
                   |2009                        |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
