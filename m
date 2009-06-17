From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: write only core inode in update_path()
Date: Wed, 17 Jun 2009 18:46:42 -0400
Message-ID: <20090617224642.GD7867@mit.edu>
References: <429929.18438.qm@web43515.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41253 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761297AbZFQWrI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 18:47:08 -0400
Content-Disposition: inline
In-Reply-To: <429929.18438.qm@web43515.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 17, 2009 at 02:32:18PM -0700, number9652 wrote:
> I was too general in my statement above about what it broke.  I think (didn't test) if a program follows this path:
> extent_open(...,*handle)
> write_inode_full(...,handle->inode,...)
>   that it will read uninitialized memory in write_inode_full.  It
>seems clear that all previously written code assumes that this path
>is valid, and fixing all that to not assume that would seemingly be
>much more than just what your patch fixes and require more time to
>test.  If you only use read/write_inode_full, everything is still
>okay.

Um, but that can't happen; the ext2_extent_handle_t type is an opaque
type.  So outside of code in lib/ext2fs/extent.c, no one else can see
the inode in the ext2_handle_t.

The safest thing to do is to simply make the extent code only use
ext2_write_inode and ext2_read_inode.  Otherwise, we have to worry
about a user passing in the smaller 128-byte inode form.  The extent
code doesn't need any of the extended inode fields, so this is
completely safe.

						- Ted
