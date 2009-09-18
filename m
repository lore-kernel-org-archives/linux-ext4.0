From: Andreas Dilger <adilger@sun.com>
Subject: Re: Does ext4 perform online update of the bad blocks inode?
Date: Fri, 18 Sep 2009 15:11:00 -0600
Message-ID: <20090918211100.GG2537@webber.adilger.int>
References: <loom.20090918T221210-583@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Francesco Pretto <ceztkoml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56420 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbZIRVK4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 17:10:56 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8ILB0tk019147
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 14:11:00 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KQ600M00QHEU600@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Fri,
 18 Sep 2009 14:11:00 -0700 (PDT)
In-reply-to: <loom.20090918T221210-583@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 18, 2009  20:26 +0000, Francesco Pretto wrote:
> Does ext4 update the bad blocks inode when a read/write failure is
> detected in a mounted filesystem? If not, is safe a daily/weekly
> "fsck.ext4 -n -c device" on a mounted filesystem? Would be safe even
> on a raid volume?

This isn't even safe on an UNMOUNTED filesystem, since "badblocks"
by default does destructive testing of the block device.  Since most
disks will internally relocate bad blocks on writes, it is very
unlikely that "badblocks" will ever find a problem on a new disk.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

