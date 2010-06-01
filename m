From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e4defrag and immutable files
Date: Tue, 01 Jun 2010 14:12:28 -0500
Message-ID: <4C055B9C.9010709@redhat.com>
References: <4C002427.3010706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756111Ab0FATMg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 15:12:36 -0400
In-Reply-To: <4C002427.3010706@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

H. Peter Anvin wrote:
> Hi all,
>=20
> I have looked a bit at e4defrag, and it does not appear to prevent th=
e
> relocation of files marked immutable.  This is a problem for boot
> loaders, which may need to have a block pointer to a specific file in
> order to bootstrap themselves.
>=20
> Would it be possible to either:
>=20
> a) prevent e4defrag and/or EXT4_IOC_MOVE_EXT from relocating an
> immutable file, or
> b) add a new attribute with the above property (in case there is
> legitimate need to move around immutable files)?

seems like the immutable flag isn't necessarily the right thing to
key on; at least it's an addition to what the manpage says immutable
means...

>        A file with the =E2=80=98i=E2=80=99 attribute cannot be modifi=
ed: it cannot
>        be  deleted or renamed, no link can be created to this file
>        and no data can be written to the file.  Only the superuser
>        or  a process possessing the CAP_LINUX_IMMUTABLE capability
>        can set or clear this attribute.

Changing the physical mapping doesn't do any of those things.

I think a new flag, no-move or something, may be better, if it's
needed.  But how many files would ever get this; maybe defragging
boot files falls into the category of "don't do that?" :)

-Eric

> 	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
