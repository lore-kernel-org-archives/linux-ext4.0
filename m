From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] msync: fix incorrect fstart calculation
Date: Fri, 27 Jun 2014 20:38:49 +0900
Message-ID: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: linux-mm@kvack.org, linux-ext4 <linux-ext4@vger.kernel.org>,
 =?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
 'Matthew Wilcox' <matthew.r.wilcox@intel.com>,
 'Eric Whitney' <enwlinux@gmail.com>, Ashish Sangwan <a.sangwan@samsung.com>
To: 'Andrew Morton' <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
Content-language: ko
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Fix a regression caused by Commit 7fc34a62ca mm/msync.c: sync only
the requested range in msync().
xfstests generic/075 fail occured on ext4 data=3Djournal mode because
the intended range was not syncing due to wrong fstart calculation.

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Luk=E1=B9 Czerner <lczerner@redhat.com>
Reported-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 mm/msync.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/msync.c b/mm/msync.c
index a5c6736..ad97dce 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -78,7 +78,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, =
len, int, flags)
 			goto out_unlock;
 		}
 		file =3D vma->vm_file;
-		fstart =3D start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+		fstart =3D (start - vma->vm_start) +
+			 ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 		fend =3D fstart + (min(end, vma->vm_end) - start) - 1;
 		start =3D vma->vm_end;
 		if ((flags & MS_SYNC) && file &&
--=20
1.7.11-rc0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
