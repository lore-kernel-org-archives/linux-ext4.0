From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 01/13][e2fsprogs] Add initial checksum support.
Date: Sun, 14 Oct 2007 22:46:05 -0400
Message-ID: <20071015024605.GA21216@thunk.org>
References: <20071011191559.4599.69332.stgit@gara> <20071011191605.4599.34407.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49620 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbXJOCqf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Oct 2007 22:46:35 -0400
Content-Disposition: inline
In-Reply-To: <20071011191605.4599.34407.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In crc16.h, this patch assumes that linux/types.h defines uint16_t. =20

There are a couple of problems with this. =20

#1) linux/types.h is non-portable, not only does it not exist on
 non-Linux systems, apparently on Ubuntu it's not always defining
 uint16_t.  On my Ubuntu gutsy system, it doesn't always get defined.

        CC ../../../lib/ext2fs/crc16.c
In file included from ../../../lib/ext2fs/crc16.c:10:
=2E./../../lib/ext2fs/crc16.h:20: error: expected =E2=80=98=3D=E2=80=99=
, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=
=80=98__attribute__=E2=80=99 before =E2=80=98const=E2=80=99
=2E./../../lib/ext2fs/crc16.h:22: error: expected =E2=80=98=3D=E2=80=99=
, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=
=80=98__attribute__=E2=80=99 before =E2=80=98crc16=E2=80=99


The right thing to do is to use ext2fs/ext2_types.h like everything
else in e2fsprogs, and use __u16 instead of uint16_t.

     		       	   	 	    - Ted
