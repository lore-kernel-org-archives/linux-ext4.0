From: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid
	(Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Wed, 1 Jul 2009 23:52:11 +0200
Message-ID: <ac3eb2510907011452g3c2c2b3cs8d0ed398117879be@mail.gmail.com>
References: <200905311113.23004.arvidjaar@mail.ru> <20090601124857.GF31943@mit.edu>
	<20090603085140.GA4060@nb.net.home> <1244021945.4120.4.camel@quest>
	<20090628133430.GA3594@mit.edu> <ac3eb2510906300317q3997f283p80248e44b0c5133d@mail.gmail.com>
	<20090701214345.GG17054@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>,
	Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090701214345.GG17054-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 1, 2009 at 23:43, Theodore Tso<tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Tue, Jun 30, 2009 at 12:17:02PM +0200, Kay Sievers wrote:
>>
>> And another thing is your custom "silent build" which can not be
>> disabled. Our build system requires the command output for fancy
>> analysis, so it would be good if it could be disabled, like it can f=
or
>> the kernel (V=3D1). Any ideas, or do I miss some switch?
>
> Is a configure-level switch all that you need? =C2=A0I hadn't done a
> make-level switch because I was trying to avoid adding a requirement
> of using GNU make in building e2fsprogs, since it gets used by *BSD
> and Solaris systems as well. =C2=A0(And in fact some of the recent UU=
ID bug
> fixes come from FreeBSD bug reports, and I suspect FreeBSD will
> continue to use UUID library from e2fsprogs rather than pulling in
> util-linux-ng....)

Anything would work, that resolves the '@' to nothing and puts out the
command, an environment var or a switch.

In older udev releases, before we switched to automake, I had
something like this, which behaves a bit like the Linux kernel build,
and V=3D1 switches off the silent mode:

  V =3D
  ifeq ($(strip $(V)),)
    E =3D @echo
    Q =3D @
  else
    E =3D @\#
    Q =3D
  endif
  export E Q

 ...

  $(E) "  CC      " $@
  $(Q) $(CC) -c $(CFLAGS) $< -o $@

  ...

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng=
" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
