From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25352] resizing ext4 will corrupt filesystem
Date: Tue, 21 Dec 2010 22:32:29 GMT
Message-ID: <201012212232.oBLMWTeF025474@demeter2.kernel.org>
References: <bug-25352-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:58080 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0LUWca (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Dec 2010 17:32:30 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBLMWUdV025475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 21 Dec 2010 22:32:30 GMT
In-Reply-To: <bug-25352-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=25352


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org,
                   |                            |maciej.rutecki@gmail.com,
                   |                            |rjw@sisk.pl
             Blocks|                            |21782




--- Comment #10 from Rafael J. Wysocki <rjw@sisk.pl>  2010-12-21 22:32:29 ---
Handled-By : Theodore Tso <tytso@mit.edu>

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
