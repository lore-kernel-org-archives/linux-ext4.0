From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Tue, 18 Aug 2009 17:38:25 GMT
Message-ID: <200908181738.n7IHcPRC002624@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55585 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbZHRRiX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2009 13:38:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7IHcPMU002625
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2009 17:38:25 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




--- Comment #17 from Eric Sandeen <sandeen@redhat.com>  2009-08-18 17:38:22 ---
Assigning to myself just so I can close.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
