From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Fri, 6 Aug 2010 06:32:08 GMT
Message-ID: <201008060632.o766W8Ao020084@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54138 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab0HFGcK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 02:32:10 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o766W8YN020086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 06:32:09 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312


Tejun Heo <tj@kernel.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tj@kernel.org




--- Comment #25 from Tejun Heo <tj@kernel.org>  2010-08-06 06:32:03 ---
(In reply to comment #23)
> Well, my naive opinion rather is that userspace shouldn't be able to access a
> device node which isn't fully set up. That could have unexpected pitfalls for
> the process and the kernel as well, couldn't it?

But device nodes can be created for any device number whether the device exists
or not.  The patch makes sd announce it later so at least udev doesn't try to
access it earlier but unless I'm misunderstanding something userspace still can
trigger these warnings easily.

Thansk.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
