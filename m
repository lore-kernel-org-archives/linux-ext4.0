From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13604] cascade of "mpage_da_map_blocks block allocation failed"
 errors
Date: Mon, 15 Mar 2010 20:22:35 GMT
Message-ID: <201003152022.o2FKMZEK015947@demeter.kernel.org>
References: <bug-13604-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60576 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936679Ab0COUWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Mar 2010 16:22:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2FKMZjb015948
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 15 Mar 2010 20:22:35 GMT
In-Reply-To: <bug-13604-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13604


Eric Sandeen <sandeen@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|fs_ext4@kernel-bugs.osdl.or |sandeen@redhat.com
                   |g                           |




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
