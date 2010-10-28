From: Ingo Molnar <mingo@elte.hu>
Subject: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Date: Thu, 28 Oct 2010 16:39:24 +0200
Message-ID: <20101028143924.GA6985@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:32941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835Ab0J1Oje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 10:39:34 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Today's -tip fails to build on !CONFIG_BLOCK, due to upstream commit 36=
7a51a ("fs:=20
Add FITRIM ioctl"):

 include/linux/fs.h:36: error: expected specifier-qualifier-list before=
 =E2=80=98uint64_t=E2=80=99
 include/linux/fs.h:36: error: expected specifier-qualifier-list before=
 =E2=80=98uint64_t=E2=80=99
 include/linux/fs.h:36: error: expected specifier-qualifier-list before=
 =E2=80=98uint64_t=E2=80=99

The commit adds uint64_t type usage to fs.h, but linux/types.h is not i=
ncluded=20
explicitly - it's only included implicitly via linux/blk_types.h, and t=
here only if=20
CONFIG_BLOCK is enabled.

Add the explicit #include to fix this.

Ob'grumpy'tester: this commit has a commit date of yesterday, that equa=
ls author=20
date while author !=3D committer - how is that possible? Also, the comm=
it was merged=20
upstream a few hours after that.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6ed7ace..1c73b50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -9,6 +9,7 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
+#include <linux/types.h>
=20
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
