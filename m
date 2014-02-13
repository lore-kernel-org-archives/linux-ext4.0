From: Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] ext4: address a benign compiler warning
Date: Wed, 12 Feb 2014 23:12:04 -0500
Message-ID: <1392264724-10542-1-git-send-email-patrick@parcs.ath.cx>
References: <CA+C-WL9ARNvOqeA4n5Abnja+99O4F1VdMDUPjuRCcXiVsMTc7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, joe@perches.com,
	Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f50.google.com ([209.85.216.50]:32934 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaBMEMW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Feb 2014 23:12:22 -0500
Received: by mail-qa0-f50.google.com with SMTP id cm18so15600027qab.9
        for <linux-ext4@vger.kernel.org>; Wed, 12 Feb 2014 20:12:21 -0800 (PST)
In-Reply-To: <CA+C-WL9ARNvOqeA4n5Abnja+99O4F1VdMDUPjuRCcXiVsMTc7A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as a
no_printk() statement instead of an empty statement in order to suppres=
s
the following compiler warning:

fs/ext4/mballoc.c: In function =E2=80=98ext4_mb_cleanup_pa=E2=80=99:
fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body in=
 an =E2=80=98if=E2=80=99 statement [-Wempty-body]
   mb_debug(1, "mballoc: %u PAs left\n", count);

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 fs/ext4/mballoc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 08481ee..9347328 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -48,7 +48,7 @@ extern ushort ext4_mballoc_debug;
 		}							\
 	} while (0)
 #else
-#define mb_debug(n, fmt, a...)
+#define mb_debug(n, fmt, a...)		no_printk(fmt, ## a)
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
