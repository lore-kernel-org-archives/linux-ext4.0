From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Implement subtree ID support for ext4
 filesystem
Date: Mon, 9 Jul 2012 17:04:39 -0400
Message-ID: <20120709210439.GB11960@thunk.org>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
 <1341847725-26114-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38107 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab2GIVEn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 17:04:43 -0400
Content-Disposition: inline
In-Reply-To: <1341847725-26114-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 09, 2012 at 07:28:44PM +0400, Dmitry Monakhov wrote:
> * Abstract
>   A subtree of a directory tree T is a tree consisting of a directory
>   (the subtree root) in T and all of its descendants in T.
> 
>   *NOTE*: User is allowed to break pure subtree hierarchy via manual
>           id manipulation.
> 
>   Subtree subtrees assumptions:
>   (1) Each inode has an id. This id is persistently stored inside
>       inode (xattr, usually inside ibody)
>   (2) Subtree id is inherent from parent directory
                      ^^^^^^^^ inherited

What really bothers me about this patch is that the abstraction is
extremely leaky.  In particular, it's not just "manual id
manipulation" that will break the abstraction.  If you rename a file
or directory across subtrees, it breaks the abstraction; so does hard
links.

When you get right down to it, this is effectively a secondary group
id, except it's not used for access control, but rather for quota
tracking.  You've used the name "subtree" id, but in fact there's no
guarantee subtrees has anything to do with it.  With a few renames,
any semblance of a subtree organization seems to disappear very
easily.

Another question which gets raised is is allowed to change the project
ownership?  Maybe I'm missing something, but I don't see any access
checking, so today it seems the answer is "anybody".  We could change
it so that only a root process can change project ownership, that
could raise other problems.

I also worry that this feature will have very limited applicability.
Will anyone other than parallels use it?

					- Ted
