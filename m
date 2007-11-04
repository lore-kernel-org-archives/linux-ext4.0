From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: delalloc fragmenting files?
Date: Sun, 04 Nov 2007 21:36:04 +0300
Message-ID: <472E1114.7060206@gmail.com>
References: <47225B1E.2060708@redhat.com>
 <20071026221938.GV3042@webber.adilger.int> <4728ED3B.1060407@redhat.com>
 <47291F62.3000008@gmail.com> <4729EEB2.9090406@redhat.com>
 <472A2384.2010001@redhat.com> <472AE644.1040102@gmail.com>
 <472B453F.8010608@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_KANwWmJ5KY698fyBXAj8zQ)"
Cc: Andreas Dilger <adilger@Sun.COM>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-mail-1.sun.com ([192.18.6.21]:53725 "EHLO
	gmp-eb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbXKDSif (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Nov 2007 13:38:35 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe2.eu.sun.com [192.18.6.11])
	by gmp-eb-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id lA4IcOmu001489
	for <linux-ext4@vger.kernel.org>; Sun, 4 Nov 2007 18:38:33 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JQZ00M01VDM1A00@fe-emea-10.sun.com>
 (original mail from bzzz.tomas@gmail.com) for linux-ext4@vger.kernel.org; Sun,
 04 Nov 2007 18:38:24 +0000 (GMT)
In-reply-to: <472B453F.8010608@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_KANwWmJ5KY698fyBXAj8zQ)
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT

thanks for the data. the attached patch should fix couple issues:
broken history output and policy in that smaller usable chunk to
be used. can you give it a spin, please?

thanks, Alex

Eric Sandeen wrote:
> Alex Tomas wrote:
>> Eric,
>>
>> would you mind to repeat the run and then grab /proc/fs/ext4/<dev>/mb_history?
>>
>> thanks in advance, Alex
> 
> Sure thing, attached; this is from a 1024x1M run, wound up with 32
> fragments, out of order:
> 
> First block: 122880
> Last block: 491519
> Discontinuity: Block 7424 is at 114688 (was 130303)
> Discontinuity: Block 15616 is at 106496 (was 122879)
> Discontinuity: Block 23552 is at 102400 (was 114431)
> Discontinuity: Block 26624 is at 155648 (was 105471)
> Discontinuity: Block 33792 is at 147456 (was 162815)
> Discontinuity: Block 41472 is at 162816 (was 155135)
> Discontinuity: Block 42496 is at 188416 (was 163839)
> Discontinuity: Block 50176 is at 180224 (was 196095)
> Discontinuity: Block 58368 is at 172032 (was 188415)
> Discontinuity: Block 66560 is at 167936 (was 180223)
> ....
> 
> pid 3695 is pdflush, I assume 7634 was the dd itself.
> 
> -Eric


--Boundary_(ID_KANwWmJ5KY698fyBXAj8zQ)
Content-type: text/x-patch; name=mballoc-use-smaller-good-chunk.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=mballoc-use-smaller-good-chunk.patch

Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/ext4/mballoc.c	2007-10-27 10:29:17.000000000 +0400
+++ linux-2.6.24-rc1/fs/ext4/mballoc.c	2007-11-04 21:30:20.000000000 +0300
@@ -1553,7 +1553,8 @@ static void ext4_mb_measure_extent(struc
 		/* if the request is satisfied, then we try to find
 		 * an extent that still satisfy the request, but is
 		 * smaller than previous one */
-		*bex = *ex;
+		if (ex->fe_len < bex->fe_len)
+			*bex = *ex;
 	}
 
 	ext4_mb_check_limits(ac, e4b, 0);
@@ -2311,6 +2312,11 @@ static void ext4_mb_store_history(struct
 	h.orig = ac->ac_o_ex;
 	h.result = ac->ac_b_ex;
 	h.flags = ac->ac_flags;
+	h.found = ac->ac_found;
+	h.groups = ac->ac_groups_scanned;
+	h.cr = ac->ac_criteria;
+	h.tail = ac->ac_tail;
+	h.buddy = ac->ac_buddy;
 	h.merged = 0;
 	if (ac->ac_op == EXT4_MB_HISTORY_ALLOC) {
 		if (ac->ac_g_ex.fe_start == ac->ac_b_ex.fe_start &&

--Boundary_(ID_KANwWmJ5KY698fyBXAj8zQ)--
