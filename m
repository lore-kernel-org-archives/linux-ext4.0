From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13598] FIEMAP related circular locking dependency detected
Date: Mon, 8 Mar 2010 18:19:20 GMT
Message-ID: <201003081819.o28IJK8N015233@demeter.kernel.org>
References: <bug-13598-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54969 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0CHSTV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 13:19:21 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o28IJK1d015234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 8 Mar 2010 18:19:20 GMT
In-Reply-To: <bug-13598-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13598


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2010-03-08 18:19:17 ---
Assigning to myself just so I can close it; Aneesh looked and this was fixed
by:

From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 10 Dec 2009 02:30:02 +0000 (-0500)
Subject: ext4: Fix potential fiemap deadlock (mmap_sem vs. i_data_sem)
X-Git-Tag: v2.6.33-rc1~330^2
X-Git-Url:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=fab3a549e204172236779f502eccb4f9bf0dc87d

ext4: Fix potential fiemap deadlock (mmap_sem vs. i_data_sem)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
