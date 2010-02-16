From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15025] Oops in ext4 driver
Date: Tue, 16 Feb 2010 13:44:44 GMT
Message-ID: <201002161344.o1GDiikT029035@demeter.kernel.org>
References: <bug-15025-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35547 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab0BPNoq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Feb 2010 08:44:46 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1GDijQI029036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 16 Feb 2010 13:44:45 GMT
In-Reply-To: <bug-15025-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15025





--- Comment #6 from Steinar H. Gunderson <sgunderson@bigfoot.com>  2010-02-16 13:44:37 ---
There was a power drop (too long for the UPS), so I've now run 2.6.33-rc8 on
this same machine for about 24 hours without seeing any ext4 errors. The load
is probably different, though, but at least it doesn't seem to bite me anymore.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
