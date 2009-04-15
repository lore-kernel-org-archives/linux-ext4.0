From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/3] Export filemap_write_and_wait_range
Date: Wed, 15 Apr 2009 13:22:37 -0400
Message-ID: <abbad87ab84075cbac38f4cd99507a4c605fd731.1239815649.git.chris.mason@oracle.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:42930 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZDORX7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2009 13:23:59 -0400
In-Reply-To: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This wasn't exported before and is used by the ext3 data=guarded code

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 mm/filemap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2e2d38e..04e2160 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -441,6 +441,7 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 	}
 	return err;
 }
+EXPORT_SYMBOL(filemap_write_and_wait_range);
 
 /**
  * add_to_page_cache_locked - add a locked page to the pagecache
-- 
1.6.0.2

