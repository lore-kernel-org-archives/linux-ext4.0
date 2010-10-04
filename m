From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Random kmemcheck errors and kernel freeze on 2.6.36-rc*
Date: Mon, 4 Oct 2010 18:51:32 GMT
Message-ID: <201010041851.o94IpWfO008847@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:58341 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab0JDSvd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Oct 2010 14:51:33 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o94IpWWQ008848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 4 Oct 2010 18:51:32 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361


Christian Casteyde <casteyde.christian@free.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Watchdog detected hard      |Random kmemcheck errors and
                   |LOCKUP in                   |kernel freeze on 2.6.36-rc*
                   |jbd2_journal_get_write_acce |
                   |ss                          |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
