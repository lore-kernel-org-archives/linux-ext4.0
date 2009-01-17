From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Sat, 17 Jan 2009 10:27:50 -0800 (PST)
Message-ID: <20090117182750.24065108040@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760402AbZAQS2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 13:28:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0HIRocH022712
	for <linux-ext4@vger.kernel.org>; Sat, 17 Jan 2009 10:27:51 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #20 from tytso@mit.edu  2009-01-17 10:27 -------
P.S. There are a few modules that I manually unload, such as ehci_ucd and
uhci_ucd for power management reasons, but that's basically because the USB
folks haven't given us better ways of turning off USB or to better manage USB's
power consumption when running on batteries. But it's better to consider that
you have a safe list of modules that which can be unloaded safely, and to do so
by hand, rather by some automatic program.

P.P.S. In any case, it's pretty clear this isn't a filesystem bug.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
