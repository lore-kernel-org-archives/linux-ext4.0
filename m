From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Mon, 26 Mar 2012 16:57:07 -0700
Message-ID: <20120326235707.GC19489@thunk.org>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
 <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
 <20120324031357.GA5690@tassilo.jf.intel.com>
 <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Andi Kleen <ak@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59859 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757876Ab2CZX5L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Mar 2012 19:57:11 -0400
Content-Disposition: inline
In-Reply-To: <4F70F51F.8030405@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 26, 2012 at 04:00:47PM -0700, Andi Kleen wrote:
> On 3/26/2012 3:26 PM, Vivek Haldar wrote:
> >Andi --
> >
> >I realized the problem soon after the original patch, and submitted
> >another patch to make these per cpu  counters.
> 
> Is there a clear use case having these counters on every production system?

Today, with the current single entry extent cache, I don't think
there's a good justification for it, no.

Vivek has worked on a rather more sophisticated extent cache which
could cache several extent entries (and indeed, combine multiple
on-disk extent entries into a single in-memory extent).  There are a
variety of reasons that hasn't gone upstream yet; one of which is
there are some interesting questions about how to control memory usage
of the extent cache; how do we trim it back in the case of memory
pressure?

One of the other things that we need to consider as we think about
getting this upstream is the "status" or "delayed" extents patches
which Allison and Yongqiang were looking at.  Does it make sense to
have two parallel datastructures which are indexed by logical block
number?  On the one hand, using an in-memory tree structure is pretty
expensive, just because of all of the 64-bit logical block numbers and
64-bit pointers.  On the other hand, would that make things too
complicated?

Once we start having multiple knobs to adjust, having these counters
available does make sense.  For now, using a per-cpu counter is
relatively low cost, except on extreme SGI Altix-like machines with
hundreds of CPU's, where the memory utilization is something to think
about.  Given that Vivek has submitted a patch to convert to per-cpu,
I can see applying it just to fix it; or just removing the stats for
now until we get the more sophisticated extent cache merged in.

    	     	     	  		       - Ted
