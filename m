From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] e2fsck: Discard only unused parts of inode table
Date: Sun, 11 Mar 2012 15:27:05 -0400
Message-ID: <20120311192705.GE1048@thunk.org>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37032 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab2CKT1H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Mar 2012 15:27:07 -0400
Content-Disposition: inline
In-Reply-To: <1330933776-2696-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 05, 2012 at 08:49:33AM +0100, Lukas Czerner wrote:
> @@ -435,6 +481,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
>  	int		skip_group = 0;
>  	int		redo_flag = 0;
>  	io_manager	manager = ctx->fs->io->manager;
> +	unsigned long long	first_free = fs->super->s_inodes_per_group + 1;

This doesn't need to be an unsigned long long; an "int" will do just
as well.

> +			/*
> +			 * If the last inode is free, we can discard it as well.
> +			 */
> +			if (inodes >= first_free)
> +				e2fsck_discard_inodes(ctx, group, first_free,
> +						      inodes - first_free + 1);

There's no guarantee the last inode is free here.  This needs to read:

			if (!bitmap && inodes >= first_free)

I'll fix this up in my version of the patches.

					- Ted
