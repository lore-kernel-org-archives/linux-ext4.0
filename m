From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Mon, 15 Mar 2010 19:35:27 GMT
Message-ID: <201003151935.o2FJZREr003192@demeter.kernel.org>
References: <bug-13549-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59970 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0COTf3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 15:35:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2FJZRte003193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Mar 2010 19:35:27 GMT
In-Reply-To: <bug-13549-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13549


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2010-03-15 19:34:54 ---
Alessandro, apologies for this bug sitting for so long.

Is this still something you can reproduce?

If so, an e2image -h of the original filesystem, and the size of the block
device you're resizing to, might help us reproduce the problem.

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
