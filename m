From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14286] kernel BUG at fs/ext4/extents.c:2863
Date: Mon, 14 Dec 2009 15:39:35 GMT
Message-ID: <200912141539.nBEFdZjq017464@demeter.kernel.org>
References: <bug-14286-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52988 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZLNPjf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Dec 2009 10:39:35 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nBEFdZOL017465
	for <linux-ext4@vger.kernel.org>; Mon, 14 Dec 2009 15:39:35 GMT
In-Reply-To: <bug-14286-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14286


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |ASSIGNED
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |tytso@mit.edu
                   |g                           |




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2009-12-14 15:39:32 ---
Created an attachment (id=24181)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24181)
Patch to fix this problem

Surbhi Palande has supplied the following patch to address this issue

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
