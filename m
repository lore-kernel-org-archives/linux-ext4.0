From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 05/10 v5] ext4: lookup block mapping in extent status tree
Date: Sat, 16 Feb 2013 10:32:51 +0800
Message-ID: <20130216023251.GA11195@gmail.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-6-git-send-email-wenqing.lz@taobao.com>
 <20130212123142.GC19583@quack.suse.cz>
 <20130215070626.GD26945@gmail.com>
 <20130215172549.GB31172@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38384 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab3BPCSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Feb 2013 21:18:14 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so838421pbc.24
        for <linux-ext4@vger.kernel.org>; Fri, 15 Feb 2013 18:18:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130215172549.GB31172@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 15, 2013 at 12:25:49PM -0500, Theodore Ts'o wrote:
> On Fri, Feb 15, 2013 at 03:06:26PM +0800, Zheng Liu wrote:
> > 
> > I am planning to refine the get_block_t and *map_blocks functions.  At
> > that time I will try to fix this problem.
> 
> Note that get_block_t can't be changed without disrupting the Direct
> I/O functions which are generic VFS functions.  There's been talk of
> trying to clean up DIO, but it will probably require building a
> parallel infrastructure in the generic layer, and then transitioning
> individual file systems over to it.  It is definitely a mess, but it's
> going to be a very tricky problem.  I suspect we'll be talking about
> it at LSF/MM.
> 
> One thing thing which might be an interesting thing to do that
> wouldn't require wholesale changes to generic code would be to
> transition ext4_readpages() to use fs/ext4/page-io.c.  Not for this
> merge window, in all likelihood, but right now we are calling
> ext4_get_block() for every single page that we read in, while is
> wasteful.  It would be nice if ext4_readpages() called
> ext4_map_blocks() for each extent, and then submitted it using the
> page-io.c functions so we don't end up calling into ext4_map_blocks()
> quite as much.
> 
> That will ease our scalability and remove locking overhead, in
> addition to saving CPU for the buffered I/O readpages path.
> Eventually it would be good to do this for DIO as well, but that's
> going to require a lot more work, and coordination with the developers
> of btrfs, xfs, etc.

To be honest, my initial idea is only to split ext4_map_blocks into
ext4_map_blocks_read and ext4_map_blocks_write, and do some cleanups.
Thanks for your suggestions.  I will look at it carefully after the
patch series of extent status tree has been applied.

Thanks,
                                                - Zheng
