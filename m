From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] dumpe2fs: Warn when filesystem is mounted read-write
Date: Thu, 28 Jul 2011 10:44:30 -0600
Message-ID: <1968AC77-D564-47DB-8D15-5F5FBB75B08B@dilger.ca>
References: <1311866224-27351-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:60451 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab1G1QoD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jul 2011 12:44:03 -0400
In-Reply-To: <1311866224-27351-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-28, at 9:17 AM, Jan Kara <jack@suse.cz> wrote:
> When dumpe2fs is used on a filesystem mounted read-write, printed information
> may be old and inconsistent because e.g. updates of some superblock fields
> happen lazily or because we do not really try to handle various intermediate
> states of filesystem operations. Document this in the manpage and warn user
> when dumpe2fs is used for such filesystem.

Jan, does this specifically relate to the free blocks or free inodes count?  My preference would actually be to have dumpe2fs print the correct values. I guess that means reading all of the group descriptors and adding up the free block/inode counts like the kernel does. 

I'm not against this patch in principle, since any operation on a mounted filesystem is inherently racy, but as it stands now the information printed by dumpe2fs can be completely useless. 

Cheers, Andreas

> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> misc/dumpe2fs.8.in |    3 ++-
> misc/dumpe2fs.c    |   14 ++++++++++++++
> 2 files changed, 16 insertions(+), 1 deletions(-)
> 
>  Ted, would you take this change? We actually had to explain to our users that
> what they were doing isn't really going to work reliably...
> 
> diff --git a/misc/dumpe2fs.8.in b/misc/dumpe2fs.8.in
> index c1dfcbd..e1336dc 100644
> --- a/misc/dumpe2fs.8.in
> +++ b/misc/dumpe2fs.8.in
> @@ -71,7 +71,8 @@ print the version number of
> and exit.
> .SH BUGS
> You need to know the physical filesystem structure to understand the
> -output.
> +output. When used with a mounted filesystem, the printed information may be
> +old or inconsistent.
> .SH AUTHOR
> .B dumpe2fs 
> was written by Remy Card <Remy.Card@linux.org>.  It is currently being
> diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> index 9a0dd46..fa1362a 100644
> --- a/misc/dumpe2fs.c
> +++ b/misc/dumpe2fs.c
> @@ -495,6 +495,7 @@ int main (int argc, char ** argv)
>    int        flags;
>    int        header_only = 0;
>    int        c;
> +    int        mount_flags;
> 
> #ifdef ENABLE_NLS
>    setlocale(LC_MESSAGES, "");
> @@ -567,6 +568,13 @@ int main (int argc, char ** argv)
>        printf (_("Couldn't find valid filesystem superblock.\n"));
>        exit (1);
>    }
> +    retval = ext2fs_check_if_mounted(device_name, &mount_flags);
> +    if (retval) {
> +        com_err("ext2fs_check_if_mount", retval,
> +            _("while determining whether %s is mounted."),
> +            device_name);
> +        exit(1);
> +    }
>    if (print_badblocks) {
>        list_bad_blocks(fs, 1);
>    } else {
> @@ -595,6 +603,12 @@ int main (int argc, char ** argv)
>        }
>    }
>    ext2fs_close (fs);
> +    if ((mount_flags & EXT2_MF_MOUNTED) &&
> +        !(mount_flags & EXT2_MF_READONLY)) {
> +        fputs(_("The filesystem is read-write mounted so printed"
> +            " information may be old or inconsistent.\n"), stderr);
> +    }
> +
>    remove_error_table(&et_ext2_error_table);
>    exit (0);
> }
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
