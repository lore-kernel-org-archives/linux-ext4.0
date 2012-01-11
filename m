From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] libquota: Do not build libquota when disabled
Date: Wed, 11 Jan 2012 10:58:12 -0800
Message-ID: <CAGr1F2E98=CDrLR5Qb5X8_qYOSHZ-YTKg890BP26dkRZnow9nQ@mail.gmail.com>
References: <1326213996-13759-1-git-send-email-jack@suse.cz>
 <20120110193814.GC4516@quack.suse.cz> <CAGr1F2FDpTa=JZeseByRwshUj652M+U_vj+O52k_XEaJxaK+Nw@mail.gmail.com>
 <20120111001305.GB16395@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57043 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab2AKS6f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jan 2012 13:58:35 -0500
Received: by pbdu13 with SMTP id u13so657674pbd.19
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jan 2012 10:58:35 -0800 (PST)
In-Reply-To: <20120111001305.GB16395@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2012 at 4:13 PM, Jan Kara <jack@suse.cz> wrote:
> On Tue 10-01-12 13:50:06, Aditya Kali wrote:
>> Libquota is supposed to be internal library of e2fsprogs. Initially =
I
>> added the code thinking that it would be an independent library, but
>> it depends too much on libext2fs and should be part of libext2fs
>> itself. The quota header files should not be installed.
> =C2=A0Thanks for clarification! Do you plan to work on fixing this or=
 should I
> have a look at it?
>
I have planned to work on fixing this. But I wasn't able to give time
for quota stuff recently. I will try to look at this asap.

>> Also, e2fsck should compile even without quota support. This needs t=
o be
>> fixed.
> =C2=A0Hum, but why would anyone want to compile e2fsprogs without quo=
ta
> support? We also don't provide a way to switch off for example indexe=
d
> directories support. So why would be quota different?
>
The quota support isn't fully baked-in yet. There are still some
e2fsck changes needed (currently, we simply recreate quota files after
e2fsck and do not check if the previous quota information was correct
or not). Also, the kernel side changes are not yet accepted. Since
this code has not been tested much, it would be better for people to
have an option to exclude it out. That was the reasoning behind adding
that option. Eventually we might want to remove it though.

Thanks,
--
Aditya

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>
>> On Tue, Jan 10, 2012 at 11:38 AM, Jan Kara <jack@suse.cz> wrote:
>> > On Tue 10-01-12 17:46:36, Jan Kara wrote:
>> >> Due to missing QUOTA_CMT definition in configure.in, libquota was=
 built
>> >> (and e.g. include file was installed) even when quota support was=
 disabled.
>> >> Fix it. Also fix help text of the configure option when we are at=
 it.
>> > =C2=A0Hum, but after this e2fsck does not compile because of missi=
ng
>> > libquota.a. So should it be possible to disable quota support (and=
 thus
>> > e2fsck should be fixed) or not (and then config option should be r=
emoved)?
>> >
>> > Also I've also noticed that libquota is generated as a static libr=
ary even
>> > if --enable-elf-shlibs is specified. Bug? Or is libquota supposed =
to be
>> > internal library of e2fsprogs and never used outside of e2fsprogs?=
 But then
>> > why is it and its header files installed?
>> >
>> > BTW, since the library is tied to ext4 anyway, won't it be more lo=
gical for
>> > external developpers to make it part of libext2fs?
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0Honza
>> >>
>> >> Signed-off-by: Jan Kara <jack@suse.cz>
>> >> ---
>> >> =C2=A0configure =C2=A0 =C2=A0| =C2=A0 11 ++++++-----
>> >> =C2=A0configure.in | =C2=A0 =C2=A04 +++-
>> >> =C2=A02 files changed, 9 insertions(+), 6 deletions(-)
>> >>
>> >> diff --git a/configure b/configure
>> >> index 9f5eeb5..965f7cf 100755
>> >> --- a/configure
>> >> +++ b/configure
>> >> @@ -1462,7 +1462,7 @@ Optional Features:
>> >> =C2=A0 =C2=A0--disable-testio-debug =C2=A0disable the use of the =
test I/O manager for debugging
>> >> =C2=A0 =C2=A0--disable-libuuid =C2=A0 =C2=A0do not build private =
uuid library
>> >> =C2=A0 =C2=A0--disable-libblkid =C2=A0 do not build private blkid=
 library
