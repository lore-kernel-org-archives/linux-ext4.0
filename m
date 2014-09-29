From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: resize2fs problem with stride calc
Date: Mon, 29 Sep 2014 13:59:30 -0700
Message-ID: <20140929205929.GA27728@birch.djwong.org>
References: <BAY179-W85AF983234DB78F07A12EFDB50@phx.gbl>
 <541EF912.7000801@redhat.com>
 <BAY179-W21A504DA0A8A8D30C139F3FDB20@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28218 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaI2U7g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2014 16:59:36 -0400
Content-Disposition: inline
In-Reply-To: <BAY179-W21A504DA0A8A8D30C139F3FDB20@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 21, 2014 at 06:32:53PM -0400, TR Reardon wrote:
> > Date: Sun, 21 Sep 2014 11:13:06 -0500
> > From: sandeen@redhat.com
> >
> > On 9/20/14 3:46 PM, TR Reardon wrote:
> >> resize2fs seems to come up with some crazy default stride numbers.
> >> This occurs with and without bigalloc.
> >>
> >>
> >> I was testing enabling/disabling 64bit using latest patches from D=
JW,
> >> and noticed that s_raid_stride was being written with nonsensical
> >> values, in particular determine_fs_stride() is coming up with over=
ly
> >> large values. The code is old (2006) and lacks comment so I'm not
> >> sure what the intended operation is. Does this just need to be
> >> updated for flex_bg? Should s_raid_stride ever be auto-changed on
> >> resize? If it should change, should stripe also change?
> >
> > That old commit says:
> >
> > + In addition, add code so that resize2fs can automatically
> > + determine the RAID stride parameter that had been
> > + previously used on the filesystem.
> >
> > but a year later, in 2007, this:
> >
> > commit 96c6a3acd377698cb99ffd9925bec9b20ca4f6f9
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date: Fri May 18 22:06:53 2007 -0400
> >
> > Store the RAID stride value in the superblock and take advantage of=
 it
> >
> > stored it properly in the superblock (this hit e2fsprogs-1.40).
> >
> > So maybe the whole heuristic could just be removed now, but from a =
simple
> > test, it's working here.
>=20
> Have you tried to test with flex_bg? =A0I think that's what raises th=
e problem.

It'll end up recalculating stride for any flexbg FS with more than 12 B=
Gs and
more than 3 flexbgs.  This piece is neither a part of nor is used for 3=
2>64bit
conversion.

AFAICT, the point of determine_fs_stride() is to try to recover the RAI=
D stride
by inferring it from minor variations in the block/inode bitmap locatio=
ns
between successive block groups.  This explodes when flexbg is turned o=
n
because bitmap blocks are stored in "other" bgs and there's a "big jump=
"
between the bitmaps in the last bg of one flexbg and the bitmaps of the=
 first
bg of the next flexbg.  Between bgs in a single flexbg the *_stride val=
ues are
"negative" and don't contribute to the stride calculation.

I /think/ the solution is to ignore first blockgroup when crossing a fl=
exbg
boundary when there are flexbgs.  Can you give the following patch a sp=
in?
It shouldn't spit out "group XXX has stride..." messages after that.  I=
'm not
sure that "negative" stride ought to be ignored either, but....

Honestly I'd rather just kill the whole thing, but someone must've had =
a reason
to put it there?  Ted?

--D

diff --git a/resize/main.c b/resize/main.c
index 060e67d..b993dfb 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -105,6 +105,7 @@ static void determine_fs_stride(ext2_filsys fs)
 	unsigned long long sum;
 	unsigned int	has_sb, prev_has_sb =3D 0, num;
 	int		i_stride, b_stride;
+	int		flexbg_size =3D 1 << fs->super->s_log_groups_per_flex;
=20
 	if (fs->stride)
 		return;
@@ -120,10 +121,11 @@ static void determine_fs_stride(ext2_filsys fs)
 			ext2fs_inode_bitmap_loc(fs, group - 1) -
 			fs->super->s_blocks_per_group;
 		if (b_stride !=3D i_stride ||
-		    b_stride < 0)
+		    b_stride < 0 ||
+		    (flexbg_size > 1 && (group % flexbg_size =3D=3D 0)))
 			goto next;
=20
-		/* printf("group %d has stride %d\n", group, b_stride); */
+		printf("group %d has stride %d %d\n", group, b_stride, i_stride);
 		sum +=3D b_stride;
 		num++;
=20
@@ -133,7 +135,7 @@ static void determine_fs_stride(ext2_filsys fs)
=20
 	if (fs->group_desc_count > 12 && num < 3)
 		sum =3D 0;
