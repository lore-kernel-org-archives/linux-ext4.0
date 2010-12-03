From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 24282] linux/ext2_fs.h uses defines from linux/fs.h
Date: Fri, 3 Dec 2010 16:27:03 GMT
Message-ID: <201012031627.oB3GR3eO008477@demeter2.kernel.org>
References: <bug-24282-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:53418 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab0LCQ1F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Dec 2010 11:27:05 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oB3GR3eN008478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Dec 2010 16:27:04 GMT
In-Reply-To: <bug-24282-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=24282


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext2@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




--- Comment #4 from Eric Sandeen <sandeen@redhat.com>  2010-12-03 16:27:02 ---
I sent a patch upstream for this.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
