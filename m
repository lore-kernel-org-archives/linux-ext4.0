From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/3] ext4: Implement subtree ID support for ext4 filesystem
Date: Wed, 11 Jul 2012 16:59:24 +0400
Message-ID: <874npefo7n.fsf@dmbot.sw.ru>
References: <1341847725-26114-1-git-send-email-dmonakhov@openvz.org> <1341847725-26114-3-git-send-email-dmonakhov@openvz.org> <20120709210439.GB11960@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57507 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2GKM7c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2012 08:59:32 -0400
In-Reply-To: <20120709210439.GB11960@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 9 Jul 2012 17:04:39 -0400, Ted Ts'o <tytso@mit.edu> wrote:
> On Mon, Jul 09, 2012 at 07:28:44PM +0400, Dmitry Monakhov wrote:
> > * Abstract
> >   A subtree of a directory tree T is a tree consisting of a directory
> >   (the subtree root) in T and all of its descendants in T.
> > 
> >   *NOTE*: User is allowed to break pure subtree hierarchy via manual
> >           id manipulation.
> > 
> >   Subtree subtrees assumptions:
> >   (1) Each inode has an id. This id is persistently stored inside
> >       inode (xattr, usually inside ibody)
> >   (2) Subtree id is inherent from parent directory
>                       ^^^^^^^^ inherited
> 
> What really bothers me about this patch is that the abstraction is
> extremely leaky.  In particular, it's not just "manual id
> manipulation" that will break the abstraction.  If you rename a file
> or directory across subtrees, it breaks the abstraction; so does hard
> links.
Yes this is my bad, bad name was chosen. When people hear about subtree they
do expect to see a true subtree (ADG). But the feature i want to add is
not about true subtree hierarchy, this is just an 3'rd inode's identifier
similar to uid/gid, subtree hierarchy is just one of most obvious
use-case. I just want to pick the best name for the feature

May be it would be better if i describe feature as "Namespace ID"
namespaces is well known abstraction in kernel, so misunderstanding
shouldn't happen.

Updated feature description:
1) Add XID (extension ID) the 3'rd inode's identifier similar to UID/GID
2) XID is stored inside xattr
3) XID is obtained from current task from current->cred->xid
4) XID is initialized on clone() according to namespace->xid

Obviously one can understand xid as "chroot id", "container id", or
"process-set id"
What do you think about that description?
> 
> When you get right down to it, this is effectively a secondary group
> id, except it's not used for access control, but rather for quota
> tracking.  You've used the name "subtree" id, but in fact there's no
> guarantee subtrees has anything to do with it.  With a few renames,
> any semblance of a subtree organization seems to disappear very
> easily.
> 
> Another question which gets raised is is allowed to change the project
> ownership?  Maybe I'm missing something, but I don't see any access
> checking, so today it seems the answer is "anybody".  We could change
> it so that only a root process can change project ownership, that
> could raise other problems.
Definitely, this should be restricted to CAP_SYS_ADMIN
> 
> I also worry that this feature will have very limited applicability.
> Will anyone other than parallels use it?
Off course no, this is very useful feature, but seems no one know
about this yet :). Third quota identifier should be usefully in following
cases:
1) Various containers implementation XLR and others
2) Chroot environments. For example I have an Android chroot environment
   and i want to prevent it from eat all space on my disk.
3) NFS: Per-mount quota. Server administrator is able to assign global
   disk limit for single nfs-share w/o limiting uid/gid quotas
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
