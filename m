From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH] ext4: queue conversion after adding to inode's completed
	IO list
Date: Fri, 6 Aug 2010 13:45:10 -0700
Message-ID: <AANLkTimci7dABU-OCPtdE9OcfW9v02C9g5dM6Ygyajwb@mail.gmail.com>
References: <4C5C67FD.5070208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:56383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061Ab0HFUpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 16:45:12 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id o76KjCk5008371
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 13:45:12 -0700
Received: from gwb15 (gwb15.prod.google.com [10.200.2.15])
	by wpaz33.hot.corp.google.com with ESMTP id o76Kj5hX014185
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 13:45:11 -0700
Received: by gwb15 with SMTP id 15so3271120gwb.20
        for <linux-ext4@vger.kernel.org>; Fri, 06 Aug 2010 13:45:11 -0700 (PDT)
In-Reply-To: <4C5C67FD.5070208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Lgtm. Thanks for the fixing patch.

Jiaying

On Fri, Aug 6, 2010 at 12:52 PM, Eric Sandeen <sandeen@redhat.com> wrot=
e:
>
> By queuing the io end on the unwritten workqueue before adding it
> to our inode's list of completed IOs, I think we run the risk
> of the work getting completed, and the IO freed, before we try
> to add it to the inode's i_completed_io_list.
>
> It should be safe to add it to the inode's list of completed
> IOs, and -then- queue it for completion, I think.
>
> Thanks to Dave Chinner for pointing out the race.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> (At least I think this is right; I haven't actually demonstrated a ra=
ce...)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 0afc8c1..7f56c48 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3804,14 +3804,14 @@ static void ext4_end_io_dio(struct kiocb *ioc=
b, loff_t offset,
> =A0 =A0 =A0 =A0io_end->flag =3D EXT4_IO_UNWRITTEN;
> =A0 =A0 =A0 =A0wq =3D EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
>
> - =A0 =A0 =A0 /* queue the work to convert unwritten extents to writt=
en */
> - =A0 =A0 =A0 queue_work(wq, &io_end->work);
> -
> =A0 =A0 =A0 =A0/* Add the io_end to per-inode completed aio dio list*=
/
> =A0 =A0 =A0 =A0ei =3D EXT4_I(io_end->inode);
> =A0 =A0 =A0 =A0spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> =A0 =A0 =A0 =A0list_add_tail(&io_end->list, &ei->i_completed_io_list)=
;
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_completed_io_lock, flags=
);
> +
> + =A0 =A0 =A0 /* queue the work to convert unwritten extents to writt=
en */
> + =A0 =A0 =A0 queue_work(wq, &io_end->work);
> =A0 =A0 =A0 =A0iocb->private =3D NULL;
> =A0out:
> =A0 =A0 =A0 =A0if (is_async)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
