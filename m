From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13232] ext3/4 with synchronous writes gets wedged by Postfix
Date: Sun, 7 Jun 2009 19:56:37 GMT
Message-ID: <200906071956.n57Jubs2023906@demeter.kernel.org>
References: <bug-13232-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:44225 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZFGT4f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Jun 2009 15:56:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n57JuboL023907
	for <linux-ext4@vger.kernel.org>; Sun, 7 Jun 2009 19:56:37 GMT
In-Reply-To: <bug-13232-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13232


Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
