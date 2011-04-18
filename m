From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP
 related?)
Date: Mon, 18 Apr 2011 10:35:53 +1000
Message-ID: <20110418003553.GR21395@dastard>
References: <20110414120635.GB1678@x4.trippels.de>
 <20110414140222.GB1679@x4.trippels.de>
 <4DA70BD3.1070409@draigBrady.com>
 <4DA717B2.3020305@sandeen.net>
 <20110414225904.GK21395@dastard>
 <4DA7836A.5040604@draigBrady.com>
 <20110415000940.GL21395@dastard>
 <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
 <20110416005040.GP21395@dastard>
 <BANLkTikEeXcvjgREoRCgriWAhZfnxJVtKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4482 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429Ab1DRAgA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Apr 2011 20:36:00 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikEeXcvjgREoRCgriWAhZfnxJVtKQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 16, 2011 at 02:05:51PM +0800, Yongqiang Yang wrote:
> On Sat, Apr 16, 2011 at 8:50 AM, Dave Chinner <david@fromorbit.com> w=
rote:
> > On Thu, Apr 14, 2011 at 11:01:04PM -0600, Andreas Dilger wrote:
> >> On 2011-04-14, at 6:09 PM, Dave Chinner <david@fromorbit.com>
> >> wrote:
> >> > No, this was explicitly laid out in the fiemap interface
> >> > discussions - it's up to the applicaiton to decide if it needs
> >> > to do a sync first. That's what the FIEMAP_FLAG_SYNC control
> >> > flag is for. =A0This forces the fiemap call to do a fsync _befor=
e_
> >> > getting the mapping. If you want to know the exact layout of the
> >> > file is, then you must use this flag.
> >> >
> >> > Even so, it is recognised that this is racy - any use of the
> >> > block map has a time-of-read-to-time-of-use race condition that
> >> > means you have to _verify_ the copy after it completes. FYI,
> >> > that's what xfs_fsr does when copying based on extent maps - if
> >> > the inode has changed in _any way_ during the copy, it aborts
> >> > the copy of that file.
> >> >
> >> > i.e. using fiemap for copying is at best a *hint* about the
> >> > regions that need copying, and it is in no way a guarantee that
> >> > you'll get all the information you need to make accurate copy
> >> > even if you do use the synchronous variant.
> >>
> >> I would tend to agree with P=E1draig. If there is data in the
> >> mapping (regardless of whether it is on disk or not), the FIEMAP
> >> should return this to the caller. =A0The SYNC flag is only intende=
d
> >> to flush the data to disk for tools that are doing
> >> direct-to-disk operations on the data.
> >
> > What you are suggesting is that FIEMAP needs to be page cache
> > coherent, and that is far, far away from the intended use of the
> > interface. Even consiering that you need to looking for active page=
s
> > in the page cache when mapping extents say to me that you are
> > doing something very wrong.
> >
> > Unwritten extents remain unwritten until the data is physically
> > written to them. Therefore, to change their state, you need to sync
> No, buffered writes change their state without sync.

They shouldn't.

> > the data covering the range. =A0_Lying_ about whether an extent is =
in
> > the unwritten state is a really bad precedence to set, especially a=
s
> > it is then guaranteed to change state when a crash occurs (Why did
> > recovery zero out my file? FIEMAP said it contained data before my
> > system crashed!).
>=20
> All filesystems have metadata in memory which is not flushed to
> permanent storage. e.g. if a extent exists in memory, but itself and
> corresponding data are not flushed to permanent storage.

Sure, but in the case of unwritten extents, XFS does not change the
metadata state in memory until *after the physical IO is completed*.
I'm pretty sure that btrfs is the same.

IOWs, despite the fact that a buffered write has occurred, no
metadata has changed state in memory, and the extents are still
unwritten in both memory and on disk....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
