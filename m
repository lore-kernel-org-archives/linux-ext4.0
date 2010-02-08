From: Girish Shilamkar <Girish.Shilamkar@Sun.COM>
Subject: e2fsprogs segfaults during make check
Date: Mon, 08 Feb 2010 13:01:26 +0530
Message-ID: <1265614286.3882.16.camel@metis>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_qVCldFmb8XZmsE9VBI9AdQ)"
Cc: adilger@Sun.COM
To: Ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:62116 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0BHHjW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Feb 2010 02:39:22 -0500
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id o187UdtT018569
	for <linux-ext4@vger.kernel.org>; Mon, 8 Feb 2010 07:30:54 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KXI00L00HTE1C00@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Mon,
 08 Feb 2010 15:30:39 +0800 (SGT)
Received: from [129.150.226.14] ([unknown] [129.150.226.14])
 by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 with ESMTPSA id <0KXI00EVGI6WKCG0@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Mon, 08 Feb 2010 15:30:38 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_qVCldFmb8XZmsE9VBI9AdQ)
Content-type: text/plain; charset=utf8
Content-transfer-encoding: 8BIT

Hello,
     I found a problem while creating e2fsprogs rpms. Few of the tests
fail with segfault during make check. The tests are d_loaddump, f_dup4,
f_imagic_fs and r_resize_inode. This failure is only seen on rhel5,
x86_64. 
      On further searching I found that this error can reproduced when
e2fsprogs is configured with shared elf libraries. For example,
configure --enable-elf-shlibs, make; make check 
And this problem is seen from 1.41.7 version onwards.

Any ideas/comments ?

﻿Thanks,
Girish

The test failures from make check:
d_loaddump: debugfs load/dump test: ./d_loaddump/script: line 22: 12573
Segmentation fault      $DEBUGFS -R "write $TEST_DATA test_data" -w
$TMPFILE >> $OUT.new 2>&1
./d_loaddump/script: line 34: 12577 Segmentation fault      $DEBUGFS -R "dump test_data $VERIFY_DATA" $TMPFILE >> $OUT.new 2>&1

f_dup4: find all directory pathnames: ./f_dup4/script: line 41: 13359 Segmentation fault      $DEBUGFS -w $TMPFILE  > /dev/null 2>&1 <<EOF

f_imagic_fs: imagic filesystem with imagic inodes: ./run_e2fsck: line 48: 14602 Segmentation fault      $DEBUGFS -w -R "feature imagic_inodes" $TMPFILE > /dev/null 2>&1
failed

_resize_inode: filesystem resize with a resize_inode present: ./r_resize_inode/script: line 101: 16093 Segmentation fault      $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE > /dev/null 2>&1
./r_resize_inode/script: line 101: 16094 Segmentation fault      $DEBUGFS -R "set_super_value hash_seed null" -w $TMPFILE > /dev/null 2>&1
./r_resize_inode/script: line 101: 16095 Segmentation fault      $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE > /dev/null 2>&1
ok


--Boundary_(ID_qVCldFmb8XZmsE9VBI9AdQ)
Content-type: text/plain; CHARSET=US-ASCII; name=typescript
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=typescript

Script started on Mon 08 Feb 2010 12:10:03 AM MST
]0;root@sfire23:/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9[root@sfire23 e2fsprogs-1.41.9]# ./configure --enable-sh[K[Kelf-shlibs; make ; make check
Generating configuration file for e2fsprogs version 1.41.9
Release date is August, 2009
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
CC defaults to cc
checking for gcc... cc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether cc accepts -g... yes
checking for cc option to accept ISO C89... none needed
checking how to run the C preprocessor... cc -E
LD defaults to cc
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking linux/fs.h usability... yes
checking linux/fs.h presence... yes
checking for linux/fs.h... yes
checking for additional special compiler flags... (none)
Disabling maintainer mode by default
Disabling verbose make commands
Disabling compression support by default
Enabling htree directory support by default
Enabling ELF shared libraries
Disabling BSD shared libraries by default
Disabling profiling libraries by default
Disabling checker libraries by default
Disabling journal debugging by default
Disabling blkid debugging by default
Enabling testio debugging by default
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
Enabling private uuid library by default
checking for pkg-config... (cached) /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
Enabling private blkid library by default
Enabling debugfs support by default
Enabling e2image support by default
Enabling e2resize support by default
Building fsck wrapper by default
Building e2initrd helper by default
Try using thread local support by default
checking for thread local storage (TLS) class... __thread
Building uuidd by default
checking whether make sets $(MAKE)... yes
checking for a BSD-compatible install... /usr/bin/install -c
checking whether NLS is requested... yes
checking for msgfmt... /usr/bin/msgfmt
checking for gmsgfmt... /usr/bin/msgfmt
checking for xgettext... /usr/bin/xgettext
checking for msgmerge... /usr/bin/msgmerge
checking for ranlib... ranlib
checking for strerror in -lcposix... no
checking for an ANSI C-conforming const... yes
checking for signed... yes
checking for inline... inline
checking for off_t... yes
checking for size_t... yes
checking for long long... yes
checking for long double... yes
checking for wchar_t... yes
checking for wint_t... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for intmax_t... yes
checking whether printf() supports POSIX/XSI format strings... yes
checking for working alloca.h... yes
checking for alloca... yes
checking for stdlib.h... (cached) yes
checking for unistd.h... (cached) yes
checking for getpagesize... yes
checking for working mmap... yes
checking whether we are using the GNU C Library 2.1 or newer... yes
checking whether integer division by zero raises SIGFPE... yes
checking for unsigned long long... yes
checking for inttypes.h... yes
checking whether the inttypes.h PRIxNN macros are broken... no
checking for stdint.h... (cached) yes
checking for SIZE_MAX... yes
checking for stdint.h... (cached) yes
checking for ld used by GCC... cc
checking if the linker (cc) is GNU ld... no
checking for shared library run path origin... done
checking for ptrdiff_t... yes
checking argz.h usability... yes
checking argz.h presence... yes
checking for argz.h... yes
checking limits.h usability... yes
checking limits.h presence... yes
checking for limits.h... yes
checking locale.h usability... yes
checking locale.h presence... yes
checking for locale.h... yes
checking nl_types.h usability... yes
checking nl_types.h presence... yes
checking for nl_types.h... yes
checking malloc.h usability... yes
checking malloc.h presence... yes
checking for malloc.h... yes
checking stddef.h usability... yes
checking stddef.h presence... yes
checking for stddef.h... yes
checking for stdlib.h... (cached) yes
checking for string.h... (cached) yes
checking for unistd.h... (cached) yes
checking sys/param.h usability... yes
checking sys/param.h presence... yes
checking for sys/param.h... yes
checking for asprintf... yes
checking for fwprintf... yes
checking for getcwd... yes
checking for getegid... yes
checking for geteuid... yes
checking for getgid... yes
checking for getuid... yes
checking for mempcpy... yes
checking for munmap... yes
checking for putenv... yes
checking for setenv... yes
checking for setlocale... yes
checking for snprintf... yes
checking for stpcpy... yes
checking for strcasecmp... yes
checking for strdup... yes
checking for strtoul... yes
checking for tsearch... yes
checking for wcslen... yes
checking for __argz_count... yes
checking for __argz_stringify... yes
checking for __argz_next... yes
checking for __fsetlocking... yes
checking whether _snprintf is declared... no
checking whether _snwprintf is declared... no
checking whether feof_unlocked is declared... yes
checking whether fgets_unlocked is declared... no
checking whether getc_unlocked is declared... yes
checking for iconv... yes
checking for iconv declaration... 
         extern size_t iconv (iconv_t cd, char * *inbuf, size_t *inbytesleft, char * *outbuf, size_t *outbytesleft);
