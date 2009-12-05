From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14739] BUG: scheduling while atomic: nfsd/3369/0x00000002
Date: Sat, 5 Dec 2009 17:28:13 GMT
Message-ID: <200912051728.nB5HSDVn018680@demeter.kernel.org>
References: <bug-14739-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41605 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZLER2H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Dec 2009 12:28:07 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nB5HSDET018681
	for <linux-ext4@vger.kernel.org>; Sat, 5 Dec 2009 17:28:13 GMT
In-Reply-To: <bug-14739-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14739


Trond Myklebust <trond.myklebust@fys.uio.no> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |trond.myklebust@fys.uio.no
          Component|NFS                         |ext4
         AssignedTo|trond.myklebust@fys.uio.no  |fs_ext4@kernel-bugs.osdl.or
                   |                            |g




--- Comment #1 from Trond Myklebust <trond.myklebust@fys.uio.no>  2009-12-05 17:28:12 ---
Hmm... This looks to me like it is rather an ext4 bug. Reassigning to
the ext4 folks for the moment.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
