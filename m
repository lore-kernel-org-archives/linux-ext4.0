From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Date: Fri, 15 Apr 2016 13:11:17 -0400
Message-ID: <x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: "Wilcox\, Matthew R" <matthew.r.wilcox@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block\@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>,
        "linux-nvdimm\@ml01.01.org" <linux-nvdimm@ml01.01.org>,
        "xfs\@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "viro\@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "axboe\@fb.com" <axboe@fb.com>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-ext4\@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "david\@fromorbit.com" <david@fromorbit.com>,
        "jack\@suse.cz" <jack@suse.cz>
To: "Verma\, Vishal L" <vishal.l.verma@intel.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1460739288.3012.3.camel@intel.com> (Vishal L. Verma's message of
	"Fri, 15 Apr 2016 16:54:48 +0000")
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

"Verma, Vishal L" <vishal.l.verma@intel.com> writes:

> On Fri, 2016-04-15 at 12:11 -0400, Jeff Moyer wrote:
>> Vishal Verma <vishal.l.verma@intel.com> writes:
>> > +	if (IS_DAX(inode)) {
>> > +		ret =3D dax_do_io(iocb, inode, iter, offset,
>> > blkdev_get_block,
>> > =C2=A0				NULL, DIO_SKIP_DIO_COUNT);
>> > -	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode),
>> > iter, offset,
>> > +		if (ret =3D=3D -EIO && (iov_iter_rw(iter) =3D=3D WRITE))
>> > +			ret_saved =3D ret;
>> > +		else
>> > +			return ret;
>> > +	}
>> > +
>> > +	ret =3D __blockdev_direct_IO(iocb, inode, I_BDEV(inode),
>> > iter, offset,
>> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0blkdev_get_block, NULL, NULL,
>> > =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0DIO_SKIP_DIO_COUNT);
>> > +	if (ret < 0 && ret_saved)
>> > +		return ret_saved;
>> > +
>> Hmm, did you just break async DIO?=C2=A0=C2=A0I think you did!=C2=A0=C2=
=A0:)
>> __blockdev_direct_IO can return -EIOCBQUEUED, and you've now turned
>> that
>> into -EIO.=C2=A0=C2=A0Really, I don't see a reason to save that first
>> -EIO.=C2=A0=C2=A0The
>> same applies to all instances in this patch.
>
> The reason I saved it was if __blockdev_direct_IO fails for some
> reason, we should return the original cause o the error, which was an
> EIO.. i.e. we shouldn't be hiding the EIO if the direct_IO fails with
> something else..

OK.

> But, how does _EIOCBQUEUED work? Maybe we need an exception for it?

For async direct I/O, only the setup phase of the I/O is performed and
then we return to the caller.  -EIOCBQUEUED signifies this.

You're heading towards code that looks like this:

        if (IS_DAX(inode)) {
                ret =3D dax_do_io(iocb, inode, iter, offset, blkdev_get_blo=
ck,
                                NULL, DIO_SKIP_DIO_COUNT);
                if (ret =3D=3D -EIO && (iov_iter_rw(iter) =3D=3D WRITE))
                        ret_saved =3D ret;
                else
                        return ret;
        }

        ret =3D __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offs=
et,
                                    blkdev_get_block, NULL, NULL,
                                    DIO_SKIP_DIO_COUNT);
        if (ret < 0 && ret !=3D -EIOCBQUEUED && ret_saved)
                return ret_saved;

There's a lot of special casing here, so you might consider adding
comments.

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
