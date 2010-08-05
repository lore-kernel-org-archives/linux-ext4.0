From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Thu, 5 Aug 2010 12:12:08 GMT
Message-ID: <201008051212.o75CC8VG014184@demeter.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34021 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900Ab0HEMMS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 08:12:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o75CC8of014204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 5 Aug 2010 12:12:09 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #22 from Tejun Heo <tj@kernel.org>  2010-08-05 12:11:59 ---
Created an attachment (id=27356)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=27356)
sd-delay-uevent.patch

This would make sd announce the sd device after block device is set up, which
probably is the right thing to do but it still is wrong to trigger WARN_ON()
when a user program accesses a device node which isn't ready yet.  Can't that
warning be removed by using a default bdi w/ BDI_CAP_NO_ACCT_AND_WRITEBACK set
for block device nodes?

Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
