From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 still busted on ext4
Date: Thu, 29 May 2008 16:07:18 +0200
Message-ID: <20080529140718.GB1180@atrey.karlin.mff.cuni.cz>
References: <20080522235441.1d1a495b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59657 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYE2OHU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 May 2008 10:07:20 -0400
Content-Disposition: inline
In-Reply-To: <20080522235441.1d1a495b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> /usr/src/devel/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
> /usr/src/devel/fs/ext4/mballoc.c:399: error: implicit declaration of function 'generic_find_next_le_bit'
> 
> This has been happening for months.
  Is there anything wrong with the obvious fix (below)? I don't have a
way to even compile-test this...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
---

From: Jan Kara <jack@suse.cz>
Subject: [PATCH] m68k: Fix compilation warning

/usr/src/devel/fs/ext4/mballoc.c: In function 'mb_find_next_bit':
/usr/src/devel/fs/ext4/mballoc.c:399: error: implicit declaration of function 'generic_find_next_le_bit'

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/asm-m68k/bitops.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-m68k/bitops.h b/include/asm-m68k/bitops.h
index 83d1f28..bb3a2fa 100644
--- a/include/asm-m68k/bitops.h
+++ b/include/asm-m68k/bitops.h
@@ -13,6 +13,7 @@
 #endif
 
 #include <linux/compiler.h>
+#include <asm-generic/bitops.h>
 
 /*
  * Require 68020 or better.
-- 
1.5.2.4

