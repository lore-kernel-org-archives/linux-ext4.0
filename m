From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] filefrag: Fix a core dump on sparc32 platforms with 8k file systems
Date: Sat, 28 Nov 2009 10:30:33 -0500
Message-ID: <1259422233-14024-3-git-send-email-tytso@mit.edu>
References: <20091128152750.GD6763@thunk.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48031 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZK1PbK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Nov 2009 10:31:10 -0500
In-Reply-To: <20091128152750.GD6763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit platforms where the file system block size is 8k or greater,
the calculation bpib*bpib*bpib* will overflow a 32-bit calculation,
leading to a divide by zero error.  Fix this.

Thanks to Mikulas Patocka for pointing this out.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/filefrag.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 11783fd..1611f90 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -341,7 +341,7 @@ static void frag_report(const char *filename)
 				if (((i-EXT2_DIRECT-bpib) % (bpib*bpib)) == 0)
 					last_block++;
 				if (((i-EXT2_DIRECT-bpib-bpib*bpib) %
-							(bpib*bpib*bpib)) == 0)
+				     (((__u64) bpib)*bpib*bpib)) == 0)
 					last_block++;
 			}
 			rc = get_bmap(fd, i, &block);
-- 
1.6.5.216.g5288a.dirty

