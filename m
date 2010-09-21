From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Date: Tue, 21 Sep 2010 17:19:33 GMT
Message-ID: <201009211719.o8LHJXnA022969@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:41707 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab0IURTe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Sep 2010 13:19:34 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8LHJXOX022971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Sep 2010 17:19:33 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361





--- Comment #4 from Christian Casteyde <casteyde.christian@free.fr>  2010-09-21 17:19:32 ---
Update : Still present in 2.6.36-rc5
With the same log as shown in comment #2
Some more info are given after that ("recursive fault fixed, but rebbot is
necessary").
If I wait a little more, I get another pile of messages.

More precisely, the problem occurs indeed after dhcp gets an IP address, and
before (or when) sshd is started. Between the two, I guess iptables rules are
defined in my network scripts.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
