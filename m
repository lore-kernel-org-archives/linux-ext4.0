From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [RFC][PATCH v2 2/3] ext4: add a new flag for ext4_map_blocks
Date: Fri, 15 Jun 2012 17:29:10 +0800
Message-ID: <CAFZ0FUWap3fio-Rwq1FY2tHKDrUijQXmvh=L8+sJHRDjBTQvwQ@mail.gmail.com>
References: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
	<1339644730-6204-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33504 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2FOJ3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2012 05:29:11 -0400
Received: by yenl2 with SMTP id l2so1684589yen.19
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2012 02:29:10 -0700 (PDT)
In-Reply-To: <1339644730-6204-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/6/14 Zheng Liu <gnehzuil.liu@gmail.com>:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> EXT4_GET_BLOCKS_NO_LOCK flag is added to indicate that we don't need =
to acquire
> i_data_sem lock in ext4_map_blocks. =A0Meanwhile, it lets _ext4_get_b=
lock do not
> start a new journal because when we do a overwrite dio, there is no a=
ny
> metadata that needs to be modified.
>
> We define a new function called ext4_get_block_write_nolock, which is=
 used in
> dio overwrite nolock. =A0In this function, it doesn't try to acquire =
i_data_sem
> lock and doesn't start a new journal as it does a lookup.
>
> CC: Tao Ma <tm@tao.ma>
> CC: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> =A0fs/ext4/ext4.h =A0| =A0 =A02 +
> =A0fs/ext4/inode.c | =A0 59 +++++++++++++++++++++++++++++++++++++++++=
++++---------
> =A02 files changed, 51 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index cfc4e01..d1a2b1e 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -571,6 +571,8 @@ enum {
> =A0#define EXT4_GET_BLOCKS_NO_NORMALIZE =A0 =A0 =A0 =A0 =A0 0x0040
> =A0 =A0 =A0 =A0/* Request will not result in inode size update (user =
for fallocate) */
> =A0#define EXT4_GET_BLOCKS_KEEP_SIZE =A0 =A0 =A0 =A0 =A0 =A0 =A00x008=
0
> + =A0 =A0 =A0 /* Do not take i_data_sem locking in ext4_map_blocks */
> +#define EXT4_GET_BLOCKS_NO_LOCK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A00x0100
>
> =A0/*
> =A0* Flags used by ext4_free_blocks
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 02bc8cb..9a714ff 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -544,7 +544,8 @@ int ext4_map_blocks(handle_t *handle, struct inod=
e *inode,
> =A0 =A0 =A0 =A0 * Try to see if we can get the block without requesti=
ng a new
> =A0 =A0 =A0 =A0 * file system block.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 down_read((&EXT4_I(inode)->i_data_sem));
> + =A0 =A0 =A0 if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 down_read((&EXT4_I(inode)->i_data_sem))=
;
> =A0 =A0 =A0 =A0if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D ext4_ext_map_blocks(handle,=
 inode, map, flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 EXT4_GET_BLOCKS_KEEP_SIZE);
> @@ -552,7 +553,8 @@ int ext4_map_blocks(handle_t *handle, struct inod=
e *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0retval =3D ext4_ind_map_blocks(handle,=
 inode, map, flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 EXT4_GET_BLOCKS_KEEP_SIZE);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 up_read((&EXT4_I(inode)->i_data_sem));
> + =A0 =A0 =A0 if (!(flags & EXT4_GET_BLOCKS_NO_LOCK))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read((&EXT4_I(inode)->i_data_sem));
>
> =A0 =A0 =A0 =A0if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int ret =3D check_block_validity(inode=
, map);
> @@ -2818,6 +2820,32 @@ static int ext4_get_block_write(struct inode *=
inode, sector_t iblock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_GET_=
BLOCKS_IO_CREATE_EXT);
> =A0}
>
> +static int ext4_get_block_write_nolock(struct inode *inode, sector_t=
 iblock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *bh_result, i=
nt create)
> +{
> + =A0 =A0 =A0 handle_t *handle =3D ext4_journal_current_handle();
> + =A0 =A0 =A0 struct ext4_map_blocks map;
> + =A0 =A0 =A0 int ret =3D 0;
> +
> + =A0 =A0 =A0 ext4_debug("ext4_get_block_write_nolock: inode %lu, cre=
ate flag %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_ino, create);
> +
> + =A0 =A0 =A0 create =3D EXT4_GET_BLOCKS_NO_LOCK;

May be better to change the variable "create" to "flags"

> +
> + =A0 =A0 =A0 map.m_lblk =3D iblock;
> + =A0 =A0 =A0 map.m_len =3D bh_result->b_size >> inode->i_blkbits;
> +
> + =A0 =A0 =A0 ret =3D ext4_map_blocks(handle, inode, &map, create);
> + =A0 =A0 =A0 if (ret > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map_bh(bh_result, inode->i_sb, map.m_pb=
lk);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh_result->b_state =3D (bh_result->b_st=
ate & ~EXT4_MAP_FLAGS) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 map.m_flags;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 bh_result->b_size =3D inode->i_sb->s_bl=
ocksize * map.m_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return ret;
> +}
> +
> =A0static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ssize_t size, =
void *private, int ret,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool is_async)
> @@ -2966,6 +2994,8 @@ static ssize_t ext4_ext_direct_IO(int rw, struc=
t kiocb *iocb,
>
> =A0 =A0 =A0 =A0loff_t final_size =3D offset + count;
> =A0 =A0 =A0 =A0if (rw =3D=3D WRITE && final_size <=3D inode->i_size) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int overwrite =3D 0;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * We could direct write to holes and =
fallocate.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *
> @@ -3005,13 +3035,22 @@ static ssize_t ext4_ext_direct_IO(int rw, str=
uct kiocb *iocb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->cur_aio=
_dio =3D iocb->private;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __blockdev_direct_IO(rw, iocb, =
inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0inode->i_sb->s_bdev, iov,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0offset, nr_segs,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0ext4_get_block_write,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0ext4_end_io_dio,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0NULL,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0DIO_LOCKING);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (overwrite)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __blockdev_dire=
ct_IO(rw, iocb, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_sb->s_bdev, iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, nr_segs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_get_block_write_nolock,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_end_io_dio,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __blockdev_dire=
ct_IO(rw, iocb, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_sb->s_bdev, iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, nr_segs,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_get_block_write,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_end_io_dio,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0DIO_LOCKING);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (iocb->private)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_I(inode)->cur_aio=
_dio =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> @@ -3031,7 +3070,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struc=
t kiocb *iocb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret !=3D -EIOCBQUEUED && ret <=3D =
0 && iocb->private) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_free_io_end(iocb-=
>private);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iocb->private =3D NULL=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (ret > 0 && ext4_test_inode_s=
tate(inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (ret > 0 && !overwrite && ext=
4_test_inode_state(inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0EXT4_STATE_DIO_UNWRITTEN)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int err;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
--
Best Regard
Robin Dong
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
