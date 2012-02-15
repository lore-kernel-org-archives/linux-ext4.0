From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: Only link an inode into a directory once
Date: Wed, 15 Feb 2012 14:25:37 -0500
Message-ID: <20120215192537.GI11382@thunk.org>
References: <20120107044743.3366.16848.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44542 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab2BOTZk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 14:25:40 -0500
Content-Disposition: inline
In-Reply-To: <20120107044743.3366.16848.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 06, 2012 at 08:47:43PM -0800, Darrick J. Wong wrote:
> The ext2fs_link helper function link_proc does not check the value of ls->done,
> which means that if the function finds multiple empty spaces that will fit the
> new directory entry, it will create a directory entry in each of the spaces.
> Instead of doing that, check the done value and don't do anything more if we've
> already added the directory entry.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

This should't necessary, since when we insert the directory entry, we
return with the DIRENT_ABORT bit set:

        dirent->inode = ls->inode;
        dirent->name_len = ls->namelen;
        strncpy(dirent->name, ls->name, ls->namelen);
        if (ls->sb->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
                dirent->name_len |= (ls->flags & 0x7) << 8;

        ls->done++;
        return DIRENT_ABORT|DIRENT_CHANGED;

Did you actually observe this happening?

Thanks,

					- Ted
