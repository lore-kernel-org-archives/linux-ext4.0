From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Mon, 12 Oct 2009 02:24:09 GMT
Message-ID: <200910120224.n9C2O9v8026736@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56141 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZJLCYp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2009 22:24:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9C2O9pY026738
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2009 02:24:09 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #19 from Holger Freyther <zecke@selfish.org>  2009-10-12 02:24:09 ---
(In reply to comment #16)

> I'll note that that what Holger and Alexey are seeing are somewhat different. 
> Holger seems to be seeing a problem after a clean shutdown after re-installing
> glibc from a build directory.  

I have been trying to reproduce it the last two days but didn't really succeed.
I'm not sure if it still makes sense to upload a dmesg/config to see my system.
Basically I'm running Ubuntu Karmic (one thing in common) with a self built
kernel (plain kernel.org) and I'm using a crypto root (so he and me have device
mapper in use of some sort).

I will try more to reproduce this. Thanks for taking a look.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
