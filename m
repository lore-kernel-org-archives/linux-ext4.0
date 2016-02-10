From: Darren Hart <dvhart@linux.intel.com>
Subject: Re: xattr corruption issue on ext2fs generated filesystems
Date: Wed, 10 Feb 2016 10:20:52 -0800
Message-ID: <1455128452.24036.38.camel@linux.intel.com>
References: <1454757826.27087.300.camel@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Richard Purdie <richard.purdie@linuxfoundation.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:22818 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbcBJSUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Feb 2016 13:20:54 -0500
In-Reply-To: <1454757826.27087.300.camel@linuxfoundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2016-02-06 at 11:23 +0000, Richard Purdie wrote:
> I'm using the -d option of mke2fs to construct a filesystem, I'm
> seeing
> that some xattrs are being corrupted. The filesystem builds with no
> errors but when mounted by the kernel, I see errors like
> "security.ima:
> No such attribute". The strace from such a failure is:


Interesting. +Ted and +Darrick who helped us merge the -d argument
originally.


> mmap(NULL, 26258, PROT_READ, MAP_SHARED, 3, 0) =3D 0x7fdb36a8c000
> close(3)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0
> getrlimit(RLIMIT_NOFILE, {rlim_cur=3D1024, rlim_max=3D64*1024}) =3D 0
> lstat("mnt/foobar", {st_mode=3DS_IFREG|0755, st_size=3D1, ...}) =3D 0
> listxattr("mnt/foobar", NULL, 0) =3D 30
> listxattr("mnt/foobar", "security.SMACK64\0security.ima\0", 256) =3D =
30
> getxattr("mnt/foobar", "security.SMACK64", 0x0, 0) =3D 1
> getxattr("mnt/foobar", "security.SMACK64", "_", 256) =3D 1
> fstat(1, {st_mode=3DS_IFCHR|0620, st_rdev=3Dmakedev(136, 13), ...}) =3D=
 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
> 0) =3D 0x7fdb36a8b000
> write(1, "# file: mnt/foobar\n", 19# file: mnt/foobar) =3D 19
> write(1, "security.SMACK64=3D\"_\"\n", 21security.SMACK64=3D"_") =3D =
21
> getxattr("mnt/foobar", "security.ima", 0x0, 0) =3D -1 ENODATA (No dat=
a
> available)
> write(2, "mnt/foobar: ", 12mnt/foobar: ) =3D 12
> write(2, "security.ima: No such attribute\n", 32security.ima: No such
> attribute) =3D 32=3D 32
>=20
> so the attribute is there but the kernel gives ENODATA when trying
> to read it.
>=20
> http://www.nongnu.org/ext2-doc/ext2.html#CONTRIB-EXTENDED-ATTRIBUTES
> co
> ntains the small snippet that " The entry descriptors are sorted by
> attribute name, so that two extended attribute blocks can be compared
> efficiently. ". It doesn't specify what kind of sort.
>=20
> Looking at ext2fs, there is some sorting code through the qsort call
> using attr_compare() but it doesn't match what the kernel is doing in
> =C2=A0ext4_xattr_find_entry().
>
> I put together this quick patch to test my theory that this causing
> the
> problem:
>=20
>=20
> This makes my filesystems work.
>=20
> Is this a bug? I'm assuming ext2fs shouldn't generate filesystems the
> kernel can't read? Is the above the correct fix?
>=20

Reviewing the kernel ext4_attr_find_entry():

=2E..
		if (cmp <=3D 0 && (sorted || cmp =3D=3D 0))
			break;
	}
	*pentry =3D entry;
	if (!cmp && ext4_xattr_check_entry(entry, size))
		return -EFSCORRUPTED;
	return cmp ? -ENODATA : 0;
=2E..

It would seem that a different sorting algorithm would result in the
kernel interpreting the FS to be corrupted.


> Cheers,
>=20
> Richard
> ---
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
=20
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.html
>=20
> Index: git/lib/ext2fs/ext_attr.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- git.orig/lib/ext2fs/ext_attr.c
> +++ git/lib/ext2fs/ext_attr.c
> @@ -258,6 +258,7 @@ static struct ea_name_index ea_names[] =3D
> =C2=A0static int attr_compare(const void *a, const void *b)
> =C2=A0{
> =C2=A0	const struct ext2_xattr *xa =3D a, *xb =3D b;
> +	size_t len;
> =C2=A0
> =C2=A0	if (xa->name =3D=3D NULL)
> =C2=A0		return +1;
> @@ -267,7 +268,11 @@ static int attr_compare(const void *a, c
> =C2=A0		return -1;
> =C2=A0	else if (!strcmp(xb->name, "system.data"))
> =C2=A0		return +1;
> -	return 0;
> +	len =3D strlen(xa->name) - strlen(xb->name);
> +	if (len)
> +		return len;

I *think* the index and len comparisons in the kernel are simply
optimizations to avoid the memcmp, but to properly sort them here, I
think you can drop the len block above and just return the strcmp
below.

Ted, Darrick?

> +
> +	return strcmp(xa->name, xb->name);
> =C2=A0}
> =C2=A0
> =C2=A0static const char *find_ea_prefix(int index)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
