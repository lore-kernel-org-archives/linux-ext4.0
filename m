From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Subject: RE: [PATCH] msync: fix incorrect fstart calculation
Date: Fri, 27 Jun 2014 12:43:30 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE0407A787B@FMSMSX114.amr.corp.intel.com>
References: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-ext4
	<linux-ext4@vger.kernel.org>, =?Windows-1252?Q?Luk=E1=9A_Czerner?=
	<lczerner@redhat.com>, 'Eric Whitney' <enwlinux@gmail.com>, Ashish Sangwan
	<a.sangwan@samsung.com>
To: Namjae Jeon <namjae.jeon@samsung.com>, 'Andrew Morton'
	<akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <006a01cf91fc$5d225170$1766f450$@samsung.com>
Content-Language: en-CA
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Acked-by: Matthew Wilcox <matthew.r.wilcox@intel.com>=0A=
________________________________________=0A=
From: Namjae Jeon [namjae.jeon@samsung.com]=0A=
Sent: June 27, 2014 4:38 AM=0A=
To: 'Andrew Morton'=0A=
Cc: linux-mm@kvack.org; linux-ext4; Luk=E1=9A Czerner; Wilcox, Matthew R; '=
Eric Whitney'; Ashish Sangwan=0A=
Subject: [PATCH] msync: fix incorrect fstart calculation=0A=
=0A=
Fix a regression caused by Commit 7fc34a62ca mm/msync.c: sync only=0A=
the requested range in msync().=0A=
xfstests generic/075 fail occured on ext4 data=3Djournal mode because=0A=
the intended range was not syncing due to wrong fstart calculation.=0A=
=0A=
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>=0A=
Cc: Luk=E1=9A Czerner <lczerner@redhat.com>=0A=
Reported-by: Eric Whitney <enwlinux@gmail.com>=0A=
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>=0A=
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>=0A=
---=0A=
 mm/msync.c | 3 ++-=0A=
 1 file changed, 2 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/mm/msync.c b/mm/msync.c=0A=
index a5c6736..ad97dce 100644=0A=
--- a/mm/msync.c=0A=
+++ b/mm/msync.c=0A=
@@ -78,7 +78,8 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len,=
 int, flags)=0A=
                        goto out_unlock;=0A=
                }=0A=
                file =3D vma->vm_file;=0A=
-               fstart =3D start + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);=
=0A=
+               fstart =3D (start - vma->vm_start) +=0A=
+                        ((loff_t)vma->vm_pgoff << PAGE_SHIFT);=0A=
                fend =3D fstart + (min(end, vma->vm_end) - start) - 1;=0A=
                start =3D vma->vm_end;=0A=
                if ((flags & MS_SYNC) && file &&=0A=
--=0A=
1.7.11-rc0=0A=
=0A=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
