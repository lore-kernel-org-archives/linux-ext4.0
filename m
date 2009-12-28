From: Larry McVoy <lm@bitmover.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Mon, 28 Dec 2009 06:08:55 -0800
Message-ID: <20091228140855.GD10982@bitmover.com>
References: <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com> <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de> <4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de> <4B37BA76.7050403@hp.com> <alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de> <20091227223307.GA4429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Kujau <lists@nerdbynature.de>, jim owens <jowens@hp.com>,
	Larry McVoy <lm@bitmover.com>,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091227223307.GA4429@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> The bottom line is that it's very hard to do good comparisons that are
> useful in the general case.

It has always amazed me watching people go about benchmarking.  I should
have a blog called "you're doing it wrong" or something.

Personally, I use benchmarks to validate what I already believe to be true.
So before I start I have a predicition as to what the answer should be,
based on my understanding of the system being measured.  Back when I
was doing this a lot, I was always within a factor of 10 (not a big
deal) and usually within a factor of 2 (quite a bit bigger deal).
When things didn't match up that was a clue that either

    - the benchmark was broken
    - the code was broken
    - the hardware was broken
    - my understanding was broken

If you start a benchmark and you don't know what the answer should be,
at the very least within a factor of 10 and ideally within a factor of 2,
you shouldn't be running the benchmark.  Well, maybe you should, they 
are fun.  But you sure as heck shouldn't be publishing results unless
you know they are correct.

This is why lmbench, to toot my own horn, measures what it does.  If go
run that, memorize the results, you can tell yourself "well, this machine
has sustained memory copy bandwidth of 3.2GB/sec, the disk I'm using
can read at 60MB/sec and write at 52MB/sec (on the outer zone where I'm
going to run my tests), it does small seeks in about 6 milliseconds,
I'm doing sequential I/O, the bcopy is in the noise, the blocks are big
enough that the seeks are hidden, so I'd like to see a steady 50MB/sec
or so on a sustained copy test".

If you have a mental model for how the bits of the system works you 
can decompose the benchmark into the parts, predict the result, run
it, and compare.  It'll match or Lucy, you have some 'splainin to do.
-- 
---
Larry McVoy                lm at bitmover.com           http://www.bitkeeper.com
