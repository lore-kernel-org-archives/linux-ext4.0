From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 35/49] ext2fs: add readahead method to improve scanning
Date: Mon, 17 Mar 2014 16:07:12 -0600
Message-ID: <8C05AA44-C139-476D-A75B-1084D8CED4A4@dilger.ca>
References: <20140311065356.30585.47192.stgit@birch.djwong.org> <20140311065741.30585.30373.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_2E86C59F-2E01-4AA3-8559-6834C2D641D3"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60567 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaCQWIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2014 18:08:16 -0400
Received: by mail-pd0-f170.google.com with SMTP id v10so6162604pde.15
        for <linux-ext4@vger.kernel.org>; Mon, 17 Mar 2014 15:08:15 -0700 (PDT)
In-Reply-To: <20140311065741.30585.30373.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_2E86C59F-2E01-4AA3-8559-6834C2D641D3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Mar 11, 2014, at 12:57 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:

> Fr=F8m: Andreas Dilger <adilger@whamcloud.com>
>=20
> Add a readahead method for prefetching ranges of disk blocks.  This is
> useful for inode table scanning, and other large contiguous ranges of
> blocks, and may also prove useful for random block prefetch, since it
> will allow reordering of the IO without waiting synchronously for the
> reads to complete.
>=20
> It is currently using the posix_fadvise(POSIX_FADV_WILLNEED)
> interface, as this proved most efficient during our testing.
>=20
> [darrick.wong@oracle.com]
> Add a cache_release method for advising the pagecache to discard disk
> cache blocks.  Make the arguments to the readahead function take the
> same ULL values as the other IO functions, and return an appropriate
> error code when fadvise isn't available.

This already has my Signed-off-by: line, but I thought I'd chime in that
I also reviewed the later additions from Darrick for the cache release.

Cheers, Andreas

> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> lib/ext2fs/ext2_io.h    |   12 ++++++++++++
> lib/ext2fs/io_manager.c |   18 ++++++++++++++++++
> lib/ext2fs/unix_io.c    |   46 =
+++++++++++++++++++++++++++++++++++++++++++---
> 3 files changed, 73 insertions(+), 3 deletions(-)
>=20
>=20
> diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
> index 1894fb8..636f797 100644
> --- a/lib/ext2fs/ext2_io.h
> +++ b/lib/ext2fs/ext2_io.h
> @@ -90,6 +90,12 @@ struct struct_io_manager {
> 					int count, const void *data);
> 	errcode_t (*discard)(io_channel channel, unsigned long long =
block,
> 			     unsigned long long count);
> +	errcode_t (*cache_readahead)(io_channel channel,
> +				     unsigned long long block,
> +				     unsigned long long count);
> +	errcode_t (*cache_release)(io_channel channel,
> +				   unsigned long long block,
> +				   unsigned long long count);
> 	long	reserved[16];
> };
>=20
> @@ -124,6 +130,12 @@ extern errcode_t io_channel_discard(io_channel =
channel,
> 				    unsigned long long count);
> extern errcode_t io_channel_alloc_buf(io_channel channel,
> 				      int count, void *ptr);
> +extern errcode_t io_channel_cache_readahead(io_channel io,
> +					    unsigned long long block,
> +					    unsigned long long count);
> +extern errcode_t io_channel_cache_release(io_channel io,
> +					  unsigned long long block,
> +					  unsigned long long count);
>=20
> /* unix_io.c */
> extern io_manager unix_io_manager;
> diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
> index 34e4859..a1258c4 100644
> --- a/lib/ext2fs/io_manager.c
> +++ b/lib/ext2fs/io_manager.c
> @@ -128,3 +128,21 @@ errcode_t io_channel_alloc_buf(io_channel io, int =
count, void *ptr)
> 	else
> 		return ext2fs_get_mem(size, ptr);
> }
> +
> +errcode_t io_channel_cache_readahead(io_channel io, unsigned long =
long block,
> +				     unsigned long long count)
> +{
> +	if (!io->manager->cache_readahead)
> +		return EXT2_ET_OP_NOT_SUPPORTED;
> +
> +	return io->manager->cache_readahead(io, block, count);
> +}
> +
> +errcode_t io_channel_cache_release(io_channel io, unsigned long long =
block,
> +				   unsigned long long count)
> +{
> +	if (!io->manager->cache_release)
> +		return EXT2_ET_OP_NOT_SUPPORTED;
> +
> +	return io->manager->cache_release(io, block, count);
> +}
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index a818c13..a95e289 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -15,6 +15,9 @@
>  * %End-Header%
>  */
>=20
> +#define _XOPEN_SOURCE 600
> +#define _DARWIN_C_SOURCE
> +#define _FILE_OFFSET_BITS 64
> #define _LARGEFILE_SOURCE
> #define _LARGEFILE64_SOURCE
> #ifndef _GNU_SOURCE
> @@ -35,6 +38,9 @@
> #ifdef __linux__
> #include <sys/utsname.h>
> #endif
> +#if HAVE_SYS_TYPES_H
> +#include <sys/types.h>
> +#endif
> #ifdef HAVE_SYS_IOCTL_H
> #include <sys/ioctl.h>
> #endif
> @@ -44,9 +50,6 @@
> #if HAVE_SYS_STAT_H
> #include <sys/stat.h>
> #endif
> -#if HAVE_SYS_TYPES_H
> -#include <sys/types.h>
> -#endif
> #if HAVE_SYS_RESOURCE_H
> #include <sys/resource.h>
> #endif
> @@ -97,6 +100,7 @@ struct unix_private_data {
> #define IS_ALIGNED(n, align) ((((unsigned long) n) & \
> 			       ((unsigned long) ((align)-1))) =3D=3D 0)
>=20
> +
> static errcode_t unix_get_stats(io_channel channel, io_stats *stats)
> {
> 	errcode_t	retval =3D 0;
> @@ -810,6 +814,40 @@ static errcode_t unix_write_blk64(io_channel =
channel, unsigned long long block,
> #endif /* NO_IO_CACHE */
> }
>=20
> +static errcode_t unix_cache_readahead(io_channel channel,
> +				      unsigned long long block,
> +				      unsigned long long count)
> +{
> +#ifdef POSIX_FADV_WILLNEED
> +	struct unix_private_data *data;
> +
> +	data =3D (struct unix_private_data *)channel->private_data;
> +	return posix_fadvise(data->dev,
> +			     (ext2_loff_t)block * channel->block_size,
> +			     (ext2_loff_t)count * channel->block_size,
> +			     POSIX_FADV_WILLNEED);
> +#else
> +	return EXT2_ET_OP_NOT_SUPPORTED;
> +#endif
> +}
> +
> +static errcode_t unix_cache_release(io_channel channel,
> +				    unsigned long long block,
> +				    unsigned long long count)
> +{
> +#ifdef POSIX_FADV_DONTNEED
> +	struct unix_private_data *data;
> +
> +	data =3D (struct unix_private_data *)channel->private_data;
> +	return posix_fadvise(data->dev,
> +			     (ext2_loff_t)block * channel->block_size,
> +			     (ext2_loff_t)count * channel->block_size,
> +			     POSIX_FADV_DONTNEED);
> +#else
> +	return EXT2_ET_OP_NOT_SUPPORTED;
> +#endif
> +}
> +
> static errcode_t unix_write_blk(io_channel channel, unsigned long =
block,
> 				int count, const void *buf)
> {
> @@ -961,6 +999,8 @@ static struct struct_io_manager =
struct_unix_manager =3D {
> 	unix_read_blk64,
> 	unix_write_blk64,
> 	unix_discard,
> +	unix_cache_readahead,
> +	unix_cache_release,
> };
>=20
> io_manager unix_io_manager =3D &struct_unix_manager;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_2E86C59F-2E01-4AA3-8559-6834C2D641D3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUydyEHKl2rkXzB/gAQL9vA//fZPtz1w4kf5huCqWEGnU+a1/zxujz1ST
8MYr5fp2QZDoE9WKNrYPD/dVwPLkWqKTPzaxuO/gq1kpX5f4S1Gqh9vzpN/67Wdz
d3xiKK0KZ35quEgqP37mZnPiAMXuV4ibVhUtIwAKY/ruSj2PhWiVGdIDDN3UVUD3
thei0nlPcNmdoLKRellryDZZdaAfnQ13be4EWevTojxukvGfxQ+qmRLTrAWm3HEx
MerEEPq0bWhVX8vGMYJF5NZLAwb/EKA2CVCZ1q0AMdJoJNARQGgD+VjGyzUqBkk6
M6m3Idjq1LVKoewhTxngslKXP/+wxn/BHiv1xZPj8Qkt8gVyjhdEIt4Dax0KBd6K
4Dv35Ls/wNCPJAILSQ0YMgLqp2NuJcJMjayOZU0HzksHhXOrsNYG+6GFPb2prRdg
VKLSGyVMlNVatj0ZzCbYeO6RiHIk7sk0gGxBc1IU8GfzxT5qjWypifnxcsa1Zzea
9Gaap2kHRGw1jtA8j23SYaoJiRXAE0mnDNwAdJVrMujeB6fc9EDa0Zmm74n766A5
3B1gWgHNE+DhAs0q8QcOuToPhJpacLVYL/oIZJ4t2uJnpy8dfo1SMIUTfoHjDVfc
G8CfcoxK7k7Hi5dimFpeK9bdWUUd7qZyz6V1bXGvTcp/nhfvisieNCTCDA3wQtGb
eVIKbeLRY9s=
=34kk
-----END PGP SIGNATURE-----

--Apple-Mail=_2E86C59F-2E01-4AA3-8559-6834C2D641D3--
