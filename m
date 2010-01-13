From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14830] When other IO is running sync times go to 10 to 20
 minutes
Date: Wed, 13 Jan 2010 19:15:13 GMT
Message-ID: <201001131915.o0DJFDKw015577@demeter.kernel.org>
References: <bug-14830-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48090 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab0AMTPO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2010 14:15:14 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0DJFDUj015578
	for <linux-ext4@vger.kernel.org>; Wed, 13 Jan 2010 19:15:13 GMT
In-Reply-To: <bug-14830-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14830


Alasdair G Kergon <agk@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |agk@redhat.com
          Component|LVM2/DM                     |ext4
         AssignedTo|agk@redhat.com              |fs_ext4@kernel-bugs.osdl.or
                   |                            |g
            Product|IO/Storage                  |File System




--- Comment #1 from Alasdair G Kergon <agk@redhat.com>  2010-01-13 19:15:12 ---
filesystem or nfs perhaps?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
