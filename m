From: Vincenzo Ciancia <vincenzo_ml@yahoo.it>
Subject: Re: User permissions or UID/GIDs for portable disks?
Date: Sun, 25 Nov 2007 22:45:05 +0100
Message-ID: <ficqd1$c1b$1@ger.gmane.org>
References: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:49435 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbXKZKpS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2007 05:45:18 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IwbSY-0001RE-K4
	for linux-ext4@vger.kernel.org; Mon, 26 Nov 2007 10:45:09 +0000
Received: from host178-16-dynamic.3-79-r.retail.telecomitalia.it ([79.3.16.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2007 10:45:02 +0000
Received: from vincenzo_ml by host178-16-dynamic.3-79-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Mon, 26 Nov 2007 10:45:02 +0000
In-Reply-To: <46c2f4ab0710241110o582dcc27pbd6d2c31474b526b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bram Neijt ha scritto:
> Dear ext4 developers,
> 
> Currently using ext3 on an usbstick seems to have a few drawbacks.

The problem of identifying a local resource (user ids) in a global
environment (many different computers) has a very simple solution:
consider uids locals when you transmit them, and use an _injective_ map
when mounting the drive to map uids in the drive to uids in the system.
The function has to be non-surjective because uids which differ on the
drive must differ in the system (this might not be a requirement but I
suppose many would appreciate it). This would, however, require support
from on-disk ext4 data format, which should provide a "table of
employied UIDS" to the ext4 kernel module, which should then do the
translation.

The injective map should, of course, be the identity function, unless
differently specified by users.

Is this feasible in anybody's opinion? It seems not such a conservative
extension so I suspect it might cause discussion :)

Alternatively, the ability to just provide a map file from uids and gids
of a disk to those of a system when mounting would be greatly
appreciated - but how to read it from the disk before mounting? Many
concerns arise. Has this already been discussed in the past?

Vincenzo
