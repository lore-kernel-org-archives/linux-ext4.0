From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Unify inode flags bit and inode flags.
Date: Sun, 11 Dec 2011 21:40:00 -0500
Message-ID: <20111212024000.GA12433@thunk.org>
References: <1323655189-3417-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41211 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab1LLCkF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Dec 2011 21:40:05 -0500
Content-Disposition: inline
In-Reply-To: <1323655189-3417-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2011 at 09:59:49AM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In order to make atomic set/get of inode flags, we create a enum of
> different inode flags. Now when we add a new inode flag(e.g inline data),
> we have to add both the 'enum' and the 'define' and calculate the value
> of 'define' by ourselves. This is a bit boring and error-prune.
> So this patch just unify these 2 fields.

This was deliberate.  The problem is these flags also have to be in
sync with the hex values defined in include/linux/fs.h (and in some
other file systems' header files), not to mention the definitions in
e2fsprogs.

This is because the lsattr and chattr command was originally defined
originally for ext2/3, but then other file systems (reiserfs, xfs,
btrfs, etc) decided they would also use the same ioctls and userspace
commands.  So we have partial overlap of these flags, and when we
define new flags we have to be a little careful to make sure we
coordinate between all of the places where these flags are defined.

So the fact that this is also an ABI is why I don't want to use an
enum and to calculate the values from that.

					- Ted
