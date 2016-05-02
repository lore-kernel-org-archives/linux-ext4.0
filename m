From: Vishal Verma <vishal@kernel.org>
Subject: Re: [PATCH v4 5/7] fs: prioritize and separate direct_io from dax_io
Date: Mon, 02 May 2016 09:51:31 -0600
Message-ID: <1462204291.11211.20.camel@kernel.org>
References: <1461878218-3844-1-git-send-email-vishal.l.verma@intel.com>
	 <1461878218-3844-6-git-send-email-vishal.l.verma@intel.com>
	 <5727753F.6090104@plexistor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-block@vger.kernel.org, Jan Kara <jack@suse.cz>, Matthew Wilcox
	 <matthew@wil.cx>, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>,
	linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig
	 <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Andrew Morton
	 <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>, Vishal Verma
 <vishal.l.verma@intel.com>,  linux-nvdimm@lists.01.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5727753F.6090104@plexistor.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2016-05-02 at 18:41 +0300, Boaz Harrosh wrote:
> On 04/29/2016 12:16 AM, Vishal Verma wrote:
> >=20
> > All IO in a dax filesystem used to go through dax_do_io, which
> > cannot
> > handle media errors, and thus cannot provide a recovery path that
> > can
> > send a write through the driver to clear errors.
> >=20
> > Add a new iocb flag for DAX, and set it only for DAX mounts. In the
> > IO
> > path for DAX filesystems, use the same direct_IO path for both DAX
> > and
> > direct_io iocbs, but use the flags to identify when we are in
> > O_DIRECT
> > mode vs non O_DIRECT with DAX, and for O_DIRECT, use the
> > conventional
> > direct_IO path instead of DAX.
> >=20
> Really? What are your thinking here?
>=20
> What about all the current users of O_DIRECT, you have just made them
> 4 times slower and "less concurrent*" then "buffred io" users. Since
> direct_IO path will queue an IO request and all.
> (And if it is not so slow then why do we need dax_do_io at all?
> [Rhetorical])
>=20
> I hate it that you overload the semantics of a known and expected
> O_DIRECT flag, for special pmem quirks. This is an incompatible
> and unrelated overload of the semantics of O_DIRECT.

We overloaded O_DIRECT a long time ago when we made DAX piggyback on
the same path:

static inline bool io_is_direct(struct file *filp)
{
	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
}

Yes O_DIRECT on a DAX mounted file system will now be slower, but -

>=20
> >=20
> > This allows us a recovery path in the form of opening the file with
> > O_DIRECT and writing to it with the usual O_DIRECT semantics
> > (sector
> > alignment restrictions).
> >=20
> I understand that you want a sector aligned IO, right? for the
> clear of errors. But I hate it that you forced all O_DIRECT IO
> to be slow for this.
> Can you not make dax_do_io handle media errors? At least for the
> parts of the IO that are aligned.
> (And your recovery path application above can use only aligned
> =C2=A0IO to make sure)
>=20
> Please look for another solution. Even a special
> IOCTL_DAX_CLEAR_ERROR

=C2=A0- see all the versions of this series prior to this one, where we t=
ry
to do a fallback...

>=20
> [*"less concurrent" because of the queuing done in bdev. Note how
> =C2=A0 pmem is not even multi-queue, and even if it was it will be much
> =C2=A0 slower then DAX because of the code depth and all the locks and
> task
> =C2=A0 switches done in the block layer. In DAX the final memcpy is don=
e
> directly
> =C2=A0 on the user-mode thread]
>=20
> Thanks
> Boaz
>=20

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
