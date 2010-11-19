From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 23232] kernel hang on insert ext4 usb key
Date: Fri, 19 Nov 2010 14:02:32 GMT
Message-ID: <201011191402.oAJE2WNL019273@demeter2.kernel.org>
References: <bug-23232-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:42312 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0KSOCd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:02:33 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oAJE2XnQ019274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 19 Nov 2010 14:02:33 GMT
In-Reply-To: <bug-23232-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=23232


Lukas Czerner <lczerner@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |lczerner@redhat.com




--- Comment #4 from Lukas Czerner <lczerner@redhat.com>  2010-11-19 14:02:31 ---
This might be related to a bug fixed with this patch. Can you try that to
confirm that it solve the issue ?

http://www.spinics.net/lists/linux-ext4/msg21743.html

Thanks!
-Lukas

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
