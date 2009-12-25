From: tytso@mit.edu
Subject: Re: [PATCH] jbd: jbd-debug and jbd2-debug should be writable.
Date: Fri, 25 Dec 2009 15:48:59 -0500
Message-ID: <20091225204859.GG32757@thunk.org>
References: <20091204031735.GN19635@kai-debian>
 <20091204094932.GC4272@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Yin, Kangkai" <kangkai.yin@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:35107 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbZLYUtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Dec 2009 15:49:06 -0500
Content-Disposition: inline
In-Reply-To: <20091204094932.GC4272@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4 portion has been added to the ext4 patch queue.

Jan, you want to add this to the ext3 tree?

					- Ted

jbd: /sys/kernel/debug/jbd/jbd-debug should be writable.

From: "Yin, Kangkai" <kangkai.yin@intel.com>

Make this sysfs file writeable so we can enable debugging without
needing to reboot and futzing with boot command-line option.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd/journal.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 4160afa..bd224ee 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1913,7 +1913,7 @@ static void __init jbd_create_debugfs_entry(void)
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
-		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
 					       jbd_debugfs_dir,
 					       &journal_enable_debug);
 }
