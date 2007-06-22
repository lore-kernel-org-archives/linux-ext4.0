From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Endianness bugs in e2fsck
Date: Fri, 22 Jun 2007 18:20:58 -0400
Message-ID: <20070622222056.GB22889@thunk.org>
References: <1182331988.9772.7.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60275 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXFVWml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 18:42:41 -0400
Content-Disposition: inline
In-Reply-To: <1182331988.9772.7.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 20, 2007 at 03:03:08PM +0530, Kalpak Shah wrote:
> In ext2fs_swap_inode_full() if to and from inodes are not the same
> (which is the case when called from e2fsck_get_next_inode_full),
> then e2fsck cannot recognize any in-inode EAs since the un-swabbed
> i_extra_isize was being used. So corrected that to use swabbed
> values all the time.

Actually, this is wrong.  Remember, the swab functions are used to
swap *from* and *to* host byte order and on-disk order.  So yes, there
was a bug in that we were also using the f->i_extra_size, but using
t->i_extra_size is also going to be wrong in some cases.  That's what
the hostorder parameter to ext2fs_swap_inode_full() is for.

					- Ted
