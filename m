From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
Date: Mon, 17 Jun 2013 10:58:35 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306171057050.3270@localhost.localdomain>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com> <20130616005533.GF29338@dastard>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Radek Pazdera <rpazdera@redhat.com>, linux-ext4@vger.kernel.org,
	kasparek@fit.vutbr.cz
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3FQI6q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 04:58:46 -0400
In-Reply-To: <20130616005533.GF29338@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 16 Jun 2013, Dave Chinner wrote:

> Date: Sun, 16 Jun 2013 10:55:33 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Radek Pazdera <rpazdera@redhat.com>
> Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com, kasparek@fit.vutbr.cz
> Subject: Re: [RFC 0/9] ext4: An Auxiliary Tree for the Directory Index
> 
> On Sat, May 04, 2013 at 11:28:33PM +0200, Radek Pazdera wrote:
> > Hello everyone,
> > 
> > I am an university student from Brno /CZE/. I decided to try to optimise
> > the readdir/stat scenario in ext4 as the final project to school. I
> > posted some test results I got few months ago [1].
> > 
> > I tried to implement an additional tree for ext4's directory index
> > that would be sorted by inode numbers. The tree then would be used
> > by ext4_readdir() which should lead to substantial increase of
> > performance of operations that manipulate a whole directory at once.
> > 
> > The performance increase should be visible especially with large
> > directories or in case of low memory or cache pressure.
> > 
> > This patch series is what I've got so far. I must say, I originally
> > thought it would be *much* simpler :).
> ....
> > BENCHMARKS
> > ==========
> > 
> > I did some benchmarks and compared the performance with ext4/htree,
> > XFS, and btrfs up to 5 000 000 of files in a single directory. Not
> > all of them are done though (they run for days).
> 
> Just a note that for users that have this sort of workload on XFS,
> it is generally recommended that they increase the directory block
> size to 8-16k (from the default of 4k). The saddle point where 8-16k
> directory blocks tends to perform better than 4k directory blocks is
> around the 2-3 million file point....
> 
> Further, if you are doing random operations on such directories,
> then increasing it to the maximum of 64k is recommended. This
> greatly reduces the IO overhead of directory manipulations by making
> the trees widers and shallower. i.e. we recommend trading off CPU
> and memory for lower IO overhead and better layout on disk as it's
> layout and IO that are the performance limiting factors for large
> directories. :)
> 
> > Full results are available here:
> >     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/ext4-5M/
> 
> Can you publish the scripts you used so we can try to reproduce
> your results?

Hi Dave,

IIRC the tests used to generate the results should be found here:

https://github.com/astro-/dir-index-test

however I am not entirely sure whether the github repository is kept
up-to-date. Radek can you confirm ?

-Lukas

> 
> > I also did some tests on an aged file system (I used the simple 0.8
> > chance to create, 0.2 to delete a file) where the results of ext4
> > with itree are much better even than xfs, which gets fragmented:
> > 
> >     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/5M-dirty/cp.png
> >     http://www.stud.fit.vutbr.cz/~xpazde00/soubory/5M-dirty/readdir-stat.png
> 
> This XFS result is of interest to me here - it shouldn't degrade
> like that, so having the script to be able to reproduce it locally
> would be helpful to me. Indeed, I posted a simple patch yesterday
> that significantly improves XFS performance on a similar small file
> create workload:
> 
> http://marc.info/?l=linux-fsdevel&m=137126465712701&w=2
> 
> That writeback plugging change should benefit ext4 as well in these
> workloads....
> 
> Cheers,
> 
> Dave.
> 
