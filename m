From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Soft lockups in mballoc code
Date: Thu, 15 May 2008 15:08:06 +0530
Message-ID: <20080515093806.GA23507@skywalker>
References: <25037.1210612895@alphaville.zko.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:51210 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYEOJi1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 05:38:27 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4F9cAmY025491
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 15:08:10 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4F9c0Ro888844
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 15:08:00 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4F9cAwJ000747
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 15:08:10 +0530
Content-Disposition: inline
In-Reply-To: <25037.1210612895@alphaville.zko.hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2008 at 01:21:35PM -0400, Nick Dokos wrote:
> I keep getting soft lockups in mballoc code, running fsstress.
> I'm running a 2.6.25.2 kernel, with 1.40.8 e2fsprogs. Here
> is sample console output on a 2-cpu Opteron box with a 2Tb filesystem -
> the two stack traces keep repeating every minute or so and the only
> way to get out is to reset the box:

What is the block size with which the file system is created. I would
also suggest testing with the latest kernel and see if you can
reproduce the same. While testing with the latest kernel please also
use the below patch.

http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4-mballoc-fix-mb-_nornalize_request-for-1K-blksz.patch;h=f7b91a6186b7b469ad798ddc95e76ece69b47c24;hb=HEAD


-aneesh
