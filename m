From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
	blocks...
Date: Mon, 20 Apr 2009 07:35:34 -0400
Message-ID: <20090420113534.GR19186@mit.edu>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47010 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbZDTLfp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2009 07:35:45 -0400
Content-Disposition: inline
In-Reply-To: <gshfgl$o6m$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 20, 2009 at 10:33:09AM +0100, Jeremy Sanders wrote:
> 
> However, the system seems to mostly work, so I recreated the ext4 device, 
> I've just run my backup script again and fsck'd the device. It seems the 
> problem is reproducible with the new kernel:

When you say reproducible, how many times have you tried it, and were
you able to reproduce it every single time?  50% of time?  I do
believe there is a problem, but we haven't been able to something
where it's easily reproducible.  So if you can easily reproduce this,
this is definitely very exciting.

> [root@xback2 ~]# fsck /dev/md0
> fsck 1.41.4 (27-Jan-2009)
> e2fsck 1.41.4 (27-Jan-2009)
> fsck.ext4: Group descriptors look bad... trying backup blocks...
> Group descriptor 0 checksum is invalid.  Fix<y>?

Do you have to reboot to see this, or is it enough to unmount the
filesystem?  How big is the ext4 filesystem, and how big was the
amount of data that you rsync'ed?  One thing that would be worth
trying if you can easily reproduce is whether it happens on a single
device disk, or whether it only shows up when you use a /dev/mdX
device.

Thanks,

						- Ted
