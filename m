From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Trinity: BUG at fs/ext4/inode.c:1590!
Date: Mon, 20 May 2013 10:27:26 -0500
Message-ID: <519A40DE.2060409@redhat.com>
References: <5199514D.5090606@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab3ETP1a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 11:27:30 -0400
In-Reply-To: <5199514D.5090606@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/19/13 5:25 PM, Toralf F=C3=B6rster wrote:
> The following BUG happened today at a stable Gentoo Linux 32bit syste=
m with stable kernel 3.9.3:

Please say right away, or even in the subject, when you're reporting a =
trinity fuzzer bug.
It helps set the stage for what we're looking at.  :)

> 2013-05-19T23:28:34.195+02:00 n22 kernel: ------------[ cut here ]---=
---------
> 2013-05-19T23:28:34.195+02:00 n22 kernel: kernel BUG at fs/ext4/inode=
=2Ec:1590!

<snip>

> The trinity log files hangs here since about a hour:
> ...

ok so you're running it as:

# trinity -C 4 -V /mnt/n22/v1/v2/ -m

so: 4 children, victim files on /mnt/n22/v1/v2, and monochrome

   PID
   |      child syscall nr
   |      |
> [4673] [415] rt_sigsuspend(unewset=3D0xc0100220, sigsetsize=3D0x5ffde=
f7a) =3D -1 (Invalid argument)
> [4673] [416] munlock(addr=3D0x85c6800, len=3D4096) =3D 0
> [4673] [417] splice(fd_in=3D8, off_in=3D0, fd_out=3D12, off_out=3D0x8=
5c3000[page_0xff], len=3D4097, flags=3D8) =3D 4097
> [4673] [418] fstatat64(dfd=3D12, filename=3D"/mnt/n22/v1/v2/d10", sta=
tbuf=3D0, flag=3D0x284d0014) =3D -1 (Invalid argument)
> [4673] [419] mincore(start=3D1, len=3D0x1000000, vec=3D0x85c0000[page=
_zeros]) =3D -1 (Invalid argument)
> [4673] [420] timer_settime(timer_id=3D0x5f3bdbfa, flags=3D0x3075aee6,=
 new_setting=3D0x85c3000[page_0xff], old_setting=3D0x85c3001) =3D -1 (I=
nvalid argument)
> [4673] [421] syncfs(fd=3D12) [watchdog] pid 4514 hasn't made progress=
 in 30 seconds! (last:1368998898 now:1368998928 diff:30). Stuck in sysc=
all 267:clock_nanosleep. Sending SIGKILL.

hm, and it's telling us (?) that pid 4514 is the one that's stuck, is t=
hat in the logs, should we see what syscalls were done there?

trinity reseeds itself now and then, and prints out the seed it's using=
 at that point.

Gathering at least the seed info would allow the test to be restarted w=
ith that seed (-s option), and in particular see if it's repeatable.

Dave, I had suggested earlier in the thread that an option to specify a=
 seed and a nr. of syscalls to skip would help narrow down what trigger=
s a bug.  i.e. in this case, we could find the last seed (for this chil=
d?) and then run with:

* that seed
* max syscalls 421
* skip the first 400 syscalls

and see if it reproduces.  Keep narrowing the window until we get the s=
mallest set that reproduces.  fsx has something similar to this.

(heh, now I want an option to emit C code to recreate the last N syscal=
ls it's made, for permanent testcases.  I suppose that'd be tough) ;)

-Eric

Here's a really hacky, untested patch that might implement the skipping=
 I'm talking about.  Caveat; I've never actually used trinity.  :)

So if I'm missing something obvious about how to narrow down a failure =
to the call that caused it, I'm all ears.  :)

=3D=3D=3D=3D=3D

trinity: Add option to skip first X syscalls

To narrow down what set of operations triggers a bug, it may
be useful to rerun w/ the same seed, but skip the first X syscalls,
to get the minimum set of calls which causes a problem.

Add an "-X" option to do this.  This is per-child, in the
same way that the -N option is per-child. (I think!)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/syscall.h b/include/syscall.h
index ccbe436..6dc00ec 100644
--- a/include/syscall.h
+++ b/include/syscall.h
@@ -99,6 +99,7 @@ extern const struct syscalltable *syscalls_32bit;
 extern const struct syscalltable *syscalls_64bit;
