From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 1 Mar 2010 04:21:03 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1003010419090.20072@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan> <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan> <20100228054240.GE14646@thunk.org> <alpine.DEB.2.00.1002280628550.22822@p34.internal.lan>
 <832C6227-BF34-43C2-8768-1308C00AB17F@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:39402 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0CAJVG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 04:21:06 -0500
In-Reply-To: <832C6227-BF34-43C2-8768-1308C00AB17F@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 1 Mar 2010, Andreas Dilger wrote:

> On 2010-02-28, at 07:55, Justin Piszcz wrote:
>> === CREATE RAID-0 WITH 11 DISKS
>
>
> Have you tried testing with "nice" numbers of disks in your RAID set (e.g. 8 
> disks for RAID-0, 9 for RAID-5, 10 for RAID-6)?  The mballoc code is really 
> much better tuned for power-of-two sized allocations.

Hi,

Yes, the second system (RAID-5) has 8 disks and it shows the same 
performance problems with ext4 and not XFS (as shown from previous 
e-mail), where XFS usually got 500-600MiB/s for writes.

http://groups.google.com/group/linux.kernel/browse_thread/thread/e7b189bcaa2c1cb4/ad6c2a54b678cf5f?show_docid=ad6c2a54b678cf5f&pli=1

For the RAID-5 (from earlier testing):  <- This one has 8 disks.
-o data=writeback,nobarrier: 
10737418240 bytes (11 GB) copied, 48.7335 s, 220 MB/s 
-o data=writeback,nobarrier,nodelalloc: 
10737418240 bytes (11 GB) copied, 30.5425 s, 352 MB/s 
An increase of 132MiB/s.

Justin.

