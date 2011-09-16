From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 24/25] e4defrag: Check error return of sysconf()
Date: Fri, 16 Sep 2011 15:49:39 -0500
Message-ID: <1316206180-6375-25-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46759 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907Ab1IPUtr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:47 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In theory sysconf() can fail, so check for an error return.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 misc/e4defrag.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index eea3057..4ade180 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -399,13 +399,16 @@ static int calc_entry_counts(const char *file EXT2FS_ATTR((unused)),
 static int page_in_core(int fd, struct move_extent defrag_data,
 			unsigned char **vec, unsigned int *page_num)
 {
-	long	pagesize = sysconf(_SC_PAGESIZE);
+	long	pagesize;
 	void	*page = NULL;
 	loff_t	offset, end_offset, length;
 
 	if (vec == NULL || *vec != NULL)
 		return -1;
 
+ 	pagesize = sysconf(_SC_PAGESIZE);
+	if (pagesize < 0)
+		return -1;
 	/* In mmap, offset should be a multiple of the page size */
 	offset = (loff_t)defrag_data.orig_start * block_size;
 	length = (loff_t)defrag_data.len * block_size;
-- 
1.7.4.1

