From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14156] Running fsstress "fsx" on ext4 filesystem gives dirty
 metadata buffer warning message
Date: Tue, 23 Feb 2010 13:18:13 GMT
Message-ID: <201002231318.o1NDIDDM004129@demeter.kernel.org>
References: <bug-14156-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52921 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0BWNSN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2010 08:18:13 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1NDIDvH004136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Feb 2010 13:18:13 GMT
In-Reply-To: <bug-14156-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14156


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
