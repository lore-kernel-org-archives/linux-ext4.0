From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Fri, 18 Sep 2009 15:25:05 GMT
Message-ID: <200909181525.n8IFP5lT006932@demeter.kernel.org>
References: <bug-13549-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40648 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbZIRPZB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 11:25:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8IFP5Mu006933
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 15:25:05 GMT
In-Reply-To: <bug-13549-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13549


Roland Kletzing <devzero@web.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |devzero@web.de




--- Comment #1 from Roland Kletzing <devzero@web.de>  2009-09-18 15:25:00 ---
this isn`t a drbd device (as that out of tree module seems to be loaded) - is
it ?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
