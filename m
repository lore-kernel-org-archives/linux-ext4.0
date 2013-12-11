From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/74] e4defrag: defensively check results of
 sysconf(_SC_PAGESIZE)
Date: Tue, 10 Dec 2013 17:20:46 -0800
Message-ID: <20131211012046.30655.22882.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26363 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3LKBUw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:20:52 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sysconf(_SC_PAGESIZE) will probably never return an error, but just in
case it does, we shouldn't pass what looks like a huge number to
sync_file_range() and posix_fadvise().

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e4defrag.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index b6e2e31..07d56d9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -473,6 +473,9 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
 	unsigned int	i;
 	loff_t	offset;
 
+	if (pagesize < 1)
+		return -1;
+
 	offset = (loff_t)defrag_data.orig_start * block_size;
 	offset = (offset / pagesize) * pagesize;
 

