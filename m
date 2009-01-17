From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 10:24:54 -0800 (PST)
Message-ID: <20090117182454.DDE40108040@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760778AbZAQSZX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 13:25:23 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HIOt5H022567
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 10:24:56 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #19 from tytso@mit.edu  2009-01-17 10:24 -------
Um, why are you loading and unloading so many modules?   Note that it is not
necessarily guaranteed to be safe to be unloading modules.   In particular with
network drivers, there are often race conditions that can crash your machine if
you unload a module.   Part of the problem is that some kernel maintainers
don't believe that it is valid/good thing to rmmod a kernel, and in practice,
it is often impossible to make module remove race-free.  Some maintainers
therefore don't take even basic precautions to avoid the most obvious race
problems.

So if you have something which is automatically unloading modules --- don't. 
It's not supported.   If you can narrow it down to a single module which is
racy on unload, and you can reproduce it, and polite request help from the
module maintainer to fix it, they might feel magnanimous and fix it for you ---
but be warned there are some maintainers (davem comes to mind) who believe so
strenuously that module unloading is evil and shouldn't be supported that even
if you give them a patch to fix some module unload race condition, they may not
accept it.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
