From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13232] ext3/4 with synchronous writes gets wedged by Postfix
Date: Tue, 5 May 2009 23:16:02 GMT
Message-ID: <200905052316.n45NG20I003897@demeter.kernel.org>
References: <bug-13232-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51174 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbZEEXQD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 May 2009 19:16:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n45NG2ZT003898
	for <linux-ext4@vger.kernel.org>; Tue, 5 May 2009 23:16:02 GMT
In-Reply-To: <bug-13232-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13232


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rjw@sisk.pl
             Blocks|                            |12398




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
