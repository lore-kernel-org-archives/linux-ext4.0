From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid
	(Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Thu, 2 Jul 2009 14:49:24 +0200
Message-ID: <ac3eb2510907020549g138c5dd2y3caa8eeba782c3ac@mail.gmail.com>
References: <200905311113.23004.arvidjaar@mail.ru> <200907011835.08501.vapier@gentoo.org>
	<20090702005858.GH17054@mit.edu> <200907012115.57826.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200907012115.57826.vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 2, 2009 at 03:15, Mike Frysinger<vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
> On Wednesday 01 July 2009 20:58:58 Theodore Tso wrote:
>> On Wed, Jul 01, 2009 at 06:35:06PM -0400, Mike Frysinger wrote:
>> > > In older udev releases, before we switched to automake, I had
>> > > something like this, which behaves a bit like the Linux kernel b=
uild,
>> > > and V=3D1 switches off the silent mode:
>> >
>> > why not just use automake-1.11's silent-rules option. =C2=A0then y=
ou dont have
>> > to waste time reinventing the wheel.
>>
>> Because I consider automake the spawn of Satan? =C2=A0:-)

Yeah, it is. It's strange what these tools produce. But it sees it's
slowly getting better over time not worse - so there is hope. Even the
recent libtool looks ok now. And I don't really miss the check for
=46ORTRAN, which seems to have disappeared here recently. :)

> i'll have you know Satan's wheel is awfully shiny ...

Heh, yeah. If you do not check-in the created stuff into git, and use:
  git clean -d -X -f
  autoreconf --install --symlink
to bootstrap a repo, stuff looks pretty good, I think. You just need
to be able to convince yourself not to look into the generated files.
:)

On the other hand the silent rules and "make distcheck" and all these
things which come along with automake are just great to have.

> Kay's rules look like they should be fairly straightforward to drop i=
nto
> e2fsprogs. =C2=A0personally i'd use:
> E =3D @:
> when V=3D1, but this is probably just splitting hairs

Ah nice, looks good to me, if that works.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng=
" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
