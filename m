From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 10/10] libss: fix memory leak if realloc() fails in ss_parse()
Date: Tue,  7 Jan 2014 09:53:14 -0500
Message-ID: <1389106394-31898-10-git-send-email-tytso@mit.edu>
References: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46606 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaAGOxW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Jan 2014 09:53:22 -0500
In-Reply-To: <1389106394-31898-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Addresses-Coverity-Id: #709491

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ss/parse.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/ss/parse.c b/lib/ss/parse.c
index e2928e2..45a2de0 100644
--- a/lib/ss/parse.c
+++ b/lib/ss/parse.c
@@ -45,7 +45,7 @@ enum parse_mode { WHITESPACE, TOKEN, QUOTED_STRING };
 
 char **ss_parse(int sci_idx, register char *line_ptr, int *argc_ptr)
 {
-    register char **argv, *cp;
+    register char **argv, **new_argv, *cp;
     register int argc;
     register enum parse_mode parse_mode;
 
@@ -78,7 +78,13 @@ char **ss_parse(int sci_idx, register char *line_ptr, int *argc_ptr)
 		/* go to quoted-string mode */
 		parse_mode = QUOTED_STRING;
 		cp = line_ptr++;
-		argv = NEW_ARGV (argv, argc);
+		new_argv = NEW_ARGV (argv, argc);
+		if (new_argv == NULL) {
+			free(argv);
+			*argc_ptr = 0;
+			return NULL;
+		}
+		argv = new_argv;
 		argv[argc++] = cp;
 		argv[argc] = NULL;
 	    }
@@ -86,11 +92,13 @@ char **ss_parse(int sci_idx, register char *line_ptr, int *argc_ptr)
 		/* random-token mode */
 		parse_mode = TOKEN;
 		cp = line_ptr;
-		argv = NEW_ARGV (argv, argc);
+		new_argv = NEW_ARGV (argv, argc);
 		if (argv == NULL) {
-			*argc_ptr = errno;
-			return argv;
+			free(argv);
+			*argc_ptr = 0;
+			return NULL;
 		}
+		argv = new_argv;
 		argv[argc++] = line_ptr;
 		argv[argc] = NULL;
 	    }
-- 
1.8.5.rc3.362.gdf10213

