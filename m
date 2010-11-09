From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Wed, 10 Nov 2010 10:40:49 +1100
Message-ID: <20101109234049.GQ2715@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
 <20101109044242.GH2715@dastard>
 <20101109214147.GK3099@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Ted Ts'o <tytso@mit.edu>, Josef Bacik <josef@redhat.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:50091 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752166Ab0KIXlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Nov 2010 18:41:40 -0500
Content-Disposition: inline
In-Reply-To: <20101109214147.GK3099@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 09, 2010 at 04:41:47PM -0500, Ted Ts'o wrote:
> On Tue, Nov 09, 2010 at 03:42:42PM +1100, Dave Chinner wrote:
> > Implementation is up to the filesystem. However, XFS does (b)
> > because:
> >=20
> > 	1) it was extremely simple to implement (one of the
> > 	   advantages of having an exceedingly complex allocation
> > 	   interface to begin with :P)
> > 	2) conversion is atomic, fast and reliable
> > 	3) it is independent of the underlying storage; and
> > 	4) reads of unwritten extents operate at memory speed,
> > 	   not disk speed.
>=20
> Yeah, I was thinking that using a device-style TRIM might be better
> since future attempts to write to it won't require a separate seek to
> modify the extent tree.  But yeah, there are a bunch of advantages of
> simply mutating the extent tree.
>=20
> While we're on the subject of changes to fallocate, what do people
> think of FALLOC_FL_EXPOSE_OLD_DATA, which requires either root
> privileges or (if capabilities are in use) CAP_DAC_OVERRIDE &&
> CAP_MAC_OVERRIDE && CAP_SYS_ADMIN.  This would allow a trusted proces=
s
> to fallocate blocks with the extent already marked initialized.  I've
> had two requests for such functionality for ext4 already. =20

We removed that ability from XFS about three years ago because it's
a massive security hole. e.g. what happens if the file is world
readable, even though the process that called
=46ALLOC_FL_EXPOSE_OLD_DATA was privileged and was allowed to expose
such data? Or the file is chmod 777 after being exposed?

The historical reason for such behaviour existing in XFS was that in
1997 the CPU and IO latency cost of unwritten extent conversion was
significant, so users with real physical security (i.e. marines with
guns) were able to make use of fast preallocation with no conversion
overhead without caring about the security implications. These days,
the performance overhead of unwritten extent conversion is minimal -
I generally can't measure a difference in IO performance as a result
of it - so there is simply no good rea=D1=95on for leaving such a gapin=
g
security hole in the system.

If anyone wants to read the underlying data, then use fiemap to map
the physical blocks and read it directly from the block device. That
requires root privileges but does not open any new stale data
exposure problems....

> (Take for example a trusted cluster filesystem backend that checks th=
e
> object checksum before returning any data to the user; and if the
> check fails the cluster file system will try to use some other replic=
a
> stored on some other server.)

IOWs, all they want to do is avoid the unwritten extent conversion
overhead. Time has shown that a bad security/performance tradeoff
decision was made 13 years ago in XFS, so I see little reason to
repeat it for ext4 today....

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
