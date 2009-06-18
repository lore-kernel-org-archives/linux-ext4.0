From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid
	(Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Thu, 18 Jun 2009 02:27:36 +0200
Message-ID: <ac3eb2510906171727t42f1430j8fac5a12e774742c@mail.gmail.com>
References: <200905311113.23004.arvidjaar@mail.ru> <20090601124857.GF31943@mit.edu>
	<20090603085140.GA4060@nb.net.home> <1244021945.4120.4.camel@quest>
	<1245159374.4225.7.camel@quest>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Scott James Remnant <scott-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1245159374.4225.7.camel@quest>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hey Ted,
it would be great, if you could add that, and put it into a release.
The current packaging is a dependency hell, and it would be much
easier if util-linux-ng can just provide all the needed stuff for
libblkid, instead of the circular dependencies we have to work around
now.

Thanks,
Kay

On Tue, Jun 16, 2009 at 15:36, Scott James Remnant<scott-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>=
 wrote:
> Hi Ted, any good?
>
> On Wed, 2009-06-03 at 10:39 +0100, Scott James Remnant wrote:
>> On Wed, 2009-06-03 at 10:51 +0200, Karel Zak wrote:
>>
>> > On Mon, Jun 01, 2009 at 08:48:57AM -0400, Theodore Tso wrote:
>> > > It is supposed to be safe to replace the built-in libblkid in
>> > > e2fsprogs with the one in util-linux-ng. =C2=A0There may be bugs=
, but if
>> > > there are report them, and we'll work to get them fixed. =C2=A0I=
'll try to
>> > > keep the bug fixes in e2fsprogs and util-linux-ng roughly synchr=
onized
>> > > for at least a while, since it takes a while for distributions t=
o make
>> > > the switch. =C2=A0So a brusque, "drop libblkid, who cares if we =
screw over
>> > > distro's that haven't yet moved to util-linux-ng" is not in the =
cards,
>> > > no. =C2=A0In terms of formal plan, probably in a year or so. =C2=
=A0I'm believer
>> > > in long compatibility windows.
>> >
>> > =C2=A0Yes, this is our plan.
>> >
>> > =C2=A0This reminds me...
>> >
>> > =C2=A0The next step is to move libuuid from e2fsprogs to util-linu=
x-ng.
>> > =C2=A0Currently, this library is widely used by many packages (Fed=
ora-11):
>> >
>> > =C2=A0 =C2=A0$ repoquery --qf=3D"%{NAME}" --whatrequires libuuid* =
| sort -u | wc -l
>> > =C2=A0 =C2=A074
>> >
>> > =C2=A0The util-linux-ng code is already prepared for this change a=
nd the
>> > =C2=A0library has been merged into git tree.
>> >
>> > =C2=A0It would be nice to add the --disable-uuid option to e2fspro=
gs. If I
>> > =C2=A0good remember Scott has a patch for this change. Scott?
>> >
>> Right ;)
>>
>> attached
>>
>> Scott
> --
> Scott James Remnant
> scott-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org
>
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng=
" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
