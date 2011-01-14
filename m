From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26642] Automatically clean dirty bit on
 ext2/ext4-without-journal file systems
Date: Fri, 14 Jan 2011 03:23:58 GMT
Message-ID: <201101140323.p0E3Nw83025882@demeter1.kernel.org>
References: <bug-26642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:49454 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1ANDX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jan 2011 22:23:59 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0E3NwDt025883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 14 Jan 2011 03:23:58 GMT
In-Reply-To: <bug-26642-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=26642





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2011-01-14 03:23:55 ---
I didn't think Val had any code that was anywhere near working.

As far as I know she never got around the design problem of what to do when you
have a big file where the inode is in group #1, but it needs blocks in block
groups #1, #2, #3, #4.... and what to do when you have a directory which has
directory blocks that spans multiple block groups.

She was going to design something complete new and incompatible from a format
perspective, that had bidirection pointers, but I don't think this ever got to
a working prototype stage as far as I know.  Feel free to ask her, though....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
