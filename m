From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tests: add test for symlink extent
Date: Tue, 10 Apr 2012 23:45:47 -0400
Message-ID: <20120411034547.GD12044@thunk.org>
References: <1334093657-32559-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42462 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab2DKDpv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Apr 2012 23:45:51 -0400
Content-Disposition: inline
In-Reply-To: <1334093657-32559-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 10, 2012 at 03:34:17PM -0600, Andreas Dilger wrote:
> Long symlinks with the EXT4_EXTENTS_FL set may have been created at
> one time due to the EXTENTS_FL being inherited from the parent dir.
> While the original cause of such symlinks has been fixed in the
> upstream kernel commit 2dc6b0d48ca0599837df21b14bb8393d0804af57,
> such symlinks may still exist in the wild.

Huh?  We're still creating long symlinks with extents, and I'm not
sure why this would be a problem.  I don't mind a test for it, but it
seems strange that (a) you think e2fsprogs wouldn't be able to deal
with it, and (b) that we aren't doing it any more.  I just tested with
a 3.3 kernel with the patches from the ext4's 3.4 merge window, and it
created a symlink with an extent.

See line 872 of fs/ext4/ialloc.c:

	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
		/* set extent flag only for directory, file and normal symlink*/
		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
			ext4_ext_tree_init(handle, inode);
		}
	}

						- Ted
