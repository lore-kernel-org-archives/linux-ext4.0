From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 1/3] Add EXT4_IOC_MOVE_EXT ioctl and related
	functions
Date: Sat, 13 Jun 2009 09:21:48 -0400
Message-ID: <20090613132148.GK24336@mit.edu>
References: <4A164EE8.1070903@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:43609 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbZFMNVw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Jun 2009 09:21:52 -0400
Content-Disposition: inline
In-Reply-To: <4A164EE8.1070903@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2009 at 04:06:16PM +0900, Akira Fujita wrote:
> ext4: online defrag -- Add EXT4_IOC_MOVE_EXT ioctl and related functions.
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> The EXT4_IOC_MOVE_EXT exchanges the blocks between orig_fd and donor_fd,
> and then write the file data of orig_fd to donor_fd.
> ext4_mext_move_extent() is the main fucntion of ext4 online defrag,
> and this patch includes all functions related to ext4 online defrag.

Akira-san,

Thank you for all of the hard work and preserverance with the online
defrag work!  This patch is much, *much* better; I've done a quick
review, and I've only noted two things, which I've updated in the
version I've now moved into the stable portion of the patch queue.
One is that nothing actually uses orig_fd in the move_extent
structure; so to avoid confusion, and I've renamed it to "reserved",
and used explicit __u32 fields for the reserved and donor_fd fields.
Also, I've renamed ext4_mext_move_extent() to ext4_move_extents();
since it is the one published interface, I wanted it to have an
easier-to-understand name.

As a side note, the static functions in fs/ext4/move_extent.c really
don't need the ext4_mext prefix, since static functions don't have
namespace issues that require a consistent naming scheme.  (Sometimes
a shorter name can also be useful since it avoids needing to line wrap
function calls with a long list of parameters.)

I haven't done extensive testing on the patch to make sure that
nothing bad happens if the file is actively been modified while the
defrag progam is running, but the interfaces look good, which is what
matters in terms of pushing it to the stable queue.

Again, many thanks,

Regards,

						- Ted
