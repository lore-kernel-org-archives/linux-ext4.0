From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] - remove timestamps from .po files
Date: Mon, 05 Nov 2007 15:13:54 -0600
Message-ID: <472F8792.6030808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbXKEVOB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 16:14:01 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.1) with ESMTP id lA5LE0FW016586
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 16:14:00 -0500
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id lA5LDxpR005856
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 16:13:59 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id lA5LDtVF017204
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 16:13:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Another one that's been in RH/Fedora specfiles a while.
Remove timestamps from .po files to avoid multilib conflicts.
It ain't pretty but it works.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Addresses-Red-Hat-Bugzilla: #245653

Index: e2fsprogs-git/po/Makefile.in.in
===================================================================
--- e2fsprogs-git.orig/po/Makefile.in.in
+++ e2fsprogs-git/po/Makefile.in.in
@@ -118,10 +118,12 @@ $(DOMAIN).pot-update: $(POTFILES) $(srcd
 	      rm -f $(DOMAIN).1po $(DOMAIN).2po $(DOMAIN).po; \
 	    else \
 	      rm -f $(DOMAIN).1po $(DOMAIN).2po $(srcdir)/$(DOMAIN).pot && \
-	      mv $(DOMAIN).po $(srcdir)/$(DOMAIN).pot; \
+	      sed -f remove-potcdate.sed < $(DOMAIN).po > $(srcdir)/$(DOMAIN).pot && \
+	      rm -f $(DOMAIN).po; \
 	    fi; \
 	  else \
-	    mv $(DOMAIN).po $(srcdir)/$(DOMAIN).pot; \
+	    sed -f remove-potcdate.sed < $(DOMAIN).po > $(srcdir)/$(DOMAIN).pot && \
+	    rm -f $(DOMAIN).po; \
 	  fi; \
 	}
 
