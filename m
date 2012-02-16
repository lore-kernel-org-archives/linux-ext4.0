From: =?UTF-8?q?Rados=C5=82aw=20Smogura?= <mail@smogura.eu>
Subject: [WIP 18/18] [WIP] Dummy patch for details
Date: Thu, 16 Feb 2012 15:47:57 +0100
Message-ID: <1329403677-25629-8-git-send-email-mail@smogura.eu>
References: <1329403677-25629-1-git-send-email-mail@smogura.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>, mail@smogura.eu,
	linux-ext4@vger.kernel.org
To: linux-mm@kvack.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from flawless.hostnac.com ([67.23.244.186]:49457 "EHLO
	flawless.hostnac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2BPOsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Feb 2012 09:48:55 -0500
In-Reply-To: <1329403677-25629-1-git-send-email-mail@smogura.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I send this dummy patch to describe a bit of work, maybe someone may
have additional ideas, concepts and tips. In any case I'm glad I mapped=
 huge
EXT4 and data was synced to disk.

Some concepts about compounds:
	- first_page moved to lru union to free place for buffers
	- refcounting changed - compound pages are "auto managed",
	  page recovering is for backward
	  compatibilit with 2.6 kernels, actully those kernels allowed
	  getting tail page of count 0, but at eye glance moving few
	  times around 0 could cause dangling pointer bug

Compound view.
In distinction to huge pages and THP, file system
compound pages are really loosely treated, as a main difference there i=
s no
implication huge page =3D> huge pmd, huge page may exist and may have n=
o
huge mappings at all.

Each page is managed almost like stand alone, have own count, mapcount,=
 dirty
bit etc. It can't be added to any LRU nor list, because list_head is
shared with compound metadata.

Read / write locking of compound.

Splitting may be dequeued this is to prevent deadlocks, "legacy" code
will probably start with normal page locked, and then try to lock
compound, for splitting purposes this may cause deadlocks (actually thi=
s
flag was not included in faulting and enywhere else, but should be).

Still there is no defragmentation daemon nor anything simillar, this
behaviour is forced by MAP_HUGETLB.

Things not made:
* kswapd & co. not tested.
* mlock not fixed, fix will cover get_user_pages & follow_user_pages.
* fork, page_mkclean, mlock,  not fixed.
* dropping caches =3D bug.
* migration not checked
* shmfs - writeback for reclaim should split, simple to make, but ext4
  experiments should go first (syncing)
* no huge COW mapping allowed.
* code cleaning from all printk...

Signed-off-by: Rados=C5=82aw Smogura <mail@smogura.eu>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index f050209..7174fff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1783,7 +1783,7 @@ int filemap_fault_huge(struct vm_area_struct *vma=
, struct vm_fault *vmf)
 	int ret =3D VM_FAULT_LOCKED;
=20
 	error =3D vma->vm_ops->fault(vma, vmf);
-	/* XXX Repeatable flags in __do fault etc. */
+	/* XXX Repeatable flags in __do fault etc.  */
 	if (error & (VM_FAULT_ERROR | VM_FAULT_NOPAGE
 		| VM_FAULT_RETRY | VM_FAULT_NOHUGE)) {
 		return error;
--=20
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
