From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] contrib: fix namespace leakage in spd_readdir
Date: Mon, 21 Jan 2013 19:09:50 -0500
Message-ID: <1358813390-26466-3-git-send-email-tytso@mit.edu>
References: <1358813390-26466-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44698 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab3AVAJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 19:09:56 -0500
In-Reply-To: <1358813390-26466-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Declare the internal symbols alloc_dirstruct() and cache_dirstruct()
as static so they don't leak out into the global namespace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 contrib/spd_readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/contrib/spd_readdir.c b/contrib/spd_readdir.c
index 910b104..8345fa1 100644
--- a/contrib/spd_readdir.c
+++ b/contrib/spd_readdir.c
@@ -186,7 +186,7 @@ static int ino_cmp(const void *a, const void *b)
 	return (i_a - i_b);
 }
 
-struct dir_s *alloc_dirstruct(DIR *dir)
+static struct dir_s *alloc_dirstruct(DIR *dir)
 {
 	struct dir_s	*dirstruct;
 	static pthread_mutexattr_t mutexattr;
@@ -200,7 +200,7 @@ struct dir_s *alloc_dirstruct(DIR *dir)
 	return dirstruct;
 }
 
-void cache_dirstruct(struct dir_s *dirstruct)
+static void cache_dirstruct(struct dir_s *dirstruct)
 {
 	struct dirent_s *ds, *dnew;
 	struct dirent64 *d;
-- 
1.7.12.rc0.22.gcdd159b

