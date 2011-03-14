From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25832] kernel crashes upon resume if usb devices are removed
 when suspended
Date: Mon, 14 Mar 2011 14:18:53 GMT
Message-ID: <201103141418.p2EEIrTN002619@demeter1.kernel.org>
References: <bug-25832-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:60555 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1CNOSy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Mar 2011 10:18:54 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p2EEIrc0002620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Mar 2011 14:18:53 GMT
In-Reply-To: <bug-25832-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25832





--- Comment #49 from Alan Stern <stern@rowland.harvard.edu>  2011-03-14 14:18:48 ---
It is possible to tell git that you can't test a certain kernel; it will then
choose a different bisection point for testing.

There is no way to make the kernel handle a catastrophic bug gracefully.  There
are ways to capture a complete kernel log when a bug does occur, by using a
serial console or a network console.  There's also the kernel's internal
debugger (kgdb).  Besides, information about process states probably won't
help.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
