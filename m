From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 2/4 v2] avoid perform unwritten convertion for direct IO
	over non fallocated space
Date: Tue, 20 Oct 2009 08:03:56 -0700
Message-ID: <6601abe90910200803n1c499ba0w825c59c2f747dce8@mail.gmail.com>
References: <1255050810.4931.191.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, ext4 development <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:30246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbZJTPD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Oct 2009 11:03:57 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n9KF40Cg008795
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 16:04:00 +0100
Received: from pwi12 (pwi12.prod.google.com [10.241.219.12])
	by wpaz29.hot.corp.google.com with ESMTP id n9KF3QSq017784
	for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 08:03:57 -0700
Received: by pwi12 with SMTP id 12so759366pwi.5
        for <linux-ext4@vger.kernel.org>; Tue, 20 Oct 2009 08:03:57 -0700 (PDT)
In-Reply-To: <1255050810.4931.191.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming:

On Thu, Oct 8, 2009 at 6:13 PM, Mingming <cmm@us.ibm.com> wrote:
> ext4: avoid perform unwritten convertion for direct IO over non fallo=
cated space
>
> When direct IO complete, without this patch, it always check and conv=
ert
> the range covered by the completed IO to be written. This is unnecess=
ary
> if the range doesn't has any preallocated area or holes. This patch a=
dd
> a state flag to alart direct IO code to only run the convertion when
> there is unwritten extents being covered in this IO.
>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A01 +
> =A0fs/ext4/extents.c | =A0 22 +++++++++++++++++-----
> =A0fs/ext4/inode.c =A0 | =A0 =A04 +++-
> =A03 files changed, 21 insertions(+), 6 deletions(-)
>
> Index: linux-2.6.31-rc4/fs/ext4/ext4.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31-rc4.orig/fs/ext4/ext4.h
> +++ linux-2.6.31-rc4/fs/ext4/ext4.h
> @@ -299,6 +299,7 @@ static inline __u32 ext4_mask_flags(umod
> =A0#define EXT4_STATE_XATTR =A0 =A0 =A0 =A0 =A0 =A0 =A0 0x00000004 /*=
 has in-inode xattrs */
> =A0#define EXT4_STATE_NO_EXPAND =A0 =A0 =A0 =A0 =A0 0x00000008 /* No =
space for expansion */
> =A0#define EXT4_STATE_DA_ALLOC_CLOSE =A0 =A0 =A00x00000010 /* Alloc D=
A blks on close */
> +#define EXT4_STATE_DIO_UNWRITTEN =A0 =A0 =A0 0x00000020 /* need conv=
ert on dio done*/

You'll need to change this value, since EXT4_STATE_EXT_MIGRATE has
already been assigned 0x20.

Thanks,
Curt


>
> =A0/* Used to pass group descriptor data when online resize is done *=
/
> =A0struct ext4_new_group_input {
> Index: linux-2.6.31-rc4/fs/ext4/extents.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31-rc4.orig/fs/ext4/extents.c
> +++ linux-2.6.31-rc4/fs/ext4/extents.c
> @@ -3029,12 +3029,18 @@ ext4_ext_handle_uninitialized_extents(ha
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_split_unwritten_extents(h=
andle,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0inode, path, iblock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0max_blocks, flags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* flag the io_end struct that we need =
convert when IO done */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Flag the inode(non aio case) or en=
d_io struct (aio case)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* that this IO needs to convertion t=
o written when IO is
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* completed
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (io)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io->flag =3D DIO_AIO_U=
NWRITTEN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(inode)->i_state =
|=3D EXT4_STATE_DIO_UNWRITTEN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 /* DIO end_io complete, convert the filled extent to wr=
itten */
> + =A0 =A0 =A0 /* async DIO end_io complete, convert the filled extent=
 to written */
> =A0 =A0 =A0 =A0if (flags =3D=3D EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D ext4_convert_unwritten_extents=
_dio(handle, inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0path);
> @@ -3276,10 +3282,16 @@ int ext4_ext_get_blocks(handle_t *handle
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * To avoid unecessary convertion for =
every aio dio rewrite
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to the mid of file, here we flag th=
e IO that is really
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * need the convertion.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For non asycn direct IO case, flag=
 the inode state
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* that we need to perform convertion=
 when IO is done.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (io && flags =3D=3D EXT4_GET_BLOCKS_=
DIO_CREATE_EXT)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->flag =3D DIO_AIO_UN=
WRITTEN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags =3D=3D EXT4_GET_BLOCKS_DIO_CR=
EATE_EXT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (io)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io->fla=
g =3D DIO_AIO_UNWRITTEN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(=
inode)->i_state |=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_STATE_DIO_UNWRITTEN;;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0err =3D ext4_ext_insert_extent(handle, inode, path, &n=
ewex, flags);
> =A0 =A0 =A0 =A0if (err) {
> Index: linux-2.6.31-rc4/fs/ext4/inode.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.31-rc4.orig/fs/ext4/inode.c
> +++ linux-2.6.31-rc4/fs/ext4/inode.c
> @@ -3693,7 +3693,8 @@ static ssize_t ext4_ext_direct_IO(int rw
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret !=3D -EIOCBQUEUED && ret <=3D =
0 && iocb->private) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_free_io_end(iocb-=
>private);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iocb->private =3D NULL=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (ret > 0){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (ret > 0 && EXT4_I(inode)->i_=
state &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_ST=
ATE_DIO_UNWRITTEN){
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int err;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * for non AIO case, s=
ince the IO is already
> @@ -3703,6 +3704,7 @@ static ssize_t ext4_ext_direct_IO(int rw
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, ret);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D=
 err;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 EXT4_I(inode)->i_state =
&=3D ~EXT4_STATE_DIO_UNWRITTEN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ret;
> =A0 =A0 =A0 =A0}
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
