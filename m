From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 08/11] ext4: introduce subtree logic
Date: Mon, 8 Feb 2010 18:54:37 -0500
Message-ID: <87f94c371002081554k3e4d6019q332602fea344ccc9@mail.gmail.com>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
	 <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	OHSM-DEV <ohsm-devel@lists.sourceforge.net>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:56017 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0BHXyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 18:54:38 -0500
Received: by iwn12 with SMTP id 12so7895557iwn.26
        for <linux-ext4@vger.kernel.org>; Mon, 08 Feb 2010 15:54:37 -0800 (PST)
In-Reply-To: <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 8, 2010 at 8:28 AM, Dmitry Monakhov <dmonakhov@openvz.org> =
wrote:
> * Abstract
> =A0A subtree of a directory tree T is a tree consisting of a director=
y
> =A0(the subtree root) in T and all of its descendants in T.
>
> =A0Subtree feature allows to create an isolated (from user point of v=
iew)
> =A0trees.
>
> =A0Subtree assumptions:
> =A0(1) Each inode has subtree id. This id is persistently stored insi=
de
> =A0 =A0 =A0inode (xattr, usually inside ibody)
> =A0(2) Subtree id is inherent from parent directory
> =A0(3) Inode can not belongs to different subtree
> =A0 =A0 =A0Otherwise changes in one subtree result in changes in othe=
r subtree
> =A0 =A0 =A0which contradict to isolation criteria.
>
> =A0This feature is similar to project-id in XFS. One may assign some =
id to
> =A0a subtree. Each entry from the subtree may be accounted in directo=
ry
> =A0subtree quota. Will appear in later patches.
>
> * Disk layout
> =A0Subtree id is stored on disk inside xattr usually inside ibody.
> =A0Xattr is used only as a data storage, It has not user visiable xat=
tr
> =A0interface.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Dmitry,

I think the idea of subtrees is useful, but I'm curious about other
use cases than just quota.

At first glance you are attempting to create a generic subtree
functionality for ext4, but criteria 3) above says a inode can only be
in one subtree at a time.

Thus if quota utilizes subtrees and another future feature were to use
subtrees and the layout of the subtree details were not identical,
they would collide.  Thus with the current patch you can only have one
subtree dependent feature at a time for a given filesystem.

It seems you need something along the lines of a subtree name space
etc. in order to allow orthogonal service users to create orthogonal
subtrees.

Also, I can envision use cases where you have subtrees within subtrees.

Envision a projects folder that forms one subtree, but one specific
project within that folder needs to be in its own subtree.  If I read
your patch description right, that is not allowed because only
directories of subtree 0 are allowed to contain diverging subtrees.

ie.  A directory of subtree 0 can contain a directory of subtrees 1
and 2, but a directory of subtree 10 is not allowed to contain
subtrees 11 and 12.

Just food for thought.

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
