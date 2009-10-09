From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Fri, 9 Oct 2009 22:01:44 GMT
Message-ID: <200910092201.n99M1iBY007169@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55967 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934649AbZJIWCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 18:02:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n99M1inK007170
	for <linux-ext4@vger.kernel.org>; Fri, 9 Oct 2009 22:01:44 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #2 from Rafael J. Wysocki <rjw@sisk.pl>  2009-10-09 22:01:43 ---
On Friday 09 October 2009, Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > Rafael J. Wysocki writes:
>  >  > On Sunday 04 October 2009, Mikael Pettersson wrote:
>  >  > > Rafael J. Wysocki wrote:
>  >  > > > The following bug entry is on the current list of known regressions
>  >  > > > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>  >  > > > be listed and let me know (either way).
>  >  > > > 
>  >  > > > 
>  >  > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14256
>  >  > > > Subject		: kernel BUG at fs/ext3/super.c:435
>  >  > > > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
>  >  > > > Date		: 2009-09-21 7:29 (11 days old)
>  >  > > > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125351816109264&w=3D4
>  >  > > 
>  >  > > The exact same bug (same cause, same symptom) just hit me again in 2.6.32-rc1.
>  >  > 
>  >  > Thanks for the update.
>  >  > 
>  >  > Could you check the current Linus' tree, please?  There are some known
>  >  > regression fixes in there.
>  > 
>  > I tried simplified versions of the bug trigger on two machines
>  > running 2.6.32-rc1-git6, and neither triggered the kernel bug.
>  > 
>  > The original recipe involved doing a glibc rebuild, run its test
>  > suite, install it, and reboot. Today however machine 1 was already
>  > doing a rebuild so after the rebuild it did a reboot into the new
>  > kernel before the install. The second machine booted the new kernel
>  > directly to install the binary packages from the first machine.
>  > 
>  > I'll re-run the full bug trigger recipe on a third machine later next
>  > week (it must rebuild glibc itself anyway due to arch differences).
> 
> Not fixed in 2.6.32-rc3. A glibc rebuild + install triggered the
> exact same bug on the third machine.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.