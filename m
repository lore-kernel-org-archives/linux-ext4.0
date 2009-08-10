From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 15:58:55 GMT
Message-ID: <200908101558.n7AFwtii015719@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39467 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZHJP6y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 11:58:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7AFwtdL015720
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 15:58:55 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #17 from Rus <harbour@sfinx.od.ua>  2009-08-10 15:58:54 ---
The bug does not related to USB. I found this bug file md5sum'ing ordinary
local HDD file. The Roland Kletzing asked me few posts back to put this file on
USB - so I did this. My original regression report was and is :

Read access to any 3GB file on my local filesystem hangs the accessing process
forever - it is not killable.

This behaviour only found on 2.6.30.x kernels, particular on 2.6.30.4 which I'm
running. Booting the same hardware to 2.6.29.x eliminates the problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
