From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sun, 13 Mar 2011 00:41:02 GMT
Message-ID: <201103130041.p2D0f22a016570@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:39986 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab1CMAlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Mar 2011 19:41:04 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2D0f2Fh016571
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 13 Mar 2011 00:41:02 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #43 from rocko <rockorequin@hotmail.com>  2011-03-13 00:41:00 ---
I tried both 2.6.38-rc8 built with gcc 4.4.5 and also the Ubuntu weekly build
of 2.6.38-rc8, which says it is built with gcc 4.2.3, and both crashed.

I didn't manage to crash the Ubuntu 2.6.35-28 kernel, so it might be a
regression between 2.6.35 and 36.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
