From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 15 Dec 2009 09:08:48 GMT
Message-ID: <200912150908.nBF98mQd022966@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43029 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbZLOJIt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 04:08:49 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nBF98msZ022967
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 09:08:48 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #16 from Mikael Pettersson <mikpe@it.uu.se>  2009-12-15 09:08:45 ---
The affected file system is /tmp. There's nothing special about it, except it
being separate from / and /home. The builds are plain "rpmbuild --rebuild" so
they do most accesses under /usr/src/ and /var/tmp/, both on /, but the glibc
test suite will create temporary files on /tmp. I have no idea what those files
are.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
