From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH -next] jbd2: fix build when CONFIG_BUG is not enabled
Date: Tue, 11 Oct 2011 12:15:20 -0700
Message-ID: <4E9495C8.1030200@xenotime.net>
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when CONFIG_BUG is not enabled:

fs/jbd2/transaction.c:1175:3: error: implicit declaration of function '__WARN'

by changing __WARN() to WARN_ON(), as suggested by
Arnaud Lacombe <lacombar@gmail.com>.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>
---

Same build error as reported on 31-AUG-2011 for
linux-next 20110830.

 fs/jbd2/transaction.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- next-2011-1011.orig/fs/jbd2/transaction.c
+++ next-2011-1011/fs/jbd2/transaction.c
@@ -27,6 +27,7 @@
 #include <linux/highmem.h>
 #include <linux/hrtimer.h>
 #include <linux/backing-dev.h>
+#include <linux/bug.h>
 #include <linux/module.h>
 
 static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh);
@@ -1171,8 +1172,7 @@ out_unlock_bh:
 	jbd_unlock_bh_state(bh);
 out:
 	JBUFFER_TRACE(jh, "exit");
-	if (ret)
-		__WARN();	/* All errors are bugs, so dump the stack */
+	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
 	return ret;
 }
 
