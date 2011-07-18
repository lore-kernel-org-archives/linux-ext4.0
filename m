From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 03/12] ext4: prevent a fs without journal from being resized
Date: Mon, 18 Jul 2011 01:00:07 -0600
Message-ID: <B8ADF8C0-6CA5-4535-A666-E7E333AC8CCE@dilger.ca>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com> <1310957555-15617-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:33066 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1GRHAI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Jul 2011 03:00:08 -0400
In-Reply-To: <1310957555-15617-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-17, at 8:52 PM, Yongqiang Yang wrote:
> This patch prevents a fs without journal from being resized, because
> it is easy to detroy the fs.

This is somewhat surprising.  I can partly agree with it - the ext4
nojournal mode appeared after the online resizing, so it probably has
some holes in the nojournal recovery.

I suspect a well-placed sync could fix any problems, however.  Probably
just before the group/space was made available would be enough, either
once per group with the current code, or possibly once per resize with
your new code (depending on how it is implemented).  If one sync per
group is considered bad (because of impact to other IO) then it might
be enough to fdatasync only the parts of the device beyond the end of
the filesystem and the backup metadata.

> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
> fs/ext4/resize.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 53d9795..33ab40d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -33,6 +33,16 @@ int ext4_resize_begin(struct super_block *sb)
> 		return -EPERM;
> 	}
> 
> +	/*
> +	 * We are not allowed to do online-resizing on a filesystem without
> +	 * journal, otherwise, it is easy to destroy the filesystem.
> +	 */
> +	if (!EXT4_SB(sb)->s_journal) {
> +		ext4_warning(sb, "There is no journal for the filesystem, "
> +			     "so online resizing is not allowed\n");
> +		return -EPERM;
> +	}
> +
> 	if (test_and_set_bit_lock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags))
> 		ret = -EBUSY;
> 
> -- 
> 1.7.5.1
> 


Cheers, Andreas





