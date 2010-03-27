From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Sat, 27 Mar 2010 19:28:14 GMT
Message-ID: <201003271928.o2RJSEkl023053@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55502 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0C0T2P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 15:28:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2RJSE0O023054
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 27 Mar 2010 19:28:15 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




--- Comment #19 from Eric Sandeen <sandeen@redhat.com>  2010-03-27 19:28:11 ---
Alessandro, your image also has groups_per_flex == 1 so it is surely the same
thing.

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
