From: Vishal Verma <vishal@kernel.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Date: Mon, 02 May 2016 09:45:35 -0600
Message-ID: <1462203935.11211.15.camel@kernel.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	 <1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	 <20160502145606.GD20589@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-nvdimm@ml01.01.org, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org, Matthew Wilcox <matthew@wil.cx>, Ross Zwisler
 <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jens Axboe
 <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org, Jeff Moyer
 <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>, Vishal Verma
	 <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160502145606.GD20589@infradead.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2016-05-02 at 07:56 -0700, Christoph Hellwig wrote:
> >=20
> > index 79defba..97a1f5f 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -167,12 +167,21 @@ blkdev_direct_IO(struct kiocb *iocb, struct
> > iov_iter *iter, loff_t offset)
> > =C2=A0	struct file *file =3D iocb->ki_filp;
> > =C2=A0	struct inode *inode =3D bdev_file_inode(file);
> > =C2=A0
> > -	if (IS_DAX(inode))
> > +	if (iocb_is_direct(iocb))
> > +		return __blockdev_direct_IO(iocb, inode,
> > I_BDEV(inode), iter,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0offset,
> > blkdev_get_block, NULL,
> > +					=C2=A0=C2=A0=C2=A0=C2=A0NULL,
> > DIO_SKIP_DIO_COUNT);
> > +	else if (iocb_is_dax(iocb))
> > =C2=A0		return dax_do_io(iocb, inode, iter, offset,
> > blkdev_get_block,
> > =C2=A0				NULL, DIO_SKIP_DIO_COUNT);
> > -	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode),
> > iter, offset,
> > -				=C2=A0=C2=A0=C2=A0=C2=A0blkdev_get_block, NULL, NULL,
> > -				=C2=A0=C2=A0=C2=A0=C2=A0DIO_SKIP_DIO_COUNT);
> > +	else {
> > +		/*
> > +		=C2=A0* If we're in the direct_IO path, either the
> > IOCB_DIRECT or
> > +		=C2=A0* IOCB_DAX flags must be set.
> > +		=C2=A0*/
> > +		WARN_ONCE(1, "Kernel Bug with iocb flags\n");
> > +		return -ENXIO;
> > +	}
> DAX should not even end up in ->direct_IO.

Do you mean to say remove the last 'else' clause entirely?
I agree that it should never be hit, which is why it is a WARN..
But I'm happy to remove it.

>=20
> >=20
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -300,7 +300,7 @@ xfs_file_read_iter(
> > =C2=A0
> > =C2=A0	XFS_STATS_INC(mp, xs_read_calls);
> > =C2=A0
> > -	if (unlikely(iocb->ki_flags & IOCB_DIRECT))
> > +	if (unlikely(iocb->ki_flags & (IOCB_DIRECT | IOCB_DAX)))
> > =C2=A0		ioflags |=3D XFS_IO_ISDIRECT;
> please also add a XFS_IO_ISDAX flag to propagate the information
> properly and allow tracing to display the actual I/O type.

Will do.

>=20
> >=20
> > +static inline bool iocb_is_dax(struct kiocb *iocb)
> > =C2=A0{
> > +	return IS_DAX(file_inode(iocb->ki_filp)) &&
> > +		(iocb->ki_flags & IOCB_DAX);
> > +}
> > +
> > +static inline bool iocb_is_direct(struct kiocb *iocb)
> > +{
> > +	return iocb->ki_flags & IOCB_DIRECT;
> > =C2=A0}
> No need for these helpers - especially as IOCB_DAX should never be
> set
> if IS_DAX is false.

Ok. So check the flags directly where needed?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-info=
.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
