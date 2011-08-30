From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42052] kernel BUG at
 build/buildd/linux-2.6.38/kernel/timer.c:668
Date: Tue, 30 Aug 2011 20:20:46 GMT
Message-ID: <201108302020.p7UKKk9p015894@demeter2.kernel.org>
References: <bug-42052-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:58380 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab1H3UUr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 16:20:47 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7UKKk9J015895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:20:47 GMT
In-Reply-To: <bug-42052-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42052


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |tytso@mit.edu
         Resolution|                            |PATCH_ALREADY_AVAILABLE




--- Comment #5 from Theodore Tso <tytso@mit.edu>  2011-08-30 20:20:45 ---
Fixed in 2.6.39, via commit: 0449641130f56

it should be pretty easy to cherry pick that into your 2.6.38.8 kernel.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
