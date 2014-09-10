From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84201] mount doesn't clear usrjquota / grpjqouta options
Date: Wed, 10 Sep 2014 13:48:21 +0000
Message-ID: <bug-84201-13602-xsi8oZCblE@https.bugzilla.kernel.org/>
References: <bug-84201-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36370 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaIJNs3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 09:48:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33EE1201C7
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2014 13:48:24 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DA252201D5
	for <linux-ext4@vger.kernel.org>; Wed, 10 Sep 2014 13:48:21 +0000 (UTC)
In-Reply-To: <bug-84201-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=84201

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
"mount -o remount,userjquota=,grpjquota= /"

should do the trick.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