checking for nl_langinfo and CODESET... yes
checking for LC_MESSAGES... yes
checking for bison... bison
checking version of bison... 2.3, ok
checking whether NLS is requested... yes
checking whether included gettext is requested... no
checking for GNU gettext in libc... yes
checking whether to use NLS... yes
checking where the gettext function comes from... libc
checking whether make sets $(MAKE)... (cached) yes
checking for GNU make... make
checking for ln... /bin/ln
checking whether ln -s works... yes
checking for mv... /bin/mv
checking for cp... /bin/cp
checking for rm... /bin/rm
checking for chmod... /bin/chmod
checking for gawk... gawk
checking for egrep... (cached) /bin/grep -E
checking for sed... /bin/sed
checking for perl... /usr/bin/perl
checking for ldconfig... /sbin/ldconfig
checking for ar... ar
checking for ranlib... (cached) ranlib
checking for strip... strip
checking for makeinfo... makeinfo
checking for a BSD-compatible install... /usr/bin/install -c
checking dirent.h usability... yes
checking dirent.h presence... yes
checking for dirent.h... yes
checking errno.h usability... yes
checking errno.h presence... yes
checking for errno.h... yes
checking getopt.h usability... yes
checking getopt.h presence... yes
checking for getopt.h... yes
checking for malloc.h... (cached) yes
checking mntent.h usability... yes
checking mntent.h presence... yes
checking for mntent.h... yes
checking paths.h usability... yes
checking paths.h presence... yes
checking for paths.h... yes
checking semaphore.h usability... yes
checking semaphore.h presence... yes
checking for semaphore.h... yes
checking setjmp.h usability... yes
checking setjmp.h presence... yes
checking for setjmp.h... yes
checking signal.h usability... yes
checking signal.h presence... yes
checking for signal.h... yes
checking stdarg.h usability... yes
checking stdarg.h presence... yes
checking for stdarg.h... yes
checking for stdint.h... (cached) yes
checking for stdlib.h... (cached) yes
checking termios.h usability... yes
checking termios.h presence... yes
checking for termios.h... yes
checking termio.h usability... yes
checking termio.h presence... yes
checking for termio.h... yes
checking for unistd.h... (cached) yes
checking utime.h usability... yes
checking utime.h presence... yes
checking for utime.h... yes
checking linux/fd.h usability... yes
checking linux/fd.h presence... yes
checking for linux/fd.h... yes
checking linux/major.h usability... yes
checking linux/major.h presence... yes
checking for linux/major.h... yes
checking net/if_dl.h usability... no
checking net/if_dl.h presence... no
checking for net/if_dl.h... no
checking netinet/in.h usability... yes
checking netinet/in.h presence... yes
checking for netinet/in.h... yes
checking sys/disklabel.h usability... no
checking sys/disklabel.h presence... no
checking for sys/disklabel.h... no
checking sys/file.h usability... yes
checking sys/file.h presence... yes
checking for sys/file.h... yes
checking sys/ioctl.h usability... yes
checking sys/ioctl.h presence... yes
checking for sys/ioctl.h... yes
checking sys/mkdev.h usability... no
checking sys/mkdev.h presence... no
checking for sys/mkdev.h... no
checking sys/mman.h usability... yes
checking sys/mman.h presence... yes
checking for sys/mman.h... yes
checking sys/prctl.h usability... yes
checking sys/prctl.h presence... yes
checking for sys/prctl.h... yes
checking sys/queue.h usability... yes
checking sys/queue.h presence... yes
checking for sys/queue.h... yes
checking sys/resource.h usability... yes
checking sys/resource.h presence... yes
checking for sys/resource.h... yes
checking sys/select.h usability... yes
checking sys/select.h presence... yes
checking for sys/select.h... yes
checking sys/socket.h usability... yes
checking sys/socket.h presence... yes
checking for sys/socket.h... yes
checking sys/sockio.h usability... no
checking sys/sockio.h presence... no
checking for sys/sockio.h... no
checking for sys/stat.h... (cached) yes
checking sys/syscall.h usability... yes
checking sys/syscall.h presence... yes
checking for sys/syscall.h... yes
checking sys/sysmacros.h usability... yes
checking sys/sysmacros.h presence... yes
checking for sys/sysmacros.h... yes
checking sys/time.h usability... yes
checking sys/time.h presence... yes
checking for sys/time.h... yes
checking for sys/types.h... (cached) yes
checking sys/un.h usability... yes
checking sys/un.h presence... yes
checking for sys/un.h... yes
checking sys/wait.h usability... yes
checking sys/wait.h presence... yes
checking for sys/wait.h... yes
checking for sys/disk.h... no
checking for sys/mount.h... yes
checking for net/if.h... yes
checking for vprintf... yes
checking for _doprnt... no
checking for struct dirent.d_reclen... yes
checking for ssize_t... yes
checking whether llseek is declared... no
checking whether lseek64 is declared... yes
checking size of short... 2
checking size of int... 4
checking size of long... 8
checking size of long long... 8
checking whether byte ordering is bigendian... no
checking for inttypes.h... (cached) yes
checking for intptr_t... yes
checking whether struct stat has a st_flags field... no
checking for struct sockaddr.sa_len... no
checking for chflags... no
checking for getrusage... yes
checking for llseek... yes
checking for lseek64... yes
checking for open64... yes
checking for fstat64... yes
checking for ftruncate64... yes
checking for getmntinfo... no
checking for strtoull... yes
checking for strcasecmp... (cached) yes
checking for srandom... yes
checking for jrand48... yes
checking for fchown... yes
checking for mallinfo... yes
checking for fdatasync... yes
checking for strnlen... yes
checking for strptime... yes
checking for strdup... (cached) yes
checking for sysconf... yes
checking for pathconf... yes
checking for posix_memalign... yes
checking for memalign... yes
checking for valloc... yes
checking for __secure_getenv... yes
checking for prctl... yes
checking for mmap... yes
checking for utime... yes
checking for setresuid... yes
checking for setresgid... yes
checking for usleep... yes
checking for nanosleep... yes
checking for getdtablesize... yes
checking for getrlimit... yes
checking for socket in -lsocket... no
checking for dlopen in -ldl... yes
checking for optreset... no
checking for sem_init... no
checking for sem_init in -lpthread... yes
checking for unified diff option... -u
On linux-gnu systems, root_prefix defaults to ''
On linux-gnu systems, prefix defaults to /usr
checking whether linker accepts -static... yes
configure: creating ./config.status
config.status: creating MCONFIG
config.status: creating Makefile
config.status: creating e2fsprogs.spec
config.status: creating util/Makefile
config.status: creating util/subst.conf
config.status: creating util/gen-tarball
config.status: creating lib/et/Makefile
config.status: creating lib/ss/Makefile
config.status: creating lib/e2p/Makefile
config.status: creating lib/ext2fs/Makefile
config.status: creating lib/ext2fs/ext2_types.h
config.status: creating lib/uuid/Makefile
config.status: creating lib/uuid/uuid_types.h
config.status: creating lib/blkid/Makefile
config.status: creating lib/blkid/blkid_types.h
config.status: creating lib/ss/ss.pc
config.status: creating lib/uuid/uuid.pc
config.status: creating lib/et/com_err.pc
config.status: creating lib/e2p/e2p.pc
config.status: creating lib/blkid/blkid.pc
config.status: creating lib/ext2fs/ext2fs.pc
config.status: creating misc/Makefile
config.status: creating ext2ed/Makefile
config.status: creating e2fsck/Makefile
config.status: creating debugfs/Makefile
config.status: creating tests/Makefile
config.status: creating tests/progs/Makefile
config.status: creating resize/Makefile
config.status: creating doc/Makefile
config.status: creating intl/Makefile
config.status: creating intl/libgnuintl.h
config.status: creating po/Makefile.in
config.status: executing default-1 commands
config.status: creating po/POTFILES
config.status: creating po/Makefile
cd ./util ; make subst
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/util'
	CC subst.c
	LD subst
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/util'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
cd .; CONFIG_FILES=./lib/ext2fs/ext2_types.h ./config.status
config.status: creating ./lib/ext2fs/ext2_types.h
config.status: executing default-1 commands
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
cd .; CONFIG_FILES=./lib/blkid/blkid_types.h ./config.status
config.status: creating ./lib/blkid/blkid_types.h
config.status: executing default-1 commands
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
cd .; CONFIG_FILES=./lib/uuid/uuid_types.h ./config.status
config.status: creating ./lib/uuid/uuid_types.h
config.status: executing default-1 commands
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
	SUBST compile_et
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
	SUBST ext2_err.et
	COMPILE_ET ext2_err.et
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
make libs
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: `lib/ext2fs/ext2_types.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: `lib/blkid/blkid_types.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: `lib/uuid/uuid_types.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[2]: `compile_et' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
make[2]: `ext2_err.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
making all in lib/et
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[3]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
	MKDIR elfshared
make[3]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
	CC error_message.c
	CC et_name.c
	CC init_et.c
	CC com_err.c
	CC com_right.c
	GEN_LIB libcom_err.a
	GEN_ELF_SOLIB libcom_err.so.2.1
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
making all in lib/ss
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
	SUBST mk_cmds
make[3]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
	MKDIR elfshared
make[3]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
	COMPILE_ET ss_err.et
	CC ss_err.c
	MK_CMDS std_rqs.c
	CC std_rqs.c
	CC invocation.c
	CC help.c
	CC execute_cmd.c
	CC listen.c
	CC parse.c
	CC error.c
	CC prompt.c
	CC request_tbl.c
	CC list_rqs.c
	CC pager.c
	CC requests.c
	CC data.c
	CC get_readline.c
	GEN_LIB libss.a
	GEN_ELF_SOLIB libss.so.2.0
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
making all in lib/e2p
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
make[3]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
	MKDIR elfshared
make[3]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
	CC feature.c
	CC fgetflags.c
	CC fsetflags.c
	CC fgetversion.c
	CC fsetversion.c
	CC getflags.c
	CC getversion.c
	CC hashstr.c
	CC iod.c
	CC ls.c
	CC mntopts.c
	CC parse_num.c
	CC pe.c
	CC pf.c
	CC ps.c
	CC setflags.c
	CC setversion.c
	CC uuid.c
	CC ostype.c
	CC percent.c
	GEN_LIB libe2p.a
	GEN_ELF_SOLIB libe2p.so.2.3
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
making all in lib/uuid
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
make[3]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
	MKDIR elfshared
make[3]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
	CC clear.c
	CC compare.c
	CC copy.c
	CC gen_uuid.c
	CC isnull.c
	CC pack.c
	CC parse.c
	CC unpack.c
	CC unparse.c
	CC uuid_time.c
	GEN_LIB libuuid.a
	GEN_ELF_SOLIB libuuid.so.1.2
	CC tst_uuid.o
	LD tst_uuid
	LD uuid_time
	SUBST uuid.3
	SUBST uuid_clear.3
	SUBST uuid_compare.3
	SUBST uuid_copy.3
	SUBST uuid_generate.3
	SUBST uuid_is_null.3
	SUBST uuid_parse.3
	SUBST uuid_time.3
	SUBST uuid_unparse.3
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
making all in lib/ext2fs
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
make[3]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
	MKDIR elfshared
make[3]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
	CC bb_compat.c
	CC fileio.c
	CC inode_io.c
	CC namei.c
	CC write_bb_file.c
	CC dupfs.c
	CC imager.c
	CC test_io.c
	CC ext2_err.c
	CC alloc.c
	CC alloc_sb.c
	CC alloc_stats.c
	CC alloc_tables.c
	CC badblocks.c
	CC bb_inode.c
	CC bitmaps.c
	CC bitops.c
	CC block.c
	CC bmap.c
	CC check_desc.c
	CC closefs.c
	CC crc16.c
	CC csum.c
	CC dblist.c
	CC dblist_dir.c
	CC dirblock.c
	CC dirhash.c
	CC dir_iterate.c
	CC expanddir.c
	CC ext_attr.c
	CC extent.c
	CC finddev.c
	CC flushb.c
	CC freefs.c
	CC gen_bitmap.c
	CC get_pathname.c
	CC getsize.c
	CC getsectsize.c
	CC i_block.c
	CC icount.c
	CC ind_block.c
	CC initialize.c
	CC inline.c
	CC inode.c
	CC io_manager.c
	CC ismounted.c
	CC link.c
	CC llseek.c
	CC lookup.c
	CC mkdir.c
	CC mkjournal.c
	CC native.c
	CC newdir.c
	CC openfs.c
	CC read_bb.c
	CC read_bb_file.c
	CC res_gdt.c
	CC rw_bitmaps.c
	CC swapfs.c
	CC tdb.c
	CC undo_io.c
	CC unix_io.c
	CC unlink.c
	CC valid_blk.c
	CC version.c
	GEN_LIB libext2fs.a
	GEN_ELF_SOLIB libext2fs.so.2.4
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
making all in lib/blkid
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
make[3]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
	MKDIR elfshared
make[3]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
	CC cache.c
	CC dev.c
	CC devname.c
	CC devno.c
	CC getsize.c
	CC llseek.c
	CC probe.c
	CC read.c
	CC resolve.c
	CC save.c
	CC tag.c
	CC version.c
	GEN_LIB libblkid.a
	GEN_ELF_SOLIB libblkid.so.1.0
	SUBST libblkid.3
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
making all in intl
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/intl'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/intl'
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make progs
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: `lib/ext2fs/ext2_types.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: `lib/blkid/blkid_types.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: `lib/uuid/uuid_types.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[2]: `compile_et' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
make[2]: `ext2_err.h' is up to date.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
making all in lib/et
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
making all in lib/ss
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
making all in lib/e2p
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
making all in lib/uuid
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
making all in lib/ext2fs
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
making all in lib/blkid
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
making all in intl
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/intl'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/intl'
making all in e2fsck
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/e2fsck'
	COMPILE_ET prof_err.et
	CC gen_crc32table
	GEN32TABLE crc32table.h
	CC crc32.c
	CC dict.c
	CC unix.c
	CC e2fsck.c
	CC super.c
	CC pass1.c
	CC pass1b.c
	CC pass2.c
	CC pass3.c
	CC pass4.c
	CC pass5.c
	CC journal.c
	CC badblocks.c
	CC util.c
	CC dirinfo.c
	CC dx_dirinfo.c
	CC ehandler.c
	CC problem.c
	CC message.c
	CC recovery.c
	CC region.c
	CC revoke.c
	CC ea_refcount.c
	CC rehash.c
	CC profile.c
	CC prof_err.c
	LD e2fsck
	SUBST e2fsck.8
	SUBST e2fsck.conf.5
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/e2fsck'
making all in debugfs
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/debugfs'
	MK_CMDS debug_cmds.c
	CC debug_cmds.c
	CC debugfs.c
	CC util.c
	CC ncheck.c
	CC icheck.c
	CC ls.c
	CC lsdel.c
	CC dump.c
	CC set_fields.c
	CC logdump.c
	CC htree.c
	CC unused.c
	LD debugfs
	SUBST debugfs.8
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/debugfs'
making all in misc
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/misc'
	COMPILE_ET prof_err.et
	CC mke2fs.c
	CC util.c
	CC ../e2fsck/profile.c
	CC prof_err.c
	PROFILE_TO_C mke2fs.conf
	CC default_profile.c
	LD mke2fs
	CC badblocks.c
	LD badblocks
	CC tune2fs.c
	LD tune2fs
	CC dumpe2fs.c
	LD dumpe2fs
	CC blkid.c
	LD blkid
	CC logsave.c
	LD logsave
	CC e2image.c
	LD e2image
	CC fsck.c
	CC base_device.c
	CC ismounted.c
	LD fsck
	CC e2undo.c
	LD e2undo
	CC chattr.c
	LD chattr
	CC lsattr.c
	LD lsattr
	CC uuidgen.c
	LD uuidgen
	CC mklost+found.c
	LD mklost+found
	CC filefrag.c
	LD filefrag
	CC e2freefrag.c
	LD e2freefrag
	CC uuidd.c
	LD uuidd
	SUBST tune2fs.8
	SUBST mklost+found.8
	SUBST mke2fs.8
	SUBST dumpe2fs.8
	SUBST badblocks.8
	SUBST e2label.8
	SUBST findfs.8
	SUBST blkid.8
	SUBST e2image.8
	SUBST logsave.8
	SUBST filefrag.8
	SUBST e2freefrag.8
	SUBST e2undo.8
	SUBST uuidd.8
	SUBST fsck.8
	SUBST chattr.1
	SUBST lsattr.1
	SUBST uuidgen.1
	SUBST mke2fs.conf.5
	CC e2initrd_helper.c
	LD e2initrd_helper
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/misc'
making all in resize
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/resize'
	CC extent.c
	CC resize2fs.c
	CC main.c
	CC online.c
	CC sim_progress.c
	LD resize2fs
	CC test_extent.c
	LD test_extent
	SUBST resize2fs.8
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/resize'
making all in tests/progs
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/tests/progs'
	CC test_icount.c
	MK_CMDS test_icount_cmds.c
	CC test_icount_cmds.c
	LD test_icount
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/tests/progs'
making all in po
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/po'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/po'
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make docs
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[2]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/doc'
	MAKEINFO libext2fs.info
