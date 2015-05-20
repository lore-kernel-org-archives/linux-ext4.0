From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unused block group, but all blocks not free?
Date: Wed, 20 May 2015 12:31:48 -0400
Message-ID: <20150520163148.GA23989@thunk.org>
References: <555BDEF4.1020704@ubuntu.com>
 <20150520151007.GK2871@thunk.org>
 <555CA52F.3010109@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phil Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48123 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbbETQbv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2015 12:31:51 -0400
Content-Disposition: inline
In-Reply-To: <555CA52F.3010109@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 20, 2015 at 11:15:59AM -0400, Phil Susi wrote:
> On 5/20/2015 11:10 AM, Theodore Ts'o wrote:
> >Have you checked to see if the metadata for other block groups are
> >taking up space in the block group.  This can happen when using the
> >flex_bg layout.  (And without flex_bg, then *all* block groups will
> >always have blocks in use, for their own metadata blocks.)
> 
> That was my first thought and no, they aren't.  The metadata is in bg 0 and
> bg 32, not 25.  Even still, when the metadata is there, shouldn't the
> allocation bitmap mark those blocks as in use rather than be uninitialized?

As an optimization, if we can reconstruct the allocation bitmap from
the block group descriptors, we'll leave the block allocation bitmap
uninitialized, so that programs like e2fsck don't have to read the
bitmap block.  For a mostly empty file system, this optimization is
quite noticeable.

Can you send me a compressed raw e2image of the file system so I can
take a look?

					- Ted
