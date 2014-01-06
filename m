From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND PATCH 2/2] ext4: ext4_inode_is_fast_symlink should use
 cluster size
Date: Mon, 6 Jan 2014 14:45:35 -0500
Message-ID: <20140106194535.GA28490@thunk.org>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com>
 <1387515880-10185-2-git-send-email-yangyongqiang01@baidu.com>
 <CAGBYx2Zx7jnK-DmM7=RCCVwz4N0FfE_-=eETO8OkLt5McCXttg@mail.gmail.com>
 <20140106145145.GC13648@thunk.org>
 <E2CB8B2A-38FD-4509-BCEF-DDF23ABA01AC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46336 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbaAFTpj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jan 2014 14:45:39 -0500
Content-Disposition: inline
In-Reply-To: <E2CB8B2A-38FD-4509-BCEF-DDF23ABA01AC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 06, 2014 at 10:47:03AM -0700, Andreas Dilger wrote:
> What about the idea to stop using the blocks count for doing the
> fast/slow symlink check, and instead use i_size?  IMHO this is far
> more robust than using the blocks count, since we've repeatedly seen
> bugs when the number of blocks allocated to an inode changes for
> done reason (e.g. xattrs, bigalloc, multi-block xattrs in the
> future).

I did see your earlier proposal on this front, but I didn't want to
this change without thinking about it a bit more closely.  In
particular, we probably would want to enforce this change in e2fsck
for a while first.

Currently, if we have a slow symlink where i_size is less than 60
bytes, both e2fsprogs and the kernel handles this case.  See the
attached file system image.

Yes, I created it synthetically, but keep in mind that that there are
other implementations of ext2/3/4 other than just in the Linux kernel.
In particular, the GNU Hurd and *BSD have their own independent
implementation of ext2.  So even if the Linux kernel has never created
a slow symlink with i_size <= 60 bytes, but that doesn't mean that
it's for certain that there are no such implementations out there in the wild.

That doesn't mean that we should never make such a change, but it does
mean that it's not something I want to do lightly.

							- Ted
