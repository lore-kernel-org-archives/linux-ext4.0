From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 4 Aug 2012 18:41:39 -0400
Message-ID: <20120804224139.23096.qmail@science.horizon.com>
References: <20120804221217.GE4724@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:45250 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754071Ab2HDWll (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Aug 2012 18:41:41 -0400
In-Reply-To: <20120804221217.GE4724@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> commit 037b728b8a6a775e9a5e03fd24b1008d633c1cb4
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sat Aug 4 16:56:55 2012 -0400
>
>     Put ELF_OTHER_LIBS in the right place for the linker

Thanks for the update.  That produces (following your procedure from
the previous e-mail exactly, modulo directory names) a *different* error...

[...snippage...]
gcc -I. -I../../lib -I/tmp/e2fsprogs-1.43/lib -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wformat-security -D__NO_STRING_INLINES -c /tmp/e2fsprogs-1.43/lib/ss/get_readline.c
gcc -I. -I../../lib -I/tmp/e2fsprogs-1.43/lib -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wformat-security -D__NO_STRING_INLINES -DSHARED_ELF_LIB -fPIC -o elfshared/get_readline.o -c /tmp/e2fsprogs-1.43/lib/ss/get_readline.c
(if test -r libss.a; then /bin/rm -f libss.a.bak && /bin/mv libss.a libss.a.bak; fi)
ar rc libss.a ss_err.o std_rqs.o invocation.o help.o execute_cmd.o listen.o parse.o error.o prompt.o request_tbl.o list_rqs.o pager.o requests.o data.o get_readline.o
/bin/rm -f ../libss.a
(cd ..; /bin/ln  \
                `echo lib/ss | sed -e 's;lib/;;'`/libss.a libss.a)
(cd elfshared; gcc --shared -o libss.so.2.0 -L../../lib -Wl,-Bsymbolic-functions -Wl,-z,relro \
                -Wl,-soname,libss.so.2 ss_err.o std_rqs.o invocation.o help.o execute_cmd.o listen.o parse.o error.o prompt.o request_tbl.o list_rqs.o pager.o requests.o data.o get_readline.o -lcom_err -ldl)
/usr/bin/ld: cannot find -lcom_err
collect2: error: ld returned 1 exit status
make[3]: *** [libss.so.2.0] Error 1
make[3]: Leaving directory `/tmp/e2fsprogs-1.43/debian/BUILD-STD/lib/ss'
make[2]: *** [all-libs-recursive] Error 1
make[2]: Leaving directory `/tmp/e2fsprogs-1.43/debian/BUILD-STD'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/tmp/e2fsprogs-1.43/debian/BUILD-STD'
make: *** [debian/stampdir/build-std-stamp] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2


libcom_err certainly exists if you look in the right places:

/tmp/e2fsprogs-1.43$ find debian -name \*com_err\* 
debian/BUILD-STD/lib/libcom_err.so.2.1
debian/BUILD-STD/lib/libcom_err.so.2
debian/BUILD-STD/lib/libcom_err.a
debian/BUILD-STD/lib/et/libcom_err.so.2.1
debian/BUILD-STD/lib/et/elfshared/com_err.o
debian/BUILD-STD/lib/et/com_err.pc
debian/BUILD-STD/lib/et/com_err.o
debian/BUILD-STD/lib/et/libcom_err.a
debian/BUILD-STD/lib/libcom_err.so

The ld was running in debian/BUILD-STD/lib/ss/elfshared, so -L../../lib
is debian/BUILD-STD/lib/lib, which does exist.  Is that right?
