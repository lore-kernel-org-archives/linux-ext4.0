From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:libuuid
	(Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 23:56:57 +0200
Message-ID: <ac3eb2510907011456k6c3cd612he94c8c03450fb0df@mail.gmail.com>
References: <20090628133430.GA3594@mit.edu> <605694f0db343657e47df0d3e82e0bc9@quantum.linuxfromscratch.org>
	<20090701212844.GC17054@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Burgess <matthew-Ugr1wgFcK0zneqvOfBTmdWD2FQJk+8+b@public.gmane.org>,
	Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090701212844.GC17054-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 1, 2009 at 23:28, Theodore Tso<tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Wed, Jul 01, 2009 at 03:04:43PM -0600, Matthew Burgess wrote:
>> I get the following output when trying to compile e2fsprogs-1.41.7
>> against util-linux-ng-2.16-rc1's installed versions of libuuid &
>> libblkid
>
> Thanks for pointing that out. =C2=A0Apparently GNU make wasn't failin=
g when
> "-luuid" was in the dependency, which is why I didn't notice this
> earlier. =C2=A0I'm not sure why it complains with "-L/tools/lib", but=
 not
> with "-luuid", but whatever. =C2=A0I've checked the following into th=
e
> e2fsprogs maint branch.

I had a similar issue, caused by a wrong libdir in the util-linux's
*.pc files. They have libdir=3D/lib instead libdir=3D/usr/lib, and in s=
ome
setups the devel-symlink isn't found, which is usually in /usr.

Only the local build on one of my boxes failed, but editing the .pc
files solved the problem.

(The real location of the .so image does not matter, it's a detail
hidden and handled by the ld loader, and the .pc files should always
poit to the devel symlink to the .so.)

Kay
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng=
" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
