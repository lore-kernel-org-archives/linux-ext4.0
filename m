From: Andrew Morton <akpm@osdl.org>
Subject: Fw: Re: ICP, 3ware,  Areca?
Date: Tue, 7 Nov 2006 11:47:24 -0800
Message-ID: <20061107114724.9c2cc644.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53405 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752997AbWKGTr1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Nov 2006 14:47:27 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id kA7JlOoZ009473
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 7 Nov 2006 11:47:26 -0800
Received: from akpm.corp.google.com (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id kA7JlOvV013956
	for <linux-ext4@vger.kernel.org>; Tue, 7 Nov 2006 11:47:24 -0800
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Why is ext3 slow??


Begin forwarded message:

Date: Tue, 7 Nov 2006 09:47:17 -0500
From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
To: Arne Schmitz <arne.schmitz@gmx.net>
Cc: linux-ide-arrays@lists.math.uh.edu
Subject: Re: ICP, 3ware,  Areca?


On Tue, Nov 07, 2006 at 03:25:04PM +0100, Arne Schmitz wrote:
> Has anyone information about how current ICP and Areca hardware performs under 
> Linux? We are currently running kernel 2.6.17 and have two offers, one with 
> an Areca ARC-1220 8-port, and one with an ICP 9087MA 8-port. Does either of 
> them make trouble running a (64 bit) Linux?
> 
> At the moment we only have two 3ware controllers running on 32 bit Linux.

On Fri, 18 Aug 2006, I wrote to the list:

   I've been doing sequential raw disk I/O testing with both Jens Axboe's
   "fio" using libaio and iodepths up to 32, as well as a basic
   "dd if=/dev/zero oflag=direct".

   Reads look fine; a zone read test shows 360 MiB/s at the start of the disk,
   190 MiB/s at the end.  I see similarly high numbers doing direct reads via
   ext3.

   Unfortunately, no matter what I do on the write side, I don't see
   more than 72 MiB/s for a sequential direct I/O write to the raw disk.
   I've tried the deadline and noop schedulers, boosted nr_requests and
   toyed with various i/o sizes and queue depths using fio.  I was expecting
   sequential writes in the range of 120-150 MiB/s, based on the (now
   ancient) tweakers.net review and various other info.  [Copying /dev/zero  
   to tmpfs on this box yields ~860 MiB/s.]

   The machine is a Tyan 2882 dual Opteron with 8GB RAM and an Areca 1220
   / 128MB BBU and 8xWDC WD2500JS-00NCB1 250.1GB 7200 RPM configured as a
   RAID6 with chunk size 64K.  [System volume is on an separate MD RAID1 on  
   the Nvidia controller.]  It's running FC4 x86_64 with a custom-built
   2.6.17.7 kernel and the arcmsr driver from scsi-misc GIT, which is
   basically 1.20.0X.13 + fixes.  The firmware is V1.41 2006-5-24.

Chris Caputo suggested:

   I'd run a test with write cache on and one with write cache off and
   compare the results.  The difference can be vast and depending on your
   application it may be okay to run with write cache on.

And I reported back on Tue, 22 Aug 2006:

   Forcing disk write caching on certainly changes the results
   (and the risk profile, of course).  For the archives, here are
   some simple "dd" and "fio" odirect results. These benchmarks
   were run with defaults (CFQ scheduler, nr_request = 128).

   ...

   Summary:

   Raw partition: 228 MiB/s
   XFS:           228 MiB/s
   Ext3:      139-151 MiB/s


Regards,

   Bill Rugolsky
