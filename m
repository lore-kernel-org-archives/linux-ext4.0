From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] e4defrag: fix build when posix_fadvise is missing
Date: Wed,  1 Jan 2014 12:28:23 +0200
Message-ID: <33245e3808058c72b66931ac14aea8d5dc6d1ba5.1388572103.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:43183 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaAAK3c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Jan 2014 05:29:32 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

uClibc declares posix_fadvise() even when the architecture does not pro=
vide
one. The static posix_fadvise() signature is not compatible with POSIX.=
 Rename
the internal implementation to fix this. Fixes the following build fail=
ure
when building against uClibc:

e4defrag.c:189:2: warning: #warning Using locally defined posix_fadvise=
 interface. [-Wcpp]
e4defrag.c:203:12: error: conflicting types for =E2=80=98posix_fadvise=E2=
=80=99

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 misc/e4defrag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index c6a5f0d..4e84a74 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -200,7 +200,8 @@ static struct frag_statistic_ino	frag_rank[SHOW_FRA=
G_FILES];
  * @len:		area length.
  * @advise:		process flag.
  */
-static int posix_fadvise(int fd, loff_t offset, size_t len, int advise=
)
+#define posix_fadvise	__posix_fadvise
+static int __posix_fadvise(int fd, loff_t offset, size_t len, int advi=
se)
 {
 	return syscall(__NR_fadvise64_64, fd, offset, len, advise);
 }
--=20
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
