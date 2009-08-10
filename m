From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 13:33:34 GMT
Message-ID: <200908101333.n7ADXY0c021383@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60006 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbZHJNdd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 09:33:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7ADXYBa021384
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 13:33:34 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #11 from Rus <harbour@sfinx.od.ua>  2009-08-10 13:33:32 ---
Yes, you are right - the fs is ext4. Checked on USB connected harddrive (WD
Raptor RAID Edition) :

reiserfs - fail
ext2 - fail
ext3 - fail
ntfs (ntfs-3g 1.5130) - fail

What is good, that after disconnecting USB HDD, in several minutes - dd exits
on I/O error, so hang is occured only while USB HDD is connected.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
