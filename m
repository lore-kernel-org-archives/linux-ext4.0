From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 26/74] libss: fix memory handling errors
Date: Tue, 10 Dec 2013 17:21:15 -0800
Message-ID: <20131211012115.30655.51030.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26472 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3LKBVU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:20 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix memory allocation calculations and check for NULL pointer returns.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ss/invocation.c  |    5 +++++
 lib/ss/parse.c       |    4 ++++
 lib/ss/request_tbl.c |    2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)


diff --git a/lib/ss/invocation.c b/lib/ss/invocation.c
index a711050..08b66f2 100644
--- a/lib/ss/invocation.c
+++ b/lib/ss/invocation.c
@@ -20,6 +20,7 @@
 #ifdef HAVE_DLOPEN
 #include <dlfcn.h>
 #endif
+#include <errno.h>
 
 int ss_create_invocation(subsystem_name, version_string, info_ptr,
 			 request_table_ptr, code_ptr)
@@ -46,6 +47,10 @@ int ss_create_invocation(subsystem_name, version_string, info_ptr,
 		;
 	table = (ss_data **) realloc((char *)table,
 				     ((unsigned)sci_idx+2)*size);
+	if (table == NULL) {
+		*code_ptr = errno;
+		return 0;
+	}
 	table[sci_idx+1] = (ss_data *) NULL;
 	table[sci_idx] = new_table;
 
diff --git a/lib/ss/parse.c b/lib/ss/parse.c
index b70ad16..baded66 100644
--- a/lib/ss/parse.c
+++ b/lib/ss/parse.c
@@ -90,6 +90,10 @@ char **ss_parse (sci_idx, line_ptr, argc_ptr)
 		parse_mode = TOKEN;
 		cp = line_ptr;
 		argv = NEW_ARGV (argv, argc);
+		if (argv == NULL) {
+			*argc_ptr = errno;
+			return argv;
+		}
 		argv[argc++] = line_ptr;
 		argv[argc] = NULL;
 	    }
diff --git a/lib/ss/request_tbl.c b/lib/ss/request_tbl.c
index b0b6f95..efdabfa 100644
--- a/lib/ss/request_tbl.c
+++ b/lib/ss/request_tbl.c
@@ -35,7 +35,7 @@ void ss_add_request_table(sci_idx, rqtbl_ptr, position, code_ptr)
 		;
 	/* size == C subscript of NULL == #elements */
 	size += 2;		/* new element, and NULL */
-	t = (ssrt **)realloc(info->rqt_tables, (unsigned)size*sizeof(ssrt));
+	t = (ssrt **)realloc(info->rqt_tables, (unsigned)size*sizeof(ssrt *));
 	if (t == (ssrt **)NULL) {
 		*code_ptr = errno;
 		return;

