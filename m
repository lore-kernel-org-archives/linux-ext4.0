From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14422] EXT4 is corrupted after clean shutdown
Date: Sat, 17 Oct 2009 07:03:41 GMT
Message-ID: <200910170703.n9H73fU5014809@demeter.kernel.org>
References: <bug-14422-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55820 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZJQHDh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 03:03:37 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9H73f9H014810
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 07:03:41 GMT
In-Reply-To: <bug-14422-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14422





--- Comment #4 from okias <d.okias@gmail.com>  2009-10-17 07:03:41 ---
fsck.ext4 automatic control fail after reboot. Then if I run manually fsck
/dev/sda2, it write something about shared inode between two files or something
like that. After lot of "yyyyyyyy" it copy some parts of files into /lost+found
I'm not 100% sure, but parts of files are in lost+found and parts remain on
it's old location.

I like to provide fsck logs, but I don't want corrupt my fs again... it's 100%
regression, with =< 2.6.31 problem newer appeared

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
