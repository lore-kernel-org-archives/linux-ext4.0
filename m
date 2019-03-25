Return-Path: <SRS0=eNh3=R4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6216FC43381
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 13:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF6C20830
	for <linux-ext4@archiver.kernel.org>; Mon, 25 Mar 2019 13:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbfCYNAu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:00:50 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:52003 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731166AbfCYNAu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Mar 2019 09:00:50 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MYcy3-1hVBFa3ZjP-00Vckl; Mon, 25 Mar 2019 14:00:41 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Whitney <enwlinux@gmail.com>,
        Sean Fu <fxinrong@gmail.com>, Jan Kara <jack@suse.cz>,
        Eric Biggers <ebiggers@google.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: use BUG() instead of BUG_ON(1)
Date:   Mon, 25 Mar 2019 14:00:25 +0100
Message-Id: <20190325130040.1437445-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:XEkcvIk1pYTWgdR+sAkYhTO1RRjWg8B5vvNlB7QcoiS1tnjfmVG
 NPe1IiRrQRvV9hkJRruQShim4S9Jspnd6/IY0wVET/d+LwgNT8B1iba+CjRBEKoZw5i6cRd
 q5VQk2r9smg0mi+ONUBTkBGjdBFY4kS4RkfjThhQhRT8D6DMK4kDgv0hBzaq2F9WstvUfhU
 Edkcxj4DdWAZm4ouyF95g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xQ9yD33iYgY=:PBt945K92l971pKmGyQkhW
 Tn9t1UZ28/jKk1IIWZJX0Tc5NsaYqQPq3w4Q7B2T1PP1XpKWIVBxMWuD33oA1fA5ieYH+wKsR
 pz8xHFRLC3PgDrfy2aKJjFkNrfFnB3OovpaeM7ZoIDJ3qzXvpq6KQnIKIWLs5ldb9+dcS8Q3V
 vs6bazv+eqp8Tyj4J9+jRf3Xb5kQwhsAEQktguc+sr9Od681prnmP7NVDp4W1EH4nZnaPLNDG
 leqsVkTk5Q2QfA771hEc3amD+1djhoX3xeIKCqNelBzLiglX8sZHNmDsoKzLh5AHa4IGr0SGO
 BZEz0ixmiU5HIOwVkw6piTdrkEiMxHRh5eZVLhT32ANF2oDKEkPeToZNJdhNDguw1lOoCc8if
 D3BcwewlEfGnuUfW59SoEeln74ACh0w7t7YG81u6JXolnVcU4D4SzvA5hq4QS2PWOuDnZAsJP
 Ok4w63/46y9VNz5B7gQKlP4x1tv31OJu25MBzc+utK/p/UN6OOcEdFademrPGZyBKH3GH6e5z
 YL6q3/2bx50Q9HIPtR/XHsGnGJFK+skTFaKovzOa9WvL3ZCLMVNAJBmHFQZSe0avcHEOcPUPZ
 B+7qZIiB3WWWnEZKpEdPDUxBhN/zbEkoPOyJEKGh5MgKdDQ030RdDmpnasiNEm/N+JOr0yKXd
 bhGrXrsl9WPYADLB1N/mXnSqENIiXij479WZe1RmhVL3EGut1pIOJA4HLRUIzk5VrHlD7p3z+
 bHt4cwucBRUlC1ofXZGkc8CwGk8nlkY0C3ppwQ==
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

BUG_ON(1) leads to bogus warnings from clang when
CONFIG_PROFILE_ANNOTATED_BRANCHES is set:

 fs/ext4/inode.c:544:4: error: variable 'retval' is used uninitialized whenever 'if' condition is false
      [-Werror,-Wsometimes-uninitialized]
                        BUG_ON(1);
                        ^~~~~~~~~
 include/asm-generic/bug.h:61:36: note: expanded from macro 'BUG_ON'
                                   ^~~~~~~~~~~~~~~~~~~
 include/linux/compiler.h:48:23: note: expanded from macro 'unlikely'
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 fs/ext4/inode.c:591:6: note: uninitialized use occurs here
        if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED) {
            ^~~~~~
 fs/ext4/inode.c:544:4: note: remove the 'if' if its condition is always true
                        BUG_ON(1);
                        ^
 include/asm-generic/bug.h:61:32: note: expanded from macro 'BUG_ON'
                               ^
 fs/ext4/inode.c:502:12: note: initialize the variable 'retval' to silence this warning

Change it to BUG() so clang can see that this code path can never
continue.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/ext4/extents_status.c | 4 ++--
 fs/ext4/inode.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 2b439afafe13..023a3eb3afa3 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -711,7 +711,7 @@ static void ext4_es_insert_extent_ind_check(struct inode *inode,
 			 * We don't need to check unwritten extent because
 			 * indirect-based file doesn't have it.
 			 */
-			BUG_ON(1);
+			BUG();
 		}
 	} else if (retval == 0) {
 		if (ext4_es_is_written(es)) {
@@ -780,7 +780,7 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
 			}
 			p = &(*p)->rb_right;
 		} else {
-			BUG_ON(1);
+			BUG();
 			return -EINVAL;
 		}
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b32a57bc5d5d..190f0478582a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -541,7 +541,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			map->m_len = retval;
 			retval = 0;
 		} else {
-			BUG_ON(1);
+			BUG();
 		}
 #ifdef ES_AGGRESSIVE_TEST
 		ext4_map_blocks_es_recheck(handle, inode, map,
@@ -1876,7 +1876,7 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		else if (ext4_es_is_unwritten(&es))
 			map->m_flags |= EXT4_MAP_UNWRITTEN;
 		else
-			BUG_ON(1);
+			BUG();
 
 #ifdef ES_AGGRESSIVE_TEST
 		ext4_map_blocks_es_recheck(NULL, inode, map, &orig_map, 0);
-- 
2.20.0

