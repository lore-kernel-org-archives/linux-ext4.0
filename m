From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Thu, 28 Jan 2010 17:23:56 GMT
Message-ID: <201001281723.o0SHNuTI027423@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35374 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0A1RX5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jan 2010 12:23:57 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0SHNuHl027424
	for <linux-ext4@vger.kernel.org>; Thu, 28 Jan 2010 17:23:56 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #46 from carlos.velasco@nimastelecom.com  2010-01-28 17:23:55 ---
Created an attachment (id=24757)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24757)
lsof before umount in a reboor without busy error

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
