From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: seekwatcher IO visualization
Date: Thu, 9 Aug 2007 22:01:11 -0500
Message-ID: <20070809220111.24d782cd@gara>
References: <20070809205355.GB6689@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54233 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbXHJDDv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2007 23:03:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l7A33png013118
	for <linux-ext4@vger.kernel.org>; Thu, 9 Aug 2007 23:03:51 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7A33ohM439310
	for <linux-ext4@vger.kernel.org>; Thu, 9 Aug 2007 23:03:51 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7A33oo9000926
	for <linux-ext4@vger.kernel.org>; Thu, 9 Aug 2007 23:03:50 -0400
In-Reply-To: <20070809205355.GB6689@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 9 Aug 2007 14:53:55 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> I saw on #linuxfs today some graphs and movies by Chris Mason showing
> the poor IO locality for ext3 compared to btrfs and XFS.  It would be
> interesting to run this with ext4+mballoc+delalloc, and a separate
> one with the FLEXBG feature enabled to see how that improves the
> seeking/locality.
> 
> http://oss.oracle.com/~mason/seekwatcher/
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

I was planing to use seekwatcher to look at fsck activity when using
FLEX_BG since I'm already seeing noticeable improvements by using this
feature alone.

We can try other workloads and see how ext4 compares.

-JRS
