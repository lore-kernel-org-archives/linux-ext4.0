From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 6 Aug 2012 18:59:37 -0400
Message-ID: <20120806225937.17241.qmail@science.horizon.com>
References: <20120806221207.GA30677@thunk.org>
Cc: linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:53639 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756373Ab2HFW7j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Aug 2012 18:59:39 -0400
In-Reply-To: <20120806221207.GA30677@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Obvious stupid question --- you don't have a 32-bit krb5 package or
> something else which depewnds on libcomerr2:i386?

Yes, exactly.  Just deleting the damn thing was the first thing I
thought of.  The dependency chain is long and annoying and ends in
something that's not 64-bit safe and so depends on ia32-libs.

That's a catch-all package; I don't know if the dependency is real
or not.  I worked around it in the simple stupid way by editing
/var/lig/dpkg/status and telling it that the installed verion is
1.43~WIP-2012-08-02-1; it's not like there's a meaningful difference.

> I'm using Debain testing and haven't noted any issues like this...

It's the Ubuntu machine.  Not your problem!

If you care, it ends up dying with the following, but I don't expect or need
your help.

i686-linux-gnu-gcc -c -I. -I../lib -I/tmp/e2fsprogs/lib -D_FORTIFY_SOURCE=2 -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Wformat-security -D__NO_STRING_INLINES /root/e2fsprogs/e2fsck/sigcatcher.c -o sigcatcher.o
i686-linux-gnu-gcc -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-rpath-link,../lib -rdynamic -o e2fsck dict.o unix.o e2fsck.o super.o pass1.o pass1b.o pass2.o pass3.o pass4.o pass5.o journal.o badblocks.o util.o dirinfo.o dx_dirinfo.o ehandler.o problem.o message.o quota.o recovery.o region.o revoke.o ea_refcount.o rehash.o profile.o prof_err.o logfile.o sigcatcher.o  ../lib/libquota.a ../lib/libext2fs.so ../lib/libcom_err.so     ../lib/libe2p.so 
unix.o: In function `PRS':
/tmp/e2fsprogs/e2fsck/unix.c:765: undefined reference to `blkid_get_cache'
/tmp/e2fsprogs/e2fsck/unix.c:857: undefined reference to `blkid_get_devname'
/tmp/e2fsprogs/e2fsck/unix.c:931: undefined reference to `blkid_get_devname'
e2fsck.o: In function `e2fsck_free_context':
/tmp/e2fsprogs/e2fsck/e2fsck.c:179: undefined reference to `blkid_put_cache'
super.o: In function `check_super_block':
/tmp/e2fsprogs/e2fsck/super.c:728: undefined reference to `uuid_is_null'
/tmp/e2fsprogs/e2fsck/super.c:730: undefined reference to `uuid_generate'
journal.o: In function `e2fsck_journal_load':
/tmp/e2fsprogs/e2fsck/journal.c:581: undefined reference to `uuid_is_null'
journal.o: In function `e2fsck_get_journal':
/tmp/e2fsprogs/e2fsck/journal.c:315: undefined reference to `uuid_is_null'
/tmp/e2fsprogs/e2fsck/journal.c:397: undefined reference to `uuid_unparse'
/tmp/e2fsprogs/e2fsck/journal.c:398: undefined reference to `blkid_get_devname'
/tmp/e2fsprogs/e2fsck/journal.c:401: undefined reference to `blkid_devno_to_devname'
journal.o: In function `e2fsck_check_ext3_journal':
/tmp/e2fsprogs/e2fsck/journal.c:766: undefined reference to `uuid_is_null'
journal.o: In function `e2fsck_journal_reset_super':
/tmp/e2fsprogs/e2fsck/journal.c:683: undefined reference to `uuid_generate'
journal.o: In function `e2fsck_fix_ext3_journal_hint':
/tmp/e2fsprogs/e2fsck/journal.c:1117: undefined reference to `uuid_is_null'
/tmp/e2fsprogs/e2fsck/journal.c:1120: undefined reference to `uuid_unparse'
/tmp/e2fsprogs/e2fsck/journal.c:1121: undefined reference to `blkid_get_devname'
dirinfo.o: In function `setup_tdb':
/tmp/e2fsprogs/e2fsck/dirinfo.c:63: undefined reference to `uuid_unparse'
collect2: error: ld returned 1 exit status
make[3]: *** [e2fsck] Error 1
make[3]: Leaving directory `/tmp/e2fsprogs/debian/BUILD-STD/e2fsck'
make[2]: *** [all-progs-recursive] Error 1
make[2]: Leaving directory `/tmp/e2fsprogs/debian/BUILD-STD'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/tmp/e2fsprogs/debian/BUILD-STD'
make: *** [debian/stampdir/build-std-stamp] Error 2
dpkg-buildpackage: error: debian/rules build gave error exit status 2
debuild: fatal error at line 1350:
dpkg-buildpackage -rfakeroot -d -us -uc -b -ai386 failed

