From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Sun, 3 Apr 2011 09:48:35 GMT
Message-ID: <201104030948.p339mZre018230@demeter1.kernel.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:47313 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1DCJsg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 3 Apr 2011 05:48:36 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p339mZUI018231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 3 Apr 2011 09:48:35 GMT
In-Reply-To: <bug-32482-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32482


Tom <egokillsall@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #9 from Tom <egokillsall@gmail.com>  2011-04-03 09:48:32 ---
Thanks Ted, it was purged by e2fsprogs 1.41.14-1 from Debian experimental. The
rare stuff 'just did read a file but it contains something else now' is still
up, but this is another thing, however I'm sure now it was the cause of all the
fs errors. I'll try and tweak with hdparm and module options (if any) to get to
some more compatible controlling level.
Case closed, thanx a lot!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
