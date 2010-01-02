From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14972] [regression] msync() call on ext4 causes disk thrashing
Date: Sat, 2 Jan 2010 16:48:01 GMT
Message-ID: <201001021648.o02Gm1sv016488@demeter.kernel.org>
References: <bug-14972-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60270 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0ABQsB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jan 2010 11:48:01 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o02Gm1ph016489
	for <linux-ext4@vger.kernel.org>; Sat, 2 Jan 2010 16:48:01 GMT
In-Reply-To: <bug-14972-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14972


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|Yes                         |No




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
