From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/7] ext4: ext4_inode_info diet
Date: Sat, 15 Sep 2012 11:53:06 -0400
Message-ID: <20120915155306.GA5446@thunk.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
 <1347211634-11509-2-git-send-email-dmonakhov@openvz.org>
 <20120913105022.GE11330@gmail.com>
 <871ui65g2r.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	jack@suse.cz, wenqing.lz@taobao.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50826 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab2IOR1h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Sep 2012 13:27:37 -0400
Content-Disposition: inline
In-Reply-To: <871ui65g2r.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 13, 2012 at 03:15:40PM +0400, Dmitry Monakhov wrote:
> Current buffer.c API layering looks sub-optimal
> 
> ->xxx_fs_routine: May create different contexts
>    ->generic_buffer_methods(inode, bh..)
>      ->xxx_fs_get_block(inode, bh,...): There is no efficient way to pass fscontext 
> Both xxx_fs_routine and xxx_fs_get_block are fs specific, but
> the only way to pass fscontext down to get_block is to pass it by
> attaching it to inode, which make it implicit serialization point.
> 
> I just want to add fsprivate argument to get_block_t callback similar
> write_begin/write_end and iocb->private, so filesystem will able to pass
> it to it's get_block callback.

If we're going to change the function prototype for get_block_t, it
might also be good to fix a long-standing ugliness with this interface
which is that the get_block() interface does two very different things
when bh->b_size is greater a single block.  If b_size is a greater a
block, then instead of bh being a "real" buffer_head, it's a pseudo
map_bh.  This is annoying because map_bh is generally allocated on the
stack, but most of the fields are unused, since it's not really a
_real_ buffer_head, but just a countainer for a handful of fields used
by the AIO/DIO and mpage.c functions.

Instead of changing get_block(), which would require lots of changes
all over the kernel, what I'd suggest doing instead is creating a new
function which I'd propose calling get_map() which fills in a new
structure which replaces map_bh, and which includes the aio_dio
structure.  It could be made mandatory for the few file systems which
support DIO, but that way we don't havec to change the dozens of other
file systems which don't use the DIO code paths.

Regards,

					- Ted
