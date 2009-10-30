From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 30 Oct 2009 10:26:32 GMT
Message-ID: <200910301026.n9UAQWZh011499@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55416 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbZJ3K01 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Oct 2009 06:26:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9UAQW0N011502
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2009 10:26:32 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354


Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aneesh.kumar@linux.vnet.ibm
                   |                            |.com




--- Comment #153 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-10-30 10:26:23 ---
Hi Linus, Eric,

There are two changes that went in after 2.6.31 that i am doubtful.

0d34ec62e18984ac9476208660372306ef54e70d

That changes the ext4_file_write to not do a journal commit if inode doesn't
have dirty flag set. Jan Kara actually found other issues with the ext4 sync
code path and have posted a patch here( MID
1256647729-29834-1-git-send-email-jack@suse.cz )
http://article.gmane.org/gmane.comp.file-systems.ext4/16126. But that should
not result in multiple claimed blocks. 


487caeef9fc08c0565e082c40a8aaf58dad92bbb
The changes allowed to release i_data_sem during truncate. That implies we
could allow block allocation while we are doing truncate. I did a patch to drop
prealloc space once we reacquire i_data_sem. Posted in comment 123 of this bug.
But that didn't fix the corruption.

So may be we want to test backing out 487caeef9fc08c0565e082c40a8aaf58dad92bbb
and applying patch at
http://article.gmane.org/gmane.comp.file-systems.ext4/16126 and see if we are
able to reproduce.

-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
