From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Sat, 27 Feb 2010 05:51:15 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com>
 <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:34705 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301Ab0B0KvQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Feb 2010 05:51:16 -0500
In-Reply-To: <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 27 Feb 2010, Justin Piszcz wrote:

> 
> 
> On Fri, 26 Feb 2010, Eric Sandeen wrote:
> 
> > Eric Sandeen wrote:
> >
> > Oh, you need very recent util-linux-ng as well, and use libblkid from there
> > with:
> >
> > [e2fsprogs] # ./configure --disable-libblkid
> >
> > Otherwise you can just feed mkfs.ext4 stripe & stride manually.
> >
> > -Eric
> >


I also tried with the default chunk size (64KiB) incase ext4 had a problem
with chunk sizes > 64KiB, the results were the same for ext4, I also tried
ext2 & ext3 as well just to see what their performance would be:

p63:~# mkfs.ext2 -b 4096 -E stride=16,stripe-width=176 /dev/md0
p63:~# mount /dev/md0 /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10737418240 bytes (11 GB) copied, 19.9434 s, 538 MB/s
p63:/r1#

p63:~# mkfs.ext3 -b 4096 -E stride=16,stripe-width=176 /dev/md0
p63:~# mount /dev/md0 /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10737418240 bytes (11 GB) copied, 31.0195 s, 346 MB/s

p63:~# mkfs.ext4 -b 4096 -E stride=16,stripe-width=176 /dev/md0
p63:~# mount /dev/md0 /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10737418240 bytes (11 GB) copied, 35.3866 s, 303 MB/s

And, for comparison, XFS:
p63:~# mkfs.xfs -f /dev/md0 > /dev/null 2>&1
p63:~# mount /dev/md0 /r1
p63:~# cd /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 18.1527 s, 592 MB/s
p63:/r1#

