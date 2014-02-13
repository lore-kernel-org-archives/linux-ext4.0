From: Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] ext4: address a benign compiler warning
Date: Wed, 12 Feb 2014 21:13:13 -0500
Message-ID: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:51037 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaBMCNs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Feb 2014 21:13:48 -0500
Received: by mail-qc0-f176.google.com with SMTP id e16so16676134qcx.21
        for <linux-ext4@vger.kernel.org>; Wed, 12 Feb 2014 18:13:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as an
empty do-while statement so as to suppress the following compiler
warning:

fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_cleanup_pa=E2=80=99:
fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body in=
 an =E2=80=98if=E2=80=99 statement [-Wempty-body]
   mb_debug(1, "mballoc: %u PAs left\n", count);

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 fs/ext4/mballoc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 08481ee..92eeb98 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -48,7 +48,7 @@ extern ushort ext4_mballoc_debug;
 		}							\
 	} while (0)
 #else
-#define mb_debug(n, fmt, a...)
+#define mb_debug(n, fmt, a...)		do { } while (0)
 #endif
=20
 #define EXT4_MB_HISTORY_ALLOC		1	/* allocation */
--=20
1.9.0.rc3

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
