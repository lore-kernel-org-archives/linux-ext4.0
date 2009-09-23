From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 1/2] ext4: clean up ext4_dirty_inode()
Date: Wed, 23 Sep 2009 07:37:06 -0700
Message-ID: <6601abe90909230737s181769b1j968c92984344a40@mail.gmail.com>
References: <6601abe90909171455q50ab5c6dr5b125278d0eae845@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:16738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZIWOhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2009 10:37:07 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id n8NEb9e6024382
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 15:37:10 +0100
Received: from pxi11 (pxi11.prod.google.com [10.243.27.11])
	by zps35.corp.google.com with ESMTP id n8NEb7LA003713
	for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 07:37:07 -0700
Received: by pxi11 with SMTP id 11so683053pxi.0
        for <linux-ext4@vger.kernel.org>; Wed, 23 Sep 2009 07:37:06 -0700 (PDT)
In-Reply-To: <6601abe90909171455q50ab5c6dr5b125278d0eae845@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted, any comment on this patch?

Thanks,
Curt

On Thu, Sep 17, 2009 at 2:55 PM, Curt Wohlgemuth <curtw@google.com> wro=
te:
> This patch cleans up ext4_dirty_inode(); it's attempt to detect non-m=
atching
> transactions can never be executed.
>
> =A0 =A0 =A0 =A0Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> ---
>
> If 'current_handle' is non-NULL, then ext4_start_journal() will retur=
n the
> same handle with it's h_ref count incremented, and the h_transaction
> pointers will be the same.
>
> diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
> --- orig/fs/ext4/inode.c =A0 =A0 =A0 =A02009-09-17 13:59:48.000000000=
 -0700
> +++ new/fs/ext4/inode.c 2009-09-17 14:14:43.000000000 -0700
> @@ -5379,24 +5379,13 @@ void ext4_dirty_inode(struct inode *inod
> =A0 =A0 =A0 =A0handle_t *current_handle =3D ext4_journal_current_hand=
le();
> =A0 =A0 =A0 =A0handle_t *handle;
>
> - =A0 =A0 =A0 if (!ext4_handle_valid(current_handle)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mark_inode_dirty(current_handle, i=
node);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 2);
> =A0 =A0 =A0 =A0if (IS_ERR(handle))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> - =A0 =A0 =A0 if (current_handle &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 current_handle->h_transaction !=3D hand=
le->h_transaction) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* This task has a transaction open aga=
inst a different fs */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "%s: transactions do =
not match!\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__);
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 jbd_debug(5, "marking dirty. =A0outer h=
andle=3D%p\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 current=
_handle);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
> - =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 jbd_debug(5, "marking dirty. =A0outer handle=3D%p\n", c=
urrent_handle);
> + =A0 =A0 =A0 ext4_mark_inode_dirty(handle, inode);
> +
> =A0 =A0 =A0 =A0ext4_journal_stop(handle);
> =A0out:
> =A0 =A0 =A0 =A0return;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
