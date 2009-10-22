From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 22 Oct 2009 19:22:27 GMT
Message-ID: <200910221922.n9MJMR6C013840@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42627 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbZJVTWW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 15:22:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9MJMRvf013841
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 19:22:27 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #103 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-22 19:22:25 ---
(In reply to comment #101)
> Alexy, is that correct?

No. ... crash, reboot, mount readonly, chroot on mounted partition and fsck
mounted partition.
But it is not what about happen after reboot. I used "clean" kernel after dirty
crash with same fs corruption.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
