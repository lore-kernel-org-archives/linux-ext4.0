From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: ll_ver_fs data verification failure - 96TB fs
Date: Thu, 06 Aug 2009 16:37:14 -0400
Message-ID: <18249.1249591034@alphaville.usa.hp.com>
References: <28623.1249307676@gamaville.dokosmarshall.org>  <20090806200400.GC1800@shell>
Reply-To: nicholas.dokos@hp.com
Cc: Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19394 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbZHFUhN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 16:37:13 -0400
In-Reply-To: Message from Valerie Aurora <vaurora@redhat.com>
   of "Thu, 06 Aug 2009 16:04:01 EDT." <20090806200400.GC1800@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Valerie Aurora <vaurora@redhat.com> wrote:

> On Mon, Aug 03, 2009 at 09:54:36AM -0400, Nick Dokos wrote:
> > Just a heads-up for now. I ran ll_ver_fs on a 96TB fs - the write phase
> > finished without problems, but the read phase encountered a problem:
> > 
> > ...
> > read File name: /mnt/dir00373/file026
> > 
> > liverfs: verify /mnt/dir00373/file026 failed offset/timestamp/inode 3244298240/1248819541/1096796: found 3243249664/1248819541/1096796 instead
> > 
> > liverfs: Data verification failed
> > 770.45user 218639.65system 67:38:18elapsed 90%CPU (0avgtext+0avgdata 0maxresident)k
> > 100357573552inputs+195522668184outputs (1major+414minor)pagefaults 0swaps
> > make: *** [llver] Error 2
> > 
> > 
> > The offset difference is exactly 1M, and it occurs about 3GB into the file.
> 
> Interesting - exactly 1M off.  Does this correspond to anything
> interesting in extent layout or block allocation boundaries?
> 
> Any chance you can patch ll_ver_fs to continue after the first error?
> I'd be happy to write the patch for you.

I did that to begin with but the problem turns out to be much more
mundane: there was an IO error on one of the volumes. It wasn't quite
obvious (no red lights going off) but there *was* a message in
/var/log/messages - unfortunately I missed it. I eventually recreated
the error by trying to read the file with ``od -c'' and then went back
and found the original error. I don't know why/how ll_ver_fs managed to
read the offset and come up with a 1M difference[1] -- ``od -c'' failed with
a big thud.

We have now replaced the disk and I'm doing the test again: it should be
done (barring further problems) by sometime next week.

> 
> > In total, there are 726 directories, each with 32 4GB files (except the last,
> > which only has 12 files). So directory 373 is roughly half-way. I'll take a look
> > at the block allocation of both the directory and the file and see if they are
> > straddling the 16TB boundary (or other such).
> 
> Did you have a chance to look at what falls before and after the 16TB
> boundary?
> 

I did go barking up the wrong tree for a while :-) (or should that be :-( ?)

Thanks,
Nick

[1] that's a 2-bit flip:

3244298240 = 2#11000001011000000001000000000000
3243249664 = 2#11000001010100000001000000000000
