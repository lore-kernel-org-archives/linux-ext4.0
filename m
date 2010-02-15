From: tytso@mit.edu
Subject: Re: resize2fs memory footprint
Date: Mon, 15 Feb 2010 16:50:12 -0500
Message-ID: <20100215215012.GO5337@thunk.org>
References: <4B78FE19.5040208@miray.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ulrich Bauer <u.bauer@miray.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:50886 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab0BOVuP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 16:50:15 -0500
Content-Disposition: inline
In-Reply-To: <4B78FE19.5040208@miray.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 15, 2010 at 08:56:09AM +0100, Ulrich Bauer wrote:
> A quick observation of
> resize2fs' source revealed that the latest git tree already has a
> bitmap interface that allows for different implementations of the
> bitmap manipulation algorithms. To solve the memory usage problem,
> two solutions seem to be feasible:
> 
> - For the huge bitmaps that already exist on the volume, we could
> create a disk-backed bitmap implementation that would only cache a
> small working set of the entire bitmap. My guess is that we can
> implement this efficiently enough to not loose too much performance.
> - For the all-zero bitmaps, we could implement a dummy bitmap that
> forces all bits to zero and spawns a real bitmap as soon as any bits
> are set to one. An alternative would be a tree-based aproach that
> works especially well when the bitmap is just sparsely set.

What I would recommend is a run-length encoded tree-based approached.
This should work well regardless of whether the bitmap is sparsely set
or not, because most of the time blocks are allocated contiguously.

> I'd be glad if one of the developers involved in the ext4
> development could tell me if these thoughts make sense and if yes,
> are there any plans to incorporate these approaches into the ext
> library anytime soon or does it make sense if I would have a deeper
> look into these issues and implement them? Thanks in advance for any
> thoughts about this.

There are plans to incorporate the RLE tree-based implementation, but
it's been relatively low on the priority list given all of the other
things.  If you'd be interested in implementing it, that would be
great.

							- Ted
