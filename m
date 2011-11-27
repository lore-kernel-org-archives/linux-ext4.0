From: Ted Ts'o <tytso@mit.edu>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Sun, 27 Nov 2011 16:34:32 -0500
Message-ID: <20111127213432.GA22465@thunk.org>
References: <4ED2994A.9080907@gmail.com>
 <4ED29C63.8070601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Alex <alex.vizor@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53430 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1K0Veg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Nov 2011 16:34:36 -0500
Content-Disposition: inline
In-Reply-To: <4ED29C63.8070601@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 27, 2011 at 11:24:03PM +0300, Alex wrote:
> BTW, after last resume from disk fs was corrupted but fsck managed
> to fix this error. So I think severity of this issue should be
> raised.

Can you reproduce this reliably?  What was running at the time of the s2disk?

What appears to be going on is that insert_inode_locked() is failing
at fs/ext4/ialloc.c:887, probably because there's another inode with
that inode number already on the superblock's hash list.  The error
codepath if insert_inode_locked() fail is incorrect; it's going to
fail_drop, which tries dropping the inode's dquot (but we haven't
calle ddquot_initialize)inode) yet) and calls unlock_new_inode(), but
I_NEW hasn't been set because insert_inode_locked().

So the warning is easy to fix; we just need to have it jump to fail
instead of fail_drop.  But the bigger issue is why did
insert_inode_locked() failed in the first place.

Did this error happen *right* after the system resumed, or did some
amount of time pass before the warning triggered?  This could have
happened because the in-memory (or possibly on-disk) copy of the inode
allocation bitmap has gotten corrupted, for example.

What was the nature of the file system corruption which e2fsck decided
that it need to correct?

Regards,

						- Ted
