From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Tue, 19 May 2009 18:40:47 GMT
Message-ID: <200905191840.n4JIelPa017873@demeter.kernel.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55046 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZESSkq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 14:40:46 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4JIeliF017874
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2009 18:40:47 GMT
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu
         Regression|---                         |No




--- Comment #17 from Theodore Tso <tytso@mit.edu>  2009-05-19 18:40:47 ---
Any luck reproducing this problem?   Especially on a more recent kernel
version?

If I don't get a response, I plan to close this bug, since we've fixed a lot of
problem in the last couple of months....

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
