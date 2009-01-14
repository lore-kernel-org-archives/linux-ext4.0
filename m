From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: kernel BUG at fs/ext/super.c:428
Date: Wed, 14 Jan 2009 16:20:38 -0500
Message-ID: <20090114212038.GJ6222@mit.edu>
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu> <496D526D.1010402@linux.intel.com> <20090114044059.GA6222@mit.edu> <20090114191632.GA13114@linux-os.sc.intel.com> <1231961377.14825.51.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46803 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbZANVWa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Jan 2009 16:22:30 -0500
Content-Disposition: inline
In-Reply-To: <1231961377.14825.51.camel@laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 14, 2009 at 08:29:37PM +0100, Peter Zijlstra wrote:
> > 38d47c1b7075bd7ec3881141bb3629da58f88dab is first bad commit
> > commit 38d47c1b7075bd7ec3881141bb3629da58f88dab
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Fri Sep 26 19:32:20 2008 +0200
> > 
> >     futex: rely on get_user_pages() for shared futexes
> >     
> >     On the way of getting rid of the mmap_sem requirement for shared futexes,
> >     start by relying on get_user_pages().
> >     
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> However does a futex change make ext3 crap its pants?

I agree, this doesn't make much sense.  I've looked at the patch, and
I don't see how this would cause an ext3 orphaned-inode list handling
problem

Are you sure the bisect was done correctly?  Have you tried reverting
that one commit, or otherwise conclusively shown that a kernel with
this commit fails, and one without this commit works just fine?

     	    	       	   	   	- Ted
