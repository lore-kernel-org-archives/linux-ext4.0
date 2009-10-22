From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Thu, 22 Oct 2009 19:37:45 GMT
Message-ID: <200910221937.n9MJbj90016364@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36849 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbZJVThl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 15:37:41 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9MJbjQE016365
	for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 19:37:45 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #105 from Eric Sandeen <sandeen@redhat.com>  2009-10-22 19:37:44 ---
(In reply to comment #103)
> (In reply to comment #101)
> > Alexy, is that correct?
> 
> No. ... crash, reboot, mount readonly, chroot on mounted partition and fsck
> mounted partition.

Oh, so you are e2fsck'ing a readonly mounted root partition...  Ok I had
misunderstood that part, sorry.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
