From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: jbd/jbd2 performance improvements
Date: Wed, 15 Oct 2008 13:29:55 -0400
Message-ID: <48F62893.9060606@redhat.com>
References: <E1KnCO6-0001qG-SV@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37978 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYJOR35 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 13:29:57 -0400
In-Reply-To: <E1KnCO6-0001qG-SV@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> As I mentioned on the ext4 call yesterday, there was an interesting
> thread on LKML that wasn't cc'ed onto the linux-ext4 mailing list.  So
> in case folks missed it, it might be worth taking a look at this mail
> thread:
>
> 	[PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
>
> 	http://lkml.org/lkml/2008/10/1/405
>
> The main issue that got discussed was the age-old "entaglement" problem.
> The jbd/jbd2 layer is supposed to avoid this by not blocking the
> "current" transaction why the blocks from the previous "committing"
> transaction are still being written out to disk.  Apparently this was
> broken sometime in the 2.5 time-frame:
>
> 	http://lkml.org/lkml/2008/10/2/41
> 	http://lkml.org/lkml/2008/10/2/322
>
> Later in the thread, a major contention point in do_get_write_access()
> was identified as the problem:
>
> 	http://lkml.org/lkml/2008/10/3/7
>
> ... and then andrew produced the following "hacky" fix:
>
> 	http://lkml.org/lkml/2008/10/3/22
>
> If someone has time to runs some benchmarks to see how this improves
> things, especially on a workload that has plenty of "engtanglements",
> that would be great.  (I bet Ric's fs_mark run should do a good job;
> fsyncs to creates lots of commits and the need to modify blocks that had
> been modified in the previous tansactions.)
>
> If we can get some quick testing done, and it shows really good results,
> this could be something that could try fast-tracking into the 2.6.28
> merge window.
>
> 						- Ted
>   

We are going to try and poke at this - do you suspect a single or 
multi-threaded test would work best?

Ric

