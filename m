From: tytso@mit.edu
Subject: Re: No space left on device after many files creation
Date: Mon, 12 Apr 2010 18:44:29 -0400
Message-ID: <20100412224429.GN1849@thunk.org>
References: <4BC38EB9.8080501@gmail.com>
 <4BC39098.4030704@redhat.com>
 <4BC39762.9080406@gmail.com>
 <4BC39805.7090807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cy6erGn0m <cy6ergn0m@gmail.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33884 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab0DLX4p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 19:56:45 -0400
Content-Disposition: inline
In-Reply-To: <4BC39805.7090807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 12, 2010 at 05:00:37PM -0500, Eric Sandeen wrote:
> cy6erGn0m wrote:
> > In the past I have done the same test for ext3 and it was created ~=
10M
> > files in one firectory at working filesystem (/home) and it was no
> > issues reached.
> >=20
> > On ext4 i found inodes max size is limited as you wrote:
> > [root@cgmachine sandbox]# df -i /e4
> > =D0=A4=D0=B0=D0=B9=D0=BB=D0=BE=D0=B2=D0=B0=D1=8F =D1=81=D0=B8=D1=81=
=D1=82=D0=B5=D0=BC=D0=B0      =D0=98=D0=BD=D0=BE=D0=B4=D0=BE=D0=B2   =D0=
=98=D1=81=D0=BF=D0=BE=D0=BB   =D0=A1=D0=B2=D0=BE=D0=B1  =D0=98=D1=81=D0=
=BF % =D1=81=D0=BC=D0=BE=D0=BD=D1=82=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=BD=
=D0=B0 =D0=BD=D0=B0
> > (file system/inodes/used/free/used%/mounted on)
> > /dev/sda4               1,8M    1,8M       0  100% /e4
> > [root@cgmachine sandbox]#
> >=20
> > Why inodes count limit is so small by default? Is it depends on
> > partition size?
>=20
> it does depend on partition size; the inode_ratio =3D 16384 in mke2fs=
=2Econf
> says 1 inode per 16k of filesystem space.

1.8 million inodes is hardly small.....  most people complain that
we're reserving too much space for inodes. =20

Cy6erGn0m, What is your use case where the average file size for your
20G partition is smaller that 16k?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
