From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/10 v5] ext4: lookup block mapping in extent status tree
Date: Fri, 15 Feb 2013 12:25:49 -0500
Message-ID: <20130215172549.GB31172@thunk.org>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-6-git-send-email-wenqing.lz@taobao.com>
 <20130212123142.GC19583@quack.suse.cz>
 <20130215070626.GD26945@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48432 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab3BORZz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Feb 2013 12:25:55 -0500
Content-Disposition: inline
In-Reply-To: <20130215070626.GD26945@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 15, 2013 at 03:06:26PM +0800, Zheng Liu wrote:
> 
> I am planning to refine the get_block_t and *map_blocks functions.  At
> that time I will try to fix this problem.

Note that get_block_t can't be changed without disrupting the Direct
I/O functions which are generic VFS functions.  There's been talk of
trying to clean up DIO, but it will probably require building a
parallel infrastructure in the generic layer, and then transitioning
individual file systems over to it.  It is definitely a mess, but it's
going to be a very tricky problem.  I suspect we'll be talking about
it at LSF/MM.

One thing thing which might be an interesting thing to do that
wouldn't require wholesale changes to generic code would be to
transition ext4_readpages() to use fs/ext4/page-io.c.  Not for this
merge window, in all likelihood, but right now we are calling
ext4_get_block() for every single page that we read in, while is
wasteful.  It would be nice if ext4_readpages() called
ext4_map_blocks() for each extent, and then submitted it using the
page-io.c functions so we don't end up calling into ext4_map_blocks()
quite as much.

That will ease our scalability and remove locking overhead, in
addition to saving CPU for the buffered I/O readpages path.
Eventually it would be good to do this for DIO as well, but that's
going to require a lot more work, and coordination with the developers
of btrfs, xfs, etc.

					- Ted
