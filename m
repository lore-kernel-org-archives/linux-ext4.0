From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Implement subtree ID support for ext4
 filesystem
Date: Wed, 11 Jul 2012 09:24:29 -0400
Message-ID: <20120711132429.GA10872@thunk.org>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org>
 <1341847725-26114-3-git-send-email-dmonakhov@openvz.org>
 <20120709210439.GB11960@thunk.org>
 <874npefo7n.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38468 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297Ab2GKNYf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 09:24:35 -0400
Content-Disposition: inline
In-Reply-To: <874npefo7n.fsf@dmbot.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 11, 2012 at 04:59:24PM +0400, Dmitry Monakhov wrote:
> 
> May be it would be better if i describe feature as "Namespace ID"
> namespaces is well known abstraction in kernel, so misunderstanding
> shouldn't happen.

What if we call it a "quota group", with the rules that if a parent
directory has a quota group, any files or directories created in that
parent directory will inherit that quota group, and only processes
with CAP_SYS_ADMIN can change it.

And then what if we simply make the rule that if an inode has a quota
group, the quota is charged against two group id's; the group id named
in inode, and the quota group?

That is, do we really need to have a separate namespace for group ids
and "subtrees" or "namespaces"?  That means we don't have to change
the userspace quota tools and we can leverage the existing ways people
are used to managing group quotas.

						- Ted
