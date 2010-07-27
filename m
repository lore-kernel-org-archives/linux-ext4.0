From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16019] Resume from hibernate corrupts ext4
Date: Tue, 27 Jul 2010 20:37:31 GMT
Message-ID: <201007272037.o6RKbV6F021531@demeter.kernel.org>
References: <bug-16019-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33035 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab0G0Uhc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2010 16:37:32 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6RKbVVF021532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 27 Jul 2010 20:37:31 GMT
In-Reply-To: <bug-16019-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16019


Steven Bakker <sb@monkey-mind.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sb@monkey-mind.net




--- Comment #40 from Steven Bakker <sb@monkey-mind.net>  2010-07-27 20:37:22 ---
I'm running 2.6.33.6-147.fc13.x86_64 with an i915, and unfortunately, it still
corrupts the ext4 FS on hibernate/wakeup.

(Off-topic: I'd be happy for my laptop to just auto-suspend when it's running
on battery, but that doesn't seem to be configurable: it's hibernate or
nothing.)

Steven

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching someone on the CC list of the bug.
