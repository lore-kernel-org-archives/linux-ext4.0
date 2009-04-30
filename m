From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12151] Unexplained fsck errors on a ext4 filesystem
Date: Thu, 30 Apr 2009 09:10:42 GMT
Message-ID: <200904300910.n3U9AgV0000783@demeter.kernel.org>
References: <bug-12151-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36700 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761779AbZD3JKn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Apr 2009 05:10:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3U9Agw4000784
	for <linux-ext4@vger.kernel.org>; Thu, 30 Apr 2009 09:10:42 GMT
In-Reply-To: <bug-12151-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12151


Florian Engelhardt <flo@dotbox.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |flo@dotbox.org




--- Comment #6 from Florian Engelhardt <flo@dotbox.org>  2009-04-30 09:10:41 ---
Same problem here with 2.6.29.2
I have tried ext4 on a linux software raid 0, it was working flawlessly for
about a week. I booted the computer yesterday and hat exactly the same errors
as described above. Running e2fsck from a archlinux bootstick took about one
hour and left me with a mountable, but free of every kind of directory
structur, ext4 filesystem.
I am running that raid 0 on two 500GB Sata Disks. I can provide you with more
information on that this evening.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
