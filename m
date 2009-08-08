From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Sat, 8 Aug 2009 19:54:50 GMT
Message-ID: <200908081954.n78JsoQt025264@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54681 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZHHTyu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2009 15:54:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n78JsovI025265
	for <linux-ext4@vger.kernel.org>; Sat, 8 Aug 2009 19:54:50 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #8 from Eric Sandeen <sandeen@redhat.com>  2009-08-08 19:54:49 ---
Does just the md5sum/dd hang or the whole system?  If you can, run ps and see
what state is the dd and/or md5sum in.  If it's in "D" state try 

# echo w > /proc/sysrq-trigger

and see what shows up in dmesg.  This dumps processes in wait state.

Otherwise

# echo t > /proc/sysrq-trigger

will dump all processes.

give that a shot & attach the resulting dmesg.

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
