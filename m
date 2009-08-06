From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13874] kenal panic on addition of xfx nvidia gts250 512mb on
 946giz motherboard
Date: Thu, 6 Aug 2009 23:25:37 GMT
Message-ID: <200908062325.n76NPbAp005496@demeter.kernel.org>
References: <bug-13874-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59356 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZHFXZg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 19:25:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n76NPbeV005497
	for <linux-ext4@vger.kernel.org>; Thu, 6 Aug 2009 23:25:37 GMT
In-Reply-To: <bug-13874-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13874


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|ext3                        |x86-64
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |platform_x86_64@kernel-bugs
                   |g                           |.osdl.org
            Product|File System                 |Platform Specific/Hardware




--- Comment #8 from Andrew Morton <akpm@linux-foundation.org>  2009-08-06 23:25:35 ---
I don't know where to reassign it, really.  Where's the bug?

A can randomly punt it in the x86_64 direction, but I suspect the hardware is
broken.

Does _any_ version of the linux kernel run properly on that particular machine?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
