From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] ext4: fix reference counting bug on block allocation
 error
Date: Thu, 7 Jul 2016 13:21:55 +0200
Message-ID: <577E3B53.3070502@oracle.com>
References: <1467813452-26763-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040803060901000104080602"
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18702 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbcGGLWz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jul 2016 07:22:55 -0400
In-Reply-To: <1467813452-26763-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040803060901000104080602
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 07/06/2016 03:57 PM, Vegard Nossum wrote:
> If we hit this error when mounted with errors=continue or
> errors=remount-ro:
>
>      EXT4-fs error (device loop0): ext4_mb_mark_diskspace_used:2940: comm ext4.exe: Allocating blocks 5090-6081 which overlap fs metadata
>
> then ext4_mb_new_blocks() will call ext4_mb_release_context() and try to
> continue. However, ext4_mb_release_context() is the wrong thing to call
> here since we are still actually using the allocation context.
>
> Instead, handle it the same way that we handle other errors, except that
> we retry the allocation instead of immediately returning an error (if we
> were mounted with errors=continue, then ext4_mb_mark_diskspace_used()
> should have fixed the original error and will either succeed or give a
> different error; if we were mounted with errors=remount-ro, then it will
> not be able to fix the original error and will raise a different error).

This didn't really work as I thought and I'm now getting stuck in an
infinite loop here where it tries (and fails) to allocate the same
blocks over and over.

The attached new patch just returns on error instead of trying to fix
the problem.


Vegard

--------------040803060901000104080602
Content-Type: text/x-patch;
 name="0001-ext4-fix-reference-counting-bug-on-block-allocation-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ext4-fix-reference-counting-bug-on-block-allocation-.pa";
 filename*1="tch"

>From 09084a94d2b176e33ee52a0bb41409988e6ff744 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@oracle.com>
Date: Wed, 6 Jul 2016 15:01:36 +0200
Subject: [PATCH] ext4: fix reference counting bug on block allocation error

If we hit this error when mounted with errors=continue or
errors=remount-ro:

    EXT4-fs error (device loop0): ext4_mb_mark_diskspace_used:2940: comm ext4.exe: Allocating blocks 5090-6081 which overlap fs metadata

then ext4_mb_new_blocks() will call ext4_mb_release_context() and try to
continue. However, ext4_mb_release_context() is the wrong thing to call
here since we are still actually using the allocation context.

Instead, just error out. We could retry the allocation, but there is a
possibility of getting stuck in an infinite loop instead, so this seems
safer.

Fixes: 8556e8f3b6 ("ext4: Don't allow new groups to be added during block allocation")
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/mballoc.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1ab3ec..e65400a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4513,18 +4513,7 @@ repeat:
 	}
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
 		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_clstrs);
-		if (*errp == -EAGAIN) {
-			/*
-			 * drop the reference that we took
-			 * in ext4_mb_use_best_found
-			 */
-			ext4_mb_release_context(ac);
-			ac->ac_b_ex.fe_group = 0;
-			ac->ac_b_ex.fe_start = 0;
-			ac->ac_b_ex.fe_len = 0;
-			ac->ac_status = AC_STATUS_CONTINUE;
-			goto repeat;
-		} else if (*errp) {
+		if (*errp) {
 			ext4_discard_allocated_blocks(ac);
 			goto errout;
 		} else {
-- 
1.9.1


--------------040803060901000104080602--
