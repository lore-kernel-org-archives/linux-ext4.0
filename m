From: Theodore Tso <tytso@mit.edu>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation
	for FLEX_BG
Date: Mon, 28 Apr 2008 08:01:38 -0400
Message-ID: <20080428120138.GE30840@mit.edu>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu> <1208868379-17580-2-git-send-email-tytso@mit.edu> <1208868379-17580-3-git-send-email-tytso@mit.edu> <20080423203955.GH2775@webber.adilger.int> <20080423160518.5c7fad2e@gara> <20080425201026.GB3444@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jose R. Santos" <jrs@us.ibm.com>, linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51211 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765702AbYD1MBu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 08:01:50 -0400
Content-Disposition: inline
In-Reply-To: <20080425201026.GB3444@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 25, 2008 at 02:10:26PM -0600, Andreas Dilger wrote:
> I'd HOPE (and I believe this is what Ted's recent patch did) is that any
> group which is being used to store flexbg data will have an initialized
> block bitmap in it, because it is "non-standard".

Correct.  If there are *any* blocks allocated other than the block's
own metadata, BLOCK_UNINIT will never be set.  And that's precisely to
avoid the tricky case described in your next paragraph:

> What is more tricky is if a group has BLOCK_UNINIT and/or INODE_UNINIT
> set what should happen when that group's block bitmap is initialized.
> Should it assume there is a block + inode bitmap and an itable, or is
> it enough to check its own group descriptor to determine if the bitmap
> and itable are not in the group itself.

In the kernel, it should be enough only to check bg_inode_bitmp,
bg_block_bitmap, and bg_inode_table to construct the block bitmap.
The point was to keep things simple.  

The cost of doing this is that you will end up needing to initialize
the block bitmaps for every an extra 1 out of every flex_bg_size block
groups, but that's not a major cost.  It also means that BLOCK_UNINIT
and BLOCK_BG_EMPTY as defined by Andreas are the same thing.  This was
a Keep It Simple, Stupid design point; I don't think the complexity is
worth it.

If someone wants to convince me that the benefits of forcing the
kernel and e2fsck pass5 to paw through all of the block group
descriptors to construct the block bitmap outweighs the costs (and
more importantly, volunteers to write the code :-), I'm willing to be
convinced otherwise....

						- Ted
