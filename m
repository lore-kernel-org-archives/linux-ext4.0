From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Sat, 10 Oct 2009 01:31:41 GMT
Message-ID: <200910100131.n9A1Vfnu029073@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50023 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138AbZJJBcT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 21:32:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9A1VfnX029074
	for <linux-ext4@vger.kernel.org>; Sat, 10 Oct 2009 01:31:41 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #3 from Theodore Tso <tytso@mit.edu>  2009-10-10 01:31:41 ---
On Fri, Oct 09, 2009 at 10:01:44PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> > Not fixed in 2.6.32-rc3. A glibc rebuild + install triggered the
> > exact same bug on the third machine.

Can you isolate this down to something simpler?  Will "make install"
followed by a reboot be sufficient to replicate the assertion failure?
If it does, will copying in a new version of libc.so.6 and then
rebooting be enough to trigger the assert failure?

Thanks,

                                            - Ted

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
