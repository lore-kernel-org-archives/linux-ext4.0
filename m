From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on append
 only file
Date: Wed, 16 Apr 2014 07:36:35 +1000
Message-ID: <20140415213635.GM15995@dastard>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-2-git-send-email-lczerner@redhat.com>
 <20140412151935.GA18047@infradead.org>
 <alpine.LFD.2.00.1404151457550.2146@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404151457550.2146@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 15, 2014 at 03:09:42PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Sat, 12 Apr 2014, Christoph Hellwig wrote:
>=20
> > Date: Sat, 12 Apr 2014 08:19:35 -0700
> > From: Christoph Hellwig <hch@infradead.org>
> > To: Lukas Czerner <lczerner@redhat.com>
> > Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
> >     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> > Subject: Re: [PATCH 2/4] fs: Prevent doing FALLOC_FL_ZERO_RANGE on =
append only
> >      file
> >=20
> > On Fri, Apr 11, 2014 at 08:57:43PM +0200, Lukas Czerner wrote:
> > >  	/*
> > > -	 * It's not possible to punch hole or perform collapse range
> > > -	 * on append only file
> > > +	 * It's not possible to punch hole, perform collapse range
> > > +	 * or zero range on append only file
> > >  	 */
> > > -	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE)
> > > +	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_COLLAPSE_RANGE |
> > > +		    FALLOC_FL_ZERO_RANGE)
> >=20
> > Might be better to make this a negative test fo the operation that =
is
> > allowed on an appen only file.  That's also much better future proo=
f.
> >=20
>=20
> True, it might be better to do it this way:
>=20
> if (mode & ~FALLOC_FL_KEEP_SIZE && IS_APPEND(inode))

if ((mode & ~FALLOC_FL_KEEP_SIZE) && IS_APPEND(inode))

:)

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
