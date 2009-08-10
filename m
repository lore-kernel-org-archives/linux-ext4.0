From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 14:34:41 GMT
Message-ID: <200908101434.n7AEYf8T001034@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38027 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbZHJOek (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 10:34:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7AEYfUf001035
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 14:34:41 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909


Leonardo Mosquera <wingsofthehydra@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wingsofthehydra@gmail.com




--- Comment #15 from Leonardo Mosquera <wingsofthehydra@gmail.com>  2009-08-10 14:34:40 ---
You mentioned this happens in all filesystems so it's not an EXT4 problem.
You also said it's a USB drive, which leads me to think it might be the
following issue with the ehci_hcd kernel module, which I also have:
http://bugzilla.kernel.org/show_bug.cgi?id=11159

You can verify this by tailing /var/log/kern.log and looking for USB related
errors when pv's traffic stalls.

The current lame fixup is to rmmod ehci_hcd, thus switching to USB 1.1 and
limiting transfer rate to 1.5MB/s. I also suggest you try to md5 without
ehci_hcd to see if the problem stops happening.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
