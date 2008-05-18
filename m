From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sat, 17 May 2008 20:48:33 -0400
Message-ID: <200805172048.34455.chris.mason@oracle.com>
References: <482DDA56.6000301@redhat.com> <20080517002030.GA7374@mit.edu> <20080516173552.e88183d9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:42054 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbYERA7E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 May 2008 20:59:04 -0400
In-Reply-To: <20080516173552.e88183d9.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday 16 May 2008, Andrew Morton wrote:
> On Fri, 16 May 2008 20:20:30 -0400 Theodore Tso <tytso@mit.edu> wrote:
> > On Fri, May 16, 2008 at 11:53:04PM +0100, Jamie Lokier wrote:
> > > > > If you just want to test the block I/O layer and drive itself,
> > > > > don't use the filesystem, but write a program which just access the
> > > > > block device, continuously writing with/without barriers every so
> > > > > often, and after power cycle read back to see what was and wasn't
> > > > > written.
> > > >
> > > > Well, I think it is worth testing through the filesystem, different
> > > > journaling mechanisms will probably react^wcorrupt in different ways.
> > >
> > > I agree, but intentional tests on the block device will show the
> > > drives characteristcs on power failure much sooner and more
> > > consistently.  Then you can concentrate on the worst drivers :-)
> >
> > I suspect the real reason why we get away with it so much with ext3 is
> > that the journal is usually contiguous on disk, hence, when you write
> > to the journal, it's highly unlikely that commit block will be written
> > and the blocks before the commit block have not.
>
> yup.  Plus with a commit only happening once per few seconds, the time
> window for a corrupting power outage is really really small, in
> relative terms.  All these improbabilities multiply.

Well, the barriers happen like so (even if we actually only do one barrier in 
submit_bh, it turns into two)

write log blocks
flush #1
write commit block
flush #2
write metadata blocks

I'd agree with Ted, there's a fairly small chance of things get reordered 
around flush #1.  flush #2 is likely to have lots of reordering though.  It 
should be easy to create situations where the metadata for a transaction is 
written before the log blocks ever see the disk.

EMC did a ton of automated testing around this when Jens and I did the initial 
barrier implementations, and they were able to trigger corruptions in fsync 
heavy workloads with randomized power offs.  I'll dig up the workload they 
used.

-chris
