From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Thu, 2 Jan 2014 19:47:10 -0500
Message-ID: <20140103004710.GA31411@thunk.org>
References: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45510 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaACArQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jan 2014 19:47:16 -0500
Content-Disposition: inline
In-Reply-To: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 02, 2014 at 08:43:54AM +0200, Baruch Siach wrote:
> Use posix_fadvise64() when available. This allows 64bit offsets on 32=
bit
> systems.
>=20
> Rename the internal posix_fadvise() implementation to avoid collision=
 with the
> C library signature that is sometimes present event when the implemen=
tation
> itself is not. This fixes build errors like:
>=20
> e4defrag.c:189:2: warning: #warning Using locally defined posix_fadvi=
se interface. [-Wcpp
> e4defrag.c:203:12: error: conflicting types for =E2=80=98posix_fadvis=
e=E2=80=99
>=20
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Thanks, applied.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
