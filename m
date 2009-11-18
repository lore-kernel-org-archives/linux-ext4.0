From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14452] Syscall to ftruncate hangs on ext4 + mdadm raid0
 filesystem on a file preallocated with fallocate
Date: Wed, 18 Nov 2009 09:54:46 GMT
Message-ID: <200911180954.nAI9sjNH015567@demeter.kernel.org>
References: <bug-14452-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56178 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZKRJyj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Nov 2009 04:54:39 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAI9skfE015568
	for <linux-ext4@vger.kernel.org>; Wed, 18 Nov 2009 09:54:46 GMT
In-Reply-To: <bug-14452-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14452


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #5 from Jan Kara <jack@suse.cz>  2009-11-18 09:54:42 ---
No, reply for two weeks. Assuming the things got fixed. Closing the bug.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
