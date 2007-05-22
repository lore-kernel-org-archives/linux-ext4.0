From: Manoj Joseph <manoj@clusterfs.com>
Subject: Re: [RFC][PATCH] Multiple mount protection
Date: Tue, 22 May 2007 12:45:09 +0530
Message-ID: <4652987D.70209@clusterfs.com>
References: <1179777153.3910.13.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:51307 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbXEVHPQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2007 03:15:16 -0400
In-Reply-To: <1179777153.3910.13.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kalpak Shah wrote:
> Hi,
> 
> There have been reported instances of a filesystem having been
> mounted at 2 places at the same time causing a lot of damage to the
> filesystem. This patch reserves superblock fields and an INCOMPAT
> flag for adding multiple mount protection(MMP) support within the
> ext4 filesystem itself. The superblock will have a block number
> (s_mmp_block) which will hold a MMP structure which has a sequence
> number which will be periodically updated every 5 seconds by a
> mounted filesystem. Whenever a filesystem will be mounted it will
> wait for s_mmp_interval seconds to make sure that the MMP sequence
> does not change. To further make sure, we write a random sequence
> number into the MMP block and wait for another s_mmp_interval secs.
> If the sequence no. doesn't change then the mount will succeed. In
> case of failure, the nodename, bdevname and the time at which the MMP
> block was last updated will be displayed. tune2fs can be used to set
> s_mmp_interval as desired.

What would the default value of s_mmp_interval be? 5 seconds? more?

If I am not reading this wrong a mount will take more than 
's_mmp_interval' seconds to complete. Wouldn't this be too much of a 
penalty during boot up if the system has many 'mount at boot' filesystems?

Also, I am curious about this. Is there a test case for mounting the 
same filesystem multiple times? Does this use different paths to reach 
the device? Or is there a race? Or does it happen on a device shared by 
multiple hosts?

-Manoj
