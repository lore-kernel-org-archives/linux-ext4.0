From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: delayed allocation i_blocks fix for stat(2)
Date: Tue, 08 Jul 2008 15:55:19 -0700
Message-ID: <1215557719.6820.14.camel@mingming-laptop>
References: <1215473799.6702.9.camel@mingming-laptop>
	 <4872BEAC.7010007@redhat.com> <48735A66.2040006@redhat.com>
	 <20080708200235.GC22477@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Staubach <staubach@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42469 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbYGHWzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2008 18:55:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m68MtK5T021198
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 18:55:20 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m68MtKYD228994
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 18:55:20 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m68MtJk1006454
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jul 2008 18:55:20 -0400
In-Reply-To: <20080708200235.GC22477@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


=E5=9C=A8 2008-07-08=E4=BA=8C=E7=9A=84 22:02 +0200=EF=BC=8CJan Kara=E5=86=
=99=E9=81=93=EF=BC=9A
> > Eric Sandeen wrote:
> > >Mingming Cao wrote:
> > > =20
> > >>ext4: delayed allocation i_blocks fix for stat(2)
> > >>
> > >>From: Mingming Cao <cmm@us.ibm.com>
> > >>
> > >>Right now i_blocks is not getting updated until the disks are act=
ually
> > >>allocaed on disk.  This means with delayed allocation, right afte=
r files
> > >>are copied, "ls -sF" shoes the file as taking 0 blocks on disk.  =
"du"
> > >>also shows the files taking zero space, which is highly confusing=
 to the=20
> > >>user.
> > >>
> > >>Since current delayed allocation already keep track of per-inode =
total=20
> > >>number
> > >>of blocks that are subject to delayed allocation, this patch fix =
this by=20
> > >>using
> > >>that to adjust the value returned by stat(2). When real block all=
ocation
> > >>is done, the i_blocks will get updated. Since the reserved blocks=
 for=20
> > >>delayed
> > >>allocation will be decreased, this will be keep value returned by=
 stat(2)
> > >>consistent.
> > >>
> > >>Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > >>   =20
> > >
> > >Thanks Mingming, looks like just the right approach.
> > >
> > >Something about the spinlock for every stat seems heavy-handed to =
me but
> > >I'll have to give that more thought.  :)
> > >
> > > =20
> >=20
> > Since i_reserved_blocks is an unsigned long, it should be possible
> > to atomically fetch it on all of the supported architectures,
> > without the use of the spinlock.  It seems to me that this spinlock
> > is not required here.
>   Well, it's certainly not nice to rely on this. The clean solution
> would be to convert i_reserved_blocks to atomic_t or atomic64_t on ar=
chs
> that have it...
>=20

I was thinking about the same thing when this lock was initially
introduced ... but this lock is protecting three counters, and these
counters are updated/reset in a couple of places, and being used to
calcuate how much per-fs free blocks counter need to be accounted.  It'=
s
doable, just need a careful look if we make them all atomic.

Mingming


> 								Honza

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
