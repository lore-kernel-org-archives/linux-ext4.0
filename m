From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 21/25] e2fsck: Fix leaks in error paths
Date: Fri, 16 Sep 2011 15:49:36 -0500
Message-ID: <1316206180-6375-22-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46743 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab1IPUtq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:46 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fn and/or array was not freed in some error paths.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/profile.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/e2fsck/profile.c b/e2fsck/profile.c
index 327bfb4..c790623 100644
--- a/e2fsck/profile.c
+++ b/e2fsck/profile.c
@@ -276,6 +276,7 @@ static errcode_t get_dirlist(const char *dirname, char***ret_array)
 			new_array = realloc(array, sizeof(char *) * (max+1));
 			if (!new_array) {
 				retval = ENOMEM;
+				free(fn);
 				goto errout;
 			}
 			array = new_array;
@@ -345,6 +346,7 @@ profile_init(const char **files, profile_t *ret_profile)
 	     * If all the files were not found, return the appropriate error.
 	     */
 	    if (!profile->first_file) {
+		free_list(array);
 		profile_release(profile);
 		return ENOENT;
 	    }
-- 
1.7.4.1

