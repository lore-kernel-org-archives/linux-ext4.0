From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 01/13][e2fsprogs] Add initial checksum support.
Date: Mon, 15 Oct 2007 04:43:06 -0500
Message-ID: <20071015044306.41a6448e@gara>
References: <20071011191559.4599.69332.stgit@gara>
	<20071011191605.4599.34407.stgit@gara>
	<20071015024605.GA21216@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58589 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758047AbXJOJnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 05:43:31 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9F9hIDc008672
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 05:43:18 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9F9hIGP112158
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 05:43:18 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9F9h8Tc015700
	for <linux-ext4@vger.kernel.org>; Mon, 15 Oct 2007 05:43:08 -0400
In-Reply-To: <20071015024605.GA21216@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 14 Oct 2007 22:46:05 -0400
Theodore Tso <tytso@mit.edu> wrote:

> In crc16.h, this patch assumes that linux/types.h defines uint16_t. =20
>=20
> There are a couple of problems with this. =20
>=20
> #1) linux/types.h is non-portable, not only does it not exist on
>  non-Linux systems, apparently on Ubuntu it's not always defining
>  uint16_t.  On my Ubuntu gutsy system, it doesn't always get defined.
>=20
>         CC ../../../lib/ext2fs/crc16.c
> In file included from ../../../lib/ext2fs/crc16.c:10:
> ../../../lib/ext2fs/crc16.h:20: error: expected =E2=80=98=3D=E2=80=99=
, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=
=80=98__attribute__=E2=80=99 before =E2=80=98const=E2=80=99
> ../../../lib/ext2fs/crc16.h:22: error: expected =E2=80=98=3D=E2=80=99=
, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=
=80=98__attribute__=E2=80=99 before =E2=80=98crc16=E2=80=99
>=20
>=20
> The right thing to do is to use ext2fs/ext2_types.h like everything
> else in e2fsprogs, and use __u16 instead of uint16_t.
>=20
>      		       	   	 	    - Ted

Yes, I notice the use of linux/types.h as well.  I already have this
fixed on my patch queue and Im in the process of cleaning some of the
other patches as well.

-JRS
