From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Sun, 22 Dec 2013 20:45:54 -0700
Message-ID: <20131223034554.GA11091@parisc-linux.org>
References: <20131219041240.GA19166@parisc-linux.org> <20131219054303.GA4391@thunk.org> <20131219152049.GB19166@parisc-linux.org> <20131219161728.GA9130@thunk.org> <20131219171201.GD19166@parisc-linux.org> <20131219171848.GC9130@thunk.org> <20131220181731.GG19166@parisc-linux.org> <20131220193455.GA6912@thunk.org> <20131220201059.GH19166@parisc-linux.org> <20131223033641.GF3220@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57480 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3LWDp4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Dec 2013 22:45:56 -0500
Content-Disposition: inline
In-Reply-To: <20131223033641.GF3220@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 02:36:41PM +1100, Dave Chinner wrote:
> What I'm trying to say is that I think the whole idea of XIP is
> separate from the page cache is completely the wrong way to go about
> fixing it. XIP should simply be a method of mapping backing device
> pages into the existing per-inode mapping tree.  If we need to
> encode, remap, etc because of constraints of the configuration (be
> it filesystem implementation or block device encodings) then we just
> use the normal buffered IO path, with the ->writepages path hitting
> the block layer to do the memcpy or encoding into persistent
> memory. Otherwise we just hit the direct IO path we've been talking
> about up to this point...

That's a very filesystem person way of thinking about the problem :-)
The problem is that you've now pushed it off on the MM people.  A page
in the page cache needs a struct page to represent it.  If you've got
70x as much persistent memory as you have volatile memory, then you just
filled all of your volatile memory with struct pages to describe the
persistent memory.  I don't remember if you were around for the joys
of dealing with 16GB+ i386 machines, but the unholy messes created to
avoid running out of the 800MB or so of lowmem are still with us.

I mean, sure, it's doable.  But it's got its own tradeoffs and they
aren't pleasant for many workloads.  We could talk about ways to work
around it, like making struct page be able to describe larger chunks of
memory, but I don't think I'm capable of that amount of surgery to the VM.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
