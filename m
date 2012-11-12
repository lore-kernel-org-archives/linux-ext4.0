From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs running out of reserved gdb blocks.
Date: Mon, 12 Nov 2012 09:40:20 -0500
Message-ID: <20121112144020.GD4895@thunk.org>
References: <alpine.DEB.1.10.1211121241000.2903@wormhole.tzimmola.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kimmo Mustonen <k-20121112-81452+linux-ext4@tzimmola.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60655 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2KLOkX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Nov 2012 09:40:23 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1211121241000.2903@wormhole.tzimmola.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 12, 2012 at 01:21:32PM +0200, Kimmo Mustonen wrote:
> I have an ext4 partition that seems to have used all reserved gdt blocks.

The original on-line resize scheme required gdt blocks to be reserved
so there would be room for the group descriptor table blocks (which
had to be contiguous).  The number of group descriptor blocks that was
reserved calculated to be a thousand times the size of the original
file system, which would normally be enough.  *But* it was also capped
by a limitation in how we reserved the gdt blocks such that the sum of
the in-use gdt blocks plus reserved gdt blocks could not exceed 1024
blocks.  Before the 64-bit option, this was not a problem, since we
would hit the 16T limitation at the same time.  However, when the
64-bit option is enabled, it's possible to run out of gdt blocks using
the old scheme; this is the limitation which you hit.

In the very latest kernels, we have added a new on-line resizing
scheme, which does not require that block group descriptors be
contiguous.  However, it requires the very latest version of e2fsprogs
(1.42.6) and the to-be-released 3.7 kernel (the new on-line resizing
code landed in 3.7-rc1, during the merge window).

If you are willing to temporarily boot a bleeding edge 3.7 kernel and
use the resize2fs from e2fsprogs 1.42.6, you'll be able to resizing
your partition.  After you do this, you could fall back to the Debian
stable kernel and things should work w/o problems; the latest kernel
and e2fsprogs code is needed just for the online resize operation.
The resulting file system will be recognized by older kernels and
e2fsprogs programs.

Regards,

						- Ted
