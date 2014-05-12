From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Do not destroy ext4_groupinfo_caches if
 ext4_mb_init() fails
Date: Mon, 12 May 2014 12:49:56 -0400
Message-ID: <20140512164956.GA4150@thunk.org>
References: <1399883039-2978-1-git-send-email-tsyvarev@ispras.ru>
 <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35038 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaELQuC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 12:50:02 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405121707120.8008@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 12, 2014 at 05:08:41PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> >=20
> > Caches from 'ext4_groupinfo_caches' may be in use by other mounts, =
which have already existed.
> > So, it is incorrect to destroy them when newly requested mount fail=
s.
> >=20
> > Found by Linux File System Verification project (linuxtesting.org).
>=20
> Makes sense, thanks! Can you please share the test case which
> triggered this ? It might be worth including in xfstests.
>=20
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

				- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
