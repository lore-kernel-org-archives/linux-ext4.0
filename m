From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12594] filesystem corruption while running bonnie
Date: Sun,  1 Feb 2009 08:14:58 -0800 (PST)
Message-ID: <20090201161458.8BFA5108040@picon.linux-foundation.org>
References: <bug-12594-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbZBAQPA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Feb 2009 11:15:00 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n11GEw1u008405
	for <linux-ext4@vger.kernel.org>; Sun, 1 Feb 2009 08:14:59 -0800
In-Reply-To: <bug-12594-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12594





------- Comment #1 from sandeen@redhat.com  2009-02-01 08:14 -------
bugme-daemon@bugzilla.kernel.org wrote:

> mkdir /mnt/tmp /tmp/tmp ; mount -t tmpfs /dev/null /mnt
> chown folkert /mnt/tmp /tmp/tmp
> 
> and then in parallel:
> while [ 1 ] ; do bonnie++ -d /tmp/tmp -s 128 -r 64 -x 1 -u folkert ; done
> while [ 1 ] ; do bonnie++ -d /mnt/tmp -s 128 -r 64 -x 1 -u folkert ; done
> 
> then after say 15 minutes i run the reboot command (normal via init) during the
> fsck (I always do a touch /forcefsck) I get:
> fsck 1.41.3 (12-Oct-2008)
> /dev/mapper/VGODR-tmp contains a file system with errors, check forced.

Need to look at system logs before this to see why the fs has errors, I
think.

-Eric


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
