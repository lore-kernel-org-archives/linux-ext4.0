From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Fri, 01 Jun 2007 13:57:46 +0530
Message-ID: <1180686466.4619.7.camel@garfield.linsyssoft.com>
References: <1179777153.3910.13.camel@garfield>
	 <p731wgwcbac.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:37231 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbXFAIYE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 04:24:04 -0400
In-Reply-To: <p731wgwcbac.fsf@bingen.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-06-01 at 10:46 +0200, Andi Kleen wrote:
> Kalpak Shah <kalpak@clusterfs.com> writes:
> 
> > Hi,
> > 
> > There have been reported instances of a filesystem having been mounted at 2 places at the same time causing a lot of damage to the filesystem. This patch reserves superblock fields and an INCOMPAT flag for adding multiple mount protection(MMP) support within the ext4 filesystem itself. The superblock will have a block number (s_mmp_block) which will hold a MMP structure which has a sequence number which will be periodically updated every 5 seconds by a mounted filesystem. Whenever a filesystem will be mounted it will wait for s_mmp_interval seconds to make sure that the MMP sequence does not change. To further make sure, we write a random sequence number into the MMP block and wait for another s_mmp_interval secs. If the sequence no. doesn't change then the mount will succeed. In case of failure, the nodename, bdevname and the time at which the MMP block was last updated will be disp
 laye
> >  d. tune2fs can be used to set s_mmp_interval as desired.
> 
> That will make laptop users very unhappy if you spin up their disks every 5 seconds.  And
> even on other systems it might reduce the MTBF if you write the super block much more
> often than before. It might be better to set it up in some way to only increase
> that number when the super block is written for some other reason anyways.

The super block only saves the block number of the MMP block. So the
super block is not updated but the contents of the MMP block are updated
every 5 seconds.

If any user is unhappy with the 5 seconds interval, he can modify the
interval to be greater, with the caveat that it will take 2*mmp_interval
seconds during mounting the filesystem.

Thanks,
Kalpak.

> 
> -Andi
