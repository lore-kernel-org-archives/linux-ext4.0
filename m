From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?=
	<andre@bsrsoft.com.br>
Subject: [PATCH 1/1] fs: Small refactoring of the code in ext4 2.6.37-rc1
Date: Thu, 4 Nov 2010 15:07:47 -0700 (PDT)
Message-ID: <250707.83204.qm@web110504.mail.gq1.yahoo.com>
Reply-To: andre@bsrsoft.com.br
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm24-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.226]:45256 "HELO
	nm24-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750929Ab0KDWHs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Nov 2010 18:07:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>

Hi.
Small refactoring of the code in order to make minor enhancements to critical areas.
The notation x + 1 has been replaced by more efficient notation x + +.

Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
---
Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
--- linux-2.6.37-rc1/fs/ext4/extents.c	2010-11-01 09:54:12.000000000 -0200
+++ linux-2.6.37-rc1-patched/fs/ext4/extents.c	2010-11-04 19:54:26.000000000 -0200
@@ -555,9 +555,9 @@ ext4_ext_binsearch(struct inode *inode,
 	while (l <= r) {
 		m = l + (r - l) / 2;
 		if (block < le32_to_cpu(m->ee_block))
-			r = m - 1;
+			r = m--;
 		else
-			l = m + 1;
+			l = m++;
 		ext_debug("%p(%u):%p(%u):%p(%u) ", l, le32_to_cpu(l->ee_block),
 				m, le32_to_cpu(m->ee_block),
 				r, le32_to_cpu(r->ee_block));
@@ -1557,7 +1557,7 @@ static int ext4_ext_try_to_merge(struct
 		if (ext4_ext_is_uninitialized(ex))
 			uninitialized = 1;
 		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
-				+ ext4_ext_get_actual_len(ex + 1));
+				+ ext4_ext_get_actual_len(ex++));
 		if (uninitialized)
 			ext4_ext_mark_uninitialized(ex);


      
