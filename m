From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17361] Random kmemcheck errors and kernel freeze on 2.6.36-rc*
Date: Wed, 20 Oct 2010 20:10:39 GMT
Message-ID: <201010202010.o9KKAdL3014017@demeter2.kernel.org>
References: <bug-17361-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:38834 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0JTUKk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Oct 2010 16:10:40 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9KKAdZQ014018
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 20 Oct 2010 20:10:39 GMT
In-Reply-To: <bug-17361-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=17361


Christian Casteyde <casteyde.christian@free.fr> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #20 from Christian Casteyde <casteyde.christian@free.fr>  2010-10-20 20:10:37 ---
Hello
My bisection was obviously false, sorry.

It took me some time, but I've finally understood why my bisection failed, and
what was happening.

The problem is that with kmemcheck, the kernel boots so slowly (except if there
is a warning at boot in swapper, as it occured in several revision pre rc1),
that the hard and soft lockup detection mechanism was triggering (often in udev
or hal or ldconfig or other slow commands). Moreover, it triggered sometimes at
a place the kernel cannot cope with it, and crashes.

Before bisecting, I took a fresh 2.6.35 .config file and reactivated the
debugging options, but I fogot the lockup detector. So I couldn't see the
errors anymore. Nevertheless, I checked other warnings that used to occur
before -rc1, and that were fixed later. As I was looking for a range between
2.6.35 and rc1, I got false results on already fixed bugs.

Finally, I do not have any problem anymore with 2.6.36-rc8. Except that the
lockup timeout is either too low for my computers, or crashes the kernel
sometimes whent it triggers. But that's not critical.

I'm closing the bug.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
