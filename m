From: Theodore Tso <tytso@mit.edu>
Subject: Re: commit a4b69b7f1809898c87bdc11502ca258a8f16a220 breaks
	parallel builds
Date: Sun, 11 May 2008 20:38:17 -0400
Message-ID: <20080512003816.GA25012@mit.edu>
References: <48226C3B.5060007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49425 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395AbYELDW3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 May 2008 23:22:29 -0400
Content-Disposition: inline
In-Reply-To: <48226C3B.5060007@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 07, 2008 at 09:58:03PM -0500, Eric Sandeen wrote:
> 
> I tried looking into this, but I'm at a bit of a loss as to what the
> change was trying to do, so not sure how to fix it... but from
> e2fsprogs/lib/uuid/ it would appear that the addition of
> $(LIB)/$(LIBRARY).a here has got us backing up one ".." too far :)

Here's the fix which I've checked into the git repository.

       	       	     	  	       	   - Ted

>From b93cb0664e1e118e2d5f6788152cb876ad3f13bc Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 11 May 2008 20:34:12 -0400
Subject: [PATCH] Fix parallel build problem

Problem was introduced by commit a4b69b7f1809898c87bdc11502ca258a8f16a220

Thanks to Eric Sandeen from Red Hat for pointing out this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/Makefile.library |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/Makefile.library b/lib/Makefile.library
index 52f28bb..7d9e99f 100644
--- a/lib/Makefile.library
+++ b/lib/Makefile.library
@@ -13,7 +13,7 @@ subdirs:: Makefile
 clean::
 	@$(RM) -f subdirs
 
-$(LIB)/$(LIBRARY).a $(LIBRARY).a: $(OBJS)
+$(LIBRARY).a: $(OBJS)
 	@echo "	GEN_LIB $@"
 	@(if test -r $@; then $(RM) -f $@.bak && $(MV) $@ $@.bak; fi)
 	@$(ARGEN) $@ $(OBJS)
@@ -21,3 +21,4 @@ $(LIB)/$(LIBRARY).a $(LIBRARY).a: $(OBJS)
 	@$(RM) -f ../$@
 	@$(LN) $@ ../$@
 
+$(LIB)/$(LIBRARY).a: $(LIBRARY).a
-- 
1.5.4.1.144.gdfee-dirty

