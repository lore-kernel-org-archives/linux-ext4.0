From: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Subject: RE: libext2fs: don't flush to device opened in read-only mode
Date: Thu, 25 May 2017 05:50:18 +0000
Message-ID: <118AAB5F26BFB34DB5CDA7DA33334DB9B6065F@vmsk-exch-01.paragon-software.com>
References: <118AAB5F26BFB34DB5CDA7DA33334DB9B5FF41@vmsk-exch-01.paragon-software.com>
 <20170524215622.fh7yin4fttggw36f@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relaymsk-01.paragon-software.com ([91.226.210.14]:34802 "EHLO
        relaymsk-01.paragon-software.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754312AbdEYFuV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 25 May 2017 01:50:21 -0400
In-Reply-To: <20170524215622.fh7yin4fttggw36f@thunk.org>
Content-Language: ru-RU
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for suggestion how to fix the bug correctly. Platform for reproducin=
g: CYGWin build (x86, x64, cygwin1.dll v.2.8.0), Windows 8.1 x64 and Window=
s  10 x64 (x86 not tested).

-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu]=20
Sent: Thursday, May 25, 2017 12:56 AM
To: Konstantin Chistyakov <Konstantin.Chistyakov@paragon-software.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: libext2fs: don't flush to device opened in read-only mode

On Mon, May 22, 2017 at 09:48:00AM +0000, Konstantin Chistyakov wrote:
> From: Konstantin Chistyakov=20
> <Konstantin.Chistyakov@Paragon-software.com>
> Date: Tue, 19 May 2017 09:23:29 -0600
> Subject: [PATCH] libext2fs: don't flush to device opened in read-only=20
> mode
>=20
> From: Konstantin Chistyakov=20
> <Konstantin.Chistyakov@Paragon-software.com>
>=20
> If the e2fsck is called with both -f -n options, the checking completing =
with a flushing error (retcode 8).
>=20
> Catch error from the unix_flush() fsync(data->dev) when data->dev is open=
ed in read-only mode:

I can't reproduce this problem.  What storage device or operating system ar=
e you using?

That being said, this is probably the wrong place to fix it.  The better fi=
x is in e2fsck/unix.c, by adding a read-only test.

       	      	 		   	  - Ted
