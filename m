From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23772] oops after mounting ext4 fs in 2.6.36.1 (failed to parse
 options in superblock)
Date: Tue, 30 Nov 2010 16:51:01 GMT
Message-ID: <201011301651.oAUGp15m027000@demeter1.kernel.org>
References: <bug-23772-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39889 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0K3QvD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Nov 2010 11:51:03 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAUGp24n027001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Nov 2010 16:51:02 GMT
In-Reply-To: <bug-23772-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23772





--- Comment #15 from Fryderyk Dziarmagowski <fdziarmagowski@gmail.com>  2010-11-30 16:50:59 ---
(In reply to comment #14)
> (In reply to comment #12)
> > I there is a way to fix it on the user space side?
> 
> Fairly simple, for this specific case.  It should overwrite the 512-byte area
> beyond the superblock with zeroes:
> 
> dd if=/dev/zero of=/dev/dsk/by-label/MyBook bs=512 count=1 seek=3 skip=3

that did the trick! Many thanks Andreas!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
