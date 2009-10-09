From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 9 Oct 2009 16:44:48 GMT
Message-ID: <200910091644.n99Gimok002570@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58549 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761123AbZJIQpZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 12:45:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n99Gim9h002571
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 16:44:48 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #3 from Eric Sandeen <sandeen@redhat.com>  2009-10-09 16:44:47 ---
(In reply to comment #2)

> > When it does this, you should get something in dmesg; can you attach that?
> 
> I will try, it is a bit difficult as the distro is not booting up to a login
> prompt in this case. I will try hard.

if you see it on the screen just a general idea or even a photo is fine :) 
(may need to switch consoles)

> > please attach the actual e2fsck output.
> 
> Do you have a better idea than using fsck -y / > /boot/fsck.output for keeping
> the log?

hopefully that works fine :)

Thanks,
-eric

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
