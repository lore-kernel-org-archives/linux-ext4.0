From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 12:18:15 +0200
Message-ID: <20090511101815.GR4694@kernel.dk>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090511100624.GB6585@logfs.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11 2009, J=F6rn Engel wrote:
> On Mon, 11 May 2009 04:37:54 -0400, Theodore Tso wrote:
> >=20
> > Well, no one has actually implemented the low-level TRIM support ye=
t;
>=20
> Iirc dwmw2 did so for some of the FTL drivers.  More a curiosity than=
 a
> useful device, though.
>=20
> > Well, no, Matthew's changes didn't do any of that, I suspect becaus=
e
> > most SSD's, including X25-M, are expected to have a granularity siz=
e
> > of 1 block.  It's the crazy people in the SCSI standards world who'=
ve
> > been pushing for granlarity sizes in the 1-4 megabyte range; as I
> > understand things, the granularity issue was not going to be a prob=
lem
> > for the ATA TRIM command.
>=20
> I am not sure about this part.  So far Intel has been the only party =
to
> release any information about their dark-grey box.  All other boxes a=
re
> still solid black.  And until I'm told otherwise I'd consider them to=
 be
> stupid devices that use erase block size as trim granularity.
>=20
> Given the total lack of information, your guess is as good as mine,
> though.
>=20
> > As far as thinking that the proposal is ludicrous --- what precisel=
y
> > did you find ludicrous about it?
>=20
> Mainly the idea that discard requests should act as barriers and inst=
ead
> of fixing that, you propose a lot of complexity to work around it.

But the command is effectively a barrier at the device level anyway,
since you need to drain the hardware queue before issuing.

> > The only problem with SSD's is the people who designed the ATA TRIM
> > command requires us to completely drian the I/O queue before issuin=
g
> > it.  Because of this incompetence, we need to be a bit more careful
> > about how we issue them.
>=20
> And this bit that I wasn't aware of.  Such a requirement in the stand=
ard
> is a trainwreck indeed.

Precisely, but that's how basically anything works with SATA NCQ, only
read/write dma commands may be queued. Anything else requires an idle
drive before issue.

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
