From: Tao Ma <taoma.tm@gmail.com>
Subject: Re: [PATCH 3/3] ext4: optimize locking for end_io extent conversion
Date: Tue, 1 Nov 2011 10:51:46 +0800
Message-ID: <CAFcGZ=K5hLLkyGSzpxUCyaAuBjHu16Q_GCUpB0pP956gs8i1mQ@mail.gmail.com>
References: <20111031150206.GC16825@thunk.org>
	<1320073367-28916-1-git-send-email-tytso@mit.edu>
	<1320073367-28916-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52824 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1KACvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 22:51:48 -0400
Received: by wyh15 with SMTP id 15so23704wyh.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 19:51:47 -0700 (PDT)
In-Reply-To: <1320073367-28916-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On Mon, Oct 31, 2011 at 11:02 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Now that we are doing the locking correctly, we need to grab the
> i_completed_io_lock() twice per end_io. =A0We can clean this up by
> removing the structure from the i_complted_io_list, and use this as
> the locking mechanism to prevent ext4_flush_completed_IO() racing
> against ext4_end_io_work(), instead of clearing the
> EXT4_IO_END_UNWRITTEN in io->flag.
>
> In addition, if the ext4_convert_unwritten_extents() returns an error=
,
> we no longer keep the end_io structure on the linked list. =A0This
> doesn't help, because it tends to lock up the file system and wedges
> the system. =A0That's one way to call attention to the problem, but i=
t
> doesn't help the overall robustness of the system.
>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> =A0fs/ext4/fsync.c =A0 | =A0 =A05 ++---
> =A0fs/ext4/page-io.c | =A0 37 +++++++++++--------------------------
> =A02 files changed, 13 insertions(+), 29 deletions(-)
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 851ac5b..00a2cb7 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -88,6 +88,7 @@ int ext4_flush_completed_IO(struct inode *inode)
> =A0 =A0 =A0 =A0while (!list_empty(&ei->i_completed_io_list)){
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io =3D list_entry(ei->i_completed_io_l=
ist.next,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_i=
o_end_t, list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&io->list);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Calling ext4_end_io_nolock() to con=
vert completed
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * IO to written.
> @@ -104,11 +105,9 @@ int ext4_flush_completed_IO(struct inode *inode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_complete=
d_io_lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_end_io_nolock(io);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&ei->i_completed_io_l=
ock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret2 =3D ret;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&io->list=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&ei->i_completed_io_l=
ock, flags);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_completed_io_lock, flags=
);
> =A0 =A0 =A0 =A0return (ret2 < 0) ? ret2 : 0;
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 4fa1d70..7bacd27 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -99,28 +99,21 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "list->prev 0x%p\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io, inode->i_ino, io->list.next, =
io->list.prev);
>
> - =A0 =A0 =A0 if (!(io->flag & EXT4_IO_END_UNWRITTEN))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> -
> =A0 =A0 =A0 =A0ret =3D ext4_convert_unwritten_extents(inode, offset, =
size);
> =A0 =A0 =A0 =A0if (ret < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_EMERG "%s: failed to conver=
t unwritten "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "extents to written ext=
ents, error is %d "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "io is still on inode %=
lu aio dio list\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__, ret, inode->i_=
ino);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_msg(inode->i_sb, KERN_EMERG,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"failed to convert u=
nwritten extents to written "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"extents -- potentia=
l data loss! =A0"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"(inode %lu, offset =
%llu, size %d, error %d)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_ino, offset=
, size, ret);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (io->iocb)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0aio_complete(io->iocb, io->result, 0);
> - =A0 =A0 =A0 /* clear the DIO AIO unwritten flag */
> - =A0 =A0 =A0 if (io->flag & EXT4_IO_END_UNWRITTEN) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->flag &=3D ~EXT4_IO_END_UNWRITTEN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Wake up anyone waiting on unwritten =
extent conversion */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_dec_and_test(&EXT4_I(inode)-=
>i_aiodio_unwritten))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_all(ext4_ioend_=
wq(io->inode));
> - =A0 =A0 =A0 }
>
> + =A0 =A0 =A0 /* Wake up anyone waiting on unwritten extent conversio=
n */
> + =A0 =A0 =A0 if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwrit=
ten))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_all(ext4_ioend_wq(io->inode));
> =A0 =A0 =A0 =A0return ret;
> =A0}
>
> @@ -133,16 +126,15 @@ static void ext4_end_io_work(struct work_struct=
 *work)
> =A0 =A0 =A0 =A0struct inode =A0 =A0 =A0 =A0 =A0 =A0*inode =3D io->ino=
de;
> =A0 =A0 =A0 =A0struct ext4_inode_info =A0*ei =3D EXT4_I(inode);
> =A0 =A0 =A0 =A0unsigned long =A0 =A0 =A0 =A0 =A0 flags;
> - =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret;
>
> =A0 =A0 =A0 =A0spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> =A0 =A0 =A0 =A0if (list_empty(&io->list)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_complete=
d_io_lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto free;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 spin_unlock_irqrestore(&ei->i_completed_io_lock, flags)=
;
>
> =A0 =A0 =A0 =A0if (!mutex_trylock(&inode->i_mutex)) {
So here, we spin_lock first and then mutex_lock.
But in  ext4_flush_completed_IO, we mutex_lock first and
then spin_lock. Will lockdep complain about it?
Other than that, the patch looks good to me.

Thanks
Tao
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&ei->i_completed=
_io_lock, flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Requeue the work instead of waiting=
 so that the work
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * items queued after this can be proc=
essed.
> @@ -159,16 +151,9 @@ static void ext4_end_io_work(struct work_struct =
*work)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io->flag |=3D EXT4_IO_END_QUEUED;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 ret =3D ext4_end_io_nolock(io);
> - =A0 =A0 =A0 if (ret < 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 spin_lock_irqsave(&ei->i_completed_io_lock, flags);
> - =A0 =A0 =A0 if (!list_empty(&io->list))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&io->list);
> + =A0 =A0 =A0 list_del_init(&io->list);
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&ei->i_completed_io_lock, flags=
);
> + =A0 =A0 =A0 (void) ext4_end_io_nolock(io);
> =A0 =A0 =A0 =A0mutex_unlock(&inode->i_mutex);
> =A0free:
> =A0 =A0 =A0 =A0ext4_free_io_end(io);
> --
> 1.7.4.1.22.gec8e1.dirty
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
