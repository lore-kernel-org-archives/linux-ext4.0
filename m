From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
Date: Wed, 13 Apr 2016 14:22:49 -0400
Message-ID: <20160413182249.GB3120@linux.intel.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
 <20160413030156.GN2781@linux.intel.com>
 <1460560116.24985.55.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com,
	linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460560116.24985.55.camel@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 13, 2016 at 09:08:36AM -0600, Toshi Kani wrote:
> > Could you do something like:
> >=20
> > =A0#ifdef CONFIG_FS_DAX
> > =A0struct page *read_dax_sector(struct block_device *bdev, sector_t=
 n);
> > +unsigned long dax_get_unmapped_area(struct file *filp, unsigned lo=
ng
> > addr,
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned long len, un=
signed long pgoff, unsigned long
> > flags);
> > =A0#else
> > =A0static inline struct page *read_dax_sector(struct block_device *=
bdev,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sector_t n)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0return ERR_PTR(-ENXIO);
> > =A0}
> > +#define dax_get_unmapped_area	NULL
> > =A0#endif
> >=20
> > in patch 1/5.=A0=A0Then there's no need for the ifdefs in each file=
system.
>=20
> I thought about it, but I do not think we can use an inline function =
to an
> entry point.

That's not an inline function.  It's just NULL.  So after the preproces=
sor
is done with it, it just looks like:

	.get_unmapped_area =3D NULL,

and it won't be called by get_unmapped_area().
