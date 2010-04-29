From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15875] Add an option to disable file/directory permissions for
 ext2/ext3/ext4 file systems
Date: Thu, 29 Apr 2010 11:11:09 GMT
Message-ID: <201004291111.o3TBB94p018529@demeter.kernel.org>
References: <bug-15875-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796Ab0D3RbP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Apr 2010 13:31:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3TBB9UX018530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 29 Apr 2010 11:11:09 GMT
In-Reply-To: <bug-15875-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15875





--- Comment #5 from Artem S. Tashkinov <t.artem@mailcity.com>  2010-04-29 11:11:05 ---
Probably it's worth implementing a more generous solution for all FS's on VFS
level, i.e. something like:

man mount:

FILESYSTEM INDEPENDENT MOUNT OPTIONS
       Some of these options are only useful when they appear in the /etc/fstab
file.

       Some of these options could be enabled or disabled by default in the
system kernel. To check the current setting see  the  options  in
       /proc/mounts.

       The  following  options  apply to any filesystem that is being mounted
(but not every filesystem actually honors them - e.g., the sync
       option today has effect only for ext2, ext3, fat, vfat and ufs):

***
       asroot  Map all uids and gids to the root user. It's useful
       for mounting removable storage  media.  Note that all files
       and directories created in this mode will be owned by root.

***

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
