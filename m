From: Toshi Kani <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
Date: Wed, 13 Apr 2016 12:52:44 -0600
Message-ID: <1460573564.24985.60.camel@hpe.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
	 <20160413030156.GN2781@linux.intel.com> <1460560116.24985.55.camel@hpe.com>
	 <20160413182249.GB3120@linux.intel.com>
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
In-Reply-To: <20160413182249.GB3120@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2016-04-13 at 14:22 -0400, Matthew Wilcox wrote:
> On Wed, Apr 13, 2016 at 09:08:36AM -0600, Toshi Kani wrote:
> >=20
> > >=20
> > > Could you do something like:
> > >=20
> > > =C2=A0#ifdef CONFIG_FS_DAX
> > > =C2=A0struct page *read_dax_sector(struct block_device *bdev, sec=
tor_t n);
> > > +unsigned long dax_get_unmapped_area(struct file *filp, unsigned =
long
> > > addr,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0unsigned long len, unsigned long pgoff, unsigne=
d long
> > > flags);
> > > =C2=A0#else
> > > =C2=A0static inline struct page *read_dax_sector(struct block_dev=
ice
> > > *bdev,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0sector_t n)
> > > =C2=A0{
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ERR_=
PTR(-ENXIO);
> > > =C2=A0}
> > > +#define dax_get_unmapped_area	NULL
> > > =C2=A0#endif
> > >=20
> > > in patch 1/5.=C2=A0=C2=A0Then there's no need for the ifdefs in e=
ach
> > > filesystem.
> >
> > I thought about it, but I do not think we can use an inline functio=
n to
> > an entry point.
>
> That's not an inline function.=C2=A0=C2=A0It's just NULL.=C2=A0=C2=A0=
So after the
> preprocessor is done with it, it just looks like:
>=20
> 	.get_unmapped_area =3D NULL,
>=20
> and it won't be called by get_unmapped_area().

Oh, I see. Good idea. I will do that.

Thanks,
-Toshi
