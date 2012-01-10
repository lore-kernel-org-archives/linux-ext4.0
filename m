From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH] libquota: Do not build libquota when disabled
Date: Tue, 10 Jan 2012 13:50:06 -0800
Message-ID: <CAGr1F2FDpTa=JZeseByRwshUj652M+U_vj+O52k_XEaJxaK+Nw@mail.gmail.com>
References: <1326213996-13759-1-git-send-email-jack@suse.cz> <20120110193814.GC4516@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab2AJVu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2012 16:50:28 -0500
Received: by pbdu13 with SMTP id u13so89262pbd.19
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2012 13:50:27 -0800 (PST)
In-Reply-To: <20120110193814.GC4516@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Libquota is supposed to be internal library of e2fsprogs. Initially I
added the code thinking that it would be an independent library, but
it depends too much on libext2fs and should be part of libext2fs
itself. The quota header files should not be installed.

Also, e2fsck should compile even without quota support. This needs to b=
e fixed.

Thanks,
Aditya

On Tue, Jan 10, 2012 at 11:38 AM, Jan Kara <jack@suse.cz> wrote:
> On Tue 10-01-12 17:46:36, Jan Kara wrote:
>> Due to missing QUOTA_CMT definition in configure.in, libquota was bu=
ilt
>> (and e.g. include file was installed) even when quota support was di=
sabled.
>> Fix it. Also fix help text of the configure option when we are at it=
=2E
> =C2=A0Hum, but after this e2fsck does not compile because of missing
> libquota.a. So should it be possible to disable quota support (and th=
us
> e2fsck should be fixed) or not (and then config option should be remo=
ved)?
>
> Also I've also noticed that libquota is generated as a static library=
 even
> if --enable-elf-shlibs is specified. Bug? Or is libquota supposed to =
be
> internal library of e2fsprogs and never used outside of e2fsprogs? Bu=
t then
> why is it and its header files installed?
>
> BTW, since the library is tied to ext4 anyway, won't it be more logic=
al for
> external developpers to make it part of libext2fs?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Honza
>>
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>> =C2=A0configure =C2=A0 =C2=A0| =C2=A0 11 ++++++-----
>> =C2=A0configure.in | =C2=A0 =C2=A04 +++-
>> =C2=A02 files changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 9f5eeb5..965f7cf 100755
>> --- a/configure
>> +++ b/configure
>> @@ -1462,7 +1462,7 @@ Optional Features:
>> =C2=A0 =C2=A0--disable-testio-debug =C2=A0disable the use of the tes=
t I/O manager for debugging
>> =C2=A0 =C2=A0--disable-libuuid =C2=A0 =C2=A0do not build private uui=
d library
>> =C2=A0 =C2=A0--disable-libblkid =C2=A0 do not build private blkid li=
brary
>> - =C2=A0--enable-libquota =C2=A0 =C2=A0enable quota support
>> + =C2=A0--enable-quota =C2=A0 =C2=A0 =C2=A0 enable quota support
>> =C2=A0 =C2=A0--disable-debugfs =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0disable support of debugfs program
>> =C2=A0 =C2=A0--disable-imager =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 disable support of e2image program
>> =C2=A0 =C2=A0--disable-resizer =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0disable support of e2resize program
>> @@ -5209,11 +5209,13 @@ fi
>> =C2=A0if test "${enable_quota+set}" =3D set; then :
>> =C2=A0 =C2=A0enableval=3D$enable_quota; if test "$enableval" =3D "no=
"
>> =C2=A0then
>> + =C2=A0 =C2=A0 QUOTA_CMT=3D"#"
>> =C2=A0 =C2=A0 =C2=A0 { $as_echo "$as_me:${as_lineno-$LINENO}: result=
: Disabling quota support" >&5
>> =C2=A0$as_echo "Disabling quota support" >&6; }
>> =C2=A0else
>> =C2=A0 =C2=A0 =C2=A0 $as_echo "#define CONFIG_QUOTA 1" >>confdefs.h
>>
>> + =C2=A0 =C2=A0 QUOTA_CMT=3D""
>> =C2=A0 =C2=A0 =C2=A0 { $as_echo "$as_me:${as_lineno-$LINENO}: result=
: Enabling quota support" >&5
>> =C2=A0$as_echo "Enabling quota support" >&6; }
>> =C2=A0fi
>> @@ -7127,7 +7129,6 @@ int
>> =C2=A0main ()
>> =C2=A0{
>> =C2=A0 =C2=A0char *data, *data2, *data3;
>> - =C2=A0const char *cdata2;
>> =C2=A0 =C2=A0int i, pagesize;
>> =C2=A0 =C2=A0int fd, fd2;
>>
>> @@ -7152,10 +7153,10 @@ main ()
>> =C2=A0 =C2=A0fd2 =3D open ("conftest.txt", O_RDWR | O_CREAT | O_TRUN=
C, 0600);
>> =C2=A0 =C2=A0if (fd2 < 0)
>> =C2=A0 =C2=A0 =C2=A0return 4;
>> - =C2=A0cdata2 =3D "";
>> - =C2=A0if (write (fd2, cdata2, 1) !=3D 1)
>> + =C2=A0data2 =3D "";
>> + =C2=A0if (write (fd2, data2, 1) !=3D 1)
>> =C2=A0 =C2=A0 =C2=A0return 5;
>> - =C2=A0data2 =3D (char *) mmap (0, pagesize, PROT_READ | PROT_WRITE=
, MAP_SHARED, fd2, 0L);
>> + =C2=A0data2 =3D mmap (0, pagesize, PROT_READ | PROT_WRITE, MAP_SHA=
RED, fd2, 0L);
>> =C2=A0 =C2=A0if (data2 =3D=3D MAP_FAILED)
>> =C2=A0 =C2=A0 =C2=A0return 6;
>> =C2=A0 =C2=A0for (i =3D 0; i < pagesize; ++i)
>> diff --git a/configure.in b/configure.in
>> index c304a8d..94e7c21 100644
>> --- a/configure.in
>> +++ b/configure.in
>> @@ -531,12 +531,14 @@ dnl
>> =C2=A0PKG_PROG_PKG_CONFIG
>> =C2=A0AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota suppo=
rt])
>> =C2=A0AC_ARG_ENABLE([quota],
>> -[ =C2=A0--enable-libquota =C2=A0 enable quota support],
>> +[ =C2=A0--enable-quota =C2=A0 =C2=A0 =C2=A0enable quota support],
>> =C2=A0if test "$enableval" =3D "no"
>> =C2=A0then
>> + =C2=A0 =C2=A0 QUOTA_CMT=3D"#"
>> =C2=A0 =C2=A0 =C2=A0 AC_MSG_RESULT([Disabling quota support])
>> =C2=A0else
>> =C2=A0 =C2=A0 =C2=A0 AC_DEFINE(CONFIG_QUOTA, 1)
>> + =C2=A0 =C2=A0 QUOTA_CMT=3D""
>> =C2=A0 =C2=A0 =C2=A0 AC_MSG_RESULT([Enabling quota support])
>> =C2=A0fi
>> =C2=A0,
>> --
>> 1.7.1
>>
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
