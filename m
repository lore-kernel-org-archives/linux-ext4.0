From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16456] sync locks up often when run soon after boot
Date: Sat, 24 Jul 2010 17:47:23 GMT
Message-ID: <201007241747.o6OHlNE5003351@demeter.kernel.org>
References: <bug-16456-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40740 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab0GXRrY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 24 Jul 2010 13:47:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6OHlNKs003352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 24 Jul 2010 17:47:23 GMT
In-Reply-To: <bug-16456-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16456





--- Comment #1 from Arvid Norlander <anmaster@tele2.se>  2010-07-24 17:47:22 ---
Forgot to mention that the system is non-SMP, x86-64 (AMD Sempron 3300+), NOHZ,
using hpet. Oh and that resyncing RAID is that inconvenient due to taking
slightly more than 3.5 hours (large drives, but not the fastest hardware)...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
