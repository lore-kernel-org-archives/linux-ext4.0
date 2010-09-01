From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16711] Oops with 2.6.36-rc1
Date: Wed, 1 Sep 2010 08:42:31 GMT
Message-ID: <201009010842.o818gVmk028983@demeter1.kernel.org>
References: <bug-16711-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50725 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0IAImc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Sep 2010 04:42:32 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o818gVeX028984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 1 Sep 2010 08:42:31 GMT
In-Reply-To: <bug-16711-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16711





--- Comment #9 from Tobias <devnull@plzk.org>  2010-09-01 08:42:21 ---
FWIW, -rc3 does not oops during boot, so I guess this has been fixed. I am
still getting ioctl errors related to dm, and screen resolution min gnome is
wrong, but those are different issues as far as I understand.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
