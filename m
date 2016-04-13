From: Toshi Kani <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
Date: Wed, 13 Apr 2016 09:08:36 -0600
Message-ID: <1460560116.24985.55.camel@hpe.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
	 <20160413030156.GN2781@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com,
	linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160413030156.GN2781@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2016-04-12 at 23:01 -0400, Matthew Wilcox wrote:
> On Tue, Apr 12, 2016 at 02:39:29PM -0600, Toshi Kani wrote:
> >=20
> > To support DAX pmd mappings with unmodified applications,
> > filesystems need to align an mmap address by the pmd size.
> >=20
> > @@ -708,6 +708,9 @@ const struct file_operations ext4_file_operatio=
ns =3D
> > {
> > =C2=A0	.open		=3D ext4_file_open,
> > =C2=A0	.release	=3D ext4_release_file,
> > =C2=A0	.fsync		=3D ext4_sync_file,
> > +#ifdef CONFIG_FS_DAX
> > +	.get_unmapped_area =3D dax_get_unmapped_area,
> > +#endif
> > =C2=A0	.splice_read	=3D generic_file_splice_read,
> > =C2=A0	.splice_write	=3D iter_file_splice_write,
> > =C2=A0	.fallocate	=3D ext4_fallocate,
>
> Could you do something like:
>=20
> =C2=A0#ifdef CONFIG_FS_DAX
> =C2=A0struct page *read_dax_sector(struct block_device *bdev, sector_=
t n);
> +unsigned long dax_get_unmapped_area(struct file *filp, unsigned long
> addr,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0unsigned long len, unsigned long pgoff, unsigned l=
ong
> flags);
> =C2=A0#else
> =C2=A0static inline struct page *read_dax_sector(struct block_device =
*bdev,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sector_t n)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ERR_PTR(=
-ENXIO);
> =C2=A0}
> +#define dax_get_unmapped_area	NULL
> =C2=A0#endif
>=20
> in patch 1/5.=C2=A0=C2=A0Then there's no need for the ifdefs in each =
filesystem.

I thought about it, but I do not think we can use an inline function to=
 an
entry point.

Thanks,
-Toshi
