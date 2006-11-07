From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: Fw: Re: ICP, 3ware,  Areca?
Date: Tue, 07 Nov 2006 14:59:52 -0600
Message-ID: <1162933193.8123.36.camel@kleikamp.austin.ibm.com>
References: <20061107114724.9c2cc644.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56741 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1752787AbWKGVAA
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Nov 2006 16:00:00 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA7Kxxtf022557
	for <linux-ext4@vger.kernel.org>; Tue, 7 Nov 2006 15:59:59 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA7Kxthp347612
	for <linux-ext4@vger.kernel.org>; Tue, 7 Nov 2006 13:59:58 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA7Kxtex011959
	for <linux-ext4@vger.kernel.org>; Tue, 7 Nov 2006 13:59:55 -0700
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061107114724.9c2cc644.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-11-07 at 11:47 -0800, Andrew Morton wrote:
> Why is ext3 slow??

Allocation?  I don't see anything indicating that Bill is overwriting an
existing file, so there is block allocation and journaling overhead.  If
that's the case, it would be interesting to see how fast ext3 is when
overwriting a file.  Extents and delayed allocation should improve on
this a lot.  

> Begin forwarded message:
> 
> Date: Tue, 7 Nov 2006 09:47:17 -0500
> From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
> To: Arne Schmitz <arne.schmitz@gmx.net>
> Cc: linux-ide-arrays@lists.math.uh.edu
> Subject: Re: ICP, 3ware,  Areca?
> 
> 
> On Tue, Nov 07, 2006 at 03:25:04PM +0100, Arne Schmitz wrote:
> > Has anyone information about how current ICP and Areca hardware performs under 
> > Linux? We are currently running kernel 2.6.17 and have two offers, one with 
> > an Areca ARC-1220 8-port, and one with an ICP 9087MA 8-port. Does either of 
> > them make trouble running a (64 bit) Linux?
> > 
> > At the moment we only have two 3ware controllers running on 32 bit Linux.
> 
> On Fri, 18 Aug 2006, I wrote to the list:
> 
>    I've been doing sequential raw disk I/O testing with both Jens Axboe's
>    "fio" using libaio and iodepths up to 32, as well as a basic
>    "dd if=/dev/zero oflag=direct".
> 
>    Reads look fine; a zone read test shows 360 MiB/s at the start of the disk,
>    190 MiB/s at the end.  I see similarly high numbers doing direct reads via
>    ext3.

This would indicate that indirect block lookups themselves aren't a
problem.

>    Summary:
> 
>    Raw partition: 228 MiB/s
>    XFS:           228 MiB/s
>    Ext3:      139-151 MiB/s
-- 
David Kleikamp
IBM Linux Technology Center
