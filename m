From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Fri, 30 Apr 2010 06:02:41 GMT
Message-ID: <201004300602.o3U62flp017987@demeter.kernel.org>
References: <bug-14830-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab0D3RbJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 13:31:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3U62f7B017988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 30 Apr 2010 06:02:41 GMT
In-Reply-To: <bug-14830-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=14830





--- Comment #38 from Michael Godfrey <godfrey@isl.stanford.edu>  2010-04-30 06:02:32 ---
Just a couple of comments on the posts above:

1. In our environment, home directories are NFS mounted,
   so vi cannot read .vimrc.  It appears that this is where
   it hangs.  The important thing is that nothing
   appears on the user's screen after typing vi. 

2. We do not have an XFS filesystem, so I cannot comment on
   whether these problems exist for XFS.

3. The comments indicate that, as usual, there is more than
   one problem.  I am hopeful that the ext4 problem that Eric
   Sandeen is fixing and proposed fixes for sync will make
   a significant difference.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
