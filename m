From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Barriers per second while doing Odirect Random Writes
Date: Mon, 26 Apr 2010 00:06:17 -0700
Message-ID: <1272265577.9664.57.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36226 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0DZHGT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 03:06:19 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3Q6rnc6015216
	for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 02:53:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3Q76I81133276
	for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 03:06:18 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3Q76IYF030640
	for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 03:06:18 -0400
Received: from [9.65.186.211] (sig-9-65-186-211.mts.ibm.com [9.65.186.211])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o3Q76HYH030595
	for <linux-ext4@vger.kernel.org>; Mon, 26 Apr 2010 03:06:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted and all, 
  While using this FFSB test profile:
http://btrfs.boxacle.net/repository/raid/2010-04-14_2004//ext4-2.6.34-rc3-nobarrier//btrfs1.ffsb.random_writes_odirect__threads_0128.10-04-21_17.38.39/benchmark/profile
(The profile is 128 threads of all odirect random writes. )
on my raid box I am seeing (via Darricks block_barrier tracepoint) right
about 32 barriers per second.

Initial analysis using perf shows kdmflush as the cause. I will continue
to look into this.  

Thanks,
  Keith Mannthey
  LTC FS-Dev 



