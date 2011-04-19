From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Tue, 19 Apr 2011 09:58:15 +0800
Message-ID: <BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
References: <20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
	<4DA717B2.3020305@sandeen.net>
	<20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56307 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab1DSB6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Apr 2011 21:58:22 -0400
Received: by pvg12 with SMTP id 12so2388146pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Apr 2011 18:58:22 -0700 (PDT)
In-Reply-To: <6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 18, 2011 at 10:45 AM, Andreas Dilger <adilger@dilger.ca> wr=
ote:
> On 2011-04-17, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, Apr 16, 2011 at 08:21:28AM -0400, Theodore Tso wrote:
>
> On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:
>
> In that case, it means cp should just always use FIEMAP_FLAG_SYNC, wh=
ich is
> fine.
>
> Except that if someone is copying a large delay allocated file, it wi=
ll
> cause
>
> the file to immediately snapped to disk, which might not be the great=
est
>
> thing in the world.
>
> Obvious workaround - if the initial fiemap call shows unwritten
> extents, redo it with the sync flag set. Though that assume=D1=95 tha=
t
> you can trust things like delalloc extents to only cover the range
> that valid data exists in. Which, of course, you can't assume,
> either. :/
>
> Always passing=C2=A0FIEMAP_FLAG_SYNC is fine in this case. It should =
only do
> anything if there is unwritten data, which is the only case we are co=
ncerned
> with at this point. =C2=A0In any case, this is a simple solution for =
coreutils
> until such a time that a more complex solution is added in the kernel=
 (if
> ever).
>
> Christoph is write, SEEK_HOLE and SEEK_DATA are
>
> a much better API for what cp woulld lke to do. =C2=A0Unfortunately i=
t hasn't
>
> been implemented yet in the VFS...
>
> Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.
>
> I don't see how this will change the problem in any meaningful way. T=
here
> will still need to be code that is traversing the on-disk mapping, an=
d also
> keeping it coherent with unwritten data in the page cache.

It seems that we are being messed up by page cache and disk.
Unwritten flag returned from FIEMAP indicates blocks on disk are not
written, but it does not say if there is data in page cache.  So
=46IEMAP itself just tells user the map on disk.  However there is an
exception for delayed allocation,  FIEMAP tells users the data is in
page cache.

Maybe FIEMAP should return all known messages for unwritten extent, if
unwritten data exists in page cache, FIEMAP should let users know that
data is in page cache and space on disk has been preallocated, but
data has not been flushed into disk.  Actually, delayed allocation has
done like this. Then user-space applications can determine how to do.
Taking cp as an example, it will copy from page cache rather ignore
it.


We need a definite definition for FIEMAP, in other words, it tells
users map on disk or both disk and page cache.

If the former one is taken, then FIEMAP should not consider delayed all=
ocation.
otherwise, FIEMAP should return all known messages for unwritten case
like delayed allocation.

> Since FIEMAP already exists for most Linux filesystems, it probably m=
akes
> sense to implement SEEK_{HOLE,DATA} by calling FIEMAP to get the disk
> mapping in the first place.
> I agree that=C2=A0SEEK_{HOLE,DATA} is an easier programming interface=
, and
> probably what cp, tar, etc should use, once it is implemented.
> Cheers, Andreas
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
