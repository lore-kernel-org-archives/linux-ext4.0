From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Wed, 11 Apr 2012 09:59:58 -0700
Message-ID: <m2zkaiyzjl.fsf@firstfloor.org>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
	<A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
	<20120324031357.GA5690@tassilo.jf.intel.com>
	<CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
	<4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com, torvalds@linux-foundation.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab2DKRAA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 13:00:00 -0400
In-Reply-To: <20120326235707.GC19489@thunk.org> (Ted Ts'o's message of "Mon,
	26 Mar 2012 16:57:07 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o <tytso@mit.edu> writes:

> On Mon, Mar 26, 2012 at 04:00:47PM -0700, Andi Kleen wrote:
>> On 3/26/2012 3:26 PM, Vivek Haldar wrote:
>> >Andi --
>> >
>> >I realized the problem soon after the original patch, and submitted
>> >another patch to make these per cpu  counters.
>> 
>> Is there a clear use case having these counters on every production system?
>
> Today, with the current single entry extent cache, I don't think
> there's a good justification for it, no.

Ping. This scalability problem is still in 3.4-rc* and causes
major slowdowns.

Can we please revert fix it or revert 
556b27abf73833923d5cd4be80006292e1b31662 before release.

-Andi

(keeping context)

>
> Vivek has worked on a rather more sophisticated extent cache which
> could cache several extent entries (and indeed, combine multiple
> on-disk extent entries into a single in-memory extent).  There are a
> variety of reasons that hasn't gone upstream yet; one of which is
> there are some interesting questions about how to control memory usage
> of the extent cache; how do we trim it back in the case of memory
> pressure?
>
> One of the other things that we need to consider as we think about
> getting this upstream is the "status" or "delayed" extents patches
> which Allison and Yongqiang were looking at.  Does it make sense to
> have two parallel datastructures which are indexed by logical block
> number?  On the one hand, using an in-memory tree structure is pretty
> expensive, just because of all of the 64-bit logical block numbers and
> 64-bit pointers.  On the other hand, would that make things too
> complicated?
>
> Once we start having multiple knobs to adjust, having these counters
> available does make sense.  For now, using a per-cpu counter is
> relatively low cost, except on extreme SGI Altix-like machines with
> hundreds of CPU's, where the memory utilization is something to think
> about.  Given that Vivek has submitted a patch to convert to per-cpu,
> I can see applying it just to fix it; or just removing the stats for
> now until we get the more sophisticated extent cache merged in.
>
>     	     	     	  		       - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
ak@linux.intel.com -- Speaking for myself only
