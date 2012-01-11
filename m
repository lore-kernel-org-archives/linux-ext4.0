From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] libquota: Do not build libquota when disabled
Date: Wed, 11 Jan 2012 01:13:05 +0100
Message-ID: <20120111001305.GB16395@quack.suse.cz>
References: <1326213996-13759-1-git-send-email-jack@suse.cz>
 <20120110193814.GC4516@quack.suse.cz>
 <CAGr1F2FDpTa=JZeseByRwshUj652M+U_vj+O52k_XEaJxaK+Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab2AKANH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 19:13:07 -0500
Content-Disposition: inline
In-Reply-To: <CAGr1F2FDpTa=JZeseByRwshUj652M+U_vj+O52k_XEaJxaK+Nw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 10-01-12 13:50:06, Aditya Kali wrote:
> Libquota is supposed to be internal library of e2fsprogs. Initially I
> added the code thinking that it would be an independent library, but
> it depends too much on libext2fs and should be part of libext2fs
> itself. The quota header files should not be installed.
  Thanks for clarification! Do you plan to work on fixing this or shoul=
d I
have a look at it?

> Also, e2fsck should compile even without quota support. This needs to=
 be
> fixed.
  Hum, but why would anyone want to compile e2fsprogs without quota
support? We also don't provide a way to switch off for example indexed
directories support. So why would be quota different?

								Honza

> On Tue, Jan 10, 2012 at 11:38 AM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 10-01-12 17:46:36, Jan Kara wrote:
> >> Due to missing QUOTA_CMT definition in configure.in, libquota was =
built
> >> (and e.g. include file was installed) even when quota support was =
disabled.
> >> Fix it. Also fix help text of the configure option when we are at =
it.
> > =A0Hum, but after this e2fsck does not compile because of missing
> > libquota.a. So should it be possible to disable quota support (and =
thus
> > e2fsck should be fixed) or not (and then config option should be re=
moved)?
> >
> > Also I've also noticed that libquota is generated as a static libra=
ry even
> > if --enable-elf-shlibs is specified. Bug? Or is libquota supposed t=
o be
> > internal library of e2fsprogs and never used outside of e2fsprogs? =
But then
> > why is it and its header files installed?
> >
> > BTW, since the library is tied to ext4 anyway, won't it be more log=
ical for
> > external developpers to make it part of libext2fs?
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> >>
> >> Signed-off-by: Jan Kara <jack@suse.cz>
> >> ---
> >> =A0configure =A0 =A0| =A0 11 ++++++-----
> >> =A0configure.in | =A0 =A04 +++-
> >> =A02 files changed, 9 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/configure b/configure
> >> index 9f5eeb5..965f7cf 100755
> >> --- a/configure
> >> +++ b/configure
> >> @@ -1462,7 +1462,7 @@ Optional Features:
> >> =A0 =A0--disable-testio-debug =A0disable the use of the test I/O m=
anager for debugging
> >> =A0 =A0--disable-libuuid =A0 =A0do not build private uuid library
> >> =A0 =A0--disable-libblkid =A0 do not build private blkid library
> >> - =A0--enable-libquota =A0 =A0enable quota support
> >> + =A0--enable-quota =A0 =A0 =A0 enable quota support
> >> =A0 =A0--disable-debugfs =A0 =A0 =A0 =A0 =A0 =A0disable support of=
 debugfs program
> >> =A0 =A0--disable-imager =A0 =A0 =A0 =A0 =A0 =A0 disable support of=
 e2image program
> >> =A0 =A0--disable-resizer =A0 =A0 =A0 =A0 =A0 =A0disable support of=
 e2resize program
> >> @@ -5209,11 +5209,13 @@ fi
> >> =A0if test "${enable_quota+set}" =3D set; then :
> >> =A0 =A0enableval=3D$enable_quota; if test "$enableval" =3D "no"
> >> =A0then
> >> + =A0 =A0 QUOTA_CMT=3D"#"
> >> =A0 =A0 =A0 { $as_echo "$as_me:${as_lineno-$LINENO}: result: Disab=
ling quota support" >&5
> >> =A0$as_echo "Disabling quota support" >&6; }
> >> =A0else
> >> =A0 =A0 =A0 $as_echo "#define CONFIG_QUOTA 1" >>confdefs.h
> >>
> >> + =A0 =A0 QUOTA_CMT=3D""
> >> =A0 =A0 =A0 { $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabl=
ing quota support" >&5
> >> =A0$as_echo "Enabling quota support" >&6; }
> >> =A0fi
> >> @@ -7127,7 +7129,6 @@ int
> >> =A0main ()
> >> =A0{
> >> =A0 =A0char *data, *data2, *data3;
> >> - =A0const char *cdata2;
> >> =A0 =A0int i, pagesize;
> >> =A0 =A0int fd, fd2;
> >>
> >> @@ -7152,10 +7153,10 @@ main ()
> >> =A0 =A0fd2 =3D open ("conftest.txt", O_RDWR | O_CREAT | O_TRUNC, 0=
600);
> >> =A0 =A0if (fd2 < 0)
> >> =A0 =A0 =A0return 4;
> >> - =A0cdata2 =3D "";
> >> - =A0if (write (fd2, cdata2, 1) !=3D 1)
> >> + =A0data2 =3D "";
> >> + =A0if (write (fd2, data2, 1) !=3D 1)
> >> =A0 =A0 =A0return 5;
> >> - =A0data2 =3D (char *) mmap (0, pagesize, PROT_READ | PROT_WRITE,=
 MAP_SHARED, fd2, 0L);
> >> + =A0data2 =3D mmap (0, pagesize, PROT_READ | PROT_WRITE, MAP_SHAR=
ED, fd2, 0L);
> >> =A0 =A0if (data2 =3D=3D MAP_FAILED)
> >> =A0 =A0 =A0return 6;
> >> =A0 =A0for (i =3D 0; i < pagesize; ++i)
> >> diff --git a/configure.in b/configure.in
> >> index c304a8d..94e7c21 100644
> >> --- a/configure.in
> >> +++ b/configure.in
> >> @@ -531,12 +531,14 @@ dnl
> >> =A0PKG_PROG_PKG_CONFIG
> >> =A0AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota suppor=
t])
> >> =A0AC_ARG_ENABLE([quota],
> >> -[ =A0--enable-libquota =A0 enable quota support],
> >> +[ =A0--enable-quota =A0 =A0 =A0enable quota support],
> >> =A0if test "$enableval" =3D "no"
> >> =A0then
> >> + =A0 =A0 QUOTA_CMT=3D"#"
> >> =A0 =A0 =A0 AC_MSG_RESULT([Disabling quota support])
> >> =A0else
> >> =A0 =A0 =A0 AC_DEFINE(CONFIG_QUOTA, 1)
> >> + =A0 =A0 QUOTA_CMT=3D""
> >> =A0 =A0 =A0 AC_MSG_RESULT([Enabling quota support])
> >> =A0fi
> >> =A0,
> >> --
> >> 1.7.1
> >>
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
