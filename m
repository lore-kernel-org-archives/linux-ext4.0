From: Dave Chinner <david@fromorbit.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP
 related?)
Date: Mon, 18 Apr 2011 10:40:40 +1000
Message-ID: <20110418004040.GS21395@dastard>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	=?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"coreutils@gnu.org" <coreutils@gnu.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	xfs-oss <xfs@oss.sgi.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:62422 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab1DRAkp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Apr 2011 20:40:45 -0400
Content-Disposition: inline
In-Reply-To: <4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 16, 2011 at 08:21:28AM -0400, Theodore Tso wrote:
>=20
> On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:
>=20
> > In that case, it means cp should just always use FIEMAP_FLAG_SYNC, =
which is fine.=20
>=20
> Except that if someone is copying a large delay allocated file, it wi=
ll cause=20
> the file to immediately snapped to disk, which might not be the great=
est
> thing in the world.=20

Obvious workaround - if the initial fiemap call shows unwritten
extents, redo it with the sync flag set. Though that assume=D1=95 that
you can trust things like delalloc extents to only cover the range
that valid data exists in. Which, of course, you can't assume,
either. :/

> Christoph is write, SEEK_HOLE and SEEK_DATA are
> a much better API for what cp woulld lke to do.  Unfortunately it has=
n't
> been implemented yet in the VFS...

Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.

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
