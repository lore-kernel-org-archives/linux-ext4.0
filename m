From: Jan Kara <jack@suse.cz>
Subject: Re: ext34_free_inode's mess
Date: Wed, 14 Apr 2010 15:34:40 +0200
Message-ID: <20100414133440.GD3616@quack.suse.cz>
References: <87pr2246y4.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49744 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0DNNef (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 09:34:35 -0400
Content-Disposition: inline
In-Reply-To: <87pr2246y4.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 14-04-10 15:19:47, Dmitry Monakhov wrote:
> I've finally automated my favorite testcase (see attachment), 
> before i've run it by hand.
> And sometimes i've saw following complain from fsck:
> fsck.ext4 -f -n /dev/sdb2
> ...
> Pass 5: Checking group summary information
> Inode bitmap differences:  -93582
> Fix? no
> 
> Free inodes count wrong for group #12 (4634, counted=4633).
> Fix? no
> 
> Free inodes count wrong (35610, counted=35609).
> Fix? no
> ...
  Interesting. So some inode is marked as free although it is in
use, right? That sounds like a nasty bug - if you reproduce this
again, could you use debugfs to find out what file type is that
inode? It could help looking for the bug.

> I've started to look an inode bitmap manipulation code paths
> and found strange logic in ext{3,4}_free_inode functions
> 
> 1) Group lock acquired twice for bitmap and for group_desc.
>    There are not any advantage from this double locking, only
>    error path(where the bit is already cleared) takes an
>    advantage from this locking schema.
>    It is reasonable to batch it in to one locking block.
  I guess you think that this happens because we pass the lock parameter
to ext3_clear_bit_atomic. But if you would actually look at the definition
of the function, you would see that it's hard to find an architecture that
uses the lock. Most architectures just use atomic bitop to clear the bit.
I actually fail to see why anyone would need the lock - probably Ted knows
:).

> 2) if we failed to read gdp then bh2 is undefined so
>    may result in oops due to undefince pointer dereferance.
  No, because during mount time we check that all gdp pointers exist so
ext3_get_group_desc can never fail after the mount has succeeded.

> 3) if we failed to get write_access to gdp we skip
>    handle_dirty_metadata for inode_bitmap which is also a bug.
  It doesn't matter. At the moment ext3_journal_get_write_access fails we
abort the journal so no writes are allowed to the filesystem anyway. So
modified bitmap has hardly any chance to get to disk and you have to
run fsck to clean up the mess anyway...

								Honza
