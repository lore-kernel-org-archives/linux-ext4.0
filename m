From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13549] Kernel oops while online resizing of an ext4 filesystem
Date: Mon, 22 Mar 2010 16:51:35 GMT
Message-ID: <201003221651.o2MGpZXK006908@demeter.kernel.org>
References: <bug-13549-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52380 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0CVQvg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 12:51:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2MGpZKn006910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 16:51:35 GMT
In-Reply-To: <bug-13549-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=13549





--- Comment #6 from Eric Sandeen <sandeen@redhat.com>  2010-03-22 16:51:25 ---
I'm very sorry, my fingers translated my brain wrong ;)  Ideally we can start
with dumpe2fs -h (not e2image -h, sorry) to quickly recreate a similar
filesystem, and try expanding it.

Keep that e2image around though just in case (although we would need one
created with -r to use it)

Thanks,

-Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
