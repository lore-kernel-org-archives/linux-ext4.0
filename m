From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: ext4: Always verify extent tree blocks
Date: Tue, 30 Aug 2011 16:04:19 -0700
Message-ID: <20110830230419.GF11984@tux1.beaverton.ibm.com>
References: <CAEd0oO1MiuLwtLBh1B7xap-269ORgKYQBTtThKBZc3q45_Z3Nw@mail.gmail.com> <20110824174506.GJ10570@tux1.beaverton.ibm.com> <CAEd0oO1_FkOPKGDzXNX9S1L2fByoMiOcbA3Qw8szwAh-BkkdbA@mail.gmail.com> <20110829221015.GB11984@tux1.beaverton.ibm.com> <CAEd0oO1wm0iinsUJ2zwZM_+i2BnfU7uNA77ReiAcFTdwomKfkA@mail.gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?utf-8?B?6buD5LiA6LuSIChJLUhzdWFuIEh1YW5nKQ==?=
	<ihhuang@abmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51428 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab1H3XF2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 19:05:28 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7UMULZr006865
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 18:30:21 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7UN4UqV2322556
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 19:04:30 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7UN4UgW014421
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 19:04:30 -0400
Content-Disposition: inline
In-Reply-To: <CAEd0oO1wm0iinsUJ2zwZM_+i2BnfU7uNA77ReiAcFTdwomKfkA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2011 at 09:08:59AM +0800, =E9=BB=83=E4=B8=80=E8=BB=92 (=
I-Hsuan Huang) wrote:
> Dear Darrick,
>=20
> Thanks for your correction.
> Would you please kindly give me some idea about how to prevent extent
> attribute block error?
> I would like to try journal_checksum.

=46irst you'd have to figure out how the extent attribute got corrupted=
 (bad
disk, bad cable, bad memory, bad software....) and then we could put to=
gether a
plan to fix it.  The ext4 metadata checksumming patches (which are near=
ly ready
to be sent out) would at least help with silent corruption.

--D
>=20
> Thanks,
> IH
>=20
> 2011/8/30 Darrick J. Wong <djwong@us.ibm.com>
>=20
> > On Mon, Aug 29, 2011 at 01:40:11PM +0800, =E9=BB=83=E4=B8=80=E8=BB=92=
 (I-Hsuan Huang) wrote:
> > > Dear Darrick,
> > >
> > > I still met the following failure symptom with your patch.
> > >
> > > <2>[    3.311674] EXT4-fs error (device mmcblk0p23): ext4_iget: i=
node
> > > #22944: (comm init) bad extended attribute block 173879342
> > >
> > > The validation code looks like not work.
> > > Is changing the flag enough to force validating extent header?
> >
> > Extended attribute blocks are not extent tree blocks.
> >
> > The patch in question only made ext4 complain consistently if the e=
xtent
> > tree
> > got corrupt.
> >
> > --D
> > >
> > > Thanks,
> > > IH Huang
> > >
> > > 2011/8/25 Darrick J. Wong <djwong@us.ibm.com>
> > >
> > > > On Wed, Aug 24, 2011 at 05:54:15PM +0800, =E9=BB=83=E4=B8=80=E8=
=BB=92 (I-Hsuan Huang) wrote:
> > > > > Dear Darrick,
> > > > >
> > > > > I have read your ext4 patch on Patchwork and have a question =
about
> > your
> > > > ext4
> > > > > patch to validate the extent header.
> > > > > Is you patch related to the Bug 20992:
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D20992
> > > >
> > > > Yes, I think it would fix that bug.  That said, I'm pretty clos=
e to
> > posting
> > > > a
> > > > patch set to implement full metadata checksuming, which include=
s a
> > better
> > > > solution than what's in patchwork.  Basically it implements a n=
ew
> > > > bufferhead
> > > > flag that tracks whether or not a metadata buffer has been vali=
dated,
> > and
> > > > skips
> > > > the checks if it has.
> > > >
> > > > Obviously that won't help you if you overwrite the filesystem w=
hile
> > it's
> > > > mounted... but oh well, at least it'll fix your case.  It was m=
eant to
> > fix
> > > > the
> > > > case where the first time a bad extent block gets read it fails=
 the
> > check
> > > > and
> > > > complains, but subsequent accesses of the same block don't even=
 check.
> > > >
> > > > --D
> > > > >
> > > > > Ted mentioned that
> > > > >
> > > > > *Yep, looks like a bug alright.
> > > > >
> > > > > From what I can tell, you were in the middle of async I/O, at=
 the
> > time
> > > > when
> > > > > the
> > > > > disk was corrupted.  The problem seemed to come after the I/O=
 was
> > > > completed,
> > > > > and  ext4_convert_unwritten_extents() was trying to set the
> > initialized
> > > > bit
> > > > > on
> > > > > the extent tree.  At that point the extent tree must have got=
ten
> > > > corrupted
> > > > > on
> > > > > disk, and this seriously confused the extent conversion code,=
 which
> > ended
> > > > up
> > > > > passing 0 to ext4_ext_put_in_cache() as the length of the ext=
ent, and
> > > > that
> > > > > tripped the BUG_ON in ext4_ext_put_in_cache().
> > > > >
> > > > > How did you corrupt the file system while it was mounted?   W=
as it
> > via
> > > > some
> > > > > dd
> > > > > to the disk device directly?
> > > > >
> > > > > We do have code that checks to make sure the extent tree is s=
ane, but
> > we
> > > > > skip
> > > > > it if the data was already in the buffer cache, to save CPU c=
osts.
> >  But
> > > > if
> > > > > you
> > > > > wrote to the disk device directly, it would have gone through=
 the
> > buffer
> > > > > cache,
> > > > > since the extent tree was already cached, we would have skipp=
ed the
> > > > > validation
> > > > > step, and that could be the explanation for how the bug got
> > triggered.
> > > > >
> > > > > If so, I'm loathe to turn on the validation check uncondition=
ally,
> > since
> > > > > that
> > > > > would kill performance.  I can probably change the BUG_ON in
> > > > > ext4_put_in_cache() to rather set the cache state to "invalid=
", which
> > > > would
> > > > > at
> > > > > least prevent the BUG_ON.  The filesystem was probably well a=
nd truly
> > > > > trashed,
> > > > > though, so sooner or later the ext4 fs code would have hit so=
mething
> > to
> > > > > cause
> > > > > it to be very unhappy.  Hoepfully it would be an ext4_error()=
 call to
> > > > mark
> > > > > the
> > > > > file system as corrupted, as opposed to another BUG_ON.
> > > > > *
> > > > > Have a nice day.
> > > > >
> > > > > Thanks,
> > > > > Randall
> > > >
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
