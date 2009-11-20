From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14619] ext3/jbd oops in journal_start
Date: Fri, 20 Nov 2009 15:19:40 GMT
Message-ID: <200911201519.nAKFJeX6021908@demeter.kernel.org>
References: <bug-14619-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47098 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZKTPTd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Nov 2009 10:19:33 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAKFJeZI021909
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2009 15:19:40 GMT
In-Reply-To: <bug-14619-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14619


Chris Mason <chris.mason@oracle.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |chris.mason@oracle.com
                   |g                           |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