=20
 extern unsigned long syscalls_todo;
+extern unsigned long syscalls_skip;
 extern unsigned int max_nr_syscalls;
 extern unsigned int max_nr_32bit_syscalls;
 extern unsigned int max_nr_64bit_syscalls;
diff --git a/params.c b/params.c
index c2c3f70..d09c032 100644
--- a/params.c
+++ b/params.c
@@ -64,6 +64,7 @@ static void usage(void)
 	fprintf(stderr, " -N#: do # syscalls then exit.\n");
 	fprintf(stderr, " -p:  pause after syscall.\n");
 	fprintf(stderr, " -s#: use # as random seed.\n");
+	fprintf(stderr, " -X#: skip first # syscalls.\n");
 	exit(EXIT_SUCCESS);
 }
=20
@@ -92,7 +93,7 @@ void parse_args(int argc, char *argv[])
 {
 	int opt;
=20
-	while ((opt =3D getopt_long(argc, argv, "c:C:dDg:hIl:LN:mnP:pqr:s:SV:=
vx:", longopts, NULL)) !=3D -1) {
+	while ((opt =3D getopt_long(argc, argv, "c:C:dDg:hIl:LN:mnP:pqr:s:SV:=
vx:X", longopts, NULL)) !=3D -1) {
 		switch (opt) {
 		default:
 			if (opt =3D=3D '?')
@@ -189,7 +190,9 @@ void parse_args(int argc, char *argv[])
 			seed =3D strtol(optarg, NULL, 10);
 			user_set_seed =3D TRUE;
 			break;
-
+		case 'X':
+			syscalls_skip =3D strtol(optarg, NULL, 10);
+			break;
=20
 		case 'S':
 			do_syslog =3D TRUE;
diff --git a/syscall.c b/syscall.c
index 42ac75e..cc33c52 100644
--- a/syscall.c
+++ b/syscall.c
@@ -83,10 +83,12 @@ static unsigned long do_syscall(int childno, int *e=
rrno_saved)
=20
 	errno =3D 0;
=20
-	if (shm->do32bit[childno] =3D=3D FALSE)
-		ret =3D syscall(nr, a1, a2, a3, a4, a5, a6);
-	else
-		ret =3D syscall32(num_args, nr, a1, a2, a3, a4, a5, a6);
+	if (shm->total_syscalls_done > syscalls_skip) {
+		if (shm->do32bit[childno] =3D=3D FALSE)
+			ret =3D syscall(nr, a1, a2, a3, a4, a5, a6);
+		else
+			ret =3D syscall32(num_args, nr, a1, a2, a3, a4, a5, a6);
+	}
=20
 	*errno_saved =3D errno;
=20
@@ -221,7 +223,8 @@ args_done:
 	sptr +=3D sprintf(sptr, ") ");
 	*sptr =3D '\0';
=20
-	output(2, "%s", string);
+	if (shm->total_syscalls_done >=3D syscalls_skip)
+		output(2, "%s", string);
=20
 	if (dopause =3D=3D TRUE) {
 		synclogs();
@@ -243,6 +246,7 @@ args_done:
 	 */
 	call +=3D SYSCALL_OFFSET;
=20
+	/* do_syscall will skip the actual call if we're still skipping */
 	ret =3D do_syscall(childno, &errno_saved);
=20
 	sptr =3D string;
@@ -262,7 +266,8 @@ args_done:
=20
 	*sptr =3D '\0';
=20
-	output(2, "%s", string);
+	if (shm->total_syscalls_done > syscalls_skip)
+		output(2, "%s", string);
=20
 	/* If the syscall doesn't exist don't bother calling it next time. */
 	if ((ret =3D=3D -1) && (errno_saved =3D=3D ENOSYS)) {
diff --git a/tables.c b/tables.c
index 2bccd83..de11fb5 100644
--- a/tables.c
+++ b/tables.c
@@ -19,6 +19,7 @@ const struct syscalltable *syscalls_32bit;
 const struct syscalltable *syscalls_64bit;
=20
 unsigned long syscalls_todo =3D 0;
+unsigned long syscalls_skip =3D 0;
=20
 unsigned int max_nr_syscalls;
 unsigned int max_nr_32bit_syscalls;


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
