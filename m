From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Mon,  5 Jan 2009 13:50:13 -0800 (PST)
Message-ID: <20090105215013.85F6F10800E@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbZAEVuP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 16:50:15 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n05LoDMG013648
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jan 2009 13:50:14 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #6 from devzero@web.de  2009-01-05 13:50 -------
the perlscript does modprobe, rmmod in a loop. 
typically it`s insmod/rmmod  or modprobe/modprobe -r

don`t know, but i would try modprobe -r instead of rmmod - just to see if it
makes a difference.

furthermore, any chance to dig out if there is one or more "offending" module,
i.e. can you try to find out if this still happens with the right modules
excluded?

if the perlscript + shellscript was done by yourself, i think you have some
programming skills and can work out some strategy to find out which module
causing this issue. (i`d bisect the lsmod output appropriately and let that run
against pyk-perl.mod)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
