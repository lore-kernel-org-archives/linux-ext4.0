From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Mon, 20 Dec 2010 20:57:54 GMT
Message-ID: <201012202057.oBKKvsRc016276@demeter2.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:55931 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab0LTU5y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Dec 2010 15:57:54 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBKKvsU3016277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Dec 2010 20:57:54 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352





--- Comment #1 from Kees Cook <kees@outflux.net>  2010-12-20 20:57:53 ---
Created an attachment (id=41062)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=41062)
script that will demo a corrupted ext4 after resize

This has already been reported to Ubuntu, but was reproduced with an upstream
kernel, so I've opened this report as well.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/692704

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
