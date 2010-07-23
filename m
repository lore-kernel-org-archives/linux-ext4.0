From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Fri, 23 Jul 2010 15:30:50 GMT
Message-ID: <201007231530.o6NFUog0031122@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34858 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760628Ab0GWPaw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 11:30:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6NFUoCb031126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 23 Jul 2010 15:30:51 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |axboe@kernel.dk,
                   |                            |jack@suse.cz




--- Comment #3 from Jan Kara <jack@suse.cz>  2010-07-23 15:30:50 ---
I was looking into this. A trivial reproducer is:
mknod devzero c 1 5; touch devzero

Essentially, the problem is that any device inode can get dirty because of time
stamp update or similar reason but some BDIs (in this case the one backing
/dev/zero) do not expect dirty inodes. Hmm, I now have to think how to fix
this... It would be more natural if device inodes were queued for metadata
updates in the queues of "parent" filesystem. But this brings problem that
device inode would need to be in two queues - one for metadata update to the
parent filesystem and one for data writeout to the device (this is not exactly
the case of /dev/zero but if you have a device node for /dev/sdb on /dev/sda,
then this is exactly what we would need).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
