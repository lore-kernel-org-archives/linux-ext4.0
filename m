From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Tue, 19 Apr 2011 14:53:20 +0800
Message-ID: <BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
References: <20110414225904.GK21395@dastard>
	<4DA7836A.5040604@draigBrady.com>
	<20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42439 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1DSGxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Apr 2011 02:53:21 -0400
Received: by pvg12 with SMTP id 12so2478087pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Apr 2011 23:53:20 -0700 (PDT)
In-Reply-To: <20110419034455.GB23985@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 19, 2011 at 11:44 AM, Dave Chinner <david@fromorbit.com> wr=
ote:
> On Tue, Apr 19, 2011 at 09:58:15AM +0800, Yongqiang Yang wrote:
>> On Mon, Apr 18, 2011 at 10:45 AM, Andreas Dilger <adilger@dilger.ca>=
 wrote:
>> > On 2011-04-17, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> >
>> > On Sat, Apr 16, 2011 at 08:21:28AM -0400, Theodore Tso wrote:
>> >
>> > On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:
>> >
>> > In that case, it means cp should just always use FIEMAP_FLAG_SYNC,=
 which is
>> > fine.
>> >
>> > Except that if someone is copying a large delay allocated file, it=
 will
>> > cause
>> >
>> > the file to immediately snapped to disk, which might not be the gr=
eatest
>> >
>> > thing in the world.
>> >
>> > Obvious workaround - if the initial fiemap call shows unwritten
>> > extents, redo it with the sync flag set. Though that assume=D1=95 =
that
>> > you can trust things like delalloc extents to only cover the range
>> > that valid data exists in. Which, of course, you can't assume,
>> > either. :/
>> >
>> > Always passing=C2=A0FIEMAP_FLAG_SYNC is fine in this case. It shou=
ld only do
>> > anything if there is unwritten data, which is the only case we are=
 concerned
>> > with at this point. =C2=A0In any case, this is a simple solution f=
or coreutils
>> > until such a time that a more complex solution is added in the ker=
nel (if
>> > ever).
>> >
>> > Christoph is write, SEEK_HOLE and SEEK_DATA are
>> >
>> > a much better API for what cp woulld lke to do. =C2=A0Unfortunatel=
y it hasn't
>> >
>> > been implemented yet in the VFS...
>> >
>> > Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem=
=2E
>> >
>> > I don't see how this will change the problem in any meaningful way=
=2E There
>> > will still need to be code that is traversing the on-disk mapping,=
 and also
>> > keeping it coherent with unwritten data in the page cache.
>>
>> It seems that we are being messed up by page cache and disk.
>> Unwritten flag returned from FIEMAP indicates blocks on disk are not
>> written, but it does not say if there is data in page cache. =C2=A0S=
o
>> FIEMAP itself just tells user the map on disk. =C2=A0However there i=
s an
>> exception for delayed allocation, =C2=A0FIEMAP tells users the data =
is in
>> page cache.
>
> No, FIEMAP does not tell the user there is data in the page cache.
> It tells there user there is a delayed allocation extent. For XFS, a
> delayed allocation extent can cover a range _greater_ than there is
> data in the page cache - we do allocation allignment, speculative
> allocation and other tricks to avoid fragmentation via
> delayed allocation. When XFSs says there is a delalloc extent, it is
> simply showing the in-memory representation of the extent. if you
> want to know where the data in the page cache actually is, you need
> to sync the file to disk to get those ranges converted to real
> extents. This is how xfs_bmap has worked for 15 years....
>
>> Maybe FIEMAP should return all known messages for unwritten extent, =
if
>> unwritten data exists in page cache, FIEMAP should let users know th=
at
>> data is in page cache and space on disk has been preallocated, but
>> data has not been flushed into disk. =C2=A0Actually, delayed allocat=
ion has
>> done like this. Then user-space applications can determine how to do=
=2E
>> Taking cp as an example, it will copy from page cache rather ignore
>> it.
>
> Once again, FIEMAP is for showing the filesystem's current extent
> state, not the page cache state. Ext4 may implement FIEMAP by doing
> page cache walks, but that is a filesystem specific implementation
> detail.
>
>> We need a definite definition for FIEMAP, in other words, it tells
>> users map on disk or both disk and page cache.
>
> We already have a definition - and it has nothing to do with the
> page cache state.
>
>> If the former one is taken, then FIEMAP should not consider
>> delayed allocation.
>
> Not at all. the delayed allocation extent is a first class extent
> type in XFS and it is reported directly from the extent list. Your
> viewpoint is very ext4-specific and ignores the fact that other
> filesystems were doing this sort of mapping long before even ext3
> (let alone ext4) was a glint in the designer's eye....
>
>> otherwise, FIEMAP should return all known messages for unwritten cas=
e
>> like delayed allocation.
>
> See my previous comments about extents being unwritten until data is
> physically written to them.
Understood, thank you for your explanation.

Ok.  Let's look at it from a higher view.  What you described about
extent state is specific to xfs.

I think there are 2 ways to provide a definite definition for FIEMAP
for all filesystems:

1. FIEMAP returns extent state on disk.
2. FIEMAP returns extent both in memory and on disk.

Now, the question comes in case 2.   How to define extent's state in
memory? Every filesystem has its own implementation regarding extent
in memory, especially for delayed and unwritten extents, and I think
they are all reasonable. For example, ext4 without delayed allocation
change unwritten extents to written ones immediately in memory, while
the changing is delayed until flush time in delayed allocation case.

It seems that there are only 1 way to provide a definite definition of
in-memory-extent - FIEMAP should return what an user has written.
this works for all filesystems.

Yongqiang.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
