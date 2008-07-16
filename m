From: Theodore Tso <tytso@mit.edu>
Subject: [PATCH, RFC] Add more intelligent handling of the mke2fs.conf
	installation process
Date: Wed, 16 Jul 2008 13:52:57 -0400
Message-ID: <20080716175257.GF2167@mit.edu>
References: <E1KITeX-0001PV-Pv@closure.thunk.org> <487BAA6B.7030001@redhat.com> <20080714195526.GA3382@mit.edu> <1216172323.8292.23.camel@mingming-laptop> <20080716023532.GO8185@mit.edu> <1216227720.6424.7.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47740 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbYGPRxA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 13:53:00 -0400
Content-Disposition: inline
In-Reply-To: <1216227720.6424.7.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 16, 2008 at 10:02:00AM -0700, Mingming Cao wrote:
> I looked at misc/Makefile, it seems if the system already
> have /etc/mke2fs.conf, it will not get updated. This is reasonable for
> ext3.   But not good for ext4.

Good point.  The following patch won't do anything for people building
RPM or dpkg packages (which have their own automatic configuration
file handling); this will provide a poor person's config handling
machinery for people building e2fsprogs and the installing on their
own local system.

						- Ted

>From f8e42224f8cc77afd2b2372dc527428072e28519 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 16 Jul 2008 13:39:32 -0400
Subject: [PATCH] Add more intelligent handling of the mke2fs.conf installation process

For people who are compiling mke2fs for their own use outside of a
package manager, we need to make sure the system /etc/mke2fs.conf is
sufficiently up-to-date that it won't cause problems, but at the same
time we don't want to blow away any user-specific customizations.

So if /etc/mk2fs.conf exists, but does not mention ext4dev, we will
move it aside to /etc/mke2fs.conf.e2fsprogs-old and then install the
new mke2fs.conf.  If the /etc/mke2fs.conf file exists but does mention
ext4dev, we install the new mke2fs.conf file as
/etc/mke2fs.conf.e2fsprogs-new.  In both we print warning to the user
so they can manually make any changes as needed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/Makefile.in |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index a8d1018..a81df8a 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -343,7 +343,30 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		echo "	INSTALL_DATA $(man5dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
 	done
-	@if ! test -f $(DESTDIR)$(root_sysconfdir)/mke2fs.conf; then \
+	@if test -f $(DESTDIR)$(root_sysconfdir)/mke2fs.conf; then \
+		if cmp -s $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
+			$(srcdir)/mke2fs.conf; then \
+			true; \
+		else \
+			if grep -q ext4dev $(DESTDIR)$(root_sysconfdir)/mke2fs.conf ; then \
+				echo "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
+				$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
+					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new; \
+				echo "Warning: installing mke2fs.conf in $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
+				echo "Check to see if you need to update your $(root_sysconfdir)/mke2fs.conf"; \
+			else \
+				echo "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
+				mv $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
+				   $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old; \
+				$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
+					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
+				echo "Your mke2fs.conf is too old.  Backing up old version in"; \
+				echo "$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old.  Please check to see"; \
+				echo "if you have any local customizations that you wish to preserve."; \
+			fi; \
+			echo " "; \
+		fi; \
+	else \
 		echo "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
 		$(INSTALL_DATA) $(srcdir)/mke2fs.conf \
 			$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
-- 
1.5.6.1.205.ge2c7.dirty

