From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2 v2] ext4: Make ext4_block_in_group() much more
 efficient
Date: Wed, 27 Mar 2013 09:34:44 -0400
Message-ID: <20130327133444.GH5861@thunk.org>
References: <1364382245-32510-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56319 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3C0Nes (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 09:34:48 -0400
Content-Disposition: inline
In-Reply-To: <1364382245-32510-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 12:04:04PM +0100, Lukas Czerner wrote:
>  #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
>  						      specified delalloc */
> +#define EXT4_MOUNT_STD_GROUP_SIZE	0x00000002 /* We have standard group
> +						      size of blocksize * 8
> +						      blocks */

This should be EXT4_MOUNT2_STD_GROUP_SIZE, and then all calls to
set_opt, test_opt, etc. should be set_opt2, test_opt2, etc.  As it
turns out bit 0x0002 isn't used for flags in s_mount_opt family, so
the other fix would be to move this definition to before
EXT4_MOUNT_GRPID in ext4.

However, the EXT4_MOUNT_* options should be reserved for options that
are set via mount options, since we have support for setting bits in
s_mount_opt via a table-driven approach (see how the mount_opt field
in the struct mount_opts in fs/ext4/super.c is used).  So for things
that are set automatically, such as in this case, we should use a bit
assignment for s_mount_opt2.

Cheers,

					- Ted
