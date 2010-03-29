From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Ext4 performance regression:  Post 2.6.30
Date: Sun, 28 Mar 2010 23:25:35 -0700
Message-ID: <1269843935.13369.52.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49610 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0C2GZY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 02:25:24 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e8.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2T6Gdw5030946
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 02:16:39 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2T6PLxh094716
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 02:25:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2T6PLks032659
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 02:25:21 -0400
Received: from [9.65.56.193] (sig-9-65-56-193.mts.ibm.com [9.65.56.193])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o2T6PKY1032649
	for <linux-ext4@vger.kernel.org>; Mon, 29 Mar 2010 02:25:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



After 2.6.30 I am seeing large performance regressions on a raid setup.
I am working to publish a larger amount of data but I wanted to get some
quick data out about what I am seeing. 

The test (FFSB test suite) I am running is basically random direct io
writes.  The below data is from 128 threads all doing these random
writes. 1 and 32 thread results are not as drastically bad but 2.6.30
has the strongest results.  

  Under a mailserver workload I see similar performance impacts at this
same kernel change point.  I hope to publish better data soon.  Several
other workload types do not show this performance regression. 
 

2.6.30:

Total Results
===============
             Op Name   Transactions	 Trans/sec	% Trans	    % Op Weight
Throughput
             =======   ============	 =========	=======	    ===========
==========
               write :      9015040	  29561.46	100.000%		100.000%
115MB/sec
-
29561.46 Transactions per Second


Any kernel past 2.6.30.  This is from 2.6.31-rc1:

Total Results
===============
             Op Name   Transactions	 Trans/sec	% Trans	    % Op Weight
Throughput
             =======   ============	 =========	=======	    ===========
==========
               write :      3185920	  10120.50	100.000%		100.000%
39.5MB/sec
