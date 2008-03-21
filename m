From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 71/76] jbd: correctly unescape journal data blocks
Date: Fri, 21 Mar 2008 15:44:01 -0700
Message-ID: <20080321224452.154449336@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Duane Griffin <duaneg@dghda.com>,
	Jan Kara <jack@suse.cz>, <linux-ext4@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41301 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbYCUWwO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Mar 2008 18:52:14 -0400
Content-Disposition: inline; filename=jbd-correctly-unescape-journal-data-blocks.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Duane Griffin <duaneg@dghda.com>

Fix a long-standing typo (predating git) that will cause data corruption if a
journal data block needs unescaping.  At the moment the wrong buffer head's
data is being unescaped.

To test this case mount a filesystem with data=journal, start creating and
deleting a bunch of files containing only JFS_MAGIC_NUMBER (0xc03b3998), then
pull the plug on the device.  Without this patch the files will contain zeros
instead of the correct data after recovery.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd/recovery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -478,7 +478,7 @@ static int do_one_pass(journal_t *journa
 					memcpy(nbh->b_data, obh->b_data,
 							journal->j_blocksize);
 					if (flags & JFS_FLAG_ESCAPE) {
-						*((__be32 *)bh->b_data) =
+						*((__be32 *)nbh->b_data) =
 						cpu_to_be32(JFS_MAGIC_NUMBER);
 					}
 

-- 
