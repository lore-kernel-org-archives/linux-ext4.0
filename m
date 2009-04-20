From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
 blocks...
Date: Mon, 20 Apr 2009 12:43:37 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:35859 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbZDTLnj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 07:43:39 -0400
In-Reply-To: <20090420113534.GR19186@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Apr 2009, Theodore Tso wrote:

> On Mon, Apr 20, 2009 at 10:33:09AM +0100, Jeremy Sanders wrote:
>>
>> However, the system seems to mostly work, so I recreated the ext4 device,
>> I've just run my backup script again and fsck'd the device. It seems the
>> problem is reproducible with the new kernel:
>
> When you say reproducible, how many times have you tried it, and were
> you able to reproduce it every single time?  50% of time?  I do
> believe there is a problem, but we haven't been able to something
> where it's easily reproducible.  So if you can easily reproduce this,
> this is definitely very exciting.

It takes a day or two to do the sync. I've only done it twice (one with 
the old kernel, once with the new fedora testing kernel) and it happened 
both times. I'm afraid the statistics are rather low number here.

I did a different faster test (just copying my home directory lots of 
times), but I wasn't able to get it to fail. That test didn't use much 
disk space, however. Maybe it's worth just dd'ing a few TB of data onto 
the device and seeing whether that fails.

>> [root@xback2 ~]# fsck /dev/md0
>> fsck 1.41.4 (27-Jan-2009)
>> e2fsck 1.41.4 (27-Jan-2009)
>> fsck.ext4: Group descriptors look bad... trying backup blocks...
>> Group descriptor 0 checksum is invalid.  Fix<y>?
>
> Do you have to reboot to see this, or is it enough to unmount the
> filesystem?  How big is the ext4 filesystem, and how big was the
> amount of data that you rsync'ed?  One thing that would be worth
> trying if you can easily reproduce is whether it happens on a single
> device disk, or whether it only shows up when you use a /dev/mdX
> device.

I didn't reboot this time - I did last time. I just unmounted the file 
system and fsckd it. The filesystem is 8.2TB and the data is around 2.5TB.

The drives on a 3ware card, so I could configure the card as a single 
raid5 device and try to reproduce it there. It may take a day or two to 
copy the data if I try this.

Jeremy

-- 
Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
X-Ray Group, Institute of Astronomy, University of Cambridge, UK.
Public Key Server PGP Key ID: E1AAE053
