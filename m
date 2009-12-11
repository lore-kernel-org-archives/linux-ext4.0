From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14739] BUG: scheduling while atomic: nfsd/3369/0x00000002
Date: Fri, 11 Dec 2009 12:11:37 GMT
Message-ID: <200912111211.nBBCBbaC021230@demeter.kernel.org>
References: <bug-14739-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58356 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZLKMLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Dec 2009 07:11:31 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nBBCBbIg021232
	for <linux-ext4@vger.kernel.org>; Fri, 11 Dec 2009 12:11:37 GMT
In-Reply-To: <bug-14739-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14739


Dmitri Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org




--- Comment #3 from Dmitri Monakhov <dmonakhov@openvz.org>  2009-12-11 12:11:33 ---
Proposed patch http://patchwork.ozlabs.org/patch/40896/

tests performed:
 mounted : ext4  with generic quota and journalled quota 
 1) fsstress -p16 -d /mnt/test -l999999999999 -n9999999999999999
   Note: many task are necessary in order to catch race condition introduced
   in [v2] of the patch 
 2) ./write-chown-truncate /mnt/ 9999999999999

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
