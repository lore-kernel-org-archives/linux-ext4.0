From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15231] kernel BUG at fs/ext4/inode.c:1852!
Date: Fri, 5 Feb 2010 09:50:09 GMT
Message-ID: <201002050950.o159o9vZ030789@demeter.kernel.org>
References: <bug-15231-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42524 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0BEJuK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Feb 2010 04:50:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o159o93s030790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 5 Feb 2010 09:50:09 GMT
In-Reply-To: <bug-15231-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15231


Franco Broi <franco@fugro-fsi.com.au> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|BUG: soft lockup - CPU#3    |kernel BUG at
                   |stuck for 61s               |fs/ext4/inode.c:1852!




--- Comment #2 from Franco Broi <franco@fugro-fsi.com.au>  2010-02-05 09:50:07 ---
Changed the summary to be more specific.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
