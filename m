From: Greg KH <gregkh@suse.de>
Subject: [patch 28/39] jbd2: Add BH_JBDPrivateStart
Date: Wed, 18 Feb 2009 13:33:07 -0800
Message-ID: <20090218213307.GC19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Mark Fasheh <mfasheh@suse.com>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:56341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757236AbZBRVfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:54 -0500
Content-Disposition: inline; filename="jbd2-add-bh_jbdprivatestart.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Fasheh <mfasheh@suse.com>

(cherry picked from commit e97fcd95a4778a8caf1980c6c72fdf68185a0838)

Add this so that file systems using JBD2 can safely allocate unused b_state
bits.

In this case, we add it so that Ocfs2 can define a single bit for tracking
the validation state of a buffer.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/jbd2.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -329,6 +329,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_JBDPrivateStart,	/* First bit available for private use by FS */
 };
 
 BUFFER_FNS(JBD, jbd)

