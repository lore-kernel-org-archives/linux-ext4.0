From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12354] Advisory: Debian's current initramdisk scripts break with an ext4 root
Date: Sun,  4 Jan 2009 10:14:33 -0800 (PST)
Message-ID: <20090104181433.645BF10800F@picon.linux-foundation.org>
References: <bug-12354-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbZADSPF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 13:15:05 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n04IEXqA017806
	for <linux-ext4@vger.kernel.org>; Sun, 4 Jan 2009 10:14:34 -0800
In-Reply-To: <bug-12354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12354





------- Comment #1 from jimsantelmo@gmail.com  2009-01-04 10:14 -------
  I traced the problem thru the Debian initrd scripts to klibc/bin/fstype and
have filed a Debian bug on it. If kernel-hackers are the ultimate upstream
klibc source, please let me know and I'll refile it in other/klibc/kinit.

# /usr/lib/klibc/bin/fstype /dev/sda5 //a 100% made-from-scratch ext4 fs
FSTYPE=ext3
FSSIZE=12000649216


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
