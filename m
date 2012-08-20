From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 32182] EXT4-fs error: bad header/extent
Date: Mon, 20 Aug 2012 20:06:47 +0000 (UTC)
Message-ID: <20120820200647.1436611FB49@bugzilla.kernel.org>
References: <bug-32182-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42323 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2HTUGx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Aug 2012 16:06:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0C1202041B
	for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2012 20:06:52 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 8B80F20409
	for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2012 20:06:49 +0000 (UTC)
In-Reply-To: <bug-32182-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=32182





--- Comment #12 from Peter Hanecak <hany+kernel.org@hany.sk>  2012-08-20 20:06:46 ---
Hello,

I'm still seeing this:

$ dmesg | grep "EXT4-fs error"
[   70.498238] EXT4-fs error (device dm-0): ext4_ext_check_inode:412: inode
#1839235: comm Xorg: bad header/extent: invalid magic - magic 0, entries 0, max
0(0), depth 0(0)
[   70.659036] EXT4-fs error (device dm-0): ext4_ext_check_inode:412: inode
#1839235: comm Xorg: bad header/extent: invalid magic - magic 0, entries 0, max
0(0), depth 0(0)
[   70.744199] EXT4-fs error (device dm-0): ext4_ext_check_inode:412: inode
#1839235: comm Xorg: bad header/extent: invalid magic - magic 0, entries 0, max
0(0), depth 0(0)
[   72.746596] EXT4-fs error (device dm-0): ext4_ext_check_inode:412: inode
#1839235: comm Xorg: bad header/extent: invalid magic - magic 0, entries 0, max
0(0), depth 0(0)

$ uname -r
3.4.7-1.fc16.x86_64


Same PC and filesystem as last time. I wonder whether copying to new filesystem
would help because since last time I updated Xorg several times, replacing the
binary (ussual Fedora updates).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
