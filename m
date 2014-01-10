From: Jan Kara <jack@suse.cz>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Fri, 10 Jan 2014 07:04:29 +0100
Message-ID: <20140110060429.GA26378@quack.suse.cz>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
 <20140108221430.GB21663@quack.suse.cz>
 <20140108233752.GD17750@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaAJGEc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jan 2014 01:04:32 -0500
Content-Disposition: inline
In-Reply-To: <20140108233752.GD17750@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 08-01-14 18:37:52, Ted Tso wrote:
> On Wed, Jan 08, 2014 at 11:14:30PM +0100, Jan Kara wrote:
> >   So when I was thinking about this (already couple of years ago) the thing
> > which stopped me was the question at which layer we should do the
> > translation. Ideally we would need something at submit_bh() level but just
> > wrapping submit_bh() calls inside ext4 isn't enough for stuff like symlinks
> > or journalled data... Do you have any thoughts on that?
> 
> I think there are two interfaces that should handle nearly all of our
> journal block mapping needs.  The functions that issue bio requests
> directly tend to use ext4_get_block*() functions, and functions which
> use the buffer cache uses submit_bh() (typically via ext4_getblk).
> There will probably be a few exceptions, but I don't think this should
> be an intractable problem.
  Surely not intractable :) It was just ugly. But you are right that
hooking in ext4_map_blocks() and then special-casing the few cases where we
get the block number by different means (xattrs, inode table, group
descriptor, superblock, traversal of extent tree & indirect block tree)
should be reasonably elegant.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
