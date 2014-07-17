From: Mason <mpeg.blue@free.fr>
Subject: Re: After unlinking a large file on ext4, the process stalls for a
 long time
Date: Thu, 17 Jul 2014 13:17:11 +0200
Message-ID: <53C7B0B7.9030007@free.fr>
References: <53C687B1.30809@free.fr>
	<21446.38705.190786.631403@quad.stoffel.home> <53C6B38A.3000100@free.fr>
	<59C3F41A-6AFD-418E-BCE6-2361B8140D9A@dilger.ca> <53C7A5CA.4050903@free.fr>
	<alpine.LFD.2.00.1407171238060.2312@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: =?iso-8859-2?b?THVr4bk=?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:42621 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbaGQLQZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2014 07:16:25 -0400
In-Reply-To: <alpine.LFD.2.00.1407171238060.2312@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Luk=E1=A8 Czerner wrote:

> So it really does not seem to be stalling in fallocate, nor unlink.
> Can you add close() before unlink, just to be sure what's happening
> there ?

Doh! Good catch! Unlinking was fast because the ref count didn't drop
to 0 on unlink, it did so on the implicit close done on exit, which
would explain why the process stalled "at the end".

If I unlink a closed file, it is indeed unlink that stalls.

[BTW, some of the e2fsprogs devs may be reading this. I suppose you
already know, but the cross-compile build was broken in 1.4.10.
I wrote a trivial patch to fix it (cf. the end of this message)
although I'm not sure I did it the canonical way.]


# time strace -T ./foo /mnt/hdd/xxx 300 2> strace.out
posix_fallocate(fd, 0, size_in_GiB << 30): 0 [412 ms]
close(fd): 0 [0 ms]
unlink(filename): 0 [111481 ms]

open("/mnt/hdd/xxx", O_WRONLY|O_CREAT|O_EXCL|O_LARGEFILE, 0600) =3D 3 <=
0.000456>
clock_gettime(CLOCK_MONOTONIC, {82152, 251657385}) =3D 0 <0.000085>
SYS_4320()                              =3D 0 <0.411628>
clock_gettime(CLOCK_MONOTONIC, {82152, 664179762}) =3D 0 <0.000089>
fstat64(1, {st_mode=3DS_IFCHR|0755, st_rdev=3Dmakedev(4, 64), ...}) =3D=
 0 <0.000094>
ioctl(1, TIOCNXCL, {B115200 opost isig icanon echo ...}) =3D 0 <0.00012=
8>
old_mmap(NULL, 65536, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, =
-1, 0) =3D 0x773e4000 <0.000195>
write(1, "posix_fallocate(fd, 0, size_in_G"..., 54) =3D 54 <0.000281>
clock_gettime(CLOCK_MONOTONIC, {82152, 668413115}) =3D 0 <0.000077>
close(3)                                =3D 0 <0.000119>
clock_gettime(CLOCK_MONOTONIC, {82152, 669249479}) =3D 0 <0.000129>
write(1, "close(fd): 0 [0 ms]\n", 20)   =3D 20 <0.000145>
clock_gettime(CLOCK_MONOTONIC, {82152, 670361133}) =3D 0 <0.000078>
unlink("/mnt/hdd/xxx")                  =3D 0 <111.479283>
clock_gettime(CLOCK_MONOTONIC, {82264, 150551496}) =3D 0 <0.000080>
write(1, "unlink(filename): 0 [111481 ms]\n", 32) =3D 32 <0.000225>
exit_group(0)                           =3D ?

0.01user 111.48system 1:51.99elapsed 99%CPU (0avgtext+0avgdata 772maxre=
sident)k
0inputs+0outputs (0major+434minor)pagefaults 0swaps


=46or reference, here's my minimal test case:

#define _FILE_OFFSET_BITS 64
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <time.h>

#define BENCH(op) do { \
  struct timespec t0; clock_gettime(CLOCK_MONOTONIC, &t0); \
  int err =3D op; \
  struct timespec t1; clock_gettime(CLOCK_MONOTONIC, &t1); \
  int ms =3D (t1.tv_sec-t0.tv_sec)*1000 + (t1.tv_nsec-t0.tv_nsec)/10000=
00; \
  printf("%s: %d [%d ms]\n", #op, err, ms); } while(0)

int main(int argc, char **argv)
{
  if (argc !=3D 3) { puts("Usage: prog filename size"); return 42; }

  char *filename =3D argv[1];
  int fd =3D open(filename, O_CREAT | O_EXCL | O_WRONLY, 0600);
  if (fd < 0) { perror("open"); return 1; }

  long long size_in_GiB =3D atoi(argv[2]);
  BENCH(posix_fallocate(fd, 0, size_in_GiB << 30));
  BENCH(close(fd));
  BENCH(unlink(filename));
  return 0;
}


$ cat e2fsprogs-1.42.10.patch=20
diff -ur a/util/Makefile.in b/util/Makefile.in
--- a/util/Makefile.in	2014-05-15 19:04:08.000000000 +0200
+++ b/util/Makefile.in	2014-07-10 15:31:04.819352596 +0200
@@ -15,7 +15,7 @@
=20
 .c.o:
 	$(E) "	CC $<"
-	$(Q) $(BUILD_CC) -c $(BUILD_CFLAGS) $< -o $@
+	$(Q) $(BUILD_CC) $(CPPFLAGS) -c $(BUILD_CFLAGS) $< -o $@
 	$(Q) $(CHECK_CMD) $(ALL_CFLAGS) $<
=20
 PROGS=3D		subst symlinks



--=20
Regards.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
