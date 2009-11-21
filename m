From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Sat, 21 Nov 2009 14:27:42 GMT
Message-ID: <200911211427.nALERgYk007319@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38658 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZKUO1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Nov 2009 09:27:36 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nALERgl5007320
	for <linux-ext4@vger.kernel.org>; Sat, 21 Nov 2009 14:27:42 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #11 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-21 14:27:39 ---
On Saturday 21 November 2009, Mikael Pettersson wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14256
> > Subject		: kernel BUG at fs/ext3/super.c:435
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-09-21 7:29 (57 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125351816109264&w=3D4
> 
> Still occurs with kernel 2.6.32-rc8.
> 
> This time I only rebuilt the glibc src rpm, which also runs its
> test suite, but I did not install the new glibc binaries before
> the shutdown -r.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.