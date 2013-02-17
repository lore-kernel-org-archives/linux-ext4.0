From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Possible TODO projects for the map_blocks() code path (was: Re:
 [PATCH 05/10 v5] ext4: lookup block mapping in extent status tree)
Date: Sun, 17 Feb 2013 11:15:55 +0800
Message-ID: <20130217031555.GA14557@gmail.com>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-6-git-send-email-wenqing.lz@taobao.com>
 <20130212123142.GC19583@quack.suse.cz>
 <20130215070626.GD26945@gmail.com>
 <20130215172549.GB31172@thunk.org>
 <20130216023251.GA11195@gmail.com>
 <20130216161846.GA17158@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41812 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab3BQDBP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Feb 2013 22:01:15 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so2255060pad.20
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2013 19:01:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130216161846.GA17158@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 16, 2013 at 11:18:46AM -0500, Theodore Ts'o wrote:
> On Sat, Feb 16, 2013 at 10:32:51AM +0800, Zheng Liu wrote:
> > 
> > To be honest, my initial idea is only to split ext4_map_blocks into
> > ext4_map_blocks_read and ext4_map_blocks_write, and do some cleanups.
> > Thanks for your suggestions.  I will look at it carefully after the
> > patch series of extent status tree has been applied.
> 
> Ah, when you said get_block_t functions, I had assumed you had meant
> changing the function signature --- because the function signature
> being fixed by the generic DIO code is one of the things holding back
> a number of improvements in the map_blocks code paths.
> 
> For example:
> 
> 1) Thanks to the DIO code, we are ab(using) a struct buffer_head data
> structure to pass the mapping to the DIO code.  Normally the
> buffer_head maps only a single block's worth of data, but here b_size
> is repurposed to indcate the size of the logical to physical block
> mapping, and b_data is invalid (since it isn't a real buffer head).
> There are a number of other fields in the struct buffer_head which in
> the DIO codepath which are completely unused, which isn't just an
> aesthetic issue --- it's also wasting valuable (and limited) kernel
> stack space, since the struct buffer_head is allocated on the stack of
> do_blockdev_direct_IO().

Yes, I also think struct buffer_head could be dropped, and get_block_t
signature should be changed.  But it needs to modify vfs layer.  We can
discuss this topic with other developers in LSF/MM summit and fsdevel@
mailing list.  AFAIK, this year in LSF/MM summit there is a topic about
this.

> 
> 2) We are currently using inode flags to pass state flags between
> different parts of the writepages code and the map_blocks code.  This
> is bad because (a) it makes the code much harder to understand and
> maintain, and (b) it blocks us from being able to call map_blocks() in
> parallel.  If we fix this, it would be relatively trivial to add
> support for parallel non-create map_block calls, and if we decide to
> try to use the extent status tree for range locking, it might be
> possible to do parallel block allocations sa well.  (I believe some
> locking may be needed in mballoc.c for the inode-specific
> preallocation code, but that should be doable.)

I think about extent-level locking when I run xfstests.  It seems that
we need to improve *_map_blocks() function if we want to use status tree
for range locking because we always need to lookup an extent in this
tree and lock this range before we do other things.  That is why I want
to split ext4_map_blocks function.  Certainly this is only my simple
idea, and I still need to consider it.  But I believe an improvement
and/or cleanup is a good start.

> 
> If we have multiple interested in working on various different
> projects, it might be useful to start documenting some of these
> proposed enhancements on the wiki, and certainly these would be good
> things for us to discuss at the ext4 developer's workshop in April.

Yes, there are a lot of things on ext4 wiki, which are out of date.
That would be great if it can be updated.

Looking forward to discussing this topics. :-)

                                                - Zheng
