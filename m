From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Sun, 4 Oct 2009 20:47:41 GMT
Message-ID: <200910042047.n94Klf3S024727@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:39718 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865AbZJDUsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Oct 2009 16:48:18 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n94KlfEo024728
	for <linux-ext4@vger.kernel.org>; Sun, 4 Oct 2009 20:47:41 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-10-04 20:47:41 ---
On Sunday 04 October 2009, Mikael Pettersson wrote:
> Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14256
> > Subject		: kernel BUG at fs/ext3/super.c:435
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-09-21 7:29 (11 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125351816109264&w=3D4
> 
> The exact same bug (same cause, same symptom) just hit me again in 2.6.32-rc1.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.