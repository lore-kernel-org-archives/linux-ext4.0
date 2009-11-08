From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sun, 8 Nov 2009 18:12:13 GMT
Message-ID: <200911081812.nA8ICD4B001460@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53087 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZKHSMI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 13:12:08 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA8ICD7D001465
	for <linux-ext4@vger.kernel.org>; Sun, 8 Nov 2009 18:12:13 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #181 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2009-11-08 18:12:03 ---
Reply-To: hch@infradead.org

On Fri, Nov 06, 2009 at 10:07:15PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> That said, I haven't looked at how nasty it would be to change the name 
> lookup to use <ptr,len>. Maybe it wouldn't be as horrible as I suspect it 
> is (the filesystems themselves wouldn't need changing, since the lowlevel 
> filesystem name lookup routines always sees a 'struct dentry' rather than 
> the pathname).

FYI there are other filesystems that historically store the the name
without terminating NULL in the symlink and would benefit from that.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
