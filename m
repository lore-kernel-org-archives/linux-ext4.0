From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Thu, 24 Feb 2011 10:34:32 -0600
Message-ID: <4D668898.3020303@redhat.com>
References: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com> <4D6538C6.4090004@redhat.com> <20110224000455.GN3166@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab1BXQen (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 11:34:43 -0500
In-Reply-To: <20110224000455.GN3166@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/23/2011 06:04 PM, Dave Chinner wrote:
> This sound sort of problem indicate=D1=95 to me that we need a generi=
c
> fiemap test in xfstests that exercises all these corner cases.
> Perhaps something similar to the way I tested all the
> XFS_IOC_ZERO_RANGE corner cases in test 242 by setting up all the
> different hole/delalloc/unwritten/allocated combinations using
> xfs_io and used the fiemap output as the golden output?
>=20
> That would catch all of these problems in the different filesystems
> that implement fiemap and make sure we notice regressions pretty
> quickly.....
>=20
> Cheers,
>=20
> Dave.

Or, remove the "sync" calls from josef's fiemap tester:

        fiemap->fm_flags =3D FIEMAP_FLAG_SYNC;

More random but would quickly blow up I bet.

-Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
