From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13992] ext3 data=ordered in fstab prevents booting
Date: Wed, 19 Aug 2009 12:47:02 GMT
Message-ID: <200908191247.n7JCl21w018943@demeter.kernel.org>
References: <bug-13992-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56210 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZHSMrB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 08:47:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7JCl2hf018944
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 12:47:02 GMT
In-Reply-To: <bug-13992-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13992


Jan Kara <jack@suse.cz> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jack@suse.cz
         AssignedTo|fs_ext3@kernel-bugs.osdl.or |jack@suse.cz
                   |g                           |




--- Comment #1 from Jan Kara <jack@suse.cz>  2009-08-19 12:46:59 ---
Oh, I see what's the problem: You cannot change journalling mode on remount. So
if by default a filesystem gets mounted as data=writeback, then mount
remounting the fs rw fails because it specifies data=ordered from /etc/fstab.
Sorry, this is a userspace issue - either you have to specify
rootflags=data=ordered or you should use initrd and initially mount the
filesystem with proper options.

I understand this might be nasty to users but there's no better solution...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
