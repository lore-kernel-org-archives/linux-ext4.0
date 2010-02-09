From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Tue, 9 Feb 2010 18:09:25 GMT
Message-ID: <201002091809.o19I9PVG000395@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38439 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab0BISJ0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 13:09:26 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o19I9PTZ000399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 9 Feb 2010 18:09:25 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz




--- Comment #7 from Jan Kara <jack@suse.cz>  2010-02-09 18:08:59 ---
Ted, what problem does commit 39bc680a cause? Because I thought all the
problems were introduced by commit d21cd8f (also mentioned in the changelogs)
and that was not committed to -stable (exactly because of this). But the
problems described in commit 0637c6f4135f592f094207c7c21e7c0fc5557834 were
always there so maybe commit 39bc680a just makes them visible... Shrug.

Maybe just backing out 39bc680a would be an option for -stable...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
