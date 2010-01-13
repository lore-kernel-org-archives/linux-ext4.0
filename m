From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12815] JBD: barrier-based sync failed on dm-1:8 - disabling
 barriers  -- and then hang
Date: Wed, 13 Jan 2010 21:15:29 GMT
Message-ID: <201001132115.o0DLFTS8004630@demeter.kernel.org>
References: <bug-12815-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51604 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0AMVP3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 16:15:29 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0DLFTKj004632
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 21:15:29 GMT
In-Reply-To: <bug-12815-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12815


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
