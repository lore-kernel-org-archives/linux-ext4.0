From: Marcin M <gmane@mejor.pl>
Subject: kernel thread "flush-254:12" eats 100% CPU
Date: Wed, 07 Sep 2011 17:46:37 +0200
Message-ID: <j483kt$en1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:44899 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab1IGRQy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Sep 2011 13:16:54 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1R1KO6-0008KF-Nn
	for linux-ext4@vger.kernel.org; Wed, 07 Sep 2011 17:50:06 +0200
Received: from cadera.waw.pl ([62.121.127.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 07 Sep 2011 17:50:06 +0200
Received: from gmane by cadera.waw.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 07 Sep 2011 17:50:06 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello!
I hope i'm writing to correct place (but i suspect g.l.kernel list could 
be proper also) :)
I'm observing situation like in subject. From time to time 
"flush-254:12" takes 100% of cpu for a couple of minutes. Then 
everything becomes ok.
This problem appears on my two different boxes.

box A)
bare metal, i686, hardened-kernel-2.6.{37-38}
on this box kernel thread never stops to do 100% of cpu. I've to reboot 
box (using sysrq, because i could't even umount partition associated 
with this thread)
My workarround for it: i changed ext4 to xfs on dm device and problem 
disappeared

box B)
xen, full virtualization, x86_64, kernels: 
hardened-kernel-{2.6.39,3.0.3,3.0.4} and 3.1.0-rc4-git2
problem is as i described above, flush took one cpu for a couple minutes 
and then everythings works correctly.

And again, 254-12 device is ext4 filesystem.
In both cases it was used lvm. At box B, additionaly i'm using dmcrypt. 
Box B is configured in this way: sda->lvm2->dmcrypt->filesystem.

How can i help to debug this problem? Or maybe it's fixed already?

Regards,
Marcin.

