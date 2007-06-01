From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: 01 Jun 2007 10:46:19 +0200
Message-ID: <p731wgwcbac.fsf@bingen.suse.de>
References: <1179777153.3910.13.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:45608 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXFAHtv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2007 03:49:51 -0400
In-Reply-To: <1179777153.3910.13.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah <kalpak@clusterfs.com> writes:

> Hi,
> 
> There have been reported instances of a filesystem having been mounted at 2 places at the same time causing a lot of damage to the filesystem. This patch reserves superblock fields and an INCOMPAT flag for adding multiple mount protection(MMP) support within the ext4 filesystem itself. The superblock will have a block number (s_mmp_block) which will hold a MMP structure which has a sequence number which will be periodically updated every 5 seconds by a mounted filesystem. Whenever a filesystem will be mounted it will wait for s_mmp_interval seconds to make sure that the MMP sequence does not change. To further make sure, we write a random sequence number into the MMP block and wait for another s_mmp_interval secs. If the sequence no. doesn't change then the mount will succeed. In case of failure, the nodename, bdevname and the time at which the MMP block was last updated will be displa
 ye
>  d. tune2fs can be used to set s_mmp_interval as desired.

That will make laptop users very unhappy if you spin up their disks every 5 seconds.  And
even on other systems it might reduce the MTBF if you write the super block much more
often than before. It might be better to set it up in some way to only increase
that number when the super block is written for some other reason anyways.

-Andi
