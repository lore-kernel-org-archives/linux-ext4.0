From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13874] kenal panic on addition of xfx nvidia gts250 512mb on
 946giz motherboard
Date: Tue, 4 Aug 2009 17:05:18 GMT
Message-ID: <200908041705.n74H5I39019842@demeter.kernel.org>
References: <bug-13874-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54816 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbZHDRFR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 13:05:17 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n74H5IjS019843
	for <linux-ext4@vger.kernel.org>; Tue, 4 Aug 2009 17:05:18 GMT
In-Reply-To: <bug-13874-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13874


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|i386                        |ext3
         AssignedTo|platform_i386@kernel-bugs.o |fs_ext3@kernel-bugs.osdl.or
                   |sdl.org                     |g
            Product|Platform Specific/Hardware  |File System




--- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2009-08-04 17:05:17 ---
OK, thanks.  Pause the video at 0:30 and one sees an oops in
ext3_handle_error().

I'll reassign the report.

I expect 2.6.30 will do the same thing :(

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
