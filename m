From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 24282] linux/ext2_fs.h uses defines from linux/fs.h
Date: Fri, 3 Dec 2010 15:20:25 GMT
Message-ID: <201012031520.oB3FKPFx023675@demeter2.kernel.org>
References: <bug-24282-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:53664 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0LCPU0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Dec 2010 10:20:26 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oB3FKQh5023676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 3 Dec 2010 15:20:26 GMT
In-Reply-To: <bug-24282-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=24282





--- Comment #2 from Cezary Sliwa <sliwa@blue.cft.edu.pl>  2010-12-03 15:20:24 ---

The error occured when compiling a user space program. Just include
linux/ext2_fs.h whithout linux/fs.h and you get:

/usr/include/linux/ext2_fs.h: In function 'ext2_mask_flags':
/usr/include/linux/ext2_fs.h:182: error: 'FS_DIRSYNC_FL' undeclared (first use
in this function)
/usr/include/linux/ext2_fs.h:182: error: (Each undeclared identifier is
reported only once
/usr/include/linux/ext2_fs.h:182: error: for each function it appears in.)
/usr/include/linux/ext2_fs.h:182: error: 'FS_TOPDIR_FL' undeclared (first use
in this function)
/usr/include/linux/ext2_fs.h:184: error: 'FS_NODUMP_FL' undeclared (first use
in this function)
/usr/include/linux/ext2_fs.h:184: error: 'FS_NOATIME_FL' undeclared (first use
in this function)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
