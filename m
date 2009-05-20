From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12603] firefox downloads hang on ext4; fine on ext3
Date: Wed, 20 May 2009 20:20:44 GMT
Message-ID: <200905202020.n4KKKitE003766@demeter.kernel.org>
References: <bug-12603-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35042 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbZETUUn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 16:20:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4KKKiDT003767
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2009 20:20:44 GMT
In-Reply-To: <bug-12603-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12603


Avery Fay <avery@shadypixel.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |INVALID




--- Comment #18 from Avery Fay <avery@shadypixel.com>  2009-05-20 20:20:44 ---
Sorry, this slipped my mind. It was almost certainly a race condition in
firefox. I ended up cleaning up a bunch of old stuff in my home directory
(specifically in the folder that I was downloading to) and it just stopped
happening altogether.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
