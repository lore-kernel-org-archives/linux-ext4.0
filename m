From: Dave Chinner <david@fromorbit.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Mon, 1 Mar 2010 10:50:24 +1100
Message-ID: <20100228235024.GF22370@discord.disaster>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com> <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan> <4B887160.2090606@redhat.com> <4B887548.50508@redhat.com> <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan> <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan> <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan> <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Feb 27, 2010 at 06:36:37AM -0500, Justin Piszcz wrote:
> Besides large sequential I/O, ext4 seems to be MUCH faster than XFS when
> working with many small files.
>
> EXT4
>
> p63:/r1# sync; /usr/bin/time bash -c 'tar xf linux-2.6.33.tar; sync'
> 0.18user 2.43system 0:02.86elapsed 91%CPU (0avgtext+0avgdata 5216maxresident)k
> 0inputs+0outputs (0major+971minor)pagefaults 0swaps
> linux-2.6.33  linux-2.6.33.tar
> p63:/r1# sync; /usr/bin/time bash -c 'rm -rf linux-2.6.33; sync'
> 0.02user 0.98system 0:01.03elapsed 97%CPU (0avgtext+0avgdata 5216maxresident)k
> 0inputs+0outputs (0major+865minor)pagefaults 0swaps
>
> XFS
>
> p63:/r1# sync; /usr/bin/time bash -c 'tar xf linux-2.6.33.tar; sync'
> 0.20user 2.62system 1:03.90elapsed 4%CPU (0avgtext+0avgdata 5200maxresident)k
> 0inputs+0outputs (0major+970minor)pagefaults 0swaps
> p63:/r1# sync; /usr/bin/time bash -c 'rm -rf linux-2.6.33; sync'
> 0.03user 2.02system 0:29.04elapsed 7%CPU (0avgtext+0avgdata 5200maxresident)k
> 0inputs+0outputs (0major+864minor)pagefaults 0swaps

Mount XFS with "-o logbsize=262144". Metadata intensive workloads on
XFS are log IO bound, so larger log buffer size makes a big
difference. On 2.6.33 kernels on a single 15krpm SCSI drive I've
been getting ~21s for the untar, and 8s for the rm -rf with that
option set. Still slower than ext4, but nowhere near as bad.

> So I guess that's the tradeoff, for massive I/O you should use XFS, else,
> use EXT4?

I wouldn't consider writing an 11GB file "massive IO", nor would I
consider an 600MB/s massive, either, since you can get that out of a
sub-$10k server these days....

> I still would like to know however, why 350MiB/s seems to be the maximum
> performance I can get from two different md raids (that easily do 600MiB/s
> with XFS).

Check whether the dd process on ext4 is CPU bound....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
