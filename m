From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 19:57:18 +0200
Message-ID: <20120413175718.GX17822@one.firstfloor.org>
References: <20120323221715.GA6712@tassilo.jf.intel.com> <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca> <20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com> <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org> <m2zkaiyzjl.fsf@firstfloor.org> <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Ted Ts'o <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41683 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2DMR5X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 13:57:23 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> > Can we please revert fix it or revert
> > 556b27abf73833923d5cd4be80006292e1b31662 before release.
> 
> That commit ID doesn't make any sense, and doesn't seem to have
> anything to do with any statistics counters that your email talks
> about. So regardless, you'd need to explain why that commit causes the
> problems you talk about, I'm not going to revert a random commit that
> doesn't even look what you describe.

Sorry correct problematic commit is

commit 77f4135f2a219a2127be6cc1208c42e6175b11dd
Author: Vivek Haldar <haldar@google.com>
Date:   Sun May 22 21:24:16 2011 -0400

    ext4: count hits/misses of extent cache and expose in sysfs

The problem is that every IO operation in ext4 bangs on this super block
cache line when it checks the extent cache and then updates the hit/miss
count. On a system with more than two sockets this is very costly
in terms of interconnect traffic under high IO load.

A straight revert has a minor conflict on a trace statement that
was added later.

-Andi

Original patch:

commit 77f4135f2a219a2127be6cc1208c42e6175b11dd
Author: Vivek Haldar <haldar@google.com>
Date:   Sun May 22 21:24:16 2011 -0400

    ext4: count hits/misses of extent cache and expose in sysfs
    
    The number of hits and misses for each filesystem is exposed in
    /sys/fs/ext4/<dev>/extent_cache_{hits, misses}.
    
    Tested: fsstress, manual checks.
    Signed-off-by: Vivek Haldar <haldar@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

