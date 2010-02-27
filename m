From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Sat, 27 Feb 2010 06:36:37 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:58695 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965891Ab0B0Lgi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 27 Feb 2010 06:36:38 -0500
In-Reply-To: <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sat, 27 Feb 2010, Justin Piszcz wrote:

> 
> 
> On Sat, 27 Feb 2010, Justin Piszcz wrote:
> 
> > 
> > 
> > On Sat, 27 Feb 2010, Justin Piszcz wrote:
> > 
> > > 
> > > 
> > > On Fri, 26 Feb 2010, Eric Sandeen wrote:
> > >
> 
> Hi,
> 
> I have found the same results on 2 different systems:
> 
> It seems to peak at ~350MiB/s performance on mdadm raid, whether
> a RAID-5 or RAID-0 (two separate machines):
> 
> The only option I found that allows it to go from:
> 10737418240 bytes (11 GB) copied, 48.7335 s, 220 MB/s
> to
> 10737418240 bytes (11 GB) copied, 30.5425 s, 352 MB/s
> 
> Is the -o nodelalloc option.
> 
> How come it is not breaking the 350MiB/s barrier is the question?
> 
> Justin.
> 
>

Besides large sequential I/O, ext4 seems to be MUCH faster than XFS when
working with many small files.

EXT4

p63:/r1# sync; /usr/bin/time bash -c 'tar xf linux-2.6.33.tar; sync'
0.18user 2.43system 0:02.86elapsed 91%CPU (0avgtext+0avgdata 5216maxresident)k
0inputs+0outputs (0major+971minor)pagefaults 0swaps
linux-2.6.33  linux-2.6.33.tar
p63:/r1# sync; /usr/bin/time bash -c 'rm -rf linux-2.6.33; sync'
0.02user 0.98system 0:01.03elapsed 97%CPU (0avgtext+0avgdata 5216maxresident)k
0inputs+0outputs (0major+865minor)pagefaults 0swaps

XFS

p63:/r1# sync; /usr/bin/time bash -c 'tar xf linux-2.6.33.tar; sync'
0.20user 2.62system 1:03.90elapsed 4%CPU (0avgtext+0avgdata 5200maxresident)k
0inputs+0outputs (0major+970minor)pagefaults 0swaps
p63:/r1# sync; /usr/bin/time bash -c 'rm -rf linux-2.6.33; sync'
0.03user 2.02system 0:29.04elapsed 7%CPU (0avgtext+0avgdata 5200maxresident)k
0inputs+0outputs (0major+864minor)pagefaults 0swaps

So I guess that's the tradeoff, for massive I/O you should use XFS, else,
use EXT4?

I still would like to know however, why 350MiB/s seems to be the maximum
performance I can get from two different md raids (that easily do 600MiB/s
with XFS).

Is this a performance issue within ext4 and md-raid?
The problem does not exist with xfs and md-raid.

Justin.


