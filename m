From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 1/2] ext4: Fix BUG_ON in ext4_da_block_invalidatepages()
Date: Wed, 16 Mar 2011 14:02:02 -0700
Message-ID: <AANLkTin31soAwuZERFTikPtCHXtj6G52HXgj6ep2=eGR@mail.gmail.com>
References: <1300308774-14140-1-git-send-email-jack@suse.cz>
	<1300308774-14140-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47682 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab1CPVCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2011 17:02:04 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id p2GL23Th003660
	for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2011 14:02:03 -0700
Received: from qwg5 (qwg5.prod.google.com [10.241.194.133])
	by wpaz29.hot.corp.google.com with ESMTP id p2GL1aV7022331
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2011 14:02:02 -0700
Received: by qwg5 with SMTP id 5so1899480qwg.31
        for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2011 14:02:02 -0700 (PDT)
In-Reply-To: <1300308774-14140-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan:

This problem was fixed by the patch I sent on 18 Feb, titled

   [PATCH 1/2] ext4: mark multi-page IO complete on mapping failure

I guess this didn't make it into 2.6.38, but it's in the ext4 patch que=
ue now.

Thanks,
Curt

On Wed, Mar 16, 2011 at 1:52 PM, Jan Kara <jack@suse.cz> wrote:
> When an allocation of blocks fails in mpage_da_map_and_submit() e.g. =
because of
> EIO we call ext4_da_block_invalidatepages() to invalidate pages we ca=
nnot write
> but we fail to set mpd->io_done. Thus we continue searching for dirty=
 pages and
> add them to the current extent in mpd structure. Eventually we try to=
 allocate
> blocks for the extent again and strange things start happening. In pa=
rticular
> if the allocation fails again, we try to invalidate pages again and t=
hat
> triggers BUG_ON in ext4_da_block_invalidatepages().
>
> Fix the issue by setting mpd->io_done after the pages are invalidated=
=2E
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
> =A0fs/ext4/inode.c | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9f7f9e4..337d9ca 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2314,6 +2314,7 @@ static void mpage_da_map_and_submit(struct mpag=
e_da_data *mpd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* invalidate all the pages */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_da_block_invalidatepages(mpd, nex=
t,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mpd->b=
_size >> mpd->inode->i_blkbits);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mpd->io_done =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0BUG_ON(blks =3D=3D 0);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
