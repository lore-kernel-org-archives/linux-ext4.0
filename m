From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Beginner questions about ext4
Date: Wed, 10 Jul 2013 13:24:09 -0400
Message-ID: <20130710172409.GC28076@thunk.org>
References: <loom.20130612T140739-743@post.gmane.org>
 <loom.20130623T082353-563@post.gmane.org>
 <20130623115953.GA16193@thunk.org>
 <CACyNnZNQ00D=hKHZ_wvfwJx3CWt7iELrbgUf_41AzzSAJmxGUw@mail.gmail.com>
 <20130701165524.GB23896@thunk.org>
 <CACyNnZPoAt2VNgGfRwzcvVdJHF8xKhE93zS7dGrmodg9Lm=cNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36594 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3GJRYN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jul 2013 13:24:13 -0400
Content-Disposition: inline
In-Reply-To: <CACyNnZPoAt2VNgGfRwzcvVdJHF8xKhE93zS7dGrmodg9Lm=cNQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 10, 2013 at 06:13:08PM +0200, Felipe Monteiro de Carvalho wrote:
> 
> When I am reading a ext4 file system and I find that there exists an
> inode /etc/ with groupnr 32 and nodenr 260099, will this group 32 be
> in the same position (distance in bytes from the beginning of the
> disk) as in ext3? Or will the flex_bg make the first 16 groups fit
> into the size that previously 1 group utilized? So group 32 in ext 4
> would be in the physical position of group 2 in ext3.
> 
> If I have s_log_groups_per_flex=4 (seams the be the most popular
> value), then each and every set of 16 groups will be groups into
> flex_bgs or only some are grouped into flex_bgs?
> 
> Basically I have a reader for ext3 and I added EXTENT support and it
> works now fine for the group 0, but for higher groups it is not
> working and I'm trying to find out what I need to change ... I'm
> trying to find what physically changed here... but it is a hard
> battle. Much harder than EXTENT support was.

Your reader shouldn't care about the flex_bg feature.  From a reader's
perspective, flex_bg's don't matter.  Just ignore it.  Just think in
terms of block groups, and you'll be find.  The Flex_bg feature
matters for how our block allocation strategy works, and it influences
how online resizing works, and it tells e2fsck that it's ok for the
inode table for a particular block group to be located outside of its
own block group (which is where the "flexible" came from).

But from a read-only client is concerned, it doesn't matter.  Just use
the block group descriptors to find the location of the inode table,
and just expunge the concept of flex_bg's from your mind entirely.  Or
better yet, just use the libext2fs library, and don't try to reinvent
the wheel.....

					- Ted
