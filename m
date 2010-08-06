From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Raid FFSB Benchmark results for 2.6.35-rc5
Date: Fri, 06 Aug 2010 12:07:13 -0700
Message-ID: <1281121633.7357.26.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58970 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965531Ab0HFTHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Aug 2010 15:07:12 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o76IrJaA001351
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 14:53:19 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o76J7BWY2007284
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 15:07:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o76J7BWi016724
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 15:07:11 -0400
Received: from [9.76.72.32] (sig-9-76-72-32.mts.ibm.com [9.76.72.32])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id o76J79jo016617
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 15:07:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a collection of benchmark runs with the FFSB test suite. The
results are comparable to other raid results on the boxacle server. 

The latest results can be found at: 
http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/2.6.35-rc5.html

I added XFS without barriers and EXT3 with barriers into the mix since
my last data set. 

In general things look about the same.  There are a few cases where ext4
with barriers (default) has gotten better but ext4 without barriers has
gotten worse. 

Thanks,
  Keith Mannthey 
  LTC Local FileSystem 

