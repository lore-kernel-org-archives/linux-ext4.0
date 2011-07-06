From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38852] Oops in page_waitqueue during large copy to ext4
 filesystem
Date: Wed, 6 Jul 2011 14:49:15 GMT
Message-ID: <201107061449.p66EnFNk026397@demeter2.kernel.org>
References: <bug-38852-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39252 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1GFOtP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 10:49:15 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p66EnFSp026398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jul 2011 14:49:15 GMT
In-Reply-To: <bug-38852-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38852


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sandeen@redhat.com




--- Comment #1 from Eric Sandeen <sandeen@redhat.com>  2011-07-06 14:49:13 ---
as for 0x1b90, the closest I can find in the kernel is:

1 pci/ctxfi/ct20k2reg.h  22 #define I2C_IF_ADDRESS   0x1B9000
0 net/bnx2x/bnx2x_dump.h 348 { 0x1b8fd0, 6, RI_E2_ONLINE }, { 0x1b9000, 1,
RI_E2_ONLINE },

but that's probably not relevant....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
