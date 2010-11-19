From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23232] kernel hang on insert ext4 usb key
Date: Fri, 19 Nov 2010 03:01:10 GMT
Message-ID: <201011190301.oAJ31AC1031668@demeter1.kernel.org>
References: <bug-23232-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47881 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0KSDBL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 22:01:11 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAJ31AF4031669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Nov 2010 03:01:10 GMT
In-Reply-To: <bug-23232-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23232


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu




--- Comment #1 from Theodore Tso <tytso@mit.edu>  2010-11-19 03:00:59 ---
Does it crash if you boot some earlier version of the kernel?

Can you send an image of the USB key?

It looks like it's dieing very early the VFS layer, in vfs_kern_mount.  It's
not clear it's called into ext4 code at all when it gives the oops message.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
