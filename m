From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] OCFS2: Allow huge (> 16 TiB) volumes to mount
Date: Tue, 13 Jul 2010 11:25:06 +1000
Message-ID: <20100713012506.GA30737@dastard>
References: <871vbax86w.fsf@patl.com>
 <87zkxyvtjt.fsf@patl.com>
 <3BB069D5-B193-43A4-B678-B3CEA4873B58@dilger.ca>
 <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:53645 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755668Ab0GMBZL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jul 2010 21:25:11 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTikAEycm5PKTLPuRFcB0e4qNp5EuQbKUx5aruNrh@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 12, 2010 at 06:08:51PM -0700, Patrick J. LoPresti wrote:
> On Mon, Jul 12, 2010 at 5:21 PM, Andreas Dilger <adilger@dilger.ca> w=
rote:
> > On 2010-07-11, at 11:04, Patrick J. LoPresti wrote:
> > >
> >> + =A0 =A0 /* Absolute addressability check (borrowed from ext4/sup=
er.c) */
> >> + =A0 =A0 if ((max_block >
> >> + =A0 =A0 =A0 =A0 =A0(sector_t)(~0LL) >> (osb->sb->s_blocksize_bit=
s - 9)) ||
> >> + =A0 =A0 =A0 =A0 (max_block > (pgoff_t)(~0LL) >> (PAGE_CACHE_SHIF=
T -
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0osb->sb->s_blocksize_bits))) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 mlog(ML_ERROR, "Volume too large "
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"to mount safely on this syst=
em");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 status =3D -EFBIG;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> >> + =A0 =A0 }
> >
> > This hunk of code is actually in several filesystems. =A0It wouldn'=
t be a bad idea to make it a library function that can be called by the=
 filesystem to check the kernel page cache and block layer can handle t=
hese large filesystems.
>=20
> True, but some of them do it differently (e.g. see the #if switch in
> xfs_sb_validate_fsb_count).  Tracking down all variants and changing
> them is a much larger task than my simple patch.

The XFS code is different to the above because there is still a 16TB
size limit on 32 bit systemsi (i.e. page cache address limits). IOWs,
you can't just remove the above 16TB check unless you (i.e. OCFS2)
handle >16TB block devices on 32 bit systems correctly...

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
