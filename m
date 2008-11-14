From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4 unlink performance
Date: Fri, 14 Nov 2008 09:59:14 -0500
Message-ID: <20081114145914.GE25117@mit.edu>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60473 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016AbYKNO7S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 09:59:18 -0500
Content-Disposition: inline
In-Reply-To: <20081114041121.GB11746@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 13, 2008 at 10:11:21PM -0600, Bruce Guenter wrote:
> 
> I had been running these benchmarks over dm-crypt (which is the target
> environment for which I was testing).  So I re-ran the tests both bare
> and with dm-crypt to compare.  The stalls reported by vmstat did not
> show up when running the test bare.
> 
> I also sat and watched the drive LED while the unlink test was running.
> The drive LED showed the occasional 1/2 second stall, but at the same
> time vmstat was showing 5-20 second stalls, so there that would seem to
> point to some kind of reporting problem.

Yeah, I'm guessing that's a red herring caused by how dm-crypt works.
The blocks had already been posted to block device, but it was taking
a while for the blocks to be written out to disk.

This is beginning to perhaps sound like a layout problem of some kind.
How big is the filesystem that you are testing against?  I'm guessing
that if you have 725,000 small files, that it can't be much more than
a gig or two, right?

Can you send me the output of 

    e2image -r /dev/XXX - | bzip2 ext4.e2i.bz2

for both the ext4 and ext3 filesystems, after you have loaded them
with your small files, and before you delete them?  This will show me
the where all of the files are located, and in fact I'll be able to
replicate the delete workload on my end and see exactly what's going on.

I will see the directory and file names of your workload, but
hopefully that won't be an issue for you.  Thanks,

							- Ted
