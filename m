From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14354] Bad corruption with 2.6.32-rc1 and upwards
Date: Sat, 17 Oct 2009 06:01:46 GMT
Message-ID: <200910170601.n9H61kB3006548@demeter.kernel.org>
References: <bug-14354-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49840 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZJQGBm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Oct 2009 02:01:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9H61kVb006549
	for <linux-ext4@vger.kernel.org>; Sat, 17 Oct 2009 06:01:46 GMT
In-Reply-To: <bug-14354-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14354





--- Comment #71 from Alexey Fisher <bug-track@fisher-privat.net>  2009-10-17 06:01:45 ---
you don't have to edit init script, all you need is to boot with "break=mount".
On ubuntu/debian this will stop boot in initrd  without mounted root. After
this you can mount it read only or what ever you need. But you can't fsck it,
initrd do not include such tools. Continue:
mount -o ro /dev/sda1_your_root /root
mount -o bind /dev /root/dev
chroot /root /bin/bash

now you'll have clean mount without any other corruptions caused by init script
bug.

Please can anyone place this "auto_da_alloc=0". On my system this work around
data lost issue. Can any one confirm this too?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
