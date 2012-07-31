From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Questions about dx --- hash conflicts and limit
Date: Tue, 31 Jul 2012 16:24:09 -0400
Message-ID: <20120731202409.GG32228@thunk.org>
References: <5017D9B8.5080103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42371 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2GaUYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 16:24:12 -0400
Content-Disposition: inline
In-Reply-To: <5017D9B8.5080103@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 31, 2012 at 09:12:24PM +0800, Wang Sheng-Hui wrote:
> 
>    I walked through the ext4/namei.c, but didn't find any
>    code dealing with hash conflicts.
> 
>    I wonder if some name hash conflicts, how can they be stored
>    and retrieved with the dir ops?

The hash lookup points us at a particular directory leaf block where
we start the search.  All directory entries that have the same has are
stored in the same directory leaf block.  What if there are more
directory entries that have the same hash than can fit in a single
leaf block?  Then we look at the next block (by tree order) in the
directory.  The low bit in the hash key is set to 1 in the index entry
to indicate that the block in question is a continuation block.

The reason why we need to know about the continuation block is if you
have so many collisions that you they spill across not only different
index blocks, but the 2nd order index block.  Basically, if you want
to ever muck with the namei code and try to improve it, there are all
sorts of scary edges cases you have to handle, and these are not well
documented.  Sorry about that....

Unfortunately namei.c isn't well documented; the original author of
this code, Daniel Phillips didn't really believe in comments and
really liked very deeply indented functions.  I did a huge amount of
cleanup before these patches were included in ext3, but looking back,
I wish I had done more cleanup and added more comments... :-(

BTW, if you *are* thinking about mucking about in the namei code, my
suggestion would be to create a new checksum function which does a
simple additive checksum, and then masks off all but the two lowest
bits, so you have a degenerate hash function which has only 4 possible
values.  Then use a 1k block file system, and fill the directory with
lots and lots of files, and test away.  That should stress all of the
various corner cases quite nicely.  :-)

					- Ted
