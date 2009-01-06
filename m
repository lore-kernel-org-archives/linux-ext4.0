From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Tue,  6 Jan 2009 15:57:26 -0800 (PST)
Message-ID: <20090106235726.AEDC810800E@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbZAFX52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 18:57:28 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06NvQ2L013679
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 15:57:27 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #8 from devzero@web.de  2009-01-06 15:57 -------
so it does NOT happen with some modules excluded and it does also NOT happen
when just trying the excluded modules ?

that`s weird.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
