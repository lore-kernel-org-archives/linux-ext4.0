From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH, RFC] ext4: don't clear orphan list on ro mount with errors
Date: Mon, 27 Aug 2012 17:31:07 -0600
Message-ID: <9B528F50-65A2-48C5-A76F-F8B6DFB66636@dilger.ca>
References: <503BC685.7090707@redhat.com> <503BCA24.7050100@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49697 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2H0XbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Aug 2012 19:31:09 -0400
In-Reply-To: <503BCA24.7050100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-27, at 1:27 PM, Eric Sandeen wrote:
> When we have a filesystem with an orphan inode list *and* in error
> state, things behave differently if:
> 
> 1) e2fsck -p is done prior to mount: e2fsck fixes things and exits
>   happily (barring other significant problems)
> 
> vs.
> 
> 2) mount is done first, then e2fsck -p: due to the orphan inode
>   list removal, more errors are found and e2fsck exits with
>   UNEXPECTED INCONSISTENCY.
> 
> The 2nd case above, on the root filesystem, has the tendency to halt
> the boot process, which is unfortunate.

I think the reasoning is that if the filesystem is corrupted, then
processing the orphan list may introduce further corruption.  If one
has to run a full e2fsck run anyway, then there is no benefit to be
had from processing the orphan list in advance, and a potential
downside (e.g. corrupt inode in the list pointing to some valid inode
and causing it to be deleted).

That said, it depends on how robust the orphan handling code is -
if it won't get confused and delete an in-use inode (i.e. dtime == 0)
then it probably is OK.  I wouldn't trust the inode bitmaps to determine
if the inode is in use or not, only whether it is referenced by some
directory.

That said, no value in trying to clear the orphan list on a read-only fs,
so I think you patch is OK.

Acked-by: Andreas Dilger <adilger@dilger.ca>

> The situation can be improved by not clearing the orphan
> inode list when the fs is mounted readonly.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2d51cd9..2e1ea01 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2165,10 +2165,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
> 	}
> 
> 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
> -		if (es->s_last_orphan)
> +		/* don't clear list on RO mount w/ errors */
> +		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
> 			jbd_debug(1, "Errors on filesystem, "
> 				  "clearing orphan list.\n");
> -		es->s_last_orphan = 0;
> +			es->s_last_orphan = 0;
> +		}
> 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
> 		return;
> 	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





