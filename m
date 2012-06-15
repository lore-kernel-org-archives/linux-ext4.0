From: Robin Dong <hao.bigrat@gmail.com>
Subject: Re: [RFC][PATCH v2 3/3] ext4: add dio overwrite nolock
Date: Fri, 15 Jun 2012 18:16:29 +0800
Message-ID: <CAFZ0FUXyxKT0cAUzkaMkE+PmoaErikcQDfL4Z_624BeqBR2WGw@mail.gmail.com>
References: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
	<1339644730-6204-4-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>,
	Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59214 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2FOKQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2012 06:16:29 -0400
Received: by obbtb18 with SMTP id tb18so3776206obb.19
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jun 2012 03:16:29 -0700 (PDT)
In-Reply-To: <1339644730-6204-4-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/6/14 Zheng Liu <gnehzuil.liu@gmail.com>:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> Aligned and overwrite direct I/O can be parallelized. =A0In ext4_file=
_dio_write,
> we first check whether these conditions are satisfied or not. =A0If s=
o, we
> take i_data_sem and release i_mutex lock directly. =A0Meanwhile iocb-=
>private is
> set to indicate that this is a dio overwrite, and it will be handled =
in
> ext4_ext_direct_IO.
>
> CC: Tao Ma <tm@tao.ma>
> CC: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
> =A0fs/ext4/file.c =A0| =A0 53 +++++++++++++++++++++++++++++++++++++++=
++++++++++++--
> =A0fs/ext4/inode.c | =A0 27 +++++++++++++++++++++++++++
> =A02 files changed, 78 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index a10dc77..812358f 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -93,9 +93,13 @@ static ssize_t
> =A0ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_segs, loff_t =
pos)
> =A0{
> - =A0 =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d=
_inode;
> + =A0 =A0 =A0 struct file *file =3D iocb->ki_filp;
> + =A0 =A0 =A0 struct inode *inode =3D file->f_mapping->host;
> + =A0 =A0 =A0 struct blk_plug plug;
> =A0 =A0 =A0 =A0int unaligned_aio =3D 0;
> =A0 =A0 =A0 =A0ssize_t ret;
> + =A0 =A0 =A0 int overwrite =3D 0;
> + =A0 =A0 =A0 size_t length =3D iov_length(iov, nr_segs);
>
> =A0 =A0 =A0 =A0if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
> =A0 =A0 =A0 =A0 =A0 =A0!is_sync_kiocb(iocb))
> @@ -115,7 +119,52 @@ ext4_file_dio_write(struct kiocb *iocb, const st=
ruct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_aiodio_wait(inode);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 ret =3D generic_file_aio_write(iocb, iov, nr_segs, pos)=
;
> + =A0 =A0 =A0 BUG_ON(iocb->ki_pos !=3D pos);
> +
> + =A0 =A0 =A0 mutex_lock(&inode->i_mutex);
> + =A0 =A0 =A0 blk_start_plug(&plug);
> +
> + =A0 =A0 =A0 iocb->private =3D &overwrite;
> +
> + =A0 =A0 =A0 /* check whether we do a DIO overwrite or not */
> + =A0 =A0 =A0 if (ext4_should_dioread_nolock(inode) && !unaligned_aio=
 &&
> + =A0 =A0 =A0 =A0 =A0 !file->f_mapping->nrpages && pos + length <=3D =
i_size_read(inode)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ext4_map_blocks map;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int blkbits =3D inode->i_blkbi=
ts;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int err, len;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_lblk =3D pos >> blkbits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_len =3D (EXT4_BLOCK_ALIGN(pos + l=
ength, blkbits) >> blkbits)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 - map.m_lblk;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map.m_flags &=3D ~EXT4_MAP_FLAGS;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D map.m_len;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ext4_map_blocks(NULL, inode, &m=
ap, 0);

Nitpick:
May be better to change variable "err" to "ret"

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 'err=3D=3Dlen' means that all of b=
locks has been preallocated no
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* matter they are initialized or not=
=2E =A0For excluding
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* uninitialized extents, we need to =
check m_flags. =A0There are
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* two conditions that indicate for i=
nitialized extents.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1) If we hit extent cache, EXT4_MA=
P_MAPPED flag is returned;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 2) If we do a real lookup, non-fla=
gs are returned.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* So we should check these two condi=
tions.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err =3D=3D len && (!map.m_flags ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
map.m_flags & EXT4_MAP_MAPPED))

If we do a real lookup in ext4_map_blocks, it also return with
EXT4_MAP_MAPPED flag, the condition should be:

                     if (err =3D=3D len && (map.m_flags & EXT4_MAP_MAPP=
ED))

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 overwrite =3D 1;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D __generic_file_aio_write(iocb, iov, nr_segs, &i=
ocb->ki_pos);
> + =A0 =A0 =A0 mutex_unlock(&inode->i_mutex);
> +
> + =A0 =A0 =A0 if (ret > 0 || ret =3D=3D -EIOCBQUEUED) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ssize_t err;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D generic_write_sync(file, pos, r=
et);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err < 0 && ret > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D err;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 blk_finish_plug(&plug);
>
> =A0 =A0 =A0 =A0if (unaligned_aio)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(ext4_aio_mutex(inode));
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9a714ff..98e9096 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2996,6 +2996,26 @@ static ssize_t ext4_ext_direct_IO(int rw, stru=
ct kiocb *iocb,
> =A0 =A0 =A0 =A0if (rw =3D=3D WRITE && final_size <=3D inode->i_size) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int overwrite =3D 0;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(iocb->private =3D=3D NULL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If we do a overwrite dio, i_mutex lo=
cking can be released */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 overwrite =3D *((int *)iocb->private);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (overwrite) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 down_read(&EXT4_I(inode=
)->i_data_sem);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_=
mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If there are still some buffered I=
/O, we should fall back
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to take i_mutex locking.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (overwrite && file->f_mapping->nrpag=
es) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 overwrite =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(&EXT4_I(inode)-=
>i_data_sem);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&inode->i_mu=
tex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * We could direct write to holes and =
fallocate.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *
> @@ -3083,6 +3103,13 @@ static ssize_t ext4_ext_direct_IO(int rw, stru=
ct kiocb *iocb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D=
 err;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_clear_inode_state=
(inode, EXT4_STATE_DIO_UNWRITTEN);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* take i_mutex locking again if we do =
a ovewrite dio */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (overwrite) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 up_read(&EXT4_I(inode)-=
>i_data_sem);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_lock(&inode->i_mu=
tex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> =A0 =A0 =A0 =A0}
>
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
