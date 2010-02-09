From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 08/11] ext4: introduce subtree logic
Date: Mon, 08 Feb 2010 17:49:51 -0700
Message-ID: <494905CF-659F-4F8E-ACB3-D0030CE69B6C@sun.com>
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
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52946 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0BIECm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 23:02:42 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o1942d5N005198
	for <linux-ext4@vger.kernel.org>; Mon, 8 Feb 2010 20:02:41 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KXK00700373X100@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 08 Feb 2010 20:02:39 -0800 (PST)
In-reply-to: <1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-02-08, at 06:28, Dmitry Monakhov wrote:
>  A subtree of a directory tree T is a tree consisting of a directory
>  (the subtree root) in T and all of its descendants in T.
>
>  Subtree feature allows to create an isolated (from user point of  
> view)
>  trees.
>
>  Subtree assumptions:
>  (1) Each inode has subtree id. This id is persistently stored inside
>      inode (xattr, usually inside ibody)
>  (2) Subtree id is inherent from parent directory
>  (3) Inode can not belongs to different subtree
>      Otherwise changes in one subtree result in changes in other  
> subtree
>      which contradict to isolation criteria.
>
>  This feature is similar to project-id in XFS. One may assign some  
> id to
>  a subtree. Each entry from the subtree may be accounted in directory
>  subtree quota. Will appear in later patches.
>
> * Disk layout
>  Subtree id is stored on disk inside xattr usually inside ibody.
>  Xattr is used only as a data storage, It has not user visiable xattr
>  interface.


Presumably this would need e2fsck support, in order to ensure that  
inodes in a given directory have the same subtree ID as the parent  
directory.

Also, how are the subtree IDs generated, to ensure that they are  
unique between subtrees?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

