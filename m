From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12689] kernel oops fs/jbd/checkpoint.c:164 __log_wait_for_space
Date: Wed, 15 Jul 2009 19:02:35 GMT
Message-ID: <200907151902.n6FJ2ZBa000673@demeter.kernel.org>
References: <bug-12689-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46696 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbZGOTCf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 15:02:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n6FJ2ZKf000674
	for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2009 19:02:35 GMT
In-Reply-To: <bug-12689-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12689


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
