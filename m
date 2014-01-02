From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] e4defrag: choose the best available posix_fadvise variant
Date: Thu,  2 Jan 2014 08:43:54 +0200
Message-ID: <23c2b99441922fe311235e241eca52e9701e54d4.1388645034.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:43927 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaABGoD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jan 2014 01:44:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use posix_fadvise64() when available. This allows 64bit offsets on 32bi=
t
systems.

Rename the internal posix_fadvise() implementation to avoid collision w=
ith the
C library signature that is sometimes present event when the implementa=
tion
itself is not. This fixes build errors like:

e4defrag.c:189:2: warning: #warning Using locally defined posix_fadvise=
 interface. [-Wcpp
e4defrag.c:203:12: error: conflicting types for =E2=80=98posix_fadvise=E2=
=80=99

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 configure.in    |  1 +
 misc/e4defrag.c | 27 +++++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/configure.in b/configure.in
index fef8d9b7b935..9f13a46ac8ae 100644
--- a/configure.in
+++ b/configure.in
@@ -1102,6 +1102,7 @@ AC_CHECK_FUNCS(m4_flatten([
 	open64
 	pathconf
 	posix_fadvise
+	posix_fadvise64
 	posix_memalign
 	prctl
 	secure_getenv
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c6a5f0daef96..b28c26538bfc 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -183,13 +183,27 @@ static ext4_fsblk_t	files_block_count;
 static struct frag_statistic_ino	frag_rank[SHOW_FRAG_FILES];
=20
=20
-/* Local definitions of some syscalls glibc may not yet have */
+/* Local definitions of some syscalls glibc may not yet have
+ *
+ * We prefer posix_fadvise64 when available, as it allows 64bit offset=
 on
+ * 32bit systems
+ */
+
+#if defined(HAVE_POSIX_FADVISE64)
+#define posix_fadvise	posix_fadvise64
+#elif defined(__NR_fadvise64_64)
+#define FADVISE_SYSCALL_NR	__NR_fadvise64_64
+#elif defined(HAVE_POSIX_FADVISE)
+#define posix_fadvise	posix_fadvise
+#elif defined(__NR_fadvise64)
+#define FADVISE_SYSCALL_NR	__NR_fadvise64
+#endif
=20
-#ifndef HAVE_POSIX_FADVISE
+#ifndef posix_fadvise
 #warning Using locally defined posix_fadvise interface.
=20
-#ifndef __NR_fadvise64_64
-#error Your kernel headers dont define __NR_fadvise64_64
+#ifndef FADVISE_SYSCALL_NR
+#error Your kernel headers dont define __NR_fadvise64_64 or __NR_fadvi=
se64
 #endif
=20
 /*
@@ -200,9 +214,10 @@ static struct frag_statistic_ino	frag_rank[SHOW_FR=
AG_FILES];
  * @len:		area length.
  * @advise:		process flag.
  */
-static int posix_fadvise(int fd, loff_t offset, size_t len, int advise=
)
+#define posix_fadvise	__posix_fadvise
+static int __posix_fadvise(int fd, loff_t offset, size_t len, int advi=
se)
 {
-	return syscall(__NR_fadvise64_64, fd, offset, len, advise);
+	return syscall(FADVISE_SYSCALL_NR, fd, offset, len, advise);
 }
 #endif /* ! HAVE_FADVISE64_64 */
=20
--=20
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
