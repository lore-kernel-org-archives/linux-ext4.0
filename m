From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/ext3: use kzalloc instead of kmalloc
Date: Tue, 25 Dec 2012 23:45:32 -0500
Message-ID: <20121226044532.GB16669@thunk.org>
References: <50D7E815.6050503@asianux.com>
 <20121225184825.GD5318@thunk.org>
 <50DA6BC7.1000804@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40384 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab2LZEpj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Dec 2012 23:45:39 -0500
Content-Disposition: inline
In-Reply-To: <50DA6BC7.1000804@asianux.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 26, 2012 at 11:15:19AM +0800, Chen Gang wrote:
> 
>   checking the ext3_acl_size, it does not like what you said above.
>   but we can say, the design for ext3_acl_size is really not quit well.
>     (maybe can cause issue).

Ah, I see.  What's there is OK, but it's not at all obvious that it's
OK.  A valid acl must have a very specific order of tags, as enforced
by posix_acl_valid() in fs/posix_acl.c:

ACL_USER_OBJ ACL_USER*[1] ACL_GROUP_OBJ ACL_GROUP*[1] ACL_MASK[2] ACL_OTHER 

[1] Where * is the regexp sense of "0 or more times"
[2] Only if there is at least one ACL_USER or ACL_GROUP tag; otherwise
	skip ACL_MASK.

Hence, a valid acl can have at most 4 short acl entry types
(ACL_USER_OBJ, ACL_GROUP, ACL_MASK, and ACL_OTHER), and if there is
less than 4 acl entries, they must all be short acl types.

All I can say is, this is a horrible way of coding things, and I wish
this was documented explicitly somewhere either in fs/posix_acl.c or
in include/linux/posix_acl.h.  Yuck, yuck, yuck....

						- Ted
