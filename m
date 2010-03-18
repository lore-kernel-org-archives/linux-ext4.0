From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] ext4 backtraces out of nowhere
Date: Thu, 18 Mar 2010 11:11:53 GMT
Message-ID: <201003181111.o2IBBrQC025529@demeter.kernel.org>
References: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60177 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0CRLLy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 07:11:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2IBBr87025530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 18 Mar 2010 11:11:53 GMT
In-Reply-To: <bug-15018-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #8 from Jan Kara <jack@suse.cz>  2010-03-18 11:11:48 ---
This bug should be fixed in 2.6.33 (commit
1db913823c0f8360fccbd24ca67eb073966a5ffd). Please reopen this bug if you can
still see the problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
