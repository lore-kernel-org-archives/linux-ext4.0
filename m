From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Fw: Re: ICP, 3ware,  Areca?
Date: Tue, 07 Nov 2006 22:55:03 +0300
Message-ID: <m3ac332fs8.fsf@bzzz.home.net>
References: <20061107114724.9c2cc644.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:18409 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1752334AbWKGTzV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Nov 2006 14:55:21 -0500
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061107114724.9c2cc644.akpm@osdl.org> (Andrew Morton's message of "Tue, 7 Nov 2006 11:47:24 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


can we get vmstat 1 output for the run?

thanks, Alex

>>>>> Andrew Morton (AM) writes:

 AM> Why is ext3 slow??


 AM> Begin forwarded message:

 AM> Date: Tue, 7 Nov 2006 09:47:17 -0500
 AM> From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
 AM> To: Arne Schmitz <arne.schmitz@gmx.net>
 AM> Cc: linux-ide-arrays@lists.math.uh.edu
 AM> Subject: Re: ICP, 3ware,  Areca?


 AM> On Tue, Nov 07, 2006 at 03:25:04PM +0100, Arne Schmitz wrote:
 >> Has anyone information about how current ICP and Areca hardware performs under 
 >> Linux? We are currently running kernel 2.6.17 and have two offers, one with 
 >> an Areca ARC-1220 8-port, and one with an ICP 9087MA 8-port. Does either of 
 >> them make trouble running a (64 bit) Linux?
 >> 
 >> At the moment we only have two 3ware controllers running on 32 bit Linux.

 AM> On Fri, 18 Aug 2006, I wrote to the list:

 AM>    I've been doing sequential raw disk I/O testing with both Jens Axboe's
 AM>    "fio" using libaio and iodepths up to 32, as well as a basic
 AM>    "dd if=/dev/zero oflag=direct".

 AM>    Reads look fine; a zone read test shows 360 MiB/s at the start of the disk,
 AM>    190 MiB/s at the end.  I see similarly high numbers doing direct reads via
 AM>    ext3.

 AM>    Unfortunately, no matter what I do on the write side, I don't see
 AM>    more than 72 MiB/s for a sequential direct I/O write to the raw disk.
 AM>    I've tried the deadline and noop schedulers, boosted nr_requests and
 AM>    toyed with various i/o sizes and queue depths using fio.  I was expecting
 AM>    sequential writes in the range of 120-150 MiB/s, based on the (now
 AM>    ancient) tweakers.net review and various other info.  [Copying /dev/zero  
 AM>    to tmpfs on this box yields ~860 MiB/s.]

 AM>    The machine is a Tyan 2882 dual Opteron with 8GB RAM and an Areca 1220
 AM>    / 128MB BBU and 8xWDC WD2500JS-00NCB1 250.1GB 7200 RPM configured as a
 AM>    RAID6 with chunk size 64K.  [System volume is on an separate MD RAID1 on  
 AM>    the Nvidia controller.]  It's running FC4 x86_64 with a custom-built
 AM>    2.6.17.7 kernel and the arcmsr driver from scsi-misc GIT, which is
 AM>    basically 1.20.0X.13 + fixes.  The firmware is V1.41 2006-5-24.

 AM> Chris Caputo suggested:

 AM>    I'd run a test with write cache on and one with write cache off and
 AM>    compare the results.  The difference can be vast and depending on your
 AM>    application it may be okay to run with write cache on.

 AM> And I reported back on Tue, 22 Aug 2006:

 AM>    Forcing disk write caching on certainly changes the results
 AM>    (and the risk profile, of course).  For the archives, here are
 AM>    some simple "dd" and "fio" odirect results. These benchmarks
 AM>    were run with defaults (CFQ scheduler, nr_request = 128).

 AM>    ...

 AM>    Summary:

 AM>    Raw partition: 228 MiB/s
 AM>    XFS:           228 MiB/s
 AM>    Ext3:      139-151 MiB/s


 AM> Regards,

 AM>    Bill Rugolsky
 AM> -
 AM> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
 AM> the body of a message to majordomo@vger.kernel.org
 AM> More majordomo info at  http://vger.kernel.org/majordomo-info.html
