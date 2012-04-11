From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] tests: add test for symlink extent
Date: Tue, 10 Apr 2012 23:06:50 -0600
Message-ID: <1AA51704-1130-44B6-A891-203FDCDBF83D@whamcloud.com>
References: <1334093657-32559-1-git-send-email-adilger@whamcloud.com> <20120411034547.GD12044@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2DKFET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2012 01:04:19 -0400
Received: by iagz16 with SMTP id z16so769717iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 Apr 2012 22:04:18 -0700 (PDT)
In-Reply-To: <20120411034547.GD12044@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-10, at 9:45 PM, Ted Ts'o wrote:
> On Tue, Apr 10, 2012 at 03:34:17PM -0600, Andreas Dilger wrote:
>> Long symlinks with the EXT4_EXTENTS_FL set may have been created at
>> one time due to the EXTENTS_FL being inherited from the parent dir.
>> While the original cause of such symlinks has been fixed in the
>> upstream kernel commit 2dc6b0d48ca0599837df21b14bb8393d0804af57,
>> such symlinks may still exist in the wild.
> 
> Huh?  We're still creating long symlinks with extents, and I'm not
> sure why this would be a problem.  I don't mind a test for it, but it
> seems strange that (a) you think e2fsprogs wouldn't be able to deal
> with it, and (b) that we aren't doing it any more.  I just tested with
> a 3.3 kernel with the patches from the ext4's 3.4 merge window, and it
> created a symlink with an extent.

My bad.  I had examined some symlinks on an ext4 filesystem to see if they had the EXT4_EXTENTS_FL set, but didn't think to check long symlinks, so I assumed this was an anachronism and rewrote the patch description while submitting it...  Originally it read:

    Long symlinks with the EXT4_EXTENTS_FL set should no longer be
    considered as corrupt, since these are created by default with
    new kernels using ext4 as the filesystem type.  This has not
    impacted Lustre in the past because extents are only enabled on
    the OST, while symlinks are only created on the MDT where extents
    are never enabled.
    
    However, now that distros are using ext4 as the base filesystem
    type, if the lustre-patched e2fsprogs RPM is installed it will
    incorrectly consider all such long symlinks as bad and remove them.

We had previously hit problems with Lustre e2fsprogs because we originally flagged such symlinks as errors, and there was no existing test which had such a symlink.  The description clearly wasn't useful for upstream submission, but the test is still useful.

Cheers, Andreas

> See line 872 of fs/ext4/ialloc.c:
> 
> 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
> 		/* set extent flag only for directory, file and normal symlink*/
> 		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
> 			ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
> 			ext4_ext_tree_init(handle, inode);
> 		}
> 	}
> 
> 						- Ted


Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




