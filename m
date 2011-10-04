From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] libquota: remove NLS support
Date: Tue,  4 Oct 2011 12:16:38 -0400
Message-ID: <1317744998-8238-5-git-send-email-tytso@mit.edu>
References: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Cc: Aditya Kali <adityakali@google.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43543 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab1JDQQq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Oct 2011 12:16:46 -0400
In-Reply-To: <1317744998-8238-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In general libraries should never (a) call exit() or (b) print output
directly to the stdout (they might be used by GUI programs.  From (b)
follows (c), should never call internationalization functions
directly.

Also, since po/POTFILES.in wasn't edited, these strings weren't
getting included in e2fsprogs.pot for translation, so the _()
indirection didn't actually buy us anything.

We eventually need to nuke all of the log_fatal() and log_err() from
libquota, so best thing to do for now is remove NLS support
completely; no point whipsawing the translators with strings to
translate that will be disappearing soon anyway!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/quota/common.h |   30 ++++--------------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/lib/quota/common.h b/lib/quota/common.h
index 48f191f..7b88003 100644
--- a/lib/quota/common.h
+++ b/lib/quota/common.h
@@ -13,41 +13,19 @@
 # endif
 #endif
 
-#ifdef ENABLE_NLS
-#include <libintl.h>
-#include <locale.h>
-#define _(a) (gettext (a))
-#ifdef gettext_noop
-#define N_(a) gettext_noop (a)
-#else
-#define N_(a) (a)
-#endif
-#define P_(singular, plural, n) (ngettext (singular, plural, n))
-#ifndef NLS_CAT_NAME
-#define NLS_CAT_NAME "e2fsprogs"
-#endif
-#ifndef LOCALEDIR
-#define LOCALEDIR "/usr/share/locale"
-#endif
-#else
-#define _(a) (a)
-#define N_(a) a
-#define P_(singular, plural, n) ((n) == 1 ? (singular) : (plural))
-#endif
-
 #define log_fatal(exit_code, format, ...)	do { \
-		fprintf(stderr, _("[FATAL] %s:%d:%s:: " format "\n"), \
+		fprintf(stderr, "[FATAL] %s:%d:%s:: " format "\n", \
 			__FILE__, __LINE__, __func__, __VA_ARGS__); \
 		exit(exit_code); \
 	} while (0)
 
 #define log_err(format, ...)	fprintf(stderr, \
-				_("[ERROR] %s:%d:%s:: " format "\n"), \
+				"[ERROR] %s:%d:%s:: " format "\n", \
 				__FILE__, __LINE__, __func__, __VA_ARGS__)
 
 #ifdef DEBUG_QUOTA
 # define log_debug(format, ...)	fprintf(stderr, \
-				_("[DEBUG] %s:%d:%s:: " format "\n"), \
+				"[DEBUG] %s:%d:%s:: " format "\n", \
 				__FILE__, __LINE__, __func__, __VA_ARGS__)
 #else
 # define log_debug(format, ...)
@@ -55,7 +33,7 @@
 
 #define BUG_ON(x)		do { if ((x)) { \
 					fprintf(stderr, \
-						_("BUG_ON: %s:%d:: ##x"), \
+						"BUG_ON: %s:%d:: ##x", \
 						__FILE__, __LINE__); \
 					exit(2); \
 				} } while (0)
-- 
1.7.4.1.22.gec8e1.dirty

