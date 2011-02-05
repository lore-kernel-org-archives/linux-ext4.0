From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Sat, 5 Feb 2011 08:31:38 GMT
Message-ID: <201102050831.p158VcNc016579@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:41947 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1BEIbj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Feb 2011 03:31:39 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p158VcjB016580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Feb 2011 08:31:38 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #10 from rocko <rockorequin@hotmail.com>  2011-02-05 08:31:16 ---
Created an attachment (id=46432)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=46432)
inode kernel bug dump

I tried suspending/resuming from a VT console in 2.6.38-rc3 and discovered a
kernel bug - I've attached it in case it's related to this. But the system
didn't freeze up in 2.6.38.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
