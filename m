From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/6] xfstests: fsstress punch should always have FALLOC_FL_KEEP_SIZE set
Date: Tue, 25 Feb 2014 20:15:25 +0100
Message-ID: <1393355728-12056-3-git-send-email-lczerner@redhat.com>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 4c3368f..42c8a5a 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2555,8 +2555,8 @@ punch_f(int opno, long r)
 	off = (off64_t)(lr % MIN(stb.st_size + (1024 * 1024), MAXFSIZE));
 	off %= maxfsize;
 	len = (off64_t)(random() % (1024 * 1024));
-	mode |= FALLOC_FL_KEEP_SIZE & random();
 	e = fallocate(fd, mode, (loff_t)off, (loff_t)len) < 0 ? errno : 0;
+	mode |= FALLOC_FL_KEEP_SIZE;
 	if (v)
 		printf("%d/%d: punch hole(%d) %s %s %lld %lld %d\n",
 		       procid, opno, mode,
-- 
1.8.3.1

