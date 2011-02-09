From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27652] 38-rc1: umount+rmmod cause ext4 error.
Date: Wed, 9 Feb 2011 04:50:25 GMT
Message-ID: <201102090450.p194oPXQ010707@demeter2.kernel.org>
References: <bug-27652-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35084 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1BIEu0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Feb 2011 23:50:26 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p194oPLb010708
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Feb 2011 04:50:26 GMT
In-Reply-To: <bug-27652-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27652


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #15 from Florian Mickler <florian@mickler.org>  2011-02-09 04:50:23 ---
Patch: http://marc.info/?l=linux-fsdevel&m=129718595331581&w=2

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
