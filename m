From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Fri, 9 Oct 2009 16:06:47 GMT
Message-ID: <200910091606.n99G6lXW030171@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46694 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462AbZJIQHX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 12:07:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n99G6l0O030172
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 16:06:47 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #2 from Holger Freyther <zecke@selfish.org>  2009-10-09 16:06:46 ---
(In reply to comment #1)
> (In reply to comment #0)
> > I don't know how to reproduce but I'm seeing the following issues with
> > 2.6.32-rcX since the "BUG_ON with page buffers has been fixed" on a daily
> > basis.
> > 
> > - Clean shutdown
> > - Reboot -> fs turns into ro mode
> 
> When it does this, you should get something in dmesg; can you attach that?

I will try, it is a bit difficult as the distro is not booting up to a login
prompt in this case. I will try hard.

> 
> > - Reboot -> fsck. I see blocks assigned to two inodes and many lost+found of
> > files touched close before the shutdown or during the shutdown. This requires
> > to go through the 1B, 1C, 1D pass on fsck.
> 
> please attach the actual e2fsck output.

Do you have a better idea than using fsck -y / > /boot/fsck.output for keeping
the log?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
