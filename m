From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/3][e2fsprogs] fix a typo in lib/e2p/Makefile.in
Date: Wed, 06 Aug 2008 17:09:11 +0800
Message-ID: <48996A37.1060401@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760320AbYHFJKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 05:10:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 lib/e2p/Makefile.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 494ecd2..6557480 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -28,7 +28,7 @@ SRCS=		$(srcdir)/feature.c $(srcdir)/fgetflags.c \
 		$(srcdir)/ls.c $(srcdir)/mntopts.c $(srcdir)/parse_num.c \
 		$(srcdir)/pe.c $(srcdir)/pf.c $(srcdir)/ps.c \
 		$(srcdir)/setflags.c $(srcdir)/setversion.c $(srcdir)/uuid.c \
-		$(srcdir)/ostype.c $(srcdir)/percent.o
+		$(srcdir)/ostype.c $(srcdir)/percent.c
 HFILES= e2p.h
 
 LIBRARY= libe2p
-- 
1.5.4.rc3