make[2]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/doc'
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: `lib/ext2fs/ext2_types.h' is up to date.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: `lib/blkid/blkid_types.h' is up to date.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: `lib/uuid/uuid_types.h' is up to date.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[1]: `compile_et' is up to date.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
make[1]: `ext2_err.h' is up to date.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
making check in util
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/util'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/util'
making check in lib/et
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
for i in ./test_cases/*.et ; do \
		t=`basename $i | sed -e 's/.et//'`; \
		./compile_et --build-tree $i ; \
		diff -c ./test_cases/$t.c $t.c > $t.failed; \
		if [ $? -ne 0 ]; then echo Test case $t failed; exit 1 ; fi ; \
		diff -c ./test_cases/$t.h $t.h >> $t.failed; \
		if [ $? -ne 0 ]; then echo Test case $t failed; exit 1 ; fi ; \
		/bin/rm -f $t.c $t.h $t.failed; \
		echo "Test case $t succeeded" ; \
	done
Test case continuation succeeded
Test case heimdal2 succeeded
Test case heimdal3 succeeded
Test case heimdal succeeded
Test case imap_err succeeded
Test case simple succeeded
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/et'
making check in lib/ss
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
	CC test_ss.c
	MK_CMDS test_cmd.c
	CC test_cmd.c
	LD test_ss
	RUN TEST test_ss
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ss'
making check in lib/e2p
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
	LD tst_ostype
	LD tst_feature
./tst_ostype
0: Linux (0)
1: Hurd (1)
2: Masix (2)
3: FreeBSD (3)
4: Lites (4)
./tst_feature
Feature list:
	Compat = 0, Mask = 1, dir_prealloc
	Compat = 0, Mask = 4, has_journal
	Compat = 0, Mask = 2, imagic_inodes
	Compat = 0, Mask = 8, ext_attr
	Compat = 0, Mask = 32, dir_index
	Compat = 0, Mask = 16, resize_inode
	Compat = 0, Mask = 64, lazy_bg
	Compat = 2, Mask = 1, sparse_super
	Compat = 2, Mask = 2, large_file
	Compat = 2, Mask = 8, huge_file
	Compat = 2, Mask = 16, uninit_bg
	Compat = 2, Mask = 16, uninit_groups
	Compat = 2, Mask = 32, dir_nlink
	Compat = 2, Mask = 64, extra_isize
	Compat = 1, Mask = 1, compression
	Compat = 1, Mask = 2, filetype
	Compat = 1, Mask = 4, needs_recovery
	Compat = 1, Mask = 8, journal_dev
	Compat = 1, Mask = 64, extent
	Compat = 1, Mask = 64, extents
	Compat = 1, Mask = 16, meta_bg
	Compat = 1, Mask = 128, 64bit
	Compat = 1, Mask = 512, flex_bg

Journal feature list:
	Compat = 0, Mask = 1, journal_checksum
	Compat = 1, Mask = 1, journal_incompat_revoke
	Compat = 1, Mask = 4, journal_async_commit
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/e2p'
making check in lib/uuid
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_uuid
UUID generate = a7fbf780-ed5c-4343-b368-b040f00aeb17
UUID: a7fbf780ed5c4343b368b040f00aeb17
UUID type = 4, UUID variant = 1

UUID random string = 81540054-81a8-48e0-9e99-a985bca4ee47
UUID: 8154005481a848e09e99a985bca4ee47
UUID type = 4, UUID variant = 1

UUID string = ba5c7764-1481-11df-bca3-00238b64a29b
UUID time: ba5c7764148111dfbca300238b64a29b
UUID type = 1, UUID variant = 1
UUID time is: (1265613325, 436298): Mon Feb  8 00:15:25 2010

UUID parse and compare succeeded.
UUID clear and is null succeeded.
UUID copy and compare succeeded.
84949cc5-4701-4a84-895b-354c584a981b is valid, OK
84949CC5-4701-4A84-895B-354C584A981B is valid, OK
84949cc5-4701-4a84-895b-354c584a981bc is invalid, OK
84949cc5-4701-4a84-895b-354c584a981 is invalid, OK
84949cc5x4701-4a84-895b-354c584a981b is invalid, OK
84949cc504701-4a84-895b-354c584a981b is invalid, OK
84949cc5-470104a84-895b-354c584a981b is invalid, OK
84949cc5-4701-4a840895b-354c584a981b is invalid, OK
84949cc5-4701-4a84-895b0354c584a981b is invalid, OK
g4949cc5-4701-4a84-895b-354c584a981b is invalid, OK
84949cc5-4701-4a84-895b-354c584a981g is invalid, OK
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/uuid'
making check in lib/ext2fs
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
	CC tst_bitops.c
	LD tst_bitops
	CC tst_badblocks.c
	LD tst_badblocks
	CC tst_iscan.c
	LD tst_iscan
	CC tst_types.c
	LD tst_types
	LD tst_icount
	CC tst_super_size.c
	LD tst_super_size
	LD tst_csum
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_bitops
ext2fs_test_bit appears to be correct
ext2fs_set_bit test succeeded.
ext2fs_clear_bit test succeed.
big bit number (2147483690) test: 4, expected 4
big bit number (2147483690) test: 0, expected 0
ext2fs_set_bit big_test successful
ext2fs_fast_set_bit test succeeded.
ext2fs_clear_bit test succeed.
big bit number (2147483690) test: 4, expected 4
big bit number (2147483690) test: 0, expected 0
ext2fs_fast_set_bit big_test successful
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_badblocks
test1: 1 2 3 4 5 6 7 8 9 10 --- OK
test2: 1 2 3 4 5 6 7 8 9 10 11 --- OK
test3: 1 2 3 4 5 6 7 8 9 10 --- OK
test4: 2 12 13 17 20 23 50 56 66 
	block 20 is present --- OK
	block 50 is present --- OK
	block 3 is absent --- OK
	block 17 is present --- OK
	block 18 is absent --- OK
	block 16 is absent --- OK
	block 11 is absent --- OK
	block 12 is present --- OK
	block 13 is present --- OK
	block 14 is absent --- OK
	block 80 is absent --- OK
	block 45 is absent --- OK
	block 66 is present --- OK

test5: 1 17 20 23 31 51 56 57 
Adding block 50 --- now present
Removing block 51 --- now absent
Removing block 57 --- now absent
Adding block 66 --- now present
Removing block 31 --- now absent
Adding block 12 --- now present
Adding block 2 --- now present
Adding block 13 --- now present
Removing block 1 --- now absent
After test5 sequence: 2 12 13 17 20 23 50 56 66 

Comparison tests:
bb1 and bb2 are NOT equal.
bb1 and bb3 are equal.
bb1 and bb4 are NOT equal.
bb4 and bb5 are equal.

Block bitmap matched after reading and writing.
Expected invalid block
Block bitmap matched after reading and writing.
ext2fs library badblocks tests checks out OK!
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_iscan
Reading blocks: 5-7, 9-11, 13-20, 21-23, 25-32, 33, 35-42, 45-52, 53-60, 61-68, 69-76, 77-84, 85-92, 93-99, 101-108, 109-116, 117-124, 125-132, 133-140, 141-148, 149-156, 157-164, 165-172, 173-180, 181-188, 189-192, 8197-8204, 8205-8212, 8213-8220, 8221-8228, 8229-8236, 8237-8244, 8245-8252, 8253-8260, 8261-8268, 8269-8276, 8277-8284, 8285-8292, 8293-8300, 8301-8308, 8309-8316, 8317-8324, 8325-8332, 8333-8340, 8341-8348, 8349-8356, 8357-8364, 8365-8372, 8373-8380, 8381-8384
Bad inodes: 25, 26, 27, 28, 29, 30, 31, 32, 57, 58, 59, 60, 61, 62, 63, 64, 153, 154, 155, 156, 157, 158, 159, 160, 233, 234, 235, 236, 237, 238, 239, 240, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 761, 762, 763, 764, 765, 766, 767, 768
Inode scan tested OK!
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_types
The ext2_types.h types are correct.
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_icount
Standard icount run:
icount_store(42, 42) = 42 (OK)
icount_store(1, 1) = 1 (OK)
icount_store(2, 2) = 2 (OK)
icount_store(3, 3) = 3 (OK)
icount_store(10, 1) = 1 (OK)
icount_store(42, 0) = 0 (OK)
icount_increment(5) = 1 (OK)
icount_increment(5) = 2 (OK)
icount_increment(5) = 3 (OK)
icount_increment(5) = 4 (OK)
icount_decrement(5) = 3 (OK)
icount_decrement(5) = 2 (OK)
icount_decrement(5) = 1 (OK)
icount_decrement(5) = 0 (OK)
icount_fetch(10) = 1 (OK)
icount_fetch(1) = 1 (OK)
icount_fetch(2) = 2 (OK)
icount_fetch(3) = 3 (OK)
icount_increment(1) = 2 (OK)
icount_decrement(2) = 1 (OK)
icount_decrement(2) = 0 (OK)
icount_fetch(12) = 0 (OK)
icount size is 60

Multiple bitmap test:
icount_store(42, 42) = 42 (OK)
icount_store(1, 1) = 1 (OK)
icount_store(2, 2) = 2 (OK)
icount_store(3, 3) = 3 (OK)
icount_store(10, 1) = 1 (OK)
icount_store(42, 0) = 0 (OK)
icount_increment(5) = 1 (OK)
icount_increment(5) = 2 (OK)
icount_increment(5) = 3 (OK)
icount_increment(5) = 4 (OK)
icount_decrement(5) = 3 (OK)
icount_decrement(5) = 2 (OK)
icount_decrement(5) = 1 (OK)
icount_decrement(5) = 0 (OK)
icount_fetch(10) = 1 (OK)
icount_fetch(1) = 1 (OK)
icount_fetch(2) = 2 (OK)
icount_fetch(3) = 3 (OK)
icount_increment(1) = 2 (OK)
icount_decrement(2) = 1 (OK)
icount_decrement(2) = 0 (OK)
icount_fetch(12) = 0 (OK)
icount size is 60

Resizing icount:
icount_store(1, 1) = 1 (OK)
icount_store(2, 2) = 2 (OK)
icount_store(3, 3) = 3 (OK)
icount_store(4, 4) = 4 (OK)
icount_store(5, 5) = 5 (OK)
icount_store(6, 1) = 1 (OK)
icount_store(7, 2) = 2 (OK)
icount_store(8, 3) = 3 (OK)
icount_store(9, 4) = 4 (OK)
icount_store(10, 5) = 5 (OK)
icount_store(11, 1) = 1 (OK)
icount_store(12, 2) = 2 (OK)
icount_store(13, 3) = 3 (OK)
icount_store(14, 4) = 4 (OK)
icount_store(15, 5) = 5 (OK)
icount_store(16, 1) = 1 (OK)
icount_store(17, 2) = 2 (OK)
icount_store(18, 3) = 3 (OK)
icount_store(19, 4) = 4 (OK)
icount_store(20, 5) = 5 (OK)
icount_store(21, 1) = 1 (OK)
icount_store(22, 2) = 2 (OK)
icount_store(23, 3) = 3 (OK)
icount_store(24, 4) = 4 (OK)
icount_store(25, 5) = 5 (OK)
icount_store(26, 1) = 1 (OK)
icount_store(27, 2) = 2 (OK)
icount_store(28, 3) = 3 (OK)
icount_store(29, 4) = 4 (OK)
icount_store(30, 5) = 5 (OK)
icount size is 2256

Standard icount run with tdb:
icount_store(42, 42) = 42 (OK)
icount_store(1, 1) = 1 (OK)
icount_store(2, 2) = 2 (OK)
icount_store(3, 3) = 3 (OK)
icount_store(10, 1) = 1 (OK)
icount_store(42, 0) = 0 (OK)
icount_increment(5) = 1 (OK)
icount_increment(5) = 2 (OK)
icount_increment(5) = 3 (OK)
icount_increment(5) = 4 (OK)
icount_decrement(5) = 3 (OK)
icount_decrement(5) = 2 (OK)
icount_decrement(5) = 1 (OK)
icount_decrement(5) = 0 (OK)
icount_fetch(10) = 1 (OK)
icount_fetch(1) = 1 (OK)
icount_fetch(2) = 2 (OK)
icount_fetch(3) = 3 (OK)
icount_increment(1) = 2 (OK)
icount_decrement(2) = 1 (OK)
icount_decrement(2) = 0 (OK)
icount_fetch(12) = 0 (OK)
icount size is 0

Multiple bitmap test with tdb:
icount_store(42, 42) = 42 (OK)
icount_store(1, 1) = 1 (OK)
icount_store(2, 2) = 2 (OK)
icount_store(3, 3) = 3 (OK)
icount_store(10, 1) = 1 (OK)
icount_store(42, 0) = 0 (OK)
icount_increment(5) = 1 (OK)
icount_increment(5) = 2 (OK)
icount_increment(5) = 3 (OK)
icount_increment(5) = 4 (OK)
icount_decrement(5) = 3 (OK)
icount_decrement(5) = 2 (OK)
icount_decrement(5) = 1 (OK)
icount_decrement(5) = 0 (OK)
icount_fetch(10) = 1 (OK)
icount_fetch(1) = 1 (OK)
icount_fetch(2) = 2 (OK)
icount_fetch(3) = 3 (OK)
icount_increment(1) = 2 (OK)
icount_decrement(2) = 1 (OK)
icount_decrement(2) = 0 (OK)
icount_fetch(12) = 0 (OK)
icount size is 0
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_super_size
Size of struct ext2_super_block is 1024
LD_LIBRARY_PATH=../../lib DYLD_LIBRARY_PATH=../../lib ./tst_csum
csum0000: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 0(df47): d3a4=d3a4
csum0001: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 1(2346): 3ea5=3ea5
csumffff: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 2(6746): 49a5=49a5
csum_set: UUID 234897e7cfe8254fdbecae4b88a7fabe(241f), grp 0(df47): d3a4=d3a4
new_uuid: UUID 30303030303030303030303030303030(766d), grp 0(76fd): a4ac=a4ac
csum_new: UUID 30303030303030303030303030303030(766d), grp 0(76fd): a4ac=a4ac
csum_blk: UUID 30303030303030303030303030303030(766d), grp 0(76fd): 2e14=2e14
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/ext2fs'
making check in lib/blkid
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
	LD tst_cache
	LD tst_dev
	LD tst_devname
	LD tst_devno
	LD tst_getsize
	LD tst_probe
	LD tst_read
	LD tst_resolve
	LD tst_save
	LD tst_tag
Creating test_probe...
	CC tst_types.c
	LD tst_types
./test_probe
cramfs: ok
ext2: ok
ext3: ok
fat32_label_64MB: ok
fat: ok
iso: ok
jbd: ok
jfs: ok
minix: ok
ocfs2: ok
reiser3: ok
reiser4: ok
romfs: ok
small-fat32: ok
swap0: ok
swap1: ok
udf: ok
xfs: ok
zfs: ok
19 tests succeeded	0 tests failed
./tst_types
The blkid_types.h types are correct.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/lib/blkid'
making check in intl
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/intl'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/intl'
making check in e2fsck
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/e2fsck'
	LD tst_refcount
	LD tst_region
LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_refcount
Creating refcount with size 5
Storing blk 3 with value 3
Storing blk 4 with value 4
Storing blk 1 with value 1
Storing blk 8 with value 8
Storing blk 2 with value 2
Storing blk 4 with value 0
Storing blk 2 with value 0
Refcount_collapse: size was 5, now 3
Storing blk 6 with value 6
Refcount validation OK.
Storing blk 4 with value 4
Refcount_collapse: size was 5, now 5
Storing blk 2 with value 2
bcode_fetch(1) returns 1
bcode_fetch(2) returns 2
bcode_increment(3) returns 4
bcode_increment(3) returns 5
bcode_decrement(4) returns 3
Storing blk 4 with value 4
Refcount validation OK.
Storing blk 20 with value 20
Storing blk 40 with value 40
Storing blk 30 with value 30
Storing blk 10 with value 10
bcode_decrement(30) returns 29
bcode_fetch(30) returns 29
bcode_decrement(2) returns 1
bcode_decrement(2) returns 0
Refcount_collapse: size was 10, now 9
	blk=1, count=1
	blk=3, count=5
	blk=4, count=4
	blk=6, count=6
	blk=8, count=8
	blk=10, count=10
	blk=20, count=20
	blk=30, count=29
	blk=40, count=40
Refcount validation OK.
Freeing refcount
LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_region
Creating region with args(1, 1001)
Printing region (min=1. max=1001)
	
Region_allocate(10, 10) returns 0
Region_allocate(30, 10) returns 0
Printing region (min=1. max=1001)
	(10, 20)  (30, 40)  
Region_allocate(1, 15) returns 1
Region_allocate(15, 8) returns 1
Region_allocate(1, 20) returns 1
Region_allocate(1, 8) returns 0
Printing region (min=1. max=1001)
	(1, 9)  (10, 20)  (30, 40)  
Region_allocate(40, 10) returns 0
Printing region (min=1. max=1001)
	(1, 9)  (10, 20)  (30, 50)  
Region_allocate(22, 5) returns 0
Printing region (min=1. max=1001)
	(1, 9)  (10, 20)  (22, 27)  (30, 50)  
Region_allocate(27, 3) returns 0
Printing region (min=1. max=1001)
	(1, 9)  (10, 20)  (22, 50)  
Region_allocate(20, 2) returns 0
Printing region (min=1. max=1001)
	(1, 9)  (10, 50)  
Region_allocate(49, 1) returns 1
Region_allocate(50, 5) returns 0
Region_allocate(9, 2) returns 1
Region_allocate(9, 1) returns 0
Printing region (min=1. max=1001)
	(1, 55)  
LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_crc32

Testing length 0...
Testing length 1...
Testing length 2...
Testing length 3...
Testing length 4...
Testing length 5...
Testing length 6...
Testing length 7...
Testing length 8...
Testing length 9...
Testing length 10...
Testing length 11...
Testing length 12...
Testing length 13...
Testing length 14...
Testing length 15...
Testing length 16...
Testing length 17...
Testing length 18...
Testing length 19...
Testing length 20...
Testing length 21...
Testing length 22...
Testing length 23...
Testing length 24...
Testing length 25...
Testing length 26...
Testing length 27...
Testing length 28...
Testing length 29...
Testing length 30...
Testing length 31...
Testing length 32...
Testing length 33...
Testing length 34...
Testing length 35...
Testing length 36...
Testing length 37...
Testing length 38...
Testing length 39...
Testing length 40...
Testing length 41...
Testing length 42...
Testing length 43...
Testing length 44...
Testing length 45...
Testing length 46...
Testing length 47...
Testing length 48...
Testing length 49...
Testing length 50...
Testing length 51...
Testing length 52...
Testing length 53...
Testing length 54...
Testing length 55...
Testing length 56...
Testing length 57...
Testing length 58...
Testing length 59...
Testing length 60...
Testing length 61...
Testing length 62...
Testing length 63...
Testing length 64...
All test complete.  No failures expected.
LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_problem
e2fsck problem table verified
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/e2fsck'
making check in debugfs
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/debugfs'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/debugfs'
making check in misc
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/misc'
	LD base_device
./base_device < ./base_device.tst > base_device.out
cmp ./base_device.tst base_device.out
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/misc'
making check in resize
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/resize'
LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./test_extent < ./test_extent.in \
		> test_extent.out
Test succeeded.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/resize'
making check in tests/progs
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/tests/progs'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/tests/progs'
making check in po
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/po'
make[1]: Nothing to be done for `check'.
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/po'
making check in tests
make[1]: Entering directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/tests'
sed -e 's/blocksize = -1/blocksize = 4096/' ./../misc/mke2fs.conf >mke2fs.conf
Creating test_script...
Running e2fsprogs test suite...
 
d_loaddump: debugfs load/dump test: ./d_loaddump/script: line 22:  5571 Segmentation fault      $DEBUGFS -R "write $TEST_DATA test_data" -w $TMPFILE >> $OUT.new 2>&1
./d_loaddump/script: line 34:  5575 Segmentation fault      $DEBUGFS -R "dump test_data $VERIFY_DATA" $TMPFILE >> $OUT.new 2>&1
cmp: test.verify: No such file or directory
failed
e_brel_bma: block relocation table using the memory array implementation: skipped
e_icount_normal: inode counting abstraction optimized for storing inode counts: ok
e_icount_opt: inode counting abstraction optimized for counting: ok
e_irel_ima: inode relocation table using the memory array implementation: skipped
f_16384_block: 16384 byte blocksize: ok
f_8192_block: 8192 byte blocksize: ok
f_bad_disconnected_inode: Disconnected inode with bad fields: ok
f_bad_local_jnl: test for corrupt local journal (bad V1->V2 journal upgrade): ok
f_badbblocks: illegal blocks in bad block inode: ok
f_baddir: corrupted directory entries: ok
f_baddir2: salvage last directory entry: ok
f_baddotdir: bad '.' and '..' entries: ok
f_badinode: corrupted inode entries: ok
f_badjour_indblks: corruption in journal inode's indirect blocks: ok
f_badjourblks: Illegal blocks in journal inode (and backup in superblock): ok
f_badorphan: corrupted orphan list: ok
f_badprimary: bad blocks in the primary superblock and group descriptors: ok
f_badroot: file in root directory inode: ok
f_badsymlinks: corrupted symlinks: ok
f_badtable: bad blocks in bitmaps and inode table: ok
f_bbfile: bad blocks in files: ok
f_bbinode: bad blocks in inode table: ok
f_big_sparse: big sparse file: ok
f_bitmaps: corrupted inode and block bitmaps: ok
f_clear_xattr: clearing i_file_acl when !ext_attr feature: ok
f_crashdisk: Superblock with illegal values: ok
f_dir_bad_mode: directory with corrupted i_mode: ok
f_dirlink: directory hard links: ok
f_dup: blocks claimed by two different files: ok
f_dup2: blocks claimed by three different files: ok
f_dup3: blocks claimed by one file multiple times: ok
f_dup4: find all directory pathnames: ./f_dup4/script: line 41:  6315 Segmentation fault      $DEBUGFS -w $TMPFILE  > /dev/null 2>&1 <<EOF
set_current_time 200704102100
set_super_value lastcheck 0
set_super_value hash_seed null
set_super_value mkfs_time 0
mkdir dir
mkdir dir2
mkdir dir3
mkdir dir4
cd /dir
write $TEST_DATA foo
cd /dir2
write $TEST_DATA bar
cd /dir3
write $TEST_DATA baz
cd /dir4
write $TEST_DATA quux
mkdir /dir/fee
mkdir /dir2/fie
mkdir /dir3/foe
mkdir /dir4/fum
link /dir/foo /dir2/foo1
link /dir/foo /dir3/foo2
link /dir2/bar /dir3/bar1
link /dir4/quux /dir/quux1
link /dir4/quux /dir2/quux2
set_inode_field /dir/foo block[0] 30
set_inode_field /dir2/bar block[0] 30
set_inode_field /dir3/baz block[0] 30
set_inode_field /dir/fee block[0] 34
set_inode_field /dir2/fie block[0] 34
set_inode_field /dir3/foe block[0] 34
q
EOF

failed
f_dup_de: duplicate directory entries: ok
f_dup_resize: blocks claimed by the resize inode and another inode: ok
f_dupdot: duplicate '.' and '..' entries: ok
f_dupfsblks: blocks claimed by a file and bitmaps or inode tables: ok
f_dupsuper: blocks claimed by a file and superblock or group descriptors: ok
f_ea_checks: extended attribute block checks: ok
f_end-bitmap: corruption at end of block bitmap: ok
f_expand: expanding lost+found: ok
f_ext_journal: ok
f_extent_bad_node: bad interior node in extent tree: ok
f_extents: basic extents support: ok
f_extents2: multiply claimed blocks in extents and other illegal extents: ok
f_extra_journal: Valid journal inode, but has_journal feature not present: ok
f_fast_symlink_extents: fast symlink with extents flag set: ok
f_file_acl_high: i_file_acl_high should be zero: ok
f_filetype: set filetype information and illegal special files: ok
f_full_bg: inode table in last block of first bg: ok
f_h_badnode: hash directory with bad HTREE nodes: ok
f_h_badroot: bad htree root nodes: ok
f_h_normal: Normal (signed) HTREE directory: ok
f_h_reindex: reindex HTREE Directory with different hash seed: ok
f_h_unsigned: Unsigned HTREE directory: ok
f_holedir: directory with holes and illegal blocks: ok
f_hurd: GNU/Hurd specific tests: ok
f_illbbitmap: illegal block bitmap: ok
f_illibitmap: illegal inode bitmap: ok
f_illitable: illegal inode table: ok
f_illitable_flexbg: illegal inode table with FLEX_BG: ok
f_imagic: non-imagic filesystem with imagic inodes: ok
f_imagic_fs: imagic filesystem with imagic inodes: ./run_e2fsck: line 48:  7057 Segmentation fault      $DEBUGFS -w -R "feature imagic_inodes" $TMPFILE > /dev/null 2>&1
failed
f_journal: recover journal from corrupted inode table: ok
f_lotsbad: too many illegal blocks in inode: ok
f_lpf: missing lost+found: ok
f_lpf2: create lost+found and reconnect lost directory: ok
f_lpffile: lost+found is not a directory: ok
f_messy_inode: bad file and directory acl pointers: ok
f_miss_blk_bmap: missing block bitmap: ok
f_miss_journal: Non-existent journal inode: ok
f_misstable: missing inode table: ok
f_mke2fs2b: mke2fs version 0.2b created filesystem: ok
f_noroot: missing root directory: ok
f_okgroup: 8193 block long filesystem: ok
f_orphan: clearing orphan inodes: ok
f_orphan_dotdot_ft: filetype of .. in orphaned directories: ok
f_overfsblks: overlapping inode and block bitmaps: ok
f_preen: preen shouldn't destroy backup superblocks: ok
f_recnect_bad: Reconnecting bad inode: ok
f_reconnect: simple disconnected file inode: ok
f_resize_inode: e2fsck with resize_inode: ok
f_salvage_dir: salvage corrupted directories: ok
f_selinux: SE Linux generated symlinks with EA data: ok
f_special_ea: Special files with extended attributes: ok
f_summary_counts: incorrect inode/block free counts: ok
f_uninit_last_uninit: last group has BLOCK_UNINIT set: ok
f_unsorted_EAs: unsorted EAs in inode should not be deleted: ok
f_valid_ea_in_inode: valid ea-in-inode examplars: ok
f_zero_group: fallback for damaged group descriptors: ok
f_zero_inode_size: superblock with a zero inode size: ok
f_zero_super: fallback for damaged superblock: ok
m_dasd_bs: 2048 byte sector devices: ok
m_large_file: largefile fs type: ok
m_meta_bg: meta blockgroup feature: ok
m_mkfs_overhead: test bg overhead calculation: ok
m_no_opt: no filesystem extensions: ok
m_raid_opt: raid options: ok
m_std: standard filesystem options: ok
m_uninit: uninitialized group feature: ok
r_inline_xattr: shrinking filesystem with in-inode extended attributes: failed
r_move_itable: filesystem resize which requires moving the inode table: ok
r_resize_inode: filesystem resize with a resize_inode present: ./r_resize_inode/script: line 101:  8169 Segmentation fault      $DEBUGFS -R "set_super_value lastcheck 0" -w $TMPFILE > /dev/null 2>&1
./r_resize_inode/script: line 101:  8170 Segmentation fault      $DEBUGFS -R "set_super_value hash_seed null" -w $TMPFILE > /dev/null 2>&1
./r_resize_inode/script: line 101:  8171 Segmentation fault      $DEBUGFS -R "set_super_value mkfs_time 0" -w $TMPFILE > /dev/null 2>&1
ok
u_mke2fs: e2undo with mke2fs: ok
u_tune2fs: e2undo with tune2fs: ok
99 tests succeeded	4 tests failed
make[1]: *** [check] Error 1
make[1]: Leaving directory `/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9/tests'
make: *** [check-recursive] Error 1
]0;root@sfire23:/home/girish/build-dir-e2fsprogs/e2fsprogs-1.41.9[root@sfire23 e2fsprogs-1.41.9]# exit

Script done on Mon 08 Feb 2010 12:23:17 AM MST

--Boundary_(ID_qVCldFmb8XZmsE9VBI9AdQ)--
