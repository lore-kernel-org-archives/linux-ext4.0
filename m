From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid
	(Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Thu, 2 Jul 2009 00:39:23 +0200
Message-ID: <ac3eb2510907011539k3e2fb664g59ec4dc6f1ae5e0a@mail.gmail.com>
References: <200905311113.23004.arvidjaar@mail.ru> <20090701214345.GG17054@mit.edu>
	<ac3eb2510907011452g3c2c2b3cs8d0ed398117879be@mail.gmail.com>
	<200907011835.08501.vapier@gentoo.org>
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
In-Reply-To: <200907011835.08501.vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 2, 2009 at 00:35, Mike Frysinger<vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:

>> In older udev releases, before we switched to automake, I had
>> something like this, which behaves a bit like the Linux kernel build=
,
>> and V=3D1 switches off the silent mode:
>
> why not just use automake-1.11's silent-rules option. =C2=A0then you =
dont have to
> waste time reinventing the wheel.

I do. :) But e2fsprogs don't use automake, only autoconf.

Kay
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng=
" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
