From: Shehjar Tikoo <shehjart@cse.unsw.edu.au>
Subject: ext4 pre-allocation performance  through nfsd
Date: Sat, 19 Jul 2008 10:37:16 +1000
Message-ID: <4881373C.10404@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:56332 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbYGSAvu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 20:51:50 -0400
Received: From
	[203.143.160.170] ([203.143.160.170] == chaos.ken.nicta.com.au) (auth-user shehjart) (cse-authentic-sender shehjart)
	(for <linux-ext4@vger.kernel.org>) By tone With Smtp ;
	Sat, 19 Jul 2008 10:51:47 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All

FYI, I ran some performance tests for a feature that incorporates 
pre-allocation support into linux nfsd. The patch is a 
proof-of-concept but the measurements are still relevant for this list.

1. Sequential read throughput with iozone reading a file written
using various pre-allocation sizes through nfsd:
http://www.gelato.unsw.edu.au/~shehjart/docs/nfsmeasurements/ext4fallocate_read.png

2. Sequential write throughput with iozone over NFS mount with the 
nfsd writing the file contents to disk using pre-allocation.
http://www.gelato.unsw.edu.au/~shehjart/docs/nfsmeasurements/ext4fallocate_write.png

Please see the following thread for more details.
http://thread.gmane.org/gmane.linux.nfs/21365

 From the write throughput plot, its clear that pre-allocation would be
highly beneficial if the pre-allocation overhead can be reduced.


Thanks
Shehjar
