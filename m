From: Nathan Roberts <nroberts@yahoo-inc.com>
Subject: Storing inodes in a separate block device?
Date: Thu, 22 May 2008 09:53:59 -0500
Message-ID: <48358907.3010103@yahoo-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mrout1.yahoo.com ([216.145.54.171]:39704 "EHLO mrout1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYEVPHt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2008 11:07:49 -0400
Received: from figurestay-lm.champ.corp.yahoo.com (figurestay-lm.champ.corp.yahoo.com [10.74.90.252])
	by mrout1.yahoo.com (8.13.6/8.13.6/y.out) with ESMTP id m4MErfZv035184
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 07:53:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Has a feature ever been considered (or already exist) for storing inodes 
in a block device separate from the data? Is it even a "reasonable" 
thing to do or are there major pitfalls that one would run into?

The rationale behind this question comes from use cases where a file 
system is storing very large numbers of files. Reading files in these 
file systems will essentially incur at least two seeks: one for the 
inode, one for the data blocks. If the seek to the inode were more 
efficient, dramatic performance gains could be achieved for such use cases.

Fast seeking devices (such as flash based devices) are becoming much 
more mainstream these days and would seem like a reasonable device for 
the inodes. The $/GB is not as good as disks but it's much better than 
DRAM. For many use cases, the number of these "fast access" inodes that 
would need to be cached in RAM is near 0. So, RAM savings are also a 
potential benefit.

I've ran some basic tests using ext4 on a SATA array plus a USB thumb 
drive for the inodes. Even with the slowness of a thumb drive, I was 
able to see encouraging results ( >50% read throughput improvement for a 
mixture of 4K-8K files).

I'm interested in hearing thoughts/potential pitfalls/etc.

Nathan




