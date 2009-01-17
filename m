From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 10:46:09 -0800 (PST)
Message-ID: <20090117184609.5B7D510800D@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763784AbZAQSqk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 13:46:40 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HIk9QI023635
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 10:46:10 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #23 from devzero@web.de  2009-01-17 10:46 -------
>Note that it is not necessarily guaranteed to be safe to be unloading modules. 

if it`s not safe, those unsafe modules should be marked appropriately that
they cannot be unloaded. at least they should spit out a warning that unloading
should be avoided. there are already lot`s of modules which cannot be
unloaded at all, so it`s just a matter of good will if the others being marked
appropriately. 

if a module is unloadable and this is unsafe and if that module doesn`t tell
that to the user, then i`d call that a bug.
if it DOES tell that and the kernel crashes, then it`s user error.

why i think this way?
i already did lot`s of module testing like this user does, so i did lot`s of
automated module load unload and found the one or other bug with this, but it`s
the first time that someone is telling, that this should NOT be done because
there are developers who do not support this.

i think it`s good that we have people like folkert reporting such issues,
because it enhances kernel quality.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
