From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH 1/6] Add helper function for blkdev_issue_zeroout
Date: Wed, 15 Sep 2010 16:33:56 -0400
Message-ID: <AANLkTik3vm6PYig5oAbB9P1e=1Nyz6tREpYJHuKOTRCN@mail.gmail.com>
References: <1284568568-13637-1-git-send-email-lczerner@redhat.com> <1284568568-13637-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, rwheeler@redhat.com,
	sandeen@redhat.com, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39143 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab0IOUeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Sep 2010 16:34:17 -0400
Received: by bwz11 with SMTP id 11so913341bwz.19
        for <linux-ext4@vger.kernel.org>; Wed, 15 Sep 2010 13:34:16 -0700 (PDT)
In-Reply-To: <1284568568-13637-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 15, 2010 at 12:36 PM, Lukas Czerner <lczerner@redhat.com> w=
rote:
> This is done the same way as function sb_issue_discard for
> blkdev_issue_discard.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> =A0include/linux/blkdev.h | =A0 =A08 ++++++++
> =A01 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 09a8402..a22939d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1023,6 +1023,14 @@ static inline int sb_issue_discard(struct supe=
r_block *sb,
> =A0 =A0 =A0 =A0return blkdev_issue_discard(sb->s_bdev, block, nr_bloc=
ks, GFP_KERNEL,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 B=
LKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
> =A0}
> +static inline int sb_issue_zeroout(struct super_block *sb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
sector_t block, sector_t nr_blocks)
> +{
> + =A0 =A0 =A0 block <<=3D (sb->s_blocksize_bits - 9);
> + =A0 =A0 =A0 nr_blocks <<=3D (sb->s_blocksize_bits - 9);
> + =A0 =A0 =A0 return blkdev_issue_zeroout(sb->s_bdev, block, nr_block=
s, GFP_KERNEL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
> +}

You'll need to rebase this patch against Jens' linux-2.6-block.git
'for-next' branch.  The flags have changed such that the
sb_issue_discard caller passes them in (and BLKDEV_IFL_BARRIER no
longer exists).  See the following commits from linux-2.6-block.git:

http://git.kernel.org/?p=3Dlinux/kernel/git/axboe/linux-2.6-block.git;a=
=3Dcommit;h=3D2cf6d26a354ab
http://git.kernel.org/?p=3Dlinux/kernel/git/axboe/linux-2.6-block.git;a=
=3Dcommit;h=3D61002f7db33c7
http://git.kernel.org/?p=3Dlinux/kernel/git/axboe/linux-2.6-block.git;a=
=3Dcommit;h=3D8c5553678237b
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
