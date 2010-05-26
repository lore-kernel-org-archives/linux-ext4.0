From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15906] performance regression in "umount" of filesystems using
 barriers
Date: Wed, 26 May 2010 16:44:45 GMT
Message-ID: <201005261644.o4QGijFc008347@demeter.kernel.org>
References: <bug-15906-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40041 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab0EZQoq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 May 2010 12:44:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4QGijih008348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 26 May 2010 16:44:45 GMT
In-Reply-To: <bug-15906-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15906


Brian Bloniarz <phunge0@hotmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |phunge0@hotmail.com




--- Comment #30 from Brian Bloniarz <phunge0@hotmail.com>  2010-05-26 16:44:37 ---
I'm trying to get these fixes merged into the ubuntu release, because ubuntu's
workaround has issues. The downstream bug for this is
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/585092

I backported to ubuntu's kernel, which took a little fixup. You'll find the
patches attached on that bug.
0001-writeback-fix-WB_SYNC_NONE-writeback-from-umount.patch
0002-writeback-Update-dirty-flags-in-two-steps.patch
0003-writeback-ensure-that-WB_SYNC_NONE-writeback-with-sb.patch

If anyone who's familiar with these code paths could review my backports, I'd
appreciate it.  They apply cleanly to mainline v2.6.32.11, which is the base
for ubuntu's kernel.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
