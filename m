From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext3: use kzalloc instead of kmalloc
Date: Tue, 25 Dec 2012 13:48:25 -0500
Message-ID: <20121225184825.GD5318@thunk.org>
References: <50D7E815.6050503@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40291 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab2LYSsf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Dec 2012 13:48:35 -0500
Content-Disposition: inline
In-Reply-To: <50D7E815.6050503@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 24, 2012 at 01:28:53PM +0800, Chen Gang wrote:
> 
>   better to use kzalloc instead of kmalloc.
>     if acl_e->e_tag is neither ACL_USER, nor ACL_GROUP.
>     entry->e_id will not be initialized
> 
>   we can not say it is a bug, but suggest to initialize it, too.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

This shouldn't be a problem, since if e_tag is not ACL_USER nor
ACL_GROUP, the on-disk encoding does not include e_id at all.

That being said, it looks to me there's another bug hiding here.  The
size of the extended attribute is calculated by ext3_acl_size(), and
it looks totally wrong.  For one thing, it caluclates the size of the
xattr assuming all of the stored encoding ext3_acl_entry_short ---
which would not be the case if we had a acl entry of type ACL_USER or
ACL_GROUP.

But if that were the case, it would mean that we would not be storing
the full acl entry on disk, which would be a pretty horrible and
obvious breakage.

I haven't had time to check this yet, but I wanted to flag this so
hopefully someone else should double check this.....  It would seem to
me that the better thing to do would be to calculate the size as part
of the for loop in ext3_acl_to_disk(), and drop ext3_acl_size() from
acl.h.  (This code exists in ext4 as well, so if we have a bug in
ext3, we would have a similar bug in ext4.)


						- Ted
