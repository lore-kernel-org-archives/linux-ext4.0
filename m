From: Theodore Ts'o <tytso@mit.edu>
Subject: Possible TODO projects for the map_blocks() code path (was: Re:
 [PATCH 05/10 v5] ext4: lookup block mapping in extent status tree)
Date: Sat, 16 Feb 2013 11:18:46 -0500
Message-ID: <20130216161846.GA17158@thunk.org>
References: <1360313046-9876-1-git-send-email-wenqing.lz@taobao.com>
 <1360313046-9876-6-git-send-email-wenqing.lz@taobao.com>
 <20130212123142.GC19583@quack.suse.cz>
 <20130215070626.GD26945@gmail.com>
 <20130215172549.GB31172@thunk.org>
 <20130216023251.GA11195@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48518 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab3BPQS7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Feb 2013 11:18:59 -0500
Content-Disposition: inline
In-Reply-To: <20130216023251.GA11195@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 16, 2013 at 10:32:51AM +0800, Zheng Liu wrote:
> 
> To be honest, my initial idea is only to split ext4_map_blocks into
> ext4_map_blocks_read and ext4_map_blocks_write, and do some cleanups.
> Thanks for your suggestions.  I will look at it carefully after the
> patch series of extent status tree has been applied.

Ah, when you said get_block_t functions, I had assumed you had meant
changing the function signature --- because the function signature
being fixed by the generic DIO code is one of the things holding back
a number of improvements in the map_blocks code paths.

For example:

1) Thanks to the DIO code, we are ab(using) a struct buffer_head data
structure to pass the mapping to the DIO code.  Normally the
buffer_head maps only a single block's worth of data, but here b_size
is repurposed to indcate the size of the logical to physical block
mapping, and b_data is invalid (since it isn't a real buffer head).
There are a number of other fields in the struct buffer_head which in
the DIO codepath which are completely unused, which isn't just an
aesthetic issue --- it's also wasting valuable (and limited) kernel
stack space, since the struct buffer_head is allocated on the stack of
do_blockdev_direct_IO().

2) We are currently using inode flags to pass state flags between
different parts of the writepages code and the map_blocks code.  This
is bad because (a) it makes the code much harder to understand and
maintain, and (b) it blocks us from being able to call map_blocks() in
parallel.  If we fix this, it would be relatively trivial to add
support for parallel non-create map_block calls, and if we decide to
try to use the extent status tree for range locking, it might be
possible to do parallel block allocations sa well.  (I believe some
locking may be needed in mballoc.c for the inode-specific
preallocation code, but that should be doable.)

If we have multiple interested in working on various different
projects, it might be useful to start documenting some of these
proposed enhancements on the wiki, and certainly these would be good
things for us to discuss at the ext4 developer's workshop in April.

Regards,

					- Ted
