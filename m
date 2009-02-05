From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] Fix possible NULL pointer dereference in JBD2
Date: Thu,  5 Feb 2009 15:52:59 +0100
Message-ID: <1233845582-954-1-git-send-email-jack@suse.cz>
References: <y>
Cc: Andrew Morton <akpm@linux-foundation.org>, mfasheh@suse.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35079 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756405AbZBEOxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2009 09:53:06 -0500
In-Reply-To: <y>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hi,

  the three patches below fix a bug in jbd2_journal_begin_ordered_truncate() that
could possibly lead to NULL pointer dereference. The question is how to merge
the fix as it changes the prototype of the function and both ext4 and ocfs2 use it.
Mark, Mingming, any suggestions?

                                                                                Honza
