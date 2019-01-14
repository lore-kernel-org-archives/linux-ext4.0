Return-Path: <SRS0=NmFT=PW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39915 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfANUkV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2019 15:40:21 -0500
From: Mathieu Malaterre <malat@debian.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mathieu Malaterre <malat@debian.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ext4: annotate implicit fall throughs
Date: Mon, 14 Jan 2019 21:39:44 +0100
Message-Id: <20190114203945.20233-2-malat@debian.org>
In-Reply-To: <20190114203945.20233-1-malat@debian.org>
References: <20190114203945.20233-1-malat@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a plan to build the kernel with -Wimplicit-fallthrough and
these places in the code produced warnings (W=1). Fix them up.

This commit remove the following warnings:

  fs/ext4/indirect.c:1182:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
  fs/ext4/indirect.c:1188:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
  fs/ext4/indirect.c:1432:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
  fs/ext4/indirect.c:1440:6: warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
 fs/ext4/indirect.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index bf7fa1507e81..c2225f0d31b5 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1183,18 +1183,21 @@ void ext4_ind_truncate(handle_t *handle, struct inode *inode)
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
 			i_data[EXT4_IND_BLOCK] = 0;
 		}
+		/* fall through */
 	case EXT4_IND_BLOCK:
 		nr = i_data[EXT4_DIND_BLOCK];
 		if (nr) {
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
 			i_data[EXT4_DIND_BLOCK] = 0;
 		}
+		/* fall through */
 	case EXT4_DIND_BLOCK:
 		nr = i_data[EXT4_TIND_BLOCK];
 		if (nr) {
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
 			i_data[EXT4_TIND_BLOCK] = 0;
 		}
+		/* fall through */
 	case EXT4_TIND_BLOCK:
 		;
 	}
@@ -1433,6 +1436,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 1);
 			i_data[EXT4_IND_BLOCK] = 0;
 		}
+		/* fall through */
 	case EXT4_IND_BLOCK:
 		if (++n >= n2)
 			return 0;
@@ -1441,6 +1445,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 2);
 			i_data[EXT4_DIND_BLOCK] = 0;
 		}
+		/* fall through */
 	case EXT4_DIND_BLOCK:
 		if (++n >= n2)
 			return 0;
@@ -1449,6 +1454,7 @@ int ext4_ind_remove_space(handle_t *handle, struct inode *inode,
 			ext4_free_branches(handle, inode, NULL, &nr, &nr+1, 3);
 			i_data[EXT4_TIND_BLOCK] = 0;
 		}
+		/* fall through */
 	case EXT4_TIND_BLOCK:
 		;
 	}
-- 
2.19.2
