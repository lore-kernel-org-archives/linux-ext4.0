From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 22 Oct 2009 19:06:06 GMT
Message-ID: <200910221906.n9MJ66Fg011192@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43103 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZJVTGB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 15:06:01 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9MJ66I2011193
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 19:06:06 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #102 from Eric Sandeen <sandeen@redhat.com>  2009-10-22 19:06:05 ---
Alexey, one other question, after you did this testcase for your bisect run:

mount /dev/sda13 /mnt
md5deep -r /lib/modules/$k_version/* > /mnt/md5sums
umount /mnt

sleep 1m
echo c > /proc/sysrq-trigger

did you reset power to get the machine up and running again?

Thanks,
-Eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
