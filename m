From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove CONFIG_EXT4_FS_XATTR.
Date: Mon, 10 Dec 2012 14:21:39 -0500
Message-ID: <20121210192139.GE7516@thunk.org>
References: <nsxsj7kw2jq.fsf@closure.thunk.org>
 <1355120348-5117-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, David Brown <davidb@codeaurora.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37833 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2LJTVr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 14:21:47 -0500
Content-Disposition: inline
In-Reply-To: <1355120348-5117-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Applied, with some minor fixups so it works with the extents_status
tree patches, and also to fix a buglet which in fs/ext4/super.c:

> @@ -1447,13 +1445,10 @@ static const struct mount_opts {
>  	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_DATAJ},
>  	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_DATAJ},
>  	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA, MOPT_DATAJ},
> -#ifdef CONFIG_EXT4_FS_XATTR
>  	{Opt_user_xattr, EXT4_MOUNT_XATTR_USER, MOPT_SET},
>  	{Opt_nouser_xattr, EXT4_MOUNT_XATTR_USER, MOPT_CLEAR},
> -#else
>  	{Opt_user_xattr, 0, MOPT_NOSUPPORT},
>  	{Opt_nouser_xattr, 0, MOPT_NOSUPPORT},
> -#endif

The table entries between the #else and #endif in the above patch
chunlk needs to be removed as well.

I've fixed this in my tree.

Regards,

					- Ted
