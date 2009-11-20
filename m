From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14619] ext3/jbd oops in journal_start
Date: Fri, 20 Nov 2009 15:19:16 GMT
Message-ID: <200911201519.nAKFJG97021807@demeter.kernel.org>
References: <bug-14619-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47089 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbZKTPTK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Nov 2009 10:19:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAKFJGoh021808
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2009 15:19:16 GMT
In-Reply-To: <bug-14619-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14619


Chris Mason <chris.mason@oracle.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chris.mason@oracle.com




--- Comment #2 from Chris Mason <chris.mason@oracle.com>  2009-11-20 15:19:15 ---
This is a btrfs bug, and was specific to ceph's use of btrfs userland
transactions.  We were leaving current->journal_info set after returning from
the kernel which ext3 (rightly) faulted on.

It is fixed in 2.6.32-rc7 and higher.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
