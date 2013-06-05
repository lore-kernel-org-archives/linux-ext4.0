From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH]mke2fs: Calculate journal blocks just after fs initialize
Date: Wed, 5 Jun 2013 13:55:31 +0530
Message-ID: <CAOiN93=QDRpp7bHygcnom0ZMwU-dc1dRaGf62qw3GDXgCb7uKQ@mail.gmail.com>
References: <1368243733-1600-1-git-send-email-ashish.sangwan2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: "Theodore Ts'o" <tytso@mit.edu>, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43837 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3FEIZd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jun 2013 04:25:33 -0400
Received: by mail-lb0-f181.google.com with SMTP id 13so1604979lba.12
        for <linux-ext4@vger.kernel.org>; Wed, 05 Jun 2013 01:25:31 -0700 (PDT)
In-Reply-To: <1368243733-1600-1-git-send-email-ashish.sangwan2@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

any comments?

On Sat, May 11, 2013 at 9:12 AM, Ashish Sangwan
<ashishsangwan2@gmail.com> wrote:
> From: Ashish Sangwan <a.sangwan@samsung.com>
>
> We can calculate journal blocks as soon as blocksize is set.
> It will help to figure out wrong journal blocks count earlier.
> This will save some un-necessary initialization.
>
> Without patch output =>
> mke2fs /dev/sdc1 -J size=1048576
> mke2fs 1.42.7 (21-Jan-2013)
> Filesystem label=
> OS type: Linux
> Block size=4096 (log=2)
> Fragment size=4096 (log=2)
> Stride=0 blocks, Stripe width=0 blocks
> 61312 inodes, 244936 blocks
> 12246 blocks (5.00%) reserved for the super user
> First data block=0
> Maximum filesystem blocks=251658240
> 8 block groups
> 32768 blocks per group, 32768 fragments per group
> 7664 inodes per group
> Superblock backups stored on blocks:
>         32768, 98304, 163840, 229376
>
> Allocating group tables: done
> Writing inode tables: done
>
> The requested journal size is 268435456 blocks; it must be
> between 1024 and 10240000 blocks.  Aborting.
>
>
> With patch output =>
> mke2fs /dev/sdc1 -J size=1048576
> mke2fs 1.42.7 (21-Jan-2013)
>
> The requested journal size is 268435456 blocks; it must be
> between 1024 and 10240000 blocks.  Aborting.
>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> ---
>  misc/mke2fs.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bbf477a..0232053 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2407,6 +2407,12 @@ int main (int argc, char *argv[])
>                 com_err(device_name, retval, _("while setting up superblock"));
>                 exit(1);
>         }
> +
> +       /* Calculate journal blocks */
> +       if (!journal_device && ((journal_size) ||
> +               (fs_param.s_feature_compat &
> +                EXT3_FEATURE_COMPAT_HAS_JOURNAL)))
> +               journal_blocks = figure_journal_size(journal_size, fs);
>         fs->progress_ops = &ext2fs_numeric_progress_ops;
>
>         /* Check the user's mkfs options for metadata checksumming */
> @@ -2683,8 +2689,6 @@ int main (int argc, char *argv[])
>         } else if ((journal_size) ||
>                    (fs_param.s_feature_compat &
>                     EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
> -               journal_blocks = figure_journal_size(journal_size, fs);
> -
>                 if (super_only) {
>                         printf(_("Skipping journal creation in super-only mode\n"));
>                         fs->super->s_journal_inum = EXT2_JOURNAL_INO;
> --
> 1.7.2.3
>
