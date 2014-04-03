From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] fsx: Add fallocate collapse range operation
Date: Fri, 4 Apr 2014 08:26:37 +1100
Message-ID: <20140403212637.GP17603@dastard>
References: <1396452800-25775-1-git-send-email-lczerner@redhat.com>
 <alpine.LFD.2.00.1404021752340.2169@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44742 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752550AbaDCV0k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Apr 2014 17:26:40 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1404021752340.2169@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2014 at 05:55:07PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> On Wed, 2 Apr 2014, Lukas Czerner wrote:
>=20
> > Date: Wed,  2 Apr 2014 17:33:19 +0200
> > From: Lukas Czerner <lczerner@redhat.com>
> > To: xfs@oss.sgi.com
> > Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
> >     Lukas Czerner <lczerner@redhat.com>
> > Subject: [PATCH 1/2] fsx: Add fallocate collapse range operation
> >=20
> > This commit adds fallocate FALLOC_FL_COLLAPSE_RANGE support for fsx=
=2E
>=20
> Btw, this actually makes the fsx fail on ext4 and xfs after a while.
> I was trying to find a problem in fsx itself but I think it is
> actually ok. That means that we could possibly have bugs in ext4 and
> xfs collapse range implementation. More eyes are needed on this!

No surprise, really. As it is, your previous ZERO_RANGE additions
caused problems for XFS, and those are mostly fixed in the 6 patch
series I sent before LSFMM.  Hence I wouldn't be surprised if that's
what you are seeing (on XFs, at least) and it's not actually
COLLAPSE_RANGE that is causing problems...

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
