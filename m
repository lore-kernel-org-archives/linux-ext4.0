From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Tue, 4 Aug 2009 17:10:19 GMT
Message-ID: <200908041710.n74HAJ1V020704@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59809 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825AbZHDRKS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 13:10:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n74HAJXw020705
	for <linux-ext4@vger.kernel.org>; Tue, 4 Aug 2009 17:10:19 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909


Michael B. Trausch <mike@trausch.us> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mike@trausch.us




--- Comment #1 from Michael B. Trausch <mike@trausch.us>  2009-08-04 17:10:18 ---
As an FYI, it doesn't seem to happen on a 2.6.31 kernel (not sure of the exact
revision, not currently running an upstream kernel).  I have a 2.6.30.4
installed, I'll check there as I'm sure that it'd be helpful to have a
confirmation.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
