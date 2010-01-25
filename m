From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Mon, 25 Jan 2010 01:37:34 GMT
Message-ID: <201001250137.o0P1bYii032083@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51780 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0AYBhf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Jan 2010 20:37:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0P1bYmD032084
	for <linux-ext4@vger.kernel.org>; Mon, 25 Jan 2010 01:37:34 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #42 from carlos.velasco@nimastelecom.com  2010-01-25 01:37:33 ---
Same problem using 2.6.33-rc5 with the patch.

Unmounting all other currently mounted file systems...
umount: /: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))

I don't know why but this only happens with the patch applied.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
