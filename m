From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 2 Sep 2009 11:03:06 -0400
Message-ID: <20090902150306.GF379@mit.edu>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <20090902144833.GA29651@zero>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tom Vier <nester@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35042 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbZIBPDG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 11:03:06 -0400
Content-Disposition: inline
In-Reply-To: <20090902144833.GA29651@zero>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 10:48:33AM -0400, Tom Vier wrote:
> On Mon, Aug 24, 2009 at 06:07:39PM -0400, Theodore Tso wrote:
> > Sure, agreed.  But let's look a bit closer at what "async commit"
> > really means.
> > 
> > What ext3 and ext4 does by default is this:
> > 
> > 1)  Write data blocks required by data=ordered mode (if any)
> 
> Shouldn't there be a write barrier after data blocks, so that the journal
> blocks aren't written first? ie, mark the first journal block write with
> barrier flag on.

No, it doesn't matter, because the journal blocks are ignored until
the commit block is written.  So the order of the data blocks required
by data=ordered mode, and the journal blocks are written can be freely
reordered by the elevator and the hard drive without any risk of data
integrity problems.

						- Ted
