From: Christian Ohm <chr.ohm@gmx.net>
Subject: Re: How to recover a damaged ext4 file system?
Date: Thu, 12 Feb 2009 22:36:24 +0100
Message-ID: <20090212213624.GA17744@moongate.localnet>
References: <20090105135347.GA3337@localdomain> <20090106120527.GT3932@webber.adilger.int> <20090106193404.GA18957@mit.edu> <20090207162725.GA27086@moongate.localnet> <498DDB26.3080102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50475 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750896AbZBLVjJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Feb 2009 16:39:09 -0500
Content-Disposition: inline
In-Reply-To: <498DDB26.3080102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Saturday,  7 February 2009 at 13:04, Eric Sandeen wrote:
> that's counting "cylinders" - try "fdisk -u" to be able to display (or
> specify) geometry in sectors, which is not a unit open to interpretation...

Corrupted disk:

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0xaaaaaaaa

   Device Boot      Start         End      Blocks   Id  System
   /dev/sdc1               1  1953520064   976760032   83  Linux

New partition:

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Disk identifier: 0xaaaaaaaa

   Device Boot      Start         End      Blocks   Id  System
   /dev/sdc1              63  1953520064   976760001   83  Linux


Both disks show the exact same size in sectors (in the kernel messages as
well), so the new partition on the new drive should be exactly the same as the
one on the old drive. For some reason the new partition starts at sector 63,
while the old one starts at sector 1 - but that could be a difference in
creating the partitions (unless sector 1 is an invalid starting sector?).

Best regards,
Christian Ohm

