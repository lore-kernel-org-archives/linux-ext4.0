From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36312] User belonging to another Group has no access when chmod
 0040
Date: Tue, 31 May 2011 18:43:44 GMT
Message-ID: <201105311843.p4VIhiul001079@demeter2.kernel.org>
References: <bug-36312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:35104 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab1EaSnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 May 2011 14:43:45 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id p4VIhiJk001080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 May 2011 18:43:44 GMT
In-Reply-To: <bug-36312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=36312


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #1 from Jan Kara <jack@suse.cz>  2011-05-31 18:43:43 ---
Yes, this works as defined in the standard. If user is the owner, we check
against owner bits. If the user is not the owner, but belongs to the owner
group, we check against group bits. If user falls into neither of previous
cathegories, we use 'other' bits.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
