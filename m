From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext2/3/4: change i_mutex usage on lseek
Date: Wed, 14 Jan 2009 22:32:30 -0600
Message-ID: <1231993950.9468.8.camel@norville.austin.ibm.com>
References: <6.0.0.20.2.20090106134318.06709010@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090106134318.06709010@172.19.0.2>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2009-01-15 at 09:32 +0900, Hisashi Hifumi wrote:
> Hi.
>=20
> I wrote some patch that changed a range of i_mutex on ext2/3/4's lsee=
k.
> Ext2/3/4 uses generic_file_llseek, this function is inside i_mutex.
> I think there is room for optimization in some cases.
> When SEEK_END is specified from caller, in this case we should handle
> inode->i_size so i_mutex is needed. But in other cases such as SEEK_C=
UR or
> SEEK_SET, i_mutex is not needed because just changing file->f_pos val=
ue without
> touching i_size.

Is there any reason you couldn't have just changed generic_file_llseek(=
)
to do this rather than making identical changes to the individual file
systems.  I would think this optimization would be safe for any file
system.

> I did some test to measure i_mutex contention.
> This test do:
> 	1. make an 128MB file.
> 	2. fork 100 processes. repeat 10000000 times lseeking randomly on ea=
ch process to this file.
> 	3, gauge seconds between start and end of this test.
>=20
> The result was:
>=20
> 	-2.6.29-rc1
> 	# time ./lseek_test
> 	315 sec
>=20
> 	real    5m15.407s
> 	user    1m19.128s
> 	sys     5m38.884s
>=20
> 	-2.6.29-rc1-patched
> 	# time ./lseek_test
> 	13 sec
>=20
> 	real    0m13.039s
> 	user    1m14.730s
> 	sys     2m9.633s=20
>=20
> Hardware environment:
> CPU=E3=80=802.4GHz(Quad Core) *4
> Memory 64GB
>=20
> This improvement is derived from just removal of lseek's i_mutex cont=
ention.
> There is i_mutex contention not only around lseek, but also fsync or =
write.
> So,  I think we also can mitigate i_mutex contention between fsync an=
d lseek.
>=20
> Thanks.
>=20
> Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
>=20
> diff -Nrup linux-2.6.29-rc1.org/fs/ext2/file.c linux-2.6.29-rc1/fs/ex=
t2/file.c
> --- linux-2.6.29-rc1.org/fs/ext2/file.c	2008-12-25 08:26:37.000000000=
 +0900
> +++ linux-2.6.29-rc1/fs/ext2/file.c	2009-01-13 11:58:16.000000000 +09=
00
> @@ -38,12 +38,24 @@ static int ext2_release_file (struct ino
>  	return 0;
>  }
>=20
> +static loff_t ext2_file_llseek(struct file *file, loff_t offset, int=
 origin)
> +{
> +	loff_t retval;
> +
> +	if (origin =3D=3D SEEK_END)
> +		retval =3D generic_file_llseek(file, offset, origin);
> +	else
> +		retval =3D generic_file_llseek_unlocked(file, offset, origin);
> +
> +	return retval;
> +}
> +
>  /*
>   * We have mostly NULL's here: the current defaults are ok for
>   * the ext2 filesystem.
>   */
>  const struct file_operations ext2_file_operations =3D {
> -	.llseek		=3D generic_file_llseek,
> +	.llseek		=3D ext2_file_llseek,
>  	.read		=3D do_sync_read,
>  	.write		=3D do_sync_write,
>  	.aio_read	=3D generic_file_aio_read,
> @@ -62,7 +74,7 @@ const struct file_operations ext2_file_o
>=20
>  #ifdef CONFIG_EXT2_FS_XIP
>  const struct file_operations ext2_xip_file_operations =3D {
> -	.llseek		=3D generic_file_llseek,
> +	.llseek		=3D ext2_file_llseek,
>  	.read		=3D xip_file_read,
>  	.write		=3D xip_file_write,
>  	.unlocked_ioctl =3D ext2_ioctl,
> diff -Nrup linux-2.6.29-rc1.org/fs/ext3/file.c linux-2.6.29-rc1/fs/ex=
t3/file.c
> --- linux-2.6.29-rc1.org/fs/ext3/file.c	2008-12-25 08:26:37.000000000=
 +0900
> +++ linux-2.6.29-rc1/fs/ext3/file.c	2009-01-13 11:58:16.000000000 +09=
00
> @@ -106,8 +106,20 @@ force_commit:
>  	return ret;
>  }
>=20
> +static loff_t ext3_file_llseek(struct file *file, loff_t offset, int=
 origin)
> +{
> +	loff_t retval;
> +
> +	if (origin =3D=3D SEEK_END)
> +		retval =3D generic_file_llseek(file, offset, origin);
> +	else
> +		retval =3D generic_file_llseek_unlocked(file, offset, origin);
> +
> +	return retval;
> +}
> +
>  const struct file_operations ext3_file_operations =3D {
> -	.llseek		=3D generic_file_llseek,
> +	.llseek		=3D ext3_file_llseek,
>  	.read		=3D do_sync_read,
>  	.write		=3D do_sync_write,
>  	.aio_read	=3D generic_file_aio_read,
> diff -Nrup linux-2.6.29-rc1.org/fs/ext4/file.c linux-2.6.29-rc1/fs/ex=
t4/file.c
> --- linux-2.6.29-rc1.org/fs/ext4/file.c	2009-01-13 11:55:09.000000000=
 +0900
> +++ linux-2.6.29-rc1/fs/ext4/file.c	2009-01-13 12:09:59.000000000 +09=
00
> @@ -140,8 +140,20 @@ static int ext4_file_mmap(struct file *f
>  	return 0;
>  }
>=20
> +static loff_t ext4_file_llseek(struct file *file, loff_t offset, int=
 origin)
> +{
> +	loff_t retval;
> +
> +	if (origin =3D=3D SEEK_END)
> +		retval =3D generic_file_llseek(file, offset, origin);
> +	else
> +		retval =3D generic_file_llseek_unlocked(file, offset, origin);
> +
> +	return retval;
> +}
> +
>  const struct file_operations ext4_file_operations =3D {
> -	.llseek		=3D generic_file_llseek,
> +	.llseek		=3D ext4_file_llseek,
>  	.read		=3D do_sync_read,
>  	.write		=3D do_sync_write,
>  	.aio_read	=3D generic_file_aio_read,

--=20
David Kleikamp
IBM Linux Technology Center

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
