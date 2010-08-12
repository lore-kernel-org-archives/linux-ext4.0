From: Evan Jones <evanj@MIT.EDU>
Subject: Intel SSD data loss: Any possible way this is user / software error?
Date: Thu, 12 Aug 2010 17:02:19 -0400
Message-ID: <4C64615B.70308@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:54340 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933653Ab0HLVCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 17:02:22 -0400
Received: from outgoing.mit.edu (OUTGOING-AUTH.MIT.EDU [18.7.22.103])
	by mailhub-auth-3.mit.edu (8.13.8/8.9.2) with ESMTP id o7CL2L6n016546
	for <linux-ext4@vger.kernel.org>; Thu, 12 Aug 2010 17:02:21 -0400
Received: from [18.26.0.45] (algoza.csail.mit.edu [18.26.0.45])
	(authenticated bits=0)
        (User authenticated as evanj@CSAIL.MIT.EDU@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.13.6/8.12.4) with ESMTP id o7CL2K8D016295
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 12 Aug 2010 17:02:21 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm testing a few systems that attempt to log data to disk reliably. I 
bought a brand new Intel SSD (X25-M G2) for this purpose. It appears to 
me that this disk does *not* store data reliably when there are power 
failures, even with write barriers, even with the cache disabled. I'm 
surprised that this disk might be this broken (possible), but it may 
also mean I've made a mistake. Is there any possible way that I have a 
bug in the test described below? The test works as expected with a 
couple SATA magnetic disks.


Configuration:

* Linux 2.6.32 (a distributed with Ubuntu 10.04)
* SATA SSD directly attached to the system's built-in controller (Intel 
N10/ICH7)
* ext4 with default options (meaning barrier=1)
* Disable the write cache (hdparm -W 0 /dev/sdb)


The test:

1. Write a 64 MB file of zeros (first use fallocate, then zero fill)
2. fsync()
3. write() blocks of this file with a sequence number.
4. fdatasync()
5. Send UDP packet reporting the sequence number written.
6. Go to 3.

While this test is running, I pull the power out of the drive to 
simulate a hard failure. On the magnetic disks I have, this works as 
expected: On reboot, the log file contains the complete record that was 
reported as last written (it may also contain part of the next record).

On the X25-M, when I use large writes (128 kB), it loses data fairly 
frequently (every couple attempts): I either see the last log record as 
being before the reported one, or occasionally I get a media error when 
reading back the file.

I'm surprised that this disk could be this broken, but I suppose it is 
possible. Any help is welcomed. Thanks,

Evan Jones

-- 
Evan Jones
http://evanjones.ca/
