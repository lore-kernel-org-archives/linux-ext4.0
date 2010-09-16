From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Thu, 16 Sep 2010 18:13:21 GMT
Message-ID: <201009161813.o8GIDLJl011203@demeter2.kernel.org>
References: <bug-16312-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:51914 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab0IPTCl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Sep 2010 15:02:41 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8GIDLHj011204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 16 Sep 2010 18:13:21 GMT
In-Reply-To: <bug-16312-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16312





--- Comment #30 from Jan Kara <jack@suse.cz>  2010-09-16 18:13:21 ---
OK, Tejun, I finally read the code. So you are right that the patch doesn't
solve the race. The race seems to be in block/genhd.c:add_disk(). Once we call
register_disk(), device can be successfully opened (get_gendisk() from
blkdev_open() will succeed as soon as disk's kobject exists). But until we call
bdi_register_dev(), backing dev isn't properly initialized and thus can see the
warning. This also explains why Larry is able to see the warning even with your
patch.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
