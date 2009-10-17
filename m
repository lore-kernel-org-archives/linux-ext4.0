From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 20:54:11 GMT
Message-ID: <200910172054.n9HKsBUw014455@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47125 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZJQUyH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 16:54:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9HKsBZv014456
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 20:54:11 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #85 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-17 20:54:10 ---
Created an attachment (id=23456)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23456)
logs of all bisected kernels

Here are logs of all tested kernels, for all test was used same script from my
previous post. Only 2.6.32-rc4-00094-g80f5069-dirty and 2.6.31 should be a bit
different... for this kernel i had thirst version of script.

After crash i started into initrd with option break=mount. So wen can exclude
any karmik initscript bugs. After it i mounted ro rootfs and chrooted to it. At
this point i run my checkfs script:
---------------------------------------------------------------------------
#!/bin/bash

current_date=$( date +%d_%m_%Y-%H_%M );
k_version=$( uname -r );

mount /dev/sda13 /mnt
cd /mnt

fsck -y -f /dev/mapper/zwerg_buntu-root_one > $k_version-$current_date.fsck
dmesg > $k_version-$current_date.dmesg
md5sum -c --quiet /mnt/md5sums > $k_version-$current_date.md5
-------------------------------------------------------------
I hope this will help you. Please check the logs if there any mistakes.

If you need more info, tell me soon. My system is badly broken now, i will need
to reinstall it.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
