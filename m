From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12679] 2.6.28.4 ext4 fs hang, load 22 and up, may be firefox/apps stuck on sync_page
Date: Mon,  9 Feb 2009 08:07:14 -0800 (PST)
Message-ID: <20090209160714.2B52410800D@picon.linux-foundation.org>
References: <bug-12679-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbZBIQHQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 11:07:16 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n19G7E3D025798
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 08:07:15 -0800
In-Reply-To: <bug-12679-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12679





------- Comment #2 from sandeen@redhat.com  2009-02-09 08:07 -------
You might do:
# dmesg -c

then attach the output of:
# echo w > /proc/sysrq-trigger"
# dmesg


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
