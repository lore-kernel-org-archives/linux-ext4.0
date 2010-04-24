From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Benchmarking data from a raid machine 2.6.34-rc3
Date: Fri, 23 Apr 2010 17:06:18 -0700
Message-ID: <1272067578.9664.40.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:50535 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0DXAGU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Apr 2010 20:06:20 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e39.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o3NNvuoW025922
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 17:57:56 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o3O06JZC126758
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 18:06:19 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o3O06JPj024215
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 18:06:19 -0600
Received: from [9.76.76.183] (sig-9-76-76-183.mts.ibm.com [9.76.76.183])
	by d03av01.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id o3O06ING024202
	for <linux-ext4@vger.kernel.org>; Fri, 23 Apr 2010 18:06:18 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At long last here is a good data set for filesystem comparison.  It is
from 2.6.34-rc3 (unpatched). It compares ext3 ext4 ext4-nobarrier,
btrfs, btrfs-nocow, xfs and jfs on a software raid setup with a decent
spindle count. 

http://btrfs.boxacle.net/repository/raid/2010-04-14_2004/2.6.34-rc3/2.6.34-rc3.html


As we know touring barriers off helps a lot with ext4 on this machine.
I think Steve Pratt send some notification to the btrfs folks. Feel free
to point others at this data.


A history from this setup can be found here:  (mostly btrfs related
data)

http://btrfs.boxacle.net/repository/raid/history/History.html


I hope to be do these large data set runs once in every major kernel
revision life cycle. 

Thanks,
  Keith Mannthey
  LTC FS-Dev 


