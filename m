From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 08/11] ext4: introduce subtree logic
Date: Tue, 09 Feb 2010 12:29:29 +0300
Message-ID: <878wb2pxja.fsf@openvz.org>
References: <1265635693-12182-1-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-2-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-3-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-4-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-5-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-6-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-7-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-8-git-send-email-dmonakhov@openvz.org>
	<1265635693-12182-9-git-send-email-dmonakhov@openvz.org>
	<494905CF-659F-4F8E-ACB3-D0030CE69B6C@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43779 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0BIJ3e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Feb 2010 04:29:34 -0500
Received: by bwz19 with SMTP id 19so602961bwz.28
        for <linux-ext4@vger.kernel.org>; Tue, 09 Feb 2010 01:29:33 -0800 (PST)
In-Reply-To: <494905CF-659F-4F8E-ACB3-D0030CE69B6C@sun.com> (Andreas Dilger's
	message of "Mon, 08 Feb 2010 17:49:51 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@sun.com> writes:

> On 2010-02-08, at 06:28, Dmitry Monakhov wrote:
>>  A subtree of a directory tree T is a tree consisting of a directory
>>  (the subtree root) in T and all of its descendants in T.
>>
>>  Subtree feature allows to create an isolated (from user point of
>> view)
>>  trees.
>>
>>  Subtree assumptions:
>>  (1) Each inode has subtree id. This id is persistently stored inside
>>      inode (xattr, usually inside ibody)
>>  (2) Subtree id is inherent from parent directory
>>  (3) Inode can not belongs to different subtree
>>      Otherwise changes in one subtree result in changes in other
>> subtree
>>      which contradict to isolation criteria.
>>
>>  This feature is similar to project-id in XFS. One may assign some
>> id to
>>  a subtree. Each entry from the subtree may be accounted in directory
>>  subtree quota. Will appear in later patches.
>>
>> * Disk layout
>>  Subtree id is stored on disk inside xattr usually inside ibody.
>>  Xattr is used only as a data storage, It has not user visiable xattr
>>  interface.
>
>
> Presumably this would need e2fsck support, in order to ensure that
> inodes in a given directory have the same subtree ID as the parent
> directory.
Yes i'm working on this, I've already prepared ioctl support
for chattr/lsattr.
> Also, how are the subtree IDs generated, to ensure that they are
> unique between subtrees?
This is user responsibility. There is possible situation where 
set of subtrees may has same ID. The main idea it that each of
such subtrees is a *full* subtree (it includes all nodes starting
from the subtree root)
About isolation: currently there is a discussion about this feature
some people state that subtrees may exist without a isolation
requirement. Let's wait where it goes.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
