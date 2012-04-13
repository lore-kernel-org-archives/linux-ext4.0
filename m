From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 20:22:27 +0200
Message-ID: <20120413182227.GY17822@one.firstfloor.org>
References: <20120323221715.GA6712@tassilo.jf.intel.com> <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca> <20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com> <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org> <m2zkaiyzjl.fsf@firstfloor.org> <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com> <20120413180603.GF26332@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2DMSW3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 14:22:29 -0400
Content-Disposition: inline
In-Reply-To: <20120413180603.GF26332@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I think Andi cited the wrong commit.  The commit in question is
> 77f4135f2a219a2127be6cc1208c42e6175b11dd, which first showed up in
> 2.6.39.  If you have a very fast (PCIe-attached would be required I

I don't think it was a highend IO device.
This already hits for buffered IO I think.

> I'm willing to push commit to you to remove the counters for now, and
> we'll probably add it back later using percpu counters if you think
> it's worth making a change at this time --- or if Andi can explain why
> he's treating this with a high degree of urgency.  Is there some
> common use case that I'm missing which is being very badly impacted
> with this cache-line thrashing?

Well IO writes is a pretty common use case. On a smaller
system it's likely not ~30%, but likely a drag too. And we normally
try to fix scalability regressions each release.  Otherwise things
will just get worse and worse over time.

Scalability is unfortunately quite fragile and needs constant
attention. Every bad hot cache line can break it.

So yes I would like this to be reverted for the release.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
