From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH XFSTESTS 3/3] dmapi: fix build failure if libdm is provided via -ldm
Date: Thu, 21 Jul 2011 19:52:04 -0400
Message-ID: <1311292324-4348-3-git-send-email-tytso@mit.edu>
References: <1311292324-4348-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49503 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab1GUXwG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 19:52:06 -0400
In-Reply-To: <1311292324-4348-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The value of $(LIBDM) may be a linker specification -ldm, and not a
file.  So it's not OK to add this to the dependency, since make will
then complain that it doesn't know how to make the target -ldm.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 dmapi/src/common/cmd/Makefile                  |    2 +-
 dmapi/src/sample_hsm/Makefile                  |    2 +-
 dmapi/src/suite1/cmd/Makefile                  |    2 +-
 dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c |    2 +-
 dmapi/src/suite2/src/Makefile                  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/dmapi/src/common/cmd/Makefile b/dmapi/src/common/cmd/Makefile
index 4b0e550..4525581 100644
--- a/dmapi/src/common/cmd/Makefile
+++ b/dmapi/src/common/cmd/Makefile
@@ -38,7 +38,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
diff --git a/dmapi/src/sample_hsm/Makefile b/dmapi/src/sample_hsm/Makefile
index 7a4ca8c..55df563 100644
--- a/dmapi/src/sample_hsm/Makefile
+++ b/dmapi/src/sample_hsm/Makefile
@@ -38,7 +38,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
diff --git a/dmapi/src/suite1/cmd/Makefile b/dmapi/src/suite1/cmd/Makefile
index 7e51763..05dbead 100644
--- a/dmapi/src/suite1/cmd/Makefile
+++ b/dmapi/src/suite1/cmd/Makefile
@@ -61,7 +61,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
diff --git a/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c b/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
index 6b4d0b6..c01dff0 100644
--- a/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
+++ b/dmapi/src/suite1/cmd/probe_punch_xfsctl_hole.c
@@ -69,7 +69,7 @@ xfsctl_punch_hole(
 	xfs_flock64_t   flock;
 	int		fd;
 	
-	if ((fd = open(path, O_RDWR|O_CREAT)) < 0) {
+	if ((fd = open(path, O_RDWR|O_CREAT, 0600)) < 0) {
 		perror(path);
 		exit(errno);
 	}
diff --git a/dmapi/src/suite2/src/Makefile b/dmapi/src/suite2/src/Makefile
index 91a0f00..c5cf6da 100644
--- a/dmapi/src/suite2/src/Makefile
+++ b/dmapi/src/suite2/src/Makefile
@@ -44,7 +44,7 @@ include $(BUILDRULES)
 
 install install-dev: default
 
-$(TARGETS): $(LLDLIBS)
+$(TARGETS):
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
-- 
1.7.4.1.22.gec8e1.dirty