>> >> - =C2=A0--enable-libquota =C2=A0 =C2=A0enable quota support
>> >> + =C2=A0--enable-quota =C2=A0 =C2=A0 =C2=A0 enable quota support
>> >> =C2=A0 =C2=A0--disable-debugfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0disable support of debugfs program
>> >> =C2=A0 =C2=A0--disable-imager =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 disable support of e2image program
>> >> =C2=A0 =C2=A0--disable-resizer =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0disable support of e2resize program
>> >> @@ -5209,11 +5209,13 @@ fi
>> >> =C2=A0if test "${enable_quota+set}" =3D set; then :
>> >> =C2=A0 =C2=A0enableval=3D$enable_quota; if test "$enableval" =3D =
"no"
>> >> =C2=A0then
>> >> + =C2=A0 =C2=A0 QUOTA_CMT=3D"#"
>> >> =C2=A0 =C2=A0 =C2=A0 { $as_echo "$as_me:${as_lineno-$LINENO}: res=
ult: Disabling quota support" >&5
>> >> =C2=A0$as_echo "Disabling quota support" >&6; }
>> >> =C2=A0else
>> >> =C2=A0 =C2=A0 =C2=A0 $as_echo "#define CONFIG_QUOTA 1" >>confdefs=
=2Eh
>> >>
>> >> + =C2=A0 =C2=A0 QUOTA_CMT=3D""
>> >> =C2=A0 =C2=A0 =C2=A0 { $as_echo "$as_me:${as_lineno-$LINENO}: res=
ult: Enabling quota support" >&5
>> >> =C2=A0$as_echo "Enabling quota support" >&6; }
>> >> =C2=A0fi
>> >> @@ -7127,7 +7129,6 @@ int
>> >> =C2=A0main ()
>> >> =C2=A0{
>> >> =C2=A0 =C2=A0char *data, *data2, *data3;
>> >> - =C2=A0const char *cdata2;
>> >> =C2=A0 =C2=A0int i, pagesize;
>> >> =C2=A0 =C2=A0int fd, fd2;
>> >>
>> >> @@ -7152,10 +7153,10 @@ main ()
>> >> =C2=A0 =C2=A0fd2 =3D open ("conftest.txt", O_RDWR | O_CREAT | O_T=
RUNC, 0600);
>> >> =C2=A0 =C2=A0if (fd2 < 0)
>> >> =C2=A0 =C2=A0 =C2=A0return 4;
>> >> - =C2=A0cdata2 =3D "";
>> >> - =C2=A0if (write (fd2, cdata2, 1) !=3D 1)
>> >> + =C2=A0data2 =3D "";
>> >> + =C2=A0if (write (fd2, data2, 1) !=3D 1)
>> >> =C2=A0 =C2=A0 =C2=A0return 5;
>> >> - =C2=A0data2 =3D (char *) mmap (0, pagesize, PROT_READ | PROT_WR=
ITE, MAP_SHARED, fd2, 0L);
>> >> + =C2=A0data2 =3D mmap (0, pagesize, PROT_READ | PROT_WRITE, MAP_=
SHARED, fd2, 0L);
>> >> =C2=A0 =C2=A0if (data2 =3D=3D MAP_FAILED)
>> >> =C2=A0 =C2=A0 =C2=A0return 6;
>> >> =C2=A0 =C2=A0for (i =3D 0; i < pagesize; ++i)
>> >> diff --git a/configure.in b/configure.in
>> >> index c304a8d..94e7c21 100644
>> >> --- a/configure.in
>> >> +++ b/configure.in
>> >> @@ -531,12 +531,14 @@ dnl
>> >> =C2=A0PKG_PROG_PKG_CONFIG
>> >> =C2=A0AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota su=
pport])
>> >> =C2=A0AC_ARG_ENABLE([quota],
>> >> -[ =C2=A0--enable-libquota =C2=A0 enable quota support],
>> >> +[ =C2=A0--enable-quota =C2=A0 =C2=A0 =C2=A0enable quota support]=
,
>> >> =C2=A0if test "$enableval" =3D "no"
>> >> =C2=A0then
>> >> + =C2=A0 =C2=A0 QUOTA_CMT=3D"#"
>> >> =C2=A0 =C2=A0 =C2=A0 AC_MSG_RESULT([Disabling quota support])
>> >> =C2=A0else
>> >> =C2=A0 =C2=A0 =C2=A0 AC_DEFINE(CONFIG_QUOTA, 1)
>> >> + =C2=A0 =C2=A0 QUOTA_CMT=3D""
>> >> =C2=A0 =C2=A0 =C2=A0 AC_MSG_RESULT([Enabling quota support])
>> >> =C2=A0fi
>> >> =C2=A0,
>> >> --
>> >> 1.7.1
>> >>
>> > --
>> > Jan Kara <jack@suse.cz>
>> > SUSE Labs, CR
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
