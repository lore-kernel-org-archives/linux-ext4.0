From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: Re: [PATCH 05/11] ext4: remove ext4_end_io()
Date: Thu, 4 Oct 2012 15:57:29 -0700
Message-ID: <CAOMFOmVyqmmepkVOYSjz7kYtqGb0ogpyOzMYAX4KiA9JKBMKaQ@mail.gmail.com>
References: <1348847051-6746-1-git-send-email-dmonakhov@openvz.org>
	<1348847051-6746-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
	lczerner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:39524 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2JDW5b (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Oct 2012 18:57:31 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so547119lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 04 Oct 2012 15:57:29 -0700 (PDT)
In-Reply-To: <1348847051-6746-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

On Fri, Sep 28, 2012 at 8:44 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> RFC_MESSAGE: It is up to committer whenever pick or drop this patch.
> Only one user exist, so it may be resonable move it inside
> caller's body. The only disadvantage is that makes end_do_flush_completed_IO()
> less readable.
>
>
> COMMIT_MESSAGE:
> ext4_do_flush_completed_IO() is the only user of this function.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/page-io.c |   56 ++++++++++++++++++++--------------------------------
>  1 files changed, 22 insertions(+), 34 deletions(-)
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 5b24c40..0435688 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -84,37 +84,6 @@ void ext4_free_io_end(ext4_io_end_t *io)
>         kmem_cache_free(io_end_cachep, io);
>  }
>
> -/* check a range of space and convert unwritten extents to written. */
> -static int ext4_end_io(ext4_io_end_t *io)
> -{
> -       struct inode *inode = io->inode;
> -       loff_t offset = io->offset;
> -       ssize_t size = io->size;
> -       int ret = 0;
> -
> -       ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
> -                  "list->prev 0x%p\n",
> -                  io, inode->i_ino, io->list.next, io->list.prev);
> -
> -       ret = ext4_convert_unwritten_extents(inode, offset, size);
> -       if (ret < 0) {
> -               ext4_msg(inode->i_sb, KERN_EMERG,
> -                        "failed to convert unwritten extents to written "
> -                        "extents -- potential data loss!  "
> -                        "(inode %lu, offset %llu, size %zd, error %d)",
> -                        inode->i_ino, offset, size, ret);
> -       }
> -       if (io->iocb)
> -               aio_complete(io->iocb, io->result, 0);
> -
> -       if (io->flag & EXT4_IO_END_DIRECT)
> -               inode_dio_done(inode);
> -       /* Wake up anyone waiting on unwritten extent conversion */
> -       if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> -               wake_up_all(ext4_ioend_wq(io->inode));
> -       return ret;
> -}
> -
>  static void dump_completed_IO(struct inode *inode)
>  {
>  #ifdef EXT4FS_DEBUG
> @@ -183,9 +152,28 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
>                 BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
>                 list_del_init(&io->list);
>
> -               err = ext4_end_io(io);
> -               if (unlikely(!ret && err))
> -                       ret = err;
> +               ext4_debug("ext4_do_flush_completed_IO: io 0x%p, inode %lu\n",
> +                          io, inode->i_ino);
> +
> +               err = ext4_convert_unwritten_extents(inode, io->offset,
> +                                                    io->size);
> +               if (err < 0) {
> +                       ext4_msg(inode->i_sb, KERN_EMERG,
> +                                "failed to convert unwritten extents to written"
> +                                " extents -- potential data loss!  "
> +                                "(inode %lu, offset %llu, size %zd, error %d)",
> +                                inode->i_ino, io->offset, io->size, err);
> +                       if (!ret)
> +                               ret = err;
> +               }
> +               if (io->iocb)
> +                       aio_complete(io->iocb, io->result, 0);
> +
> +               if (io->flag & EXT4_IO_END_DIRECT)
> +                       inode_dio_done(inode);
> +               /* Wake up anyone waiting on unwritten extent conversion */
> +               if (atomic_dec_and_test(&EXT4_I(inode)->i_unwritten))
> +                       wake_up_all(ext4_ioend_wq(io->inode));

Should we use "inode" instead of "io->inode"?

>
>                 list_add_tail(&io->list, &complete);
>         }
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
