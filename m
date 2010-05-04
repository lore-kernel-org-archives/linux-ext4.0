From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15768] Incorrectly calculated free blocks result in ENOSPC from
 writepage
Date: Tue, 4 May 2010 21:15:44 GMT
Message-ID: <201005042115.o44LFijp018482@demeter.kernel.org>
References: <bug-15768-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39487 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754Ab0EDVPp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 May 2010 17:15:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o44LFiJV018483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 4 May 2010 21:15:44 GMT
In-Reply-To: <bug-15768-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15768


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #5 from Rafael J. Wysocki <rjw@sisk.pl>  2010-05-04 21:15:42 ---
Patch : http://patchwork.ozlabs.org/patch/49989/
Handled-By : Dmitry Monakhov <dmonakhov@openvz.org>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
