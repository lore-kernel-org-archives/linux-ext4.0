From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15252] ext4 triggers warning about high order allocations
Date: Sun, 7 Feb 2010 21:33:44 GMT
Message-ID: <201002072133.o17LXiM4016048@demeter.kernel.org>
References: <bug-15252-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35531 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0BGVdo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Feb 2010 16:33:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o17LXiqC016053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 7 Feb 2010 21:33:44 GMT
In-Reply-To: <bug-15252-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15252





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2010-02-07 21:33:42 ---
On Sunday 07 February 2010, Michael S. Tsirkin wrote:
> On Sun, Feb 07, 2010 at 01:00:53PM -0600, Eric Sandeen wrote:
> > > I have removed auto_da_alloc option, but still see a warning at boot:
> > 
> > Any chance you've still got it in an initrd or grub rootfs options, or similar?
> 
> Looks like this was the case: I rebuilt initrd and it's gone.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
