From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Wed, 22 Sep 2010 17:48:04 GMT
Message-ID: <201009221748.o8MHm4hN031275@demeter1.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47059 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0IVRsG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Sep 2010 13:48:06 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8MHm4LN031277
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 22 Sep 2010 17:48:04 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #5 from Christian Casteyde <casteyde.christian@free.fr>  2010-09-22 17:47:58 ---
Well, I managed to boot in single mode, and tried to execute commands one by
one to see what triggers the problems.
Indeed, it's really random, sometime it's while ldconfig is called by the init
scripts, sometime it's when starting udev...
The callstacks are quite different also, sometime it's kmemcheck, sometime
preempt count, sometime NULL dereference...

So I'm posting the dmesg output I saved each time I got an error. Now at least
they are complete, so the root cause may be easier to find.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
