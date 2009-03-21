From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext2/3: document conditions when reliable operation is possible
Date: Sat, 21 Mar 2009 12:24:24 +0100
Message-ID: <20090321112424.GA6253@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <ef1cd66f0903120440q6e49b90dye92abfaa455055b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	tytso@mit.edu, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Jochen =?iso-8859-1?B?Vm/f?= <jochen.voss@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46247 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZCULVl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Mar 2009 07:21:41 -0400
Content-Disposition: inline
In-Reply-To: <ef1cd66f0903120440q6e49b90dye92abfaa455055b0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 2009-03-12 11:40:52, Jochen Vo=DF wrote:
> Hi,
>=20
> 2009/3/12 Pavel Machek <pavel@ucw.cz>:
> > diff --git a/Documentation/filesystems/ext2.txt b/Documentation/fil=
esystems/ext2.txt
> > index 4333e83..b09aa4c 100644
> > --- a/Documentation/filesystems/ext2.txt
> > +++ b/Documentation/filesystems/ext2.txt
> > @@ -338,27 +339,25 @@ enough 4-character names to make up unique di=
rectory entries, so they
> > =A0have to be 8 character filenames, even then we are fairly close =
to
> > =A0running out of unique filenames.
> >
> > +Requirements
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Ext3 expects disk/storage subsystem to behave sanely. On sanely
>    ^^^^
> Shouldn't this be "Ext2"?

Thanks, fixed.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
