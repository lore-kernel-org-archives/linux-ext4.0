From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: WARNING: at fs/inode.c:884 unlock_new_inode+0x34/0x59()
Date: Mon, 05 Dec 2011 14:54:54 -0600
Message-ID: <4EDD2F9E.3000704@redhat.com>
References: <4ED2994A.9080907@gmail.com> <4ED29C63.8070601@gmail.com> <20111127213432.GA22465@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex <alex.vizor@gmail.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636Ab1LEUzF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 15:55:05 -0500
In-Reply-To: <20111127213432.GA22465@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/27/11 3:34 PM, Ted Ts'o wrote:
> On Sun, Nov 27, 2011 at 11:24:03PM +0300, Alex wrote:
>> BTW, after last resume from disk fs was corrupted but fsck managed
>> to fix this error. So I think severity of this issue should be
>> raised.
> 
> Can you reproduce this reliably?  What was running at the time of the s2disk?
> 
> What appears to be going on is that insert_inode_locked() is failing
> at fs/ext4/ialloc.c:887, probably because there's another inode with
> that inode number already on the superblock's hash list.  The error
> codepath if insert_inode_locked() fail is incorrect; it's going to
> fail_drop, which tries dropping the inode's dquot (but we haven't
> calle ddquot_initialize)inode) yet) and calls unlock_new_inode(), but
> I_NEW hasn't been set because insert_inode_locked().

OK; this looks to be the result of:

commit 250df6ed274d767da844a5d9f05720b804240197
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Mar 22 22:23:36 2011 +1100

    fs: protect inode->i_state with inode->i_lock

(went in on 2.6.39)

because before that, insert_inode_locked() used to unconditionally do:

-       inode->i_state |= I_NEW;

but that's gone now.  Now if the function fails it'll return the
inode w/o I_NEW set.

ext2/3/4, jffs2, and jfs all call unlock_new_inode() on insert_inode_locked()
failure, and all would warn on this path.

I'm still not clear on what's causing insert_inode_locked() to fail,
but it used to be harmless (or at least silent) before.

I suppose it makes most sense to fix all callers to not clear I_NEW
on failure, unless it's too icky; it does seem weird to have I_NEW set
if we return with failure.

-Eric




> So the warning is easy to fix; we just need to have it jump to fail
> instead of fail_drop.  But the bigger issue is why did
> insert_inode_locked() failed in the first place.
> 
> Did this error happen *right* after the system resumed, or did some
> amount of time pass before the warning triggered?  This could have
> happened because the in-memory (or possibly on-disk) copy of the inode
> allocation bitmap has gotten corrupted, for example.
> 
> What was the nature of the file system corruption which e2fsck decided
> that it need to correct?
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

