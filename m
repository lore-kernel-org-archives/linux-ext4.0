From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Sat, 26 Jan 2013 12:00:55 +1100
Message-ID: <20130126010055.GH2667@dastard>
References: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
 <20130124195458.GD9477@thunk.org>
 <alpine.LFD.2.00.1301251012200.20753@localhost>
 <20130125150948.GK28908@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57474 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab3AZBA6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jan 2013 20:00:58 -0500
Content-Disposition: inline
In-Reply-To: <20130125150948.GK28908@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 10:09:48AM -0500, Theodore Ts'o wrote:
> On Fri, Jan 25, 2013 at 10:22:44AM +0100, Luk=C3=A1=C5=A1 Czerner wro=
te:
> >=20
> > we can get the EIO error from ext4_map_blocks not only in the case
> > of hardware error. The extent tree might not be in consistent state=
,
> > or we could even ask for blocks outside the file system itself (I
> > believe I've seen this before) and I think that in those cases it
> > might be worth to all WARN_ON.
>=20
> Sure, but in those cases, the file system is corrupt, and we should
> have thrown an ext4_error() in ext4_map_blocks().  The point is that =
a
> WARN_ON is only useful if there is a potential programming bug.  If w=
e
> know for sure that it's caused by a file system corruption, then we
> don't want to throw a WARN_ON.

=46WIW, XFS handles this problem with an error level sysctl. For
situations like this, the default level doesn't throw stack traces
(just the error message), but there are situations where diagnosis
requires emitting the stack trace.

Hence if it is necessary for bug triage, users can then turn the
sysctl up to 11 and the stack trace will be emitted after the
warning message.  CONFIG_XFS_DEBUG sets the default log level to 11,
because developers always want to know where an error came from ;)

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
