From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12478] Infinite loop printing "__find_get_block_slow() failed."
 on accessing intentionally corrupted ext4 fs
Date: Tue, 19 May 2009 18:32:42 GMT
Message-ID: <200905191832.n4JIWgBX017279@demeter.kernel.org>
References: <bug-12478-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50030 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZESSck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 14:32:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JIWg28017280
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 18:32:42 GMT
In-Reply-To: <bug-12478-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12478


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
