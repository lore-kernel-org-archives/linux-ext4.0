From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Intel SSD data loss: Any possible way this is user / software
 error?
Date: Fri, 13 Aug 2010 07:57:14 -0400
Message-ID: <4C65331A.9050203@redhat.com>
References: <4C64615B.70308@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Evan Jones <evanj@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761525Ab0HML5T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Aug 2010 07:57:19 -0400
In-Reply-To: <4C64615B.70308@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Evan Jones wrote:
> I'm testing a few systems that attempt to log data to disk reliably. I
> bought a brand new Intel SSD (X25-M G2) for this purpose. It appears to
> me that this disk does *not* store data reliably when there are power
> failures, even with write barriers, even with the cache disabled. I'm
> surprised that this disk might be this broken (possible), but it may
> also mean I've made a mistake. Is there any possible way that I have a
> bug in the test described below? The test works as expected with a
> couple SATA magnetic disks.
> 
> 
> Configuration:
> 
> * Linux 2.6.32 (a distributed with Ubuntu 10.04)
> * SATA SSD directly attached to the system's built-in controller (Intel
> N10/ICH7)
> * ext4 with default options (meaning barrier=1)
> * Disable the write cache (hdparm -W 0 /dev/sdb)

Just out of curiosity, what do you see when the write cache is on?
Seems counter-intuitive that it'd work better, but talking w/
Ric Wheeler, he was curious... maybe Intel didn't test with the
write cache off?

Also, would you be willing to publish the test you're using?

Thanks,
-Eric

> 
> The test:
> 
> 1. Write a 64 MB file of zeros (first use fallocate, then zero fill)
> 2. fsync()
> 3. write() blocks of this file with a sequence number.
> 4. fdatasync()
> 5. Send UDP packet reporting the sequence number written.
> 6. Go to 3.
> 
> While this test is running, I pull the power out of the drive to
> simulate a hard failure. On the magnetic disks I have, this works as
> expected: On reboot, the log file contains the complete record that was
> reported as last written (it may also contain part of the next record).
> 
> On the X25-M, when I use large writes (128 kB), it loses data fairly
> frequently (every couple attempts): I either see the last log record as
> being before the reported one, or occasionally I get a media error when
> reading back the file.
> 
> I'm surprised that this disk could be this broken, but I suppose it is
> possible. Any help is welcomed. Thanks,
> 
> Evan Jones
> 

