From: Theodore Ts'o <tytso@mit.edu>
Subject: Ext4 patches for the next merge window
Date: Sat,  5 Jul 2008 13:35:26 -0400
Message-ID: <1215279378-30504-1-git-send-email-tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33011 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753088AbYGERgX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following set of patches are being prepared for pushing to Linus
during the next patch window.  Aside from a large number of cleanups
the big new feature in this patchset is delayed allocation support.

I've been running this patch series on my laptop for the past couple
of days in production, and it's been working quite well for me.

   	   	       	   	     - Ted


