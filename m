From: =?UTF-8?q?Rados=C5=82aw=20Smogura?= <mail@smogura.eu>
Subject: [WIP 16/18] SHM: Support for splitting on truncation
Date: Thu, 16 Feb 2012 15:47:55 +0100
Message-ID: <1329403677-25629-6-git-send-email-mail@smogura.eu>
References: <1329403677-25629-1-git-send-email-mail@smogura.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, mail@smogura.eu,
	linux-ext4@vger.kernel.org
To: linux-mm@kvack.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from flawless.hostnac.com ([67.23.244.186]:49449 "EHLO
	flawless.hostnac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2BPOsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 09:48:53 -0500
In-Reply-To: <1329403677-25629-1-git-send-email-mail@smogura.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Writeback will be added in next patches, but after experimental support
for huge pages for EXT 4.

Signed-off-by: Rados=C5=82aw Smogura <mail@smogura.eu>
---
 mm/shmem.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 97e76b9..db377bf 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -454,6 +454,7 @@ void shmem_truncate_range(struct inode *inode, loff=
_t lstart, loff_t lend)
 		mem_cgroup_uncharge_start();
 		for (i =3D 0; i < pagevec_count(&pvec); i++) {
 			struct page *page =3D pvec.pages[i];
+			struct page *head =3D NULL;
=20
 			index =3D indices[i];
 			if (index > end)
@@ -464,12 +465,32 @@ void shmem_truncate_range(struct inode *inode, lo=
ff_t lstart, loff_t lend)
 								index, page);
 				continue;
 			}
-
 			if (!trylock_page(page))
 				continue;
+			if (PageCompound(page)) {
+				head =3D compound_head(page);
+				switch (compound_try_freeze(head, false)) {
+				case -1:
+					head =3D NULL;
+					break;
+				case 1:
+					unlock_page(page);
+					continue;
+				case 0:
+					if (!split_huge_page_file(head, page))
+						head =3D NULL;
+					break;
+				}
+			}
+			/* Truncate inode page may try to freez, so unfreez. */
 			if (page->mapping =3D=3D mapping) {
 				VM_BUG_ON(PageWriteback(page));
+				if (head !=3D NULL)
+					compound_unfreeze(head);
 				truncate_inode_page(mapping, page);
+			} else {
+				if (head !=3D NULL)
+					compound_unfreeze(head);
 			}
 			unlock_page(page);
 		}
@@ -511,6 +532,7 @@ void shmem_truncate_range(struct inode *inode, loff=
_t lstart, loff_t lend)
 		mem_cgroup_uncharge_start();
 		for (i =3D 0; i < pagevec_count(&pvec); i++) {
 			struct page *page =3D pvec.pages[i];
+			struct page *head =3D NULL;
=20
 			index =3D indices[i];
 			if (index > end)
@@ -523,9 +545,24 @@ void shmem_truncate_range(struct inode *inode, lof=
f_t lstart, loff_t lend)
 			}
=20
 			lock_page(page);
+			if (PageCompound(page)) {
+				head =3D compound_head(page);
+				if (compound_freeze(head)) {
+					if (!split_huge_page_file(head, page))
+						head =3D NULL;
+				} else {
+					head =3D NULL;
+				}
+			}
+			/* Truncate inode page may try to freez, so unfreez. */
 			if (page->mapping =3D=3D mapping) {
 				VM_BUG_ON(PageWriteback(page));
+				if (head !=3D NULL)
+					compound_unfreeze(head);
 				truncate_inode_page(mapping, page);
+			} else {
+				if (head !=3D NULL)
+					compound_unfreeze(head);
 			}
 			unlock_page(page);
 		}
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
