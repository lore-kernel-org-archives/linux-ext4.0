From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 01 Mar 2010 10:15:17 -0600
Message-ID: <4B8BE815.50607@redhat.com>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan> <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan> <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan> <20100228054240.GE14646@thunk.org> <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0CAQP0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 11:15:26 -0500
In-Reply-To: <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Piszcz wrote:
> 
> 
> On Sun, 28 Feb 2010, tytso@mit.edu wrote:
> 
>> On Sat, Feb 27, 2010 at 06:36:37AM -0500, Justin Piszcz wrote:
>>>
>>> I still would like to know however, why 350MiB/s seems to be the maximum
>>> performance I can get from two different md raids (that easily do
>>> 600MiB/s
>>> with XFS).
> 
>> Can you run "filefrag -v <filename>" on the large file you created
>> using dd?  Part of the problem may be the block allocator simply not
>> being well optimized super large writes.  To be honest, that's not
>> something we've tried (at all) to optimize, mainly because for most
>> users of ext4 they're more interested in much more reasonable sized
>> files, and we only have so many hours in a day to hack on ext4.  :-)
>> XFS in contrast has in the past had plenty of paying customers
>> interested in writing really large scientific data sets, so this is
>> something Irix *has* spent time optimizing.
> Yes, this is shown at the bottom of the e-mail both with -o data=ordered
> and data=writeback.

...

> === SHOW FILEFRAG OUTPUT (NOBARRIER,ORDERED)
> 
> p63:/r1# filefrag -v /r1/bigfile Filesystem type is: ef53
> File size of /r1/bigfile is 10737418240 (2621440 blocks, blocksize 4096)
>  ext logical  physical  expected length flags
>    0       0     34816            32768
>    1   32768     67584            30720
>    2   63488    100352     98303  32768
>    3   96256    133120            30720
>    4  126976    165888    163839  32768
>    5  159744    198656            30720
...

That looks pretty good.

I think Dave's suggesting of seeing what cpu usage looks like is a good one.

Running blktrace on xfs vs. ext4 could possibly also shed some light.

-Eric
